From: akpm@linux-foundation.org
Subject: +
 ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:51:43 -0700
Message-ID: <51e5ce7f./MqdD5bDaigLjMgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:43 -0700


The patch titled
     Subject: ipc,shm: introduce lockless functions to obtain the ipc object
has been added to the -mm tree.  Its filename is
     ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,shm: introduce lockless functions to obtain the ipc object

This is the third and final patchset that deals with reducing the amount
of contention we impose on the ipc lock (kern_ipc_perm.lock).  These
changes mostly deal with shared memory, previous work has already been
done for semaphores and message queues:

http://lkml.org/lkml/2013/3/20/546 (sems)
http://lkml.org/lkml/2013/5/15/584 (mqueues)

With these patches applied, a custom shm microbenchmark stressing shmctl
doing IPC_STAT with 4 threads a million times, reduces the execution time
by 50%.  A similar run, this time with IPC_SET, reduces the execution time
from 3 mins and 35 secs to 27 seconds.

Patches 1-8: replaces blindly taking the ipc lock for a smarter combination
of rcu and ipc_obtain_object, only acquiring the spinlock when updating.

Patch 9: renames the ids rw_mutex to rwsem, which is what it already was.

Patch 10: is a trivial mqueue leftover cleanup

Patch 11: adds a brief lock scheme description, requested by Andrew.


This patch:

Add shm_obtain_object() and shm_obtain_object_check(), which will allow us
to get the ipc object without acquiring the lock.  Just as with other
forms of ipc, these functions are basically wrappers around
ipc_obtain_object*().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN ipc/shm.c~ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object ipc/shm.c
--- a/ipc/shm.c~ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object
+++ a/ipc/shm.c
@@ -124,6 +124,26 @@ void __init shm_init (void)
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
 
+static inline struct shmid_kernel *shm_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&shm_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
+static inline struct shmid_kernel *shm_obtain_object_check(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&shm_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct shmid_kernel, shm_perm);
+}
+
 /*
  * shm_lock_(check_) routines are called in the paths where the rw_mutex
  * is not necessarily held.
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch

