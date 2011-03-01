From: akpm@linux-foundation.org
Subject: + userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch added to -mm tree
Date: Mon, 28 Feb 2011 16:29:21 -0800
Message-ID: <201103010029.p210TM9g007096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab1CAA3g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 19:29:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com


The patch titled
     userns: user namespaces: convert all capable checks in kernel/sys.c
has been added to the -mm tree.  Its filename is
     userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch

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
Subject: userns: user namespaces: convert all capable checks in kernel/sys.c
From: "Serge E. Hallyn" <serge@hallyn.com>

This allows setuid/setgid in containers.  It also fixes some corner cases
where kernel logic foregoes capability checks when uids are equivalent. 
The latter will need to be done throughout the whole kernel.

Changelog:
	Jan 11: Use nsown_capable() as suggested by Bastian Blank.
	Jan 11: Fix logic errors in uid checks pointed out by Bastian.
	Feb 15: allow prlimit to current (was regression in previous version)
	Feb 23: remove debugging printks, uninline set_one_prio_perm and
		make it bool, and document its return value.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   73 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff -puN kernel/sys.c~userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc kernel/sys.c
--- a/kernel/sys.c~userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc
+++ a/kernel/sys.c
@@ -119,16 +119,33 @@ EXPORT_SYMBOL(cad_pid);
 void (*pm_power_off_prepare)(void);
 
 /*
+ * Returns true if current's euid is same as p's uid or euid,
+ * or has CAP_SYS_NICE to p's user_ns.
+ *
+ * Called with rcu_read_lock, creds are safe
+ */
+static bool set_one_prio_perm(struct task_struct *p)
+{
+	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
+
+	if (pcred->user->user_ns == cred->user->user_ns &&
+	    (pcred->uid  == cred->euid ||
+	     pcred->euid == cred->euid))
+		return true;
+	if (ns_capable(pcred->user->user_ns, CAP_SYS_NICE))
+		return true;
+	return false;
+}
+
+/*
  * set the priority of a task
  * - the caller must hold the RCU read lock
  */
 static int set_one_prio(struct task_struct *p, int niceval, int error)
 {
-	const struct cred *cred = current_cred(), *pcred = __task_cred(p);
 	int no_nice;
 
-	if (pcred->uid  != cred->euid &&
-	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
+	if (!set_one_prio_perm(p)) {
 		error = -EPERM;
 		goto out;
 	}
@@ -502,7 +519,7 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, g
 	if (rgid != (gid_t) -1) {
 		if (old->gid == rgid ||
 		    old->egid == rgid ||
-		    capable(CAP_SETGID))
+		    nsown_capable(CAP_SETGID))
 			new->gid = rgid;
 		else
 			goto error;
@@ -511,7 +528,7 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, g
 		if (old->gid == egid ||
 		    old->egid == egid ||
 		    old->sgid == egid ||
-		    capable(CAP_SETGID))
+		    nsown_capable(CAP_SETGID))
 			new->egid = egid;
 		else
 			goto error;
@@ -546,7 +563,7 @@ SYSCALL_DEFINE1(setgid, gid_t, gid)
 	old = current_cred();
 
 	retval = -EPERM;
-	if (capable(CAP_SETGID))
+	if (nsown_capable(CAP_SETGID))
 		new->gid = new->egid = new->sgid = new->fsgid = gid;
 	else if (gid == old->gid || gid == old->sgid)
 		new->egid = new->fsgid = gid;
@@ -613,7 +630,7 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, u
 		new->uid = ruid;
 		if (old->uid != ruid &&
 		    old->euid != ruid &&
-		    !capable(CAP_SETUID))
+		    !nsown_capable(CAP_SETUID))
 			goto error;
 	}
 
@@ -622,7 +639,7 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, u
 		if (old->uid != euid &&
 		    old->euid != euid &&
 		    old->suid != euid &&
-		    !capable(CAP_SETUID))
+		    !nsown_capable(CAP_SETUID))
 			goto error;
 	}
 
@@ -670,7 +687,7 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
 	old = current_cred();
 
 	retval = -EPERM;
-	if (capable(CAP_SETUID)) {
+	if (nsown_capable(CAP_SETUID)) {
 		new->suid = new->uid = uid;
 		if (uid != old->uid) {
 			retval = set_user(new);
@@ -712,7 +729,7 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, 
 	old = current_cred();
 
 	retval = -EPERM;
-	if (!capable(CAP_SETUID)) {
+	if (!nsown_capable(CAP_SETUID)) {
 		if (ruid != (uid_t) -1 && ruid != old->uid &&
 		    ruid != old->euid  && ruid != old->suid)
 			goto error;
@@ -776,7 +793,7 @@ SYSCALL_DEFINE3(setresgid, gid_t, rgid, 
 	old = current_cred();
 
 	retval = -EPERM;
-	if (!capable(CAP_SETGID)) {
+	if (!nsown_capable(CAP_SETGID)) {
 		if (rgid != (gid_t) -1 && rgid != old->gid &&
 		    rgid != old->egid  && rgid != old->sgid)
 			goto error;
@@ -836,7 +853,7 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 
 	if (uid == old->uid  || uid == old->euid  ||
 	    uid == old->suid || uid == old->fsuid ||
-	    capable(CAP_SETUID)) {
+	    nsown_capable(CAP_SETUID)) {
 		if (uid != old_fsuid) {
 			new->fsuid = uid;
 			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
@@ -869,7 +886,7 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
 
 	if (gid == old->gid  || gid == old->egid  ||
 	    gid == old->sgid || gid == old->fsgid ||
-	    capable(CAP_SETGID)) {
+	    nsown_capable(CAP_SETGID)) {
 		if (gid != old_fsgid) {
 			new->fsgid = gid;
 			goto change_okay;
@@ -1179,6 +1196,7 @@ SYSCALL_DEFINE2(sethostname, char __user
 
 	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
+
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
 	down_write(&uts_sem);
@@ -1226,7 +1244,7 @@ SYSCALL_DEFINE2(setdomainname, char __us
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
@@ -1341,6 +1359,8 @@ int do_prlimit(struct task_struct *tsk, 
 	rlim = tsk->signal->rlim + resource;
 	task_lock(tsk->group_leader);
 	if (new_rlim) {
+		/* Keep the capable check against init_user_ns until
+		   cgroups can contain all limits */
 		if (new_rlim->rlim_max > rlim->rlim_max &&
 				!capable(CAP_SYS_RESOURCE))
 			retval = -EPERM;
@@ -1384,19 +1404,22 @@ static int check_prlimit_permission(stru
 {
 	const struct cred *cred = current_cred(), *tcred;
 
+	if (current == task)
+		return 0;
+
 	tcred = __task_cred(task);
-	if (current != task &&
-	    (cred->uid != tcred->euid ||
-	     cred->uid != tcred->suid ||
-	     cred->uid != tcred->uid  ||
-	     cred->gid != tcred->egid ||
-	     cred->gid != tcred->sgid ||
-	     cred->gid != tcred->gid) &&
-	     !capable(CAP_SYS_RESOURCE)) {
-		return -EPERM;
-	}
+	if (cred->user->user_ns == tcred->user->user_ns &&
+	    (cred->uid == tcred->euid &&
+	     cred->uid == tcred->suid &&
+	     cred->uid == tcred->uid  &&
+	     cred->gid == tcred->egid &&
+	     cred->gid == tcred->sgid &&
+	     cred->gid == tcred->gid))
+		return 0;
+	if (ns_capable(tcred->user->user_ns, CAP_SYS_RESOURCE))
+		return 0;
 
-	return 0;
+	return -EPERM;
 }
 
 SYSCALL_DEFINE4(prlimit64, pid_t, pid, unsigned int, resource,
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

