From: akpm@linux-foundation.org
Subject: - leases-can-be-hidden-by-flocks.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:19 -0700
Message-ID: <200709160926.l8G9QJ9B009175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36996 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbXIPJje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, akpm@linux-foundation.org, bfields@fieldses.org, stable@kernel.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Leases can be hidden by flocks
has been removed from the -mm tree.  Its filename was
     leases-can-be-hidden-by-flocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Leases can be hidden by flocks
From: Pavel Emelyanov <xemul@openvz.org>

The inode->i_flock list contains the leases, flocks and posix
locks in the specified order. However, the flocks are added in
the head of this list thus hiding the leases from F_GETLEASE
command, from time_out_leases() and other code that expects
the leases to come first.

The following example will demonstrate this:

#define _GNU_SOURCE

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/file.h>

static void show_lease(int fd)
{
        int res;

        res = fcntl(fd, F_GETLEASE);
        switch (res) {
                case F_RDLCK:
                        printf("Read lease\n");
                        break;
                case F_WRLCK:
                        printf("Write lease\n");
                        break;
                case F_UNLCK:
                        printf("No leases\n");
                        break;
                default:
                        printf("Some shit\n");
                        break;
        }
}

int main(int argc, char **argv)
{
        int fd, res;

        fd = open(argv[1], O_RDONLY);
        if (fd == -1) {
                perror("Can't open file");
                return 1;
        }

        res = fcntl(fd, F_SETLEASE, F_WRLCK);
        if (res == -1) {
                perror("Can't set lease");
                return 1;
        }

        show_lease(fd);

        if (flock(fd, LOCK_SH) == -1) {
                perror("Can't flock shared");
                return 1;
        }

        show_lease(fd);

        return 0;
}

The first call to show_lease() will show the write lease set, but
the second will show no leases.

Fix the flock adding so that the leases always stay in the head
of this list.

Found during making the flocks pid-namespaces aware.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/locks.c~leases-can-be-hidden-by-flocks fs/locks.c
--- a/fs/locks.c~leases-can-be-hidden-by-flocks
+++ a/fs/locks.c
@@ -782,7 +782,7 @@ find_conflict:
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 	locks_copy_lock(new_fl, request);
-	locks_insert_lock(&inode->i_flock, new_fl);
+	locks_insert_lock(before, new_fl);
 	new_fl = NULL;
 	error = 0;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
wake-up-mandatory-locks-waiter-on-chmod.patch
convert-uid-hash-to-hlist.patch
fix-user-namespace-exiting-oops.patch
git-net.patch
git-nfsd.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
isolate-some-explicit-usage-of-task-tgid-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
