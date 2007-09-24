From: akpm@linux-foundation.org
Subject: + make-lockdep-happy-with-r-o-bind-mounts.patch added to -mm tree
Date: Mon, 24 Sep 2007 12:02:46 -0700
Message-ID: <200709241902.l8OJ2keP012785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbXIXTCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 15:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com


The patch titled
     make lockdep happy with r/o bind mounts
has been added to the -mm tree.  Its filename is
     make-lockdep-happy-with-r-o-bind-mounts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN fs/namespace.c~make-lockdep-happy-with-r-o-bind-mounts fs/namespace.c
--- a/fs/namespace.c~make-lockdep-happy-with-r-o-bind-mounts
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

revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
r-o-bind-mounts-give-permission-a-local-mnt-variable.patch
r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-hack-hack-hack.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
touch-command-causes-oops.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
page-owner-tracking-leak-detector.patch
