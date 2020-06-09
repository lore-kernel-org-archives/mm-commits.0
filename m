From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch removed from
 -mm tree
Date: Mon, 08 Jun 2020 20:18:38 -0700
Message-ID: <20200609031838.MEpYyqDGG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgFIDSj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, walken@google.com


The patch titled
     Subject: mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch

This patch was dropped because it was folded into mmap-locking-api-convert-mmap_sem-comments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix

more linux-next fixups, per Michel

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |    6 +++---
 drivers/misc/cxl/cxllib.c                 |    5 ++---
 drivers/vfio/pci/vfio_pci.c               |   14 +++++++-------
 3 files changed, 12 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c~mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix
+++ a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -1326,9 +1326,9 @@ int rdtgroup_pseudo_lock_create(struct r
 	 * pseudo-locked region will still be here on return.
 	 *
 	 * The mutex has to be released temporarily to avoid a potential
-	 * deadlock with the mm->mmap_lock semaphore which is obtained in
-	 * the device_create() and debugfs_create_dir() callpath below
-	 * as well as before the mmap() callback is called.
+	 * deadlock with the mm->mmap_lock which is obtained in the
+	 * device_create() and debugfs_create_dir() callpath below as well as
+	 * before the mmap() callback is called.
 	 */
 	mutex_unlock(&rdtgroup_mutex);
 
--- a/drivers/misc/cxl/cxllib.c~mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix
+++ a/drivers/misc/cxl/cxllib.c
@@ -245,9 +245,8 @@ int cxllib_handle_fault(struct mm_struct
 	     dar += page_size) {
 		if (dar < vma_start || dar >= vma_end) {
 			/*
-			 * We don't hold the mm->mmap_lock semaphore
-			 * while iterating, since the semaphore is
-			 * required by one of the lower-level page
+			 * We don't hold mm->mmap_lock while iterating, since
+			 * the lock is required by one of the lower-level page
 			 * fault processing functions and it could
 			 * create a deadlock.
 			 *
--- a/drivers/vfio/pci/vfio_pci.c~mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -1185,7 +1185,7 @@ reset_info_exit:
 
 		/*
 		 * We need to get memory_lock for each device, but devices
-		 * can share mmap_sem, therefore we need to zap and hold
+		 * can share mmap_lock, therefore we need to zap and hold
 		 * the vma_lock for each device, and only then get each
 		 * memory_lock.
 		 */
@@ -1375,26 +1375,26 @@ static int vfio_pci_zap_and_vma_lock(str
 
 	/*
 	 * Lock ordering:
-	 * vma_lock is nested under mmap_sem for vm_ops callback paths.
+	 * vma_lock is nested under mmap_lock for vm_ops callback paths.
 	 * The memory_lock semaphore is used by both code paths calling
 	 * into this function to zap vmas and the vm_ops.fault callback
 	 * to protect the memory enable state of the device.
 	 *
-	 * When zapping vmas we need to maintain the mmap_sem => vma_lock
+	 * When zapping vmas we need to maintain the mmap_lock => vma_lock
 	 * ordering, which requires using vma_lock to walk vma_list to
-	 * acquire an mm, then dropping vma_lock to get the mmap_sem and
+	 * acquire an mm, then dropping vma_lock to get the mmap_lock and
 	 * reacquiring vma_lock.  This logic is derived from similar
 	 * requirements in uverbs_user_mmap_disassociate().
 	 *
-	 * mmap_sem must always be the top-level lock when it is taken.
+	 * mmap_lock must always be the top-level lock when it is taken.
 	 * Therefore we can only hold the memory_lock write lock when
-	 * vma_list is empty, as we'd need to take mmap_sem to clear
+	 * vma_list is empty, as we'd need to take mmap_lock to clear
 	 * entries.  vma_list can only be guaranteed empty when holding
 	 * vma_lock, thus memory_lock is nested under vma_lock.
 	 *
 	 * This enables the vm_ops.fault callback to acquire vma_lock,
 	 * followed by memory_lock read lock, while already holding
-	 * mmap_sem without risk of deadlock.
+	 * mmap_lock without risk of deadlock.
 	 */
 	while (1) {
 		struct mm_struct *mm = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mmap-locking-api-convert-mmap_sem-comments.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
