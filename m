From: akpm@linux-foundation.org
Subject: + ipc-drop-ipc_lock_by_ptr.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:23:28 -0700
Message-ID: <51f037c0.Jwcqus97lYJ98PXd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3GXUX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipc-drop-ipc_lock_by_ptr.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:23:28 -0700


The patch titled
     Subject: ipc: drop ipc_lock_by_ptr
has been added to the -mm tree.  Its filename is
     ipc-drop-ipc_lock_by_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-drop-ipc_lock_by_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-drop-ipc_lock_by_ptr.patch

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
Subject: ipc: drop ipc_lock_by_ptr

After previous cleanups and optimizations, this function is no longer
heavily used and we don't have a good reason to keep it.  Update the few
remaining callers and get rid of it.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    3 ++-
 ipc/util.c      |    6 ++++--
 ipc/util.h      |    6 ------
 3 files changed, 6 insertions(+), 9 deletions(-)

diff -puN ipc/namespace.c~ipc-drop-ipc_lock_by_ptr ipc/namespace.c
--- a/ipc/namespace.c~ipc-drop-ipc_lock_by_ptr
+++ a/ipc/namespace.c
@@ -89,7 +89,8 @@ void free_ipcs(struct ipc_namespace *ns,
 		perm = idr_find(&ids->ipcs_idr, next_id);
 		if (perm == NULL)
 			continue;
-		ipc_lock_by_ptr(perm);
+		rcu_read_lock();
+		ipc_lock_object(perm);
 		free(ns, perm);
 		total++;
 	}
diff -puN ipc/util.c~ipc-drop-ipc_lock_by_ptr ipc/util.c
--- a/ipc/util.c~ipc-drop-ipc_lock_by_ptr
+++ a/ipc/util.c
@@ -205,7 +205,8 @@ static struct kern_ipc_perm *ipc_findkey
 			continue;
 		}
 
-		ipc_lock_by_ptr(ipc);
+		rcu_read_lock();
+		ipc_lock_object(ipc);
 		return ipc;
 	}
 
@@ -838,7 +839,8 @@ static struct kern_ipc_perm *sysvipc_fin
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
-			ipc_lock_by_ptr(ipc);
+			rcu_read_lock();
+			ipc_lock_object(ipc);
 			return ipc;
 		}
 	}
diff -puN ipc/util.h~ipc-drop-ipc_lock_by_ptr ipc/util.h
--- a/ipc/util.h~ipc-drop-ipc_lock_by_ptr
+++ a/ipc/util.h
@@ -171,12 +171,6 @@ static inline void ipc_assert_locked_obj
 	assert_spin_locked(&perm->lock);
 }
 
-static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
-{
-	rcu_read_lock();
-	ipc_lock_object(perm);
-}
-
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
 	ipc_unlock_object(perm);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch
ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch
ipc-drop-ipc_lock_by_ptr.patch
ipc-shm-drop-shm_lock_check.patch
ipc-drop-ipc_lock_check.patch
linux-next.patch

