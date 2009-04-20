From: akpm@linux-foundation.org
Subject: + ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch added to -mm tree
Date: Mon, 20 Apr 2009 16:32:47 -0700
Message-ID: <200904202332.n3KNWmKA002788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbZDTXhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 19:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     ksm: add replace_page(): change the page pte is pointing to
has been added to the -mm tree.  Its filename is
     ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: add replace_page(): change the page pte is pointing to
From: Izik Eidus <ieidus@redhat.com>

replace_page() allow changing the mapping of pte from one physical page
into diffrent physical page.

This function is working by removing oldpage from the rmap and calling
put_page on it, and by setting the pte to point into newpage and by
inserting it to the rmap using page_add_file_rmap().

note: newpage must be non anonymous page, the reason for this is:
replace_page() is built to allow mapping one page into more than one
virtual addresses, the mapping of this page can happen in diffrent offsets
inside each vma, and therefore we cannot trust the page->index anymore.

The side effect of this issue is that newpage cannot be anything but
kernel allocated page that is not swappable.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 ++
 mm/memory.c        |   80 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff -puN include/linux/mm.h~ksm-add-replace_page-change-the-page-pte-is-pointing-to include/linux/mm.h
--- a/include/linux/mm.h~ksm-add-replace_page-change-the-page-pte-is-pointing-to
+++ a/include/linux/mm.h
@@ -1255,6 +1255,11 @@ int vm_insert_pfn(struct vm_area_struct 
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 
+#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+int replace_page(struct vm_area_struct *vma, struct page *oldpage,
+		 struct page *newpage, pte_t orig_pte, pgprot_t prot);
+#endif
+
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
 #define FOLL_WRITE	0x01	/* check pte is writable */
diff -puN mm/memory.c~ksm-add-replace_page-change-the-page-pte-is-pointing-to mm/memory.c
--- a/mm/memory.c~ksm-add-replace_page-change-the-page-pte-is-pointing-to
+++ a/mm/memory.c
@@ -1617,6 +1617,86 @@ int vm_insert_mixed(struct vm_area_struc
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
+#if defined(CONFIG_KSM) || defined(CONFIG_KSM_MODULE)
+
+/**
+ * replace_page - replace page in vma with new page
+ * @vma:      vma that hold the pte oldpage is pointed by.
+ * @oldpage:  the page we are replacing with newpage
+ * @newpage:  the page we replace oldpage with
+ * @orig_pte: the original value of the pte
+ * @prot: page protection bits
+ *
+ * Returns 0 on success, -EFAULT on failure.
+ *
+ * Note: @newpage must not be an anonymous page because replace_page() does
+ * not change the mapping of @newpage to have the same values as @oldpage.
+ * @newpage can be mapped in several vmas at different offsets (page->index).
+ */
+int replace_page(struct vm_area_struct *vma, struct page *oldpage,
+		 struct page *newpage, pte_t orig_pte, pgprot_t prot)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep;
+	spinlock_t *ptl;
+	unsigned long addr;
+	int ret;
+
+	BUG_ON(PageAnon(newpage));
+
+	ret = -EFAULT;
+	addr = page_address_in_vma(oldpage, vma);
+	if (addr == -EFAULT)
+		goto out;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		goto out;
+
+	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!ptep)
+		goto out;
+
+	if (!pte_same(*ptep, orig_pte)) {
+		pte_unmap_unlock(ptep, ptl);
+		goto out;
+	}
+
+	ret = 0;
+	get_page(newpage);
+	page_add_file_rmap(newpage);
+
+	flush_cache_page(vma, addr, pte_pfn(*ptep));
+	ptep_clear_flush(vma, addr, ptep);
+	set_pte_at_notify(mm, addr, ptep, mk_pte(newpage, prot));
+
+	page_remove_rmap(oldpage);
+	if (PageAnon(oldpage)) {
+		dec_mm_counter(mm, anon_rss);
+		inc_mm_counter(mm, file_rss);
+	}
+	put_page(oldpage);
+
+	pte_unmap_unlock(ptep, ptl);
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(replace_page);
+
+#endif
+
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch

