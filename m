From: akpm@linux-foundation.org
Subject: + ipc-kernel-clear-whitespace.patch added to -mm tree
Date: Thu, 17 Apr 2014 14:53:02 -0700
Message-ID: <53504d3e.uBTsGiqLZmdX+xiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaDQVxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 17:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulmcquad@gmail.com

Subject: + ipc-kernel-clear-whitespace.patch added to -mm tree
To: paulmcquad@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 14:53:02 -0700


The patch titled
     Subject: ipc, kernel: clear whitespace
has been added to the -mm tree.  Its filename is
     ipc-kernel-clear-whitespace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-kernel-clear-whitespace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-kernel-clear-whitespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: ipc, kernel: clear whitespace

trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c     |   31 +++++++++++++++----------------
 ipc/sem.c     |   10 +++++-----
 ipc/shm.c     |    2 +-
 ipc/util.c    |    4 ++--
 ipc/util.h    |    8 ++++----
 kernel/acct.c |    4 ++--
 6 files changed, 29 insertions(+), 30 deletions(-)

diff -puN ipc/msg.c~ipc-kernel-clear-whitespace ipc/msg.c
--- a/ipc/msg.c~ipc-kernel-clear-whitespace
+++ a/ipc/msg.c
@@ -611,23 +611,22 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 
 static int testmsg(struct msg_msg *msg, long type, int mode)
 {
-	switch (mode)
-	{
-		case SEARCH_ANY:
-		case SEARCH_NUMBER:
+	switch (mode) {
+	case SEARCH_ANY:
+	case SEARCH_NUMBER:
+		return 1;
+	case SEARCH_LESSEQUAL:
+		if (msg->m_type <= type)
 			return 1;
-		case SEARCH_LESSEQUAL:
-			if (msg->m_type <= type)
-				return 1;
-			break;
-		case SEARCH_EQUAL:
-			if (msg->m_type == type)
-				return 1;
-			break;
-		case SEARCH_NOTEQUAL:
-			if (msg->m_type != type)
-				return 1;
-			break;
+		break;
+	case SEARCH_EQUAL:
+		if (msg->m_type == type)
+			return 1;
+		break;
+	case SEARCH_NOTEQUAL:
+		if (msg->m_type != type)
+			return 1;
+		break;
 	}
 	return 0;
 }
diff -puN ipc/sem.c~ipc-kernel-clear-whitespace ipc/sem.c
--- a/ipc/sem.c~ipc-kernel-clear-whitespace
+++ a/ipc/sem.c
@@ -160,7 +160,7 @@ static int sysvipc_sem_proc_show(struct
  *	sem_array.pending{_alter,_cont},
  *	sem_array.sem_undo: global sem_lock() for read/write
  *	sem_undo.proc_next: only "current" is allowed to read/write that field.
- *	
+ *
  *	sem_array.sem_base[i].pending_{const,alter}:
  *		global or semaphore sem_lock() for read/write
  */
@@ -1161,7 +1161,7 @@ static int semctl_nolock(struct ipc_name
 		err = security_sem_semctl(NULL, cmd);
 		if (err)
 			return err;
-		
+
 		memset(&seminfo, 0, sizeof(seminfo));
 		seminfo.semmni = ns->sc_semmni;
 		seminfo.semmns = ns->sc_semmns;
@@ -1181,7 +1181,7 @@ static int semctl_nolock(struct ipc_name
 		}
 		max_id = ipc_get_maxid(&sem_ids(ns));
 		up_read(&sem_ids(ns).rwsem);
-		if (copy_to_user(p, &seminfo, sizeof(struct seminfo))) 
+		if (copy_to_user(p, &seminfo, sizeof(struct seminfo)))
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
@@ -1883,7 +1883,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
 	 */
-		
+
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
@@ -2016,7 +2016,7 @@ int copy_semundo(unsigned long clone_fla
 			return error;
 		atomic_inc(&undo_list->refcnt);
 		tsk->sysvsem.undo_list = undo_list;
-	} else 
+	} else
 		tsk->sysvsem.undo_list = NULL;
 
 	return 0;
diff -puN ipc/shm.c~ipc-kernel-clear-whitespace ipc/shm.c
--- a/ipc/shm.c~ipc-kernel-clear-whitespace
+++ a/ipc/shm.c
@@ -694,7 +694,7 @@ static inline unsigned long copy_shminfo
 		out.shmmin	= in->shmmin;
 		out.shmmni	= in->shmmni;
 		out.shmseg	= in->shmseg;
-		out.shmall	= in->shmall; 
+		out.shmall	= in->shmall;
 
 		return copy_to_user(buf, &out, sizeof(out));
 	    }
diff -puN ipc/util.c~ipc-kernel-clear-whitespace ipc/util.c
--- a/ipc/util.c~ipc-kernel-clear-whitespace
+++ a/ipc/util.c
@@ -183,7 +183,7 @@ void __init ipc_init_proc_interface(cons
  * ipc_findkey	- find a key in an ipc identifier set
  * @ids: ipc identifier set
  * @key: key to find
- *	
+ *
  * Returns the locked pointer to the ipc structure if found or NULL
  * otherwise. If key is found ipc points to the owning ipc structure
  *
@@ -538,7 +538,7 @@ int ipcperms(struct ipc_namespace *ns, s
 	else if (in_group_p(ipcp->cgid) || in_group_p(ipcp->gid))
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
-	if ((requested_mode & ~granted_mode & 0007) && 
+	if ((requested_mode & ~granted_mode & 0007) &&
 	    !ns_capable(ns->user_ns, CAP_IPC_OWNER))
 		return -1;
 
diff -puN ipc/util.h~ipc-kernel-clear-whitespace ipc/util.h
--- a/ipc/util.h~ipc-kernel-clear-whitespace
+++ a/ipc/util.h
@@ -78,9 +78,9 @@ struct ipc_params {
  *      . routine to call for an extra check if needed
  */
 struct ipc_ops {
-	int (*getnew) (struct ipc_namespace *, struct ipc_params *);
-	int (*associate) (struct kern_ipc_perm *, int);
-	int (*more_checks) (struct kern_ipc_perm *, struct ipc_params *);
+	int (*getnew)(struct ipc_namespace *, struct ipc_params *);
+	int (*associate)(struct kern_ipc_perm *, int);
+	int (*more_checks)(struct kern_ipc_perm *, struct ipc_params *);
 };
 
 struct seq_file;
@@ -142,7 +142,7 @@ struct kern_ipc_perm *ipcctl_pre_down_no
 					     struct ipc64_perm *perm, int extra_perm);
 
 #ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
-  /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
+/* On IA-64, we always use the "64-bit version" of the IPC structures.  */
 # define ipc_parse_version(cmd)	IPC_64
 #else
 int ipc_parse_version(int *cmd);
diff -puN kernel/acct.c~ipc-kernel-clear-whitespace kernel/acct.c
--- a/kernel/acct.c~ipc-kernel-clear-whitespace
+++ a/kernel/acct.c
@@ -134,7 +134,7 @@ static int check_free_space(struct bsd_a
 	spin_lock(&acct_lock);
 	if (file != acct->file) {
 		if (act)
-			res = act>0;
+			res = act > 0;
 		goto out;
 	}
 
@@ -262,7 +262,7 @@ SYSCALL_DEFINE1(acct, const char __user
 	if (name) {
 		struct filename *tmp = getname(name);
 		if (IS_ERR(tmp))
-			return (PTR_ERR(tmp));
+			return PTR_ERR(tmp);
 		error = acct_on(tmp);
 		putname(tmp);
 	} else {
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

ipc-kernel-use-linux-headers.patch
ipc-kernel-clear-whitespace.patch
linux-next.patch

