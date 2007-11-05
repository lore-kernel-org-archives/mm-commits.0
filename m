From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:37 -0800
Message-ID: <200711052307.lA5N7bI8024377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46360 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbXKEXJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:09:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     make lockdep happy with r/o bind mounts
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: make lockdep happy with r/o bind mounts
From: Dave Hansen <haveblue@us.ibm.com>

With the r/o bind mount patches, we can have as many
spinlocks nested as there are CPUs on the system.
Lockdep freaks out after 8.

So, create a new lockdep class of locks for the
mnt_writer spinlocks, and initialize each of the
cpu locks to be in a different class.

It should shut up warnings like this, while still
allowing some of the lockdep goodness to remain:

=============================================
[ INFO: possible recursive locking detected ]
2.6.23-rc6 #6
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&writer->lock){--..}, at: [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c

but task is already holding lock:
 (&writer->lock){--..}, at: [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&writer->lock){--..}, at: [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c

stack backtrace:
 [<c01034ab>] show_trace_log_lvl+0x19/0x2e
 [<c01034d2>] show_trace+0x12/0x14
 [<c01035be>] dump_stack+0x14/0x16
 [<c0130ab2>] print_deadlock_bug+0xb7/0xc1
 [<c0130afc>] check_deadlock+0x40/0x54
 [<c013100a>] validate_chain+0x26e/0x319
 [<c0132cca>] __lock_acquire+0x6c4/0x731
 [<c01332da>] lock_acquire+0x7a/0x94
 [<c031bb01>] _spin_lock+0x38/0x62
 [<c016c094>] lock_and_coalesce_cpu_mnt_writer_counts+0x29/0x5c
 [<c016c5f8>] mntput_no_expire+0x38/0xad
 [<c015fbed>] path_release_on_umount+0x15/0x18
 [<c016cc76>] sys_umount+0x67/0x6f
 [<c010058a>] name_to_dev_t+0x22a/0x24c
 [<c0427207>] prepare_namespace+0x89/0x187
 [<c0426cdd>] kernel_init+0x9a/0xa3
 [<c010336f>] kernel_thread_helper+0x7/0x10
 =======================

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts
+++ a/fs/namespace.c
@@ -115,6 +115,7 @@ struct mnt_writer {
 	 * must be ordered by cpu number.
 	 */
 	spinlock_t lock;
+	struct lock_class_key lock_class; /* compiles out with !lockdep */
 	unsigned long count;
 	struct vfsmount *mnt;
 } ____cacheline_aligned_in_smp;
@@ -126,6 +127,7 @@ static int __init init_mnt_writers(void)
 	for_each_possible_cpu(cpu) {
 		struct mnt_writer *writer = &per_cpu(mnt_writers, cpu);
 		spin_lock_init(&writer->lock);
+		lockdep_set_class(&writer->lock, &writer->lock_class);
 		writer->count = 0;
 	}
 	return 0;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
