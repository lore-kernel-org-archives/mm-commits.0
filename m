From: akpm@linux-foundation.org
Subject: + ipc-introduce-ipc_update_perm.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:28:38 -0800
Message-ID: <200802122128.m1CLScIK023100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbYBLVen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:34:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com


The patch titled
     IPC: introduce ipc_update_perm()
has been added to the -mm tree.  Its filename is
     ipc-introduce-ipc_update_perm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IPC: introduce ipc_update_perm()
From: Pierre Peiffer <pierre.peiffer@bull.net>

The IPC_SET command performs the same permission setting for all IPCs.  This
patch introduces a common ipc_update_perm() function to update these
permissions and makes use of it for all IPCs.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    5 +----
 ipc/sem.c  |    5 +----
 ipc/shm.c  |    5 +----
 ipc/util.c |   13 +++++++++++++
 ipc/util.h |    1 +
 5 files changed, 17 insertions(+), 12 deletions(-)

diff -puN ipc/msg.c~ipc-introduce-ipc_update_perm ipc/msg.c
--- a/ipc/msg.c~ipc-introduce-ipc_update_perm
+++ a/ipc/msg.c
@@ -484,10 +484,7 @@ static int msgctl_down(struct ipc_namesp
 
 		msq->q_qbytes = msqid64.msg_qbytes;
 
-		ipcp->uid = msqid64.msg_perm.uid;
-		ipcp->gid = msqid64.msg_perm.gid;
-		ipcp->mode = (ipcp->mode & ~S_IRWXUGO) |
-			     (S_IRWXUGO & msqid64.msg_perm.mode);
+		ipc_update_perm(&msqid64.msg_perm, ipcp);
 		msq->q_ctime = get_seconds();
 		/* sleeping receivers might be excluded by
 		 * stricter permissions.
diff -puN ipc/sem.c~ipc-introduce-ipc_update_perm ipc/sem.c
--- a/ipc/sem.c~ipc-introduce-ipc_update_perm
+++ a/ipc/sem.c
@@ -913,10 +913,7 @@ static int semctl_down(struct ipc_namesp
 		freeary(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipcp->uid = semid64.sem_perm.uid;
-		ipcp->gid = semid64.sem_perm.gid;
-		ipcp->mode = (ipcp->mode & ~S_IRWXUGO)
-				| (semid64.sem_perm.mode & S_IRWXUGO);
+		ipc_update_perm(&semid64.sem_perm, ipcp);
 		sma->sem_ctime = get_seconds();
 		break;
 	default:
diff -puN ipc/shm.c~ipc-introduce-ipc_update_perm ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-ipc_update_perm
+++ a/ipc/shm.c
@@ -657,10 +657,7 @@ static int shmctl_down(struct ipc_namesp
 		do_shm_rmid(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
-		ipcp->uid = shmid64.shm_perm.uid;
-		ipcp->gid = shmid64.shm_perm.gid;
-		ipcp->mode = (ipcp->mode & ~S_IRWXUGO)
-			| (shmid64.shm_perm.mode & S_IRWXUGO);
+		ipc_update_perm(&shmid64.shm_perm, ipcp);
 		shp->shm_ctim = get_seconds();
 		break;
 	default:
diff -puN ipc/util.c~ipc-introduce-ipc_update_perm ipc/util.c
--- a/ipc/util.c~ipc-introduce-ipc_update_perm
+++ a/ipc/util.c
@@ -811,6 +811,19 @@ int ipcget(struct ipc_namespace *ns, str
 		return ipcget_public(ns, ids, ops, params);
 }
 
+/**
+ * ipc_update_perm - update the permissions of an IPC.
+ * @in:  the permission given as input.
+ * @out: the permission of the ipc to set.
+ */
+void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out)
+{
+	out->uid = in->uid;
+	out->gid = in->gid;
+	out->mode = (out->mode & ~S_IRWXUGO)
+		| (in->mode & S_IRWXUGO);
+}
+
 #ifdef __ARCH_WANT_IPC_PARSE_VERSION
 
 
diff -puN ipc/util.h~ipc-introduce-ipc_update_perm ipc/util.h
--- a/ipc/util.h~ipc-introduce-ipc_update_perm
+++ a/ipc/util.h
@@ -112,6 +112,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
+void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 
 #if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

origin.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
