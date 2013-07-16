From: akpm@linux-foundation.org
Subject: + ipc-drop-ipcctl_pre_down.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:51:45 -0700
Message-ID: <51e5ce81.JcqIOfF0kiTBw+kZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657Ab3GPWv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipc-drop-ipcctl_pre_down.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:51:45 -0700


The patch titled
     Subject: ipc: drop ipcctl_pre_down
has been added to the -mm tree.  Its filename is
     ipc-drop-ipcctl_pre_down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-drop-ipcctl_pre_down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-drop-ipcctl_pre_down.patch

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
Subject: ipc: drop ipcctl_pre_down

Now that sem, msgque and shm, through *_down(), all use the lockless
variant of ipcctl_pre_down(), go ahead and delete it.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   21 ++-------------------
 ipc/util.h |    3 ---
 2 files changed, 2 insertions(+), 22 deletions(-)

diff -puN ipc/util.c~ipc-drop-ipcctl_pre_down ipc/util.c
--- a/ipc/util.c~ipc-drop-ipcctl_pre_down
+++ a/ipc/util.c
@@ -746,26 +746,10 @@ int ipc_update_perm(struct ipc64_perm *i
  * It must be called without any lock held and
  *  - retrieves the ipc with the given id in the given table.
  *  - performs some audit and permission check, depending on the given cmd
- *  - returns the ipc with the ipc lock held in case of success
- *    or an err-code without any lock held otherwise.
+ *  - returns a pointer to the ipc object or otherwise, the corresponding error.
  *
  * Call holding the both the rw_mutex and the rcu read lock.
  */
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
-				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm)
-{
-	struct kern_ipc_perm *ipcp;
-
-	ipcp = ipcctl_pre_down_nolock(ns, ids, id, cmd, perm, extra_perm);
-	if (IS_ERR(ipcp))
-		goto out;
-
-	spin_lock(&ipcp->lock);
-out:
-	return ipcp;
-}
-
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
 					     struct ipc64_perm *perm, int extra_perm)
@@ -782,8 +766,7 @@ struct kern_ipc_perm *ipcctl_pre_down_no
 
 	audit_ipc_obj(ipcp);
 	if (cmd == IPC_SET)
-		audit_ipc_set_perm(extra_perm, perm->uid,
-				   perm->gid, perm->mode);
+		audit_ipc_set_perm(extra_perm, perm->uid, perm->gid, perm->mode);
 
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
diff -puN ipc/util.h~ipc-drop-ipcctl_pre_down ipc/util.h
--- a/ipc/util.h~ipc-drop-ipcctl_pre_down
+++ a/ipc/util.h
@@ -131,9 +131,6 @@ int ipc_update_perm(struct ipc64_perm *i
 struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 					     struct ipc_ids *ids, int id, int cmd,
 					     struct ipc64_perm *perm, int extra_perm);
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
-				      struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extra_perm);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
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

