From: akpm@linux-foundation.org
Subject: - mm-add-vm_insert_mixed.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:47 -0700
Message-ID: <200804282152.m3SLqlL4017801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934771AbYD1Vwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, cotte@de.ibm.com, heiko.carstens@de.ibm.com, jaredeh@gmail.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mm: add vm_insert_mixed
has been removed from the -mm tree.  Its filename was
     mm-add-vm_insert_mixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add vm_insert_mixed
From: Nick Piggin <npiggin@suse.de>

vm_insert_mixed will insert either a raw pfn or a refcounted struct page into
the page tables, depending on whether vm_normal_page() will return the page or
not.  With the introduction of the new pte bit, this is now a too tricky for
drivers to be doing themselves.

filemap_xip uses this in a subsequent patch.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 mm/memory.c        |   86 ++++++++++++++++++++++++++++++-------------
 2 files changed, 62 insertions(+), 26 deletions(-)

diff -puN include/linux/mm.h~mm-add-vm_insert_mixed include/linux/mm.h
--- a/include/linux/mm.h~mm-add-vm_insert_mixed
+++ a/include/linux/mm.h
@@ -1152,6 +1152,8 @@ int remap_pfn_range(struct vm_area_struc
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+			unsigned long pfn);
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff -puN mm/memory.c~mm-add-vm_insert_mixed mm/memory.c
--- a/mm/memory.c~mm-add-vm_insert_mixed
+++ a/mm/memory.c
@@ -1176,8 +1176,10 @@ pte_t *get_locked_pte(struct mm_struct *
  * old drivers should use this, and they needed to mark their
  * pages reserved for the old functions anyway.
  */
-static int insert_page(struct mm_struct *mm, unsigned long addr, struct page *page, pgprot_t prot)
+static int insert_page(struct vm_area_struct *vma, unsigned long addr,
+			struct page *page, pgprot_t prot)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int retval;
 	pte_t *pte;
 	spinlock_t *ptl;
@@ -1237,17 +1239,46 @@ out:
  *
  * The page does not need to be reserved.
  */
-int vm_insert_page(struct vm_area_struct *vma, unsigned long addr, struct page *page)
+int vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
+			struct page *page)
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
 	if (!page_count(page))
 		return -EINVAL;
 	vma->vm_flags |= VM_INSERTPAGE;
-	return insert_page(vma->vm_mm, addr, page, vma->vm_page_prot);
+	return insert_page(vma, addr, page, vma->vm_page_prot);
 }
 EXPORT_SYMBOL(vm_insert_page);
 
+static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
+			unsigned long pfn, pgprot_t prot)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int retval;
+	pte_t *pte, entry;
+	spinlock_t *ptl;
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
+	entry = pte_mkspecial(pfn_pte(pfn, prot));
+	set_pte_at(mm, addr, pte, entry);
+	update_mmu_cache(vma, addr, entry); /* XXX: why not for insert_page? */
+
+	retval = 0;
+out_unlock:
+	pte_unmap_unlock(pte, ptl);
+out:
+	return retval;
+}
+
 /**
  * vm_insert_pfn - insert single pfn into user vma
  * @vma: user vma to map to
@@ -1261,13 +1292,8 @@ EXPORT_SYMBOL(vm_insert_page);
  * in that case the handler should return NULL.
  */
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn)
+			unsigned long pfn)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	int retval;
-	pte_t *pte, entry;
-	spinlock_t *ptl;
-
 	/*
 	 * Technically, architectures with pte_special can avoid all these
 	 * restrictions (same for remap_pfn_range).  However we would like
@@ -1280,27 +1306,35 @@ int vm_insert_pfn(struct vm_area_struct 
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
 
-	retval = -ENOMEM;
-	pte = get_locked_pte(mm, addr, &ptl);
-	if (!pte)
-		goto out;
-	retval = -EBUSY;
-	if (!pte_none(*pte))
-		goto out_unlock;
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return -EFAULT;
+	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_insert_pfn);
 
-	/* Ok, finally just insert the thing.. */
-	entry = pte_mkspecial(pfn_pte(pfn, vma->vm_page_prot));
-	set_pte_at(mm, addr, pte, entry);
-	update_mmu_cache(vma, addr, entry);
+int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+			unsigned long pfn)
+{
+	BUG_ON(!(vma->vm_flags & VM_MIXEDMAP));
 
-	retval = 0;
-out_unlock:
-	pte_unmap_unlock(pte, ptl);
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return -EFAULT;
 
-out:
-	return retval;
+	/*
+	 * If we don't have pte special, then we have to use the pfn_valid()
+	 * based VM_MIXEDMAP scheme (see vm_normal_page), and thus we *must*
+	 * refcount the page if pfn_valid is true (hence insert_page rather
+	 * than insert_pfn).
+	 */
+	if (!HAVE_PTE_SPECIAL && pfn_valid(pfn)) {
+		struct page *page;
+
+		page = pfn_to_page(pfn);
+		return insert_page(vma, addr, page, vma->vm_page_prot);
+	}
+	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
 }
-EXPORT_SYMBOL(vm_insert_pfn);
+EXPORT_SYMBOL(vm_insert_mixed);
 
 /*
  * maps a range of physical memory into the requested pages. the old
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-kvm.patch
fuse-implement-perform_write.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
likeliness-accounting-change-and-cleanup.patch

