From: akpm@linux-foundation.org
Subject: [to-be-updated] userns-user-namespaces-convert-several-capable-calls.patch removed from -mm tree
Date: Mon, 28 Feb 2011 16:12:09 -0800
Message-ID: <201103010012.p210C9Xx006224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801Ab1CAAMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 19:12:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, kees.cook@canonical.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: user namespaces: convert several capable() calls
has been removed from the -mm tree.  Its filename was
     userns-user-namespaces-convert-several-capable-calls.patch

This patch was dropped because an updated version will be merged

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

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c             |    2 +-
 ipc/util.c            |    5 +++--
 kernel/futex.c        |   11 ++++++++++-
 kernel/futex_compat.c |   11 ++++++++++-
 kernel/groups.c       |    2 +-
 kernel/sched.c        |    9 ++++++---
 kernel/uid16.c        |    2 +-
 7 files changed, 32 insertions(+), 10 deletions(-)

diff -puN ipc/shm.c~userns-user-namespaces-convert-several-capable-calls ipc/shm.c
--- a/ipc/shm.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/shm.c
@@ -773,7 +773,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 
 		audit_ipc_obj(&(shp->shm_perm));
 
-		if (!capable(CAP_IPC_LOCK)) {
+		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
 			uid_t euid = current_euid();
 			err = -EPERM;
 			if (euid != shp->shm_perm.uid &&
diff -puN ipc/util.c~userns-user-namespaces-convert-several-capable-calls ipc/util.c
--- a/ipc/util.c~userns-user-namespaces-convert-several-capable-calls
+++ a/ipc/util.c
@@ -627,7 +627,7 @@ int ipcperms (struct kern_ipc_perm *ipcp
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
 	if ((requested_mode & ~granted_mode & 0007) && 
-	    !capable(CAP_IPC_OWNER))
+	    !ns_capable(current->nsproxy->ipc_ns->user_ns, CAP_IPC_OWNER))
 		return -1;
 
 	return security_ipc_permission(ipcp, flag);
@@ -800,7 +800,8 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 
 	euid = current_euid();
 	if (euid == ipcp->cuid ||
-	    euid == ipcp->uid  || capable(CAP_SYS_ADMIN))
+	    euid == ipcp->uid  ||
+	    ns_capable(current->nsproxy->ipc_ns->user_ns, CAP_SYS_ADMIN))
 		return ipcp;
 
 	err = -EPERM;
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
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch

