From: akpm@linux-foundation.org
Subject: - mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:43 -0700
Message-ID: <200807301915.m6UJFhvc011049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbYG3TQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: add zap_vma_ptes(): a library function to unmap driver ptes
has been removed from the -mm tree.  Its filename was
     mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add zap_vma_ptes(): a library function to unmap driver ptes
From: Jack Steiner <steiner@sgi.com>

zap_vma_ptes() is intended to be used by drivers to unmap ptes assigned to the
driver private vmas.  This interface is similar to zap_page_range() but is
less general & less likely to be abused.

Needed by the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -puN include/linux/mm.h~mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes include/linux/mm.h
--- a/include/linux/mm.h~mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes
+++ a/include/linux/mm.h
@@ -744,6 +744,8 @@ struct zap_details {
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		pte_t pte);
 
+int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
+		unsigned long size);
 unsigned long zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *);
 unsigned long unmap_vmas(struct mmu_gather **tlb,
diff -puN mm/memory.c~mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes mm/memory.c
--- a/mm/memory.c~mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes
+++ a/mm/memory.c
@@ -994,6 +994,29 @@ unsigned long zap_page_range(struct vm_a
 	return end;
 }
 
+/**
+ * zap_vma_ptes - remove ptes mapping the vma
+ * @vma: vm_area_struct holding ptes to be zapped
+ * @address: starting address of pages to zap
+ * @size: number of bytes to zap
+ *
+ * This function only unmaps ptes assigned to VM_PFNMAP vmas.
+ *
+ * The entire address range must be fully contained within the vma.
+ *
+ * Returns 0 if successful.
+ */
+int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
+		unsigned long size)
+{
+	if (address < vma->vm_start || address + size > vma->vm_end ||
+	    		!(vma->vm_flags & VM_PFNMAP))
+		return -1;
+	zap_page_range(vma, address, size, NULL);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(zap_vma_ptes);
+
 /*
  * Do a quick page-table lookup for a single page.
  */
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
linux-next.patch

