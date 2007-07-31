From: akpm@linux-foundation.org
Subject: - fix-user-struct-leakage-with-locked-ipc-shem-segment.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:17 -0700
Message-ID: <200707312357.l6VNvHlY029385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757256AbXHAAQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix user struct leakage with locked IPC shem segment
has been removed from the -mm tree.  Its filename was
     fix-user-struct-leakage-with-locked-ipc-shem-segment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix user struct leakage with locked IPC shem segment
From: Pavel Emelianov <xemul@openvz.org>

When user locks an ipc shmem segmant with SHM_LOCK ctl and the segment is
already locked the shmem_lock() function returns 0.  After this the
subsequent code leaks the existing user struct:

== ipc/shm.c: sys_shmctl() ==
     ...
     err = shmem_lock(shp->shm_file, 1, user);
     if (!err) {
          shp->shm_perm.mode |= SHM_LOCKED;
          shp->mlock_user = user;
     }
     ...
==

Other results of this are:
1. the new shp->mlock_user is not get-ed and will point to freed
   memory when the task dies.
2. the RLIMIT_MEMLOCK is screwed on both user structs.

The exploit looks like this:

==
    id = shmget(...);
    setresuid(uid, 0, 0);
    shmctl(id, SHM_LOCK, NULL);
    setresuid(uid + 1, 0, 0);
    shmctl(id, SHM_LOCK, NULL);
==

My solution is to return 0 to the userspace and do not change the
segment's user.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~fix-user-struct-leakage-with-locked-ipc-shem-segment ipc/shm.c
--- a/ipc/shm.c~fix-user-struct-leakage-with-locked-ipc-shem-segment
+++ a/ipc/shm.c
@@ -716,7 +716,7 @@ asmlinkage long sys_shmctl (int shmid, i
 			struct user_struct * user = current->user;
 			if (!is_file_hugepages(shp->shm_file)) {
 				err = shmem_lock(shp->shm_file, 1, user);
-				if (!err) {
+				if (!err && !(shp->shm_perm.mode & SHM_LOCKED)){
 					shp->shm_perm.mode |= SHM_LOCKED;
 					shp->mlock_user = user;
 				}
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
