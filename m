From: akpm@linux-foundation.org
Subject: + ipc-drop-ipc_lock_check.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:23:30 -0700
Message-ID: <51f037c2.aZf6YlbgjkSkzl+4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3GXUXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipc-drop-ipc_lock_check.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:23:30 -0700


The patch titled
     Subject: ipc: drop ipc_lock_check
has been added to the -mm tree.  Its filename is
     ipc-drop-ipc_lock_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-drop-ipc_lock_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-drop-ipc_lock_check.patch

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
Subject: ipc: drop ipc_lock_check

No remaining users, we now use ipc_obtain_object_check().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   16 ----------------
 ipc/util.h |    1 -
 2 files changed, 17 deletions(-)

diff -puN ipc/util.c~ipc-drop-ipc_lock_check ipc/util.c
--- a/ipc/util.c~ipc-drop-ipc_lock_check
+++ a/ipc/util.c
@@ -686,22 +686,6 @@ out:
 	return out;
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
-
 /**
  * ipcget - Common sys_*get() code
  * @ns : namsepace
diff -puN ipc/util.h~ipc-drop-ipc_lock_check ipc/util.h
--- a/ipc/util.h~ipc-drop-ipc_lock_check
+++ a/ipc/util.h
@@ -177,7 +177,6 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
-struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id);
 int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
 			struct ipc_ops *ops, struct ipc_params *params);
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

