From: akpm@linux-foundation.org
Subject: - mspec-convert-nopfn-to-fault.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:20 -0700
Message-ID: <200807242321.m6ONLKZ2010392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbYGXXV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mspec: convert nopfn to fault
has been removed from the -mm tree.  Its filename was
     mspec-convert-nopfn-to-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mspec: convert nopfn to fault
From: Nick Piggin <npiggin@suse.de>

[akpm@linux-foundation.org: remove unused variable]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff -puN drivers/char/mspec.c~mspec-convert-nopfn-to-fault drivers/char/mspec.c
--- a/drivers/char/mspec.c~mspec-convert-nopfn-to-fault
+++ a/drivers/char/mspec.c
@@ -193,25 +193,23 @@ mspec_close(struct vm_area_struct *vma)
 }
 
 /*
- * mspec_nopfn
+ * mspec_fault
  *
  * Creates a mspec page and maps it to user space.
  */
-static unsigned long
-mspec_nopfn(struct vm_area_struct *vma, unsigned long address)
+static int
+mspec_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long paddr, maddr;
 	unsigned long pfn;
-	int index;
+	pgoff_t index = vmf->pgoff;
 	struct vma_data *vdata = vma->vm_private_data;
 
-	BUG_ON(address < vdata->vm_start || address >= vdata->vm_end);
-	index = (address - vdata->vm_start) >> PAGE_SHIFT;
 	maddr = (volatile unsigned long) vdata->maddr[index];
 	if (maddr == 0) {
 		maddr = uncached_alloc_page(numa_node_id(), 1);
 		if (maddr == 0)
-			return NOPFN_OOM;
+			return VM_FAULT_OOM;
 
 		spin_lock(&vdata->lock);
 		if (vdata->maddr[index] == 0) {
@@ -231,13 +229,20 @@ mspec_nopfn(struct vm_area_struct *vma, 
 
 	pfn = paddr >> PAGE_SHIFT;
 
-	return pfn;
+	/*
+	 * vm_insert_pfn can fail with -EBUSY, but in that case it will
+	 * be because another thread has installed the pte first, so it
+	 * is no problem.
+	 */
+	vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+
+	return VM_FAULT_NOPAGE;
 }
 
 static struct vm_operations_struct mspec_vm_ops = {
 	.open = mspec_open,
 	.close = mspec_close,
-	.nopfn = mspec_nopfn
+	.fault = mspec_fault,
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

