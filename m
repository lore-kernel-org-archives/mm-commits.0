From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vm_insert_pages.patch added to -mm tree
Date: Wed, 12 Feb 2020 18:56:57 -0800
Message-ID: <20200213025657.SqK-UkL58%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbgBMC46 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 21:56:58 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, mm-commits@vger.kernel.org, soheil@google.com


The patch titled
     Subject: mm/memory.c: add vm_insert_pages()
has been added to the -mm tree.  Its filename is
     mm-add-vm_insert_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-vm_insert_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-vm_insert_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arjun Roy <arjunroy@google.com>
Subject: mm/memory.c: add vm_insert_pages()

Add the ability to insert multiple pages at once to a user VM with lower
PTE spinlock operations.

The intention of this patch-set is to reduce atomic ops for tcp zerocopy
receives, which normally hits the same spinlock multiple times
consecutively.

Link: http://lkml.kernel.org/r/20200128025958.43490-2-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 
 mm/memory.c        |  111 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-add-vm_insert_pages
+++ a/include/linux/mm.h
@@ -2597,6 +2597,8 @@ struct vm_area_struct *find_extend_vma(s
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num);
 int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 				unsigned long num);
 int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
--- a/mm/memory.c~mm-add-vm_insert_pages
+++ a/mm/memory.c
@@ -1407,8 +1407,7 @@ void zap_vma_ptes(struct vm_area_struct
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
-pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
-			spinlock_t **ptl)
+static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1427,6 +1426,16 @@ pte_t *__get_locked_pte(struct mm_struct
 		return NULL;
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
+	return pmd;
+}
+
+pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			spinlock_t **ptl)
+{
+	pmd_t *pmd = walk_to_pmd(mm, addr);
+
+	if (!pmd)
+		return NULL;
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
@@ -1451,6 +1460,15 @@ static int insert_page_into_pte_locked(s
 	return 0;
 }
 
+static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, struct page *page, pgprot_t prot)
+{
+	const int err = validate_page_before_insert(page);
+
+	return err ? err : insert_page_into_pte_locked(
+		mm, pte_offset_map(pmd, addr), addr, page, prot);
+}
+
 /*
  * This is the old fallback for page remapping.
  *
@@ -1479,6 +1497,95 @@ out:
 	return retval;
 }
 
+/* insert_pages() amortizes the cost of spinlock operations
+ * when inserting pages in a loop.
+ */
+static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num, pgprot_t prot)
+{
+	pmd_t *pmd = NULL;
+	spinlock_t *pte_lock = NULL;
+	struct mm_struct *const mm = vma->vm_mm;
+	unsigned long curr_page_idx = 0;
+	unsigned long remaining_pages_total = *num;
+	unsigned long pages_to_write_in_pmd;
+	int ret;
+more:
+	ret = -EFAULT;
+	pmd = walk_to_pmd(mm, addr);
+	if (!pmd)
+		goto out;
+
+	pages_to_write_in_pmd = min_t(unsigned long,
+		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
+
+	/* Allocate the PTE if necessary; takes PMD lock once only. */
+	ret = -ENOMEM;
+	if (pte_alloc(mm, pmd, addr))
+		goto out;
+	pte_lock = pte_lockptr(mm, pmd);
+
+	while (pages_to_write_in_pmd) {
+		int pte_idx = 0;
+		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
+
+		spin_lock(pte_lock);
+		for (; pte_idx < batch_size; ++pte_idx) {
+			int err = insert_page_in_batch_locked(mm, pmd,
+				addr, pages[curr_page_idx], prot);
+			if (unlikely(err)) {
+				spin_unlock(pte_lock);
+				ret = err;
+				remaining_pages_total -= pte_idx;
+				goto out;
+			}
+			addr += PAGE_SIZE;
+			++curr_page_idx;
+		}
+		spin_unlock(pte_lock);
+		pages_to_write_in_pmd -= batch_size;
+		remaining_pages_total -= batch_size;
+	}
+	if (remaining_pages_total)
+		goto more;
+	ret = 0;
+out:
+	*num = remaining_pages_total;
+	return ret;
+}
+
+/**
+ * vm_insert_pages - insert multiple pages into user vma, batching the pmd lock.
+ * @vma: user vma to map to
+ * @addr: target start user address of these pages
+ * @pages: source kernel pages
+ * @num: in: number of pages to map. out: number of pages that were *not*
+ * mapped. (0 means all pages were successfully mapped).
+ *
+ * Preferred over vm_insert_page() when inserting multiple pages.
+ *
+ * In case of error, we may have mapped a subset of the provided
+ * pages. It is the caller's responsibility to account for this case.
+ *
+ * The same restrictions apply as in vm_insert_page().
+ */
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num)
+{
+	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
+
+	if (addr < vma->vm_start || end_addr >= vma->vm_end)
+		return -EFAULT;
+	if (!(vma->vm_flags & VM_MIXEDMAP)) {
+		BUG_ON(down_read_trylock(&vma->vm_mm->mmap_sem));
+		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		vma->vm_flags |= VM_MIXEDMAP;
+	}
+	/* Defer page refcount checking till we're about to map that page. */
+	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_insert_pages);
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
_

Patches currently in -mm which might be from arjunroy@google.com are

mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch
mm-add-vm_insert_pages.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
