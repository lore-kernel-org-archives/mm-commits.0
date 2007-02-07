From: akpm@linux-foundation.org
Subject: + add-vm_insert_pfn.patch added to -mm tree
Date: Wed, 07 Feb 2007 14:21:24 -0800
Message-ID: <200702072221.l17MLO5E029056@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40863 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030663AbXBGWVm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 17:21:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org, hch@lst.de, hugh@veritas.com


The patch titled
     add vm_insert_pfn()
has been added to the -mm tree.  Its filename is
     add-vm_insert_pfn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add vm_insert_pfn()
From: Nick Piggin <npiggin@suse.de>

Add a vm_insert_pfn helper, so that ->fault handlers can have nopfn
functionality by installing their own pte and returning NULL.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/memory.c        |   44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff -puN include/linux/mm.h~add-vm_insert_pfn include/linux/mm.h
--- a/include/linux/mm.h~add-vm_insert_pfn
+++ a/include/linux/mm.h
@@ -1124,6 +1124,7 @@ unsigned long vmalloc_to_pfn(void *addr)
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
+int vm_insert_pfn(struct vm_area_struct *, unsigned long addr, unsigned long pfn);
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff -puN mm/memory.c~add-vm_insert_pfn mm/memory.c
--- a/mm/memory.c~add-vm_insert_pfn
+++ a/mm/memory.c
@@ -1277,6 +1277,50 @@ int vm_insert_page(struct vm_area_struct
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+/**
+ * vm_insert_pfn - insert single pfn into user vma
+ * @vma: user vma to map to
+ * @addr: target user address of this page
+ * @pfn: source kernel pfn
+ *
+ * Similar to vm_inert_page, this allows drivers to insert individual pages
+ * they've allocated into a user vma. Same comments apply.
+ *
+ * This function should only be called from a vm_ops->fault handler, and
+ * in that case the handler should return NULL.
+ */
+int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr, unsigned long pfn)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int retval;
+	pte_t *pte, entry;
+	spinlock_t *ptl;
+
+	BUG_ON(!(vma->vm_flags & VM_PFNMAP));
+	BUG_ON(is_cow_mapping(vma->vm_flags));
+
+	retval = -ENOMEM;
+	pte = get_locked_pte(mm, addr, &ptl);
+	if (!pte)
+		goto out;
+	retval = -EBUSY;
+	if (!pte_none(*pte))
+		goto out_unlock;
+
+	/* Ok, finally just insert the thing.. */
+	entry = pfn_pte(pfn, vma->vm_page_prot);
+	set_pte_at(mm, addr, pte, entry);
+	update_mmu_cache(vma, addr, entry);
+
+	retval = 0;
+out_unlock:
+	pte_unmap_unlock(pte, ptl);
+
+out:
+	return retval;
+}
+EXPORT_SYMBOL(vm_insert_pfn);
+
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
add-vm_insert_pfn.patch
mm-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
buffer-memorder-fix.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
inotify-read-return-val-fix.patch
sched-avoid-div-in-rebalance_tick.patch
