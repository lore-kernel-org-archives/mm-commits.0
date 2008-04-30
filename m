From: akpm@linux-foundation.org
Subject: - ipc-introduce-ipc_update_perm.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:19 -0700
Message-ID: <200804300544.m3U5iJP3029401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760661AbYD3GMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre.peiffer@bull.net, Nadia.Derbey@bull.net, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IPC: introduce ipc_update_perm()
has been removed from the -mm tree.  Its filename was
     ipc-introduce-ipc_update_perm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -656,10 +656,7 @@ static int shmctl_down(struct ipc_namesp
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

