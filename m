From: akpm@linux-foundation.org
Subject: + ipc-introduce-lockless-pre_down-ipcctl.patch added to -mm tree
Date: Fri, 22 Mar 2013 14:04:38 -0700
Message-ID: <20130322210438.E643E5A43B8@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:45555 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423106Ab3CVVEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:04:40 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so422764vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:04:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, benisty.e@gmail.com, chegu_vinod@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com


The patch titled
     Subject: ipc: introduce lockless pre_down ipcctl
has been added to the -mm tree.  Its filename is
     ipc-introduce-lockless-pre_down-ipcctl.patch

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
Subject: ipc: introduce lockless pre_down ipcctl

Various forms of ipc use ipcctl_pre_down() to retrieve an ipc object and
check permissions, mostly for IPC_RMID and IPC_SET commands.

Introduce ipcctl_pre_down_nolock(), a lockless version of this function. 
The locking version is retained, yet modified to call the nolock version
without affecting its semantics, thus transparent to all ipc callers.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   31 ++++++++++++++++++++++++++-----
 ipc/util.h |    3 +++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff -puN ipc/util.c~ipc-introduce-lockless-pre_down-ipcctl ipc/util.c
--- a/ipc/util.c~ipc-introduce-lockless-pre_down-ipcctl
+++ a/ipc/util.c
@@ -823,11 +823,28 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
+
+	ipcp = ipcctl_pre_down_nolock(ns, ids, id, cmd, perm, extra_perm);
+	if (IS_ERR(ipcp))
+		goto out;
+
+	spin_lock(&ipcp->lock);
+out:
+	return ipcp;
+}
+
+struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
+					     struct ipc_ids *ids, int id, int cmd,
+					     struct ipc64_perm *perm, int extra_perm)
+{
 	kuid_t euid;
-	int err;
+	int err = -EPERM;
+	struct kern_ipc_perm *ipcp;
 
 	down_write(&ids->rw_mutex);
-	ipcp = ipc_lock_check(ids, id);
+	rcu_read_lock();
+
+	ipcp = ipc_obtain_object_check(ids, id);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
 		goto out_up;
@@ -836,17 +853,21 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 	audit_ipc_obj(ipcp);
 	if (cmd == IPC_SET)
 		audit_ipc_set_perm(extra_perm, perm->uid,
-					 perm->gid, perm->mode);
+				   perm->gid, perm->mode);
 
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
 	    ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 		return ipcp;
 
-	err = -EPERM;
-	ipc_unlock(ipcp);
 out_up:
+	/*
+	 * Unsuccessful lookup, unlock and return
+	 * the corresponding error.
+	 */
+	rcu_read_unlock();
 	up_write(&ids->rw_mutex);
+
 	return ERR_PTR(err);
 }
 
diff -puN ipc/util.h~ipc-introduce-lockless-pre_down-ipcctl ipc/util.h
--- a/ipc/util.h~ipc-introduce-lockless-pre_down-ipcctl
+++ a/ipc/util.h
@@ -128,6 +128,9 @@ struct kern_ipc_perm *ipc_obtain_object(
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 int ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
+struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
+					     struct ipc_ids *ids, int id, int cmd,
+					     struct ipc64_perm *perm, int extra_perm);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch

