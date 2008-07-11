From: akpm@linux-foundation.org
Subject: + mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:44:21 -0700
Message-ID: <200807111850.m6BIo2Mg031233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981AbYGKSuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     mm: add zap_vma_ptes(): a library function to unmap driver ptes
has been added to the -mm tree.  Its filename is
     mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -743,6 +743,8 @@ struct zap_details {
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
@@ -993,6 +993,29 @@ unsigned long zap_page_range(struct vm_a
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

linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-hardware-data-structures.patch
gru-driver-v3-gru-instructions-macros.patch
gru-driver-v3-driver-internal-header-files.patch
gru-driver-v3-kernel-services-header-files.patch
gru-driver-v3-driver-initialization-file-vma-ops.patch
gru-driver-v3-page-faults-exceptions.patch
gru-driver-v3-page-faults-exceptions-gru-virtual-physical-translation.patch
gru-driver-v3-kernel-services-provide-by-driver.patch
gru-driver-v3-resource-management.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
gru-driver-v3-proc-interfaces.patch
gru-driver-v3-tlb-flushing-mmuops-callouts.patch
gru-driver-v3-driver-makefile.patch
gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v3-driver-misc-makefile-kconfig-changes.patch

