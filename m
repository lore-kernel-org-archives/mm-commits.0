From: akpm@linux-foundation.org
Subject: [wrecked] prio_tree-debugging-patch.patch removed from -mm tree
Date: Fri, 31 Aug 2012 11:57:01 -0700
Message-ID: <20120831185703.2F6BB200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:34709 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2HaS5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 14:57:06 -0400
Received: by weyr1 with SMTP id r1so170837wey.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 11:57:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, jaysonsantos2003@yahoo.com.br, mm-commits@vger.kernel.org


The patch titled
     Subject: prio_tree: debugging patch
has been removed from the -mm tree.  Its filename was
     prio_tree-debugging-patch.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: prio_tree: debugging patch

Jayson Santos has sighted mm/prio_tree.c:78,79 BUGs (kernel bugzilla 8446),
and one was sighted a couple of years ago.  No reason yet to suppose
they're prio_tree bugs, but we can't tell much about them without seeing
the vmas.

So dump vma and the one it's supposed to resemble: I had expected to use
print_hex_dump(), but that's designed for u8 dumps, whereas almost every
field of vm_area_struct is either a pointer or an unsigned long - which
look nonsense dumped as u8s.

Replace the two BUG_ONs by a single WARN_ON; and if it fires, just keep
this vma out of the tree (truncation and swapout won't be able to find it).
 How safe this is depends on what the error really is; but we hold a file's
i_mmap_lock here, so it may be impossible to recover from BUG_ON.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Jayson Santos <jaysonsantos2003@yahoo.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/prio_tree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff -puN mm/prio_tree.c~prio_tree-debugging-patch mm/prio_tree.c
--- a/mm/prio_tree.c~prio_tree-debugging-patch
+++ a/mm/prio_tree.c
@@ -68,6 +68,20 @@
  * 	vma->shared.vm_set.head == NULL ==> a list node
  */
 
+static void dump_vma(struct vm_area_struct *vma)
+{
+	void **ptr = (void **) vma;
+	int i;
+
+	printk("vm_area_struct at %p:", ptr);
+	for (i = 0; i < sizeof(*vma)/sizeof(*ptr); i++, ptr++) {
+		if (!(i & 3))
+			printk("\n");
+		printk(" %p", *ptr);
+	}
+	printk("\n");
+}
+
 /*
  * Add a new vma known to map the same set of pages as the old vma:
  * useful for fork's dup_mmap as well as vma_prio_tree_insert below.
@@ -75,14 +89,23 @@
  */
 void vma_prio_tree_add(struct vm_area_struct *vma, struct vm_area_struct *old)
 {
-	/* Leave these BUG_ONs till prio_tree patch stabilizes */
-	BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
-	BUG_ON(HEAP_INDEX(vma) != HEAP_INDEX(old));
-
 	vma->shared.vm_set.head = NULL;
 	vma->shared.vm_set.parent = NULL;
 
-	if (!old->shared.vm_set.parent)
+	if (WARN_ON(RADIX_INDEX(vma) != RADIX_INDEX(old) ||
+		    HEAP_INDEX(vma)  != HEAP_INDEX(old))) {
+		/*
+		 * This should never happen, yet it has been seen a few times:
+		 * we cannot say much about it without seeing the vma contents.
+		 */
+		dump_vma(vma);
+		dump_vma(old);
+		/*
+		 * Don't try to link this (corrupt?) vma into the (corrupt?)
+		 * prio_tree, but arrange for its removal to succeed later.
+		 */
+		INIT_LIST_HEAD(&vma->shared.vm_set.list);
+	} else if (!old->shared.vm_set.parent)
 		list_add(&vma->shared.vm_set.list,
 				&old->shared.vm_set.list);
 	else if (old->shared.vm_set.head)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

