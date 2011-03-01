From: akpm@linux-foundation.org
Subject: + userns-user-namespaces-convert-several-capable-calls.patch added to -mm tree
Date: Mon, 28 Feb 2011 16:29:26 -0800
Message-ID: <201103010029.p210TQ0B007107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970Ab1CAA3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 19:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com


The patch titled
     userns: user namespaces: convert several capable() calls
has been added to the -mm tree.  Its filename is
     userns-user-namespaces-convert-several-capable-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: user namespaces: convert several capable() calls
From: "Serge E. Hallyn" <serge@hallyn.com>

CAP_IPC_OWNER and CAP_IPC_LOCK can be checked against current_user_ns(),
because the resource comes from current's own ipc namespace.

setuid/setgid are to uids in own namespace, so again checks can be against
current_user_ns().

Changelog:
	Jan 11: Use task_ns_capable() in place of sched_capable().
	Jan 11: Use nsown_capable() as suggested by Bastian Blank.
	Jan 11: Clarify (hopefully) some logic in futex and sched.c
	Feb 15: use ns_capable for ipc, not nsown_capable
	Feb 23: let copy_ipcs handle setting ipc_ns->user_ns
	Feb 23: pass ns down rather than taking it from current

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    7 ++++---
 ipc/msg.c                     |    8 ++++----
 ipc/namespace.c               |   13 ++++++++-----
 ipc/sem.c                     |    9 +++++----
 ipc/shm.c                     |    9 +++++----
 ipc/util.c                    |   22 +++++++++++++---------
 ipc/util.h                    |    5 +++--
 kernel/futex.c                |   11 ++++++++++-
 kernel/futex_compat.c         |   11 ++++++++++-
 kernel/groups.c               |    2 +-
 kernel/nsproxy.c              |    7 +------
 kernel/sched.c                |    9 ++++++---
 kernel/uid16.c                |    2 +-
 13 files changed, 71 insertions(+), 44 deletions(-)

diff -puN include/linux/ipc_namespace.h~userns-user-namespaces-convert-several-capable-calls include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~userns-user-namespaces-convert-several-capable-calls
+++ a/include/linux/ipc_namespace.h
@@ -5,6 +5,7 @@
 #include <linux/idr.h>
 #include <linux/rwsem.h>
 #include <linux/notifier.h>
+#include <linux/nsproxy.h>
 
 /*
  * ipc namespace events
@@ -94,7 +95,7 @@ static inline int mq_init_ns(struct ipc_
 
 #if defined(CONFIG_IPC_NS)
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
-				       struct ipc_namespace *ns);
+				       struct task_struct *tsk);
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
 {
 	if (ns)
@@ -105,12 +106,12 @@ static inline struct ipc_namespace *get_
 extern void put_ipc_ns(struct ipc_namespace *ns);
 #else
 static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
-		struct ipc_namespace *ns)
+					      struct task_struct *tsk)
 {
 	if (flags & CLONE_NEWIPC)
 		return ERR_PTR(-EINVAL);
 
-	return ns;
+	return tsk->nsproxy->ipc_ns;
 }
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
diff -puN ipc/msg.c~userns-user-namespaces-convert-several-capable-calls ipc/msg.c
--- a/ipc/msg.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/msg.c
@@ -421,7 +421,7 @@ static int msgctl_down(struct ipc_namesp
 			return -EFAULT;
 	}
 
-	ipcp = ipcctl_pre_down(&msg_ids(ns), msqid, cmd,
+	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
 			       &msqid64.msg_perm, msqid64.msg_qbytes);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
@@ -539,7 +539,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 			success_return = 0;
 		}
 		err = -EACCES;
-		if (ipcperms(&msq->q_perm, S_IRUGO))
+		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
 
 		err = security_msg_queue_msgctl(msq, cmd);
@@ -664,7 +664,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		struct msg_sender s;
 
 		err = -EACCES;
-		if (ipcperms(&msq->q_perm, S_IWUGO))
+		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
 			goto out_unlock_free;
 
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
@@ -774,7 +774,7 @@ long do_msgrcv(int msqid, long *pmtype, 
 		struct list_head *tmp;
 
 		msg = ERR_PTR(-EACCES);
-		if (ipcperms(&msq->q_perm, S_IRUGO))
+		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
 
 		msg = ERR_PTR(-EAGAIN);
diff -puN ipc/namespace.c~userns-user-namespaces-convert-several-capable-calls ipc/namespace.c
--- a/ipc/namespace.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/namespace.c
@@ -15,7 +15,8 @@
 
 #include "util.h"
 
-static struct ipc_namespace *create_ipc_ns(struct ipc_namespace *old_ns)
+static struct ipc_namespace *create_ipc_ns(struct task_struct *tsk,
+					   struct ipc_namespace *old_ns)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -44,17 +45,19 @@ static struct ipc_namespace *create_ipc_
 	ipcns_notify(IPCNS_CREATED);
 	register_ipcns_notifier(ns);
 
-	ns->user_ns = old_ns->user_ns;
-	get_user_ns(ns->user_ns);
+	ns->user_ns = get_user_ns(task_cred_xxx(tsk, user)->user_ns);
 
 	return ns;
 }
 
-struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
+struct ipc_namespace *copy_ipcs(unsigned long flags,
+				struct task_struct *tsk)
 {
+	struct ipc_namespace *ns = tsk->nsproxy->ipc_ns;
+
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-	return create_ipc_ns(ns);
+	return create_ipc_ns(tsk, ns);
 }
 
 /*
diff -puN ipc/sem.c~userns-user-namespaces-convert-several-capable-calls ipc/sem.c
--- a/ipc/sem.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/sem.c
@@ -817,7 +817,7 @@ static int semctl_nolock(struct ipc_name
 		}
 
 		err = -EACCES;
-		if (ipcperms (&sma->sem_perm, S_IRUGO))
+		if (ipcperms (ns, &sma->sem_perm, S_IRUGO))
 			goto out_unlock;
 
 		err = security_sem_semctl(sma, cmd);
@@ -862,7 +862,7 @@ static int semctl_main(struct ipc_namesp
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
-	if (ipcperms (&sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 		goto out_unlock;
 
 	err = security_sem_semctl(sma, cmd);
@@ -1047,7 +1047,8 @@ static int semctl_down(struct ipc_namesp
 			return -EFAULT;
 	}
 
-	ipcp = ipcctl_pre_down(&sem_ids(ns), semid, cmd, &semid64.sem_perm, 0);
+	ipcp = ipcctl_pre_down(ns, &sem_ids(ns), semid, cmd,
+			       &semid64.sem_perm, 0);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
 
@@ -1386,7 +1387,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 		goto out_unlock_free;
 
 	error = -EACCES;
-	if (ipcperms(&sma->sem_perm, alter ? S_IWUGO : S_IRUGO))
+	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO))
 		goto out_unlock_free;
 
 	error = security_sem_semop(sma, sops, nsops, alter);
diff -puN ipc/shm.c~userns-user-namespaces-convert-several-capable-calls ipc/shm.c
--- a/ipc/shm.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/shm.c
@@ -623,7 +623,8 @@ static int shmctl_down(struct ipc_namesp
 			return -EFAULT;
 	}
 
-	ipcp = ipcctl_pre_down(&shm_ids(ns), shmid, cmd, &shmid64.shm_perm, 0);
+	ipcp = ipcctl_pre_down(ns, &shm_ids(ns), shmid, cmd,
+			       &shmid64.shm_perm, 0);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
 
@@ -737,7 +738,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 			result = 0;
 		}
 		err = -EACCES;
-		if (ipcperms (&shp->shm_perm, S_IRUGO))
+		if (ipcperms (ns, &shp->shm_perm, S_IRUGO))
 			goto out_unlock;
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
@@ -773,7 +774,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 
 		audit_ipc_obj(&(shp->shm_perm));
 
-		if (!capable(CAP_IPC_LOCK)) {
+		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			uid_t euid = current_euid();
 			err = -EPERM;
 			if (euid != shp->shm_perm.uid &&
@@ -888,7 +889,7 @@ long do_shmat(int shmid, char __user *sh
 	}
 
 	err = -EACCES;
-	if (ipcperms(&shp->shm_perm, acc_mode))
+	if (ipcperms(ns, &shp->shm_perm, acc_mode))
 		goto out_unlock;
 
 	err = security_shm_shmat(shp, shmaddr, shmflg);
diff -puN ipc/util.c~userns-user-namespaces-convert-several-capable-calls ipc/util.c
--- a/ipc/util.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/util.c
@@ -329,12 +329,14 @@ retry:
  *
  *	It is called with ipc_ids.rw_mutex and ipcp->lock held.
  */
-static int ipc_check_perms(struct kern_ipc_perm *ipcp, struct ipc_ops *ops,
-			struct ipc_params *params)
+static int ipc_check_perms(struct ipc_namespace *ns,
+			   struct kern_ipc_perm *ipcp,
+			   struct ipc_ops *ops,
+			   struct ipc_params *params)
 {
 	int err;
 
-	if (ipcperms(ipcp, params->flg))
+	if (ipcperms(ns, ipcp, params->flg))
 		err = -EACCES;
 	else {
 		err = ops->associate(ipcp, params->flg);
@@ -396,7 +398,7 @@ retry:
 				 * ipc_check_perms returns the IPC id on
 				 * success
 				 */
-				err = ipc_check_perms(ipcp, ops, params);
+				err = ipc_check_perms(ns, ipcp, ops, params);
 		}
 		ipc_unlock(ipcp);
 	}
@@ -612,7 +614,7 @@ void ipc_rcu_putref(void *ptr)
  *	to ipc resources. return 0 if allowed
  */
  
-int ipcperms (struct kern_ipc_perm *ipcp, short flag)
+int ipcperms (struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
 {	/* flag will most probably be 0 or S_...UGO from <linux/stat.h> */
 	uid_t euid = current_euid();
 	int requested_mode, granted_mode;
@@ -627,7 +629,7 @@ int ipcperms (struct kern_ipc_perm *ipcp
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
 	if ((requested_mode & ~granted_mode & 0007) && 
-	    !capable(CAP_IPC_OWNER))
+	    !ns_capable(ns->user_ns, CAP_IPC_OWNER))
 		return -1;
 
 	return security_ipc_permission(ipcp, flag);
@@ -765,6 +767,7 @@ void ipc_update_perm(struct ipc64_perm *
 
 /**
  * ipcctl_pre_down - retrieve an ipc and check permissions for some IPC_XXX cmd
+ * @ids:  the ipc namespace
  * @ids:  the table of ids where to look for the ipc
  * @id:   the id of the ipc to retrieve
  * @cmd:  the cmd to check
@@ -779,7 +782,8 @@ void ipc_update_perm(struct ipc64_perm *
  *  - returns the ipc with both ipc and rw_mutex locks held in case of success
  *    or an err-code without any lock held otherwise.
  */
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
+struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
+				      struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
@@ -799,8 +803,8 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 					 perm->gid, perm->mode);
 
 	euid = current_euid();
-	if (euid == ipcp->cuid ||
-	    euid == ipcp->uid  || capable(CAP_SYS_ADMIN))
+	if (euid == ipcp->cuid || euid == ipcp->uid  ||
+	    ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 		return ipcp;
 
 	err = -EPERM;
diff -puN ipc/util.h~userns-user-namespaces-convert-several-capable-calls ipc/util.h
--- a/ipc/util.h~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/util.h
@@ -103,7 +103,7 @@ int ipc_get_maxid(struct ipc_ids *);
 void ipc_rmid(struct ipc_ids *, struct kern_ipc_perm *);
 
 /* must be called with ipcp locked */
-int ipcperms(struct kern_ipc_perm *ipcp, short flg);
+int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flg);
 
 /* for rare, potentially huge allocations.
  * both function can sleep
@@ -126,7 +126,8 @@ struct kern_ipc_perm *ipc_lock(struct ip
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
-struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
+struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
+				      struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
 
 #ifndef __ARCH_WANT_IPC_PARSE_VERSION
diff -puN kernel/futex.c~userns-user-namespaces-convert-several-capable-calls kernel/futex.c
--- a/kernel/futex.c~userns-user-namespaces-convert-several-capable-calls
+++ a/kernel/futex.c
@@ -2423,10 +2423,19 @@ SYSCALL_DEFINE3(get_robust_list, int, pi
 			goto err_unlock;
 		ret = -EPERM;
 		pcred = __task_cred(p);
+		/* If victim is in different user_ns, then uids are not
+		   comparable, so we must have CAP_SYS_PTRACE */
+		if (cred->user->user_ns != pcred->user->user_ns) {
+			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
+				goto err_unlock;
+			goto ok;
+		}
+		/* If victim is in same user_ns, then uids are comparable */
 		if (cred->euid != pcred->euid &&
 		    cred->euid != pcred->uid &&
-		    !capable(CAP_SYS_PTRACE))
+		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
 			goto err_unlock;
+ok:
 		head = p->robust_list;
 		rcu_read_unlock();
 	}
diff -puN kernel/futex_compat.c~userns-user-namespaces-convert-several-capable-calls kernel/futex_compat.c
--- a/kernel/futex_compat.c~userns-user-namespaces-convert-several-capable-calls
+++ a/kernel/futex_compat.c
@@ -153,10 +153,19 @@ compat_sys_get_robust_list(int pid, comp
 			goto err_unlock;
 		ret = -EPERM;
 		pcred = __task_cred(p);
+		/* If victim is in different user_ns, then uids are not
+		   comparable, so we must have CAP_SYS_PTRACE */
+		if (cred->user->user_ns != pcred->user->user_ns) {
+			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
+				goto err_unlock;
+			goto ok;
+		}
+		/* If victim is in same user_ns, then uids are comparable */
 		if (cred->euid != pcred->euid &&
 		    cred->euid != pcred->uid &&
-		    !capable(CAP_SYS_PTRACE))
+		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
 			goto err_unlock;
+ok:
 		head = p->compat_robust_list;
 		rcu_read_unlock();
 	}
diff -puN kernel/groups.c~userns-user-namespaces-convert-several-capable-calls kernel/groups.c
--- a/kernel/groups.c~userns-user-namespaces-convert-several-capable-calls
+++ a/kernel/groups.c
@@ -233,7 +233,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsi
 	struct group_info *group_info;
 	int retval;
 
-	if (!capable(CAP_SETGID))
+	if (!nsown_capable(CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff -puN kernel/nsproxy.c~userns-user-namespaces-convert-several-capable-calls kernel/nsproxy.c
--- a/kernel/nsproxy.c~userns-user-namespaces-convert-several-capable-calls
+++ a/kernel/nsproxy.c
@@ -75,16 +75,11 @@ static struct nsproxy *create_new_namesp
 		goto out_uts;
 	}
 
-	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
+	new_nsp->ipc_ns = copy_ipcs(flags, tsk);
 	if (IS_ERR(new_nsp->ipc_ns)) {
 		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
 	}
-	if (new_nsp->ipc_ns != tsk->nsproxy->ipc_ns) {
-		put_user_ns(new_nsp->ipc_ns->user_ns);
-		new_nsp->ipc_ns->user_ns = task_cred_xxx(tsk, user)->user_ns;
-		get_user_ns(new_nsp->ipc_ns->user_ns);
-	}
 
 	new_nsp->pid_ns = copy_pid_ns(flags, task_active_pid_ns(tsk));
 	if (IS_ERR(new_nsp->pid_ns)) {
diff -puN kernel/sched.c~userns-user-namespaces-convert-several-capable-calls kernel/sched.c
--- a/kernel/sched.c~userns-user-namespaces-convert-several-capable-calls
+++ a/kernel/sched.c
@@ -4899,8 +4899,11 @@ static bool check_same_owner(struct task
 
 	rcu_read_lock();
 	pcred = __task_cred(p);
-	match = (cred->euid == pcred->euid ||
-		 cred->euid == pcred->uid);
+	if (cred->user->user_ns == pcred->user->user_ns)
+		match = (cred->euid == pcred->euid ||
+			 cred->euid == pcred->uid);
+	else
+		match = false;
 	rcu_read_unlock();
 	return match;
 }
@@ -5225,7 +5228,7 @@ long sched_setaffinity(pid_t pid, const 
 		goto out_free_cpus_allowed;
 	}
 	retval = -EPERM;
-	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
+	if (!check_same_owner(p) && !task_ns_capable(p, CAP_SYS_NICE))
 		goto out_unlock;
 
 	retval = security_task_setscheduler(p);
diff -puN kernel/uid16.c~userns-user-namespaces-convert-several-capable-calls kernel/uid16.c
--- a/kernel/uid16.c~userns-user-namespaces-convert-several-capable-calls
+++ a/kernel/uid16.c
@@ -189,7 +189,7 @@ SYSCALL_DEFINE2(setgroups16, int, gidset
 	struct group_info *group_info;
 	int retval;
 
-	if (!capable(CAP_SETGID))
+	if (!nsown_capable(CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
_

Patches currently in -mm which might be from serge@hallyn.com are

lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
pid-remove-the-child_reaper-special-case-in-init-mainc.patch
pidns-call-pid_ns_prepare_proc-from-create_pid_namespace.patch
procfs-kill-the-global-proc_mnt-variable.patch
userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-allow-sethostname-in-a-container.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch

