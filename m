From: akpm@linux-foundation.org
Subject: + fix-user-struct-leakage-with-locked-ipc-shem-segment.patch added to -mm tree
Date: Mon, 16 Jul 2007 15:17:42 -0700
Message-ID: <200707162217.l6GMHg3Q007466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbXGPWSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 18:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, stable@kernel.org


The patch titled
     Fix user struct leakage with locked IPC shem segment
has been added to the -mm tree.  Its filename is
     fix-user-struct-leakage-with-locked-ipc-shem-segment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~fix-user-struct-leakage-with-locked-ipc-shem-segment ipc/shm.c
--- a/ipc/shm.c~fix-user-struct-leakage-with-locked-ipc-shem-segment
+++ a/ipc/shm.c
@@ -714,7 +714,7 @@ asmlinkage long sys_shmctl (int shmid, i
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
make-input-layer-use-seq_list_xxx-helpers.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
fix-user-struct-leakage-with-locked-ipc-shem-segment.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
