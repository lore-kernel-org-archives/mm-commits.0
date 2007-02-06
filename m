From: akpm@linux-foundation.org
Subject: + mm-vm_insert_pfn.patch added to -mm tree
Date: Mon, 05 Feb 2007 20:05:19 -0800
Message-ID: <200702060405.l1645Jwa009665@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47750 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbXBFEFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 23:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com


The patch titled
     mm: vm_insert_pfn
has been added to the -mm tree.  Its filename is
     mm-vm_insert_pfn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: vm_insert_pfn
From: Nick Piggin <npiggin@suse.de>

Add a vm_insert_pfn helper, so that fault handlers can have nopfn
functionality by installing their own pte and returning NOPAGE_REFAULT.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/memory.c        |   44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff -puN include/linux/mm.h~mm-vm_insert_pfn include/linux/mm.h
--- a/include/linux/mm.h~mm-vm_insert_pfn
+++ a/include/linux/mm.h
@@ -1121,6 +1121,7 @@ unsigned long vmalloc_to_pfn(void *addr)
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
+int vm_insert_pfn(struct vm_area_struct *, unsigned long addr, unsigned long pfn);
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff -puN mm/memory.c~mm-vm_insert_pfn mm/memory.c
--- a/mm/memory.c~mm-vm_insert_pfn
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
+ * Similar to vm_insert_page, this allows drivers to insert individual pages
+ * they've allocated into a user vma. Same comments apply.
+ *
+ * This function should only be called from a nopage handler, and
+ * in that case the handler should return NOPAGE_REFAULT.
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
mm-vm_insert_pfn.patch
buffer-memorder-fix.patch
sched-avoid-div-in-rebalance_tick.patch
