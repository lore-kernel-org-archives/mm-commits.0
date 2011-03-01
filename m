From: akpm@linux-foundation.org
Subject: + userns-allow-ptrace-from-non-init-user-namespaces.patch added to -mm tree
Date: Mon, 28 Feb 2011 16:29:19 -0800
Message-ID: <201103010029.p210TJQU007093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab1CAA3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 19:29:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com


The patch titled
     userns: allow ptrace from non-init user namespaces
has been added to the -mm tree.  Its filename is
     userns-allow-ptrace-from-non-init-user-namespaces.patch

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
Subject: userns: allow ptrace from non-init user namespaces
From: "Serge E. Hallyn" <serge@hallyn.com>

ptrace is allowed to tasks in the same user namespace according to the
usual rules (i.e.  the same rules as for two tasks in the init user
namespace).  ptrace is also allowed to a user namespace to which the
current task the has CAP_SYS_PTRACE capability.

Changelog:
	Dec 31: Address feedback by Eric:
		. Correct ptrace uid check
		. Rename may_ptrace_ns to ptrace_capable
		. Also fix the cap_ptrace checks.
	Jan  1: Use const cred struct
	Jan 11: use task_ns_capable() in place of ptrace_capable().
	Feb 23: same_or_ancestore_user_ns() was not an appropriate
		check to constrain cap_issubset.  Rather, cap_issubset()
		only is meaningful when both capsets are in the same
		user_ns.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    2 +
 kernel/ptrace.c            |   27 +++++++++++++----------
 security/commoncap.c       |   40 ++++++++++++++++++++++++++++-------
 3 files changed, 49 insertions(+), 20 deletions(-)

diff -puN include/linux/capability.h~userns-allow-ptrace-from-non-init-user-namespaces include/linux/capability.h
--- a/include/linux/capability.h~userns-allow-ptrace-from-non-init-user-namespaces
+++ a/include/linux/capability.h
@@ -553,6 +553,8 @@ static inline kernel_cap_t cap_raise_nfs
  */
 #define has_capability(t, cap) (security_real_capable((t), &init_user_ns, (cap)) == 0)
 
+#define has_ns_capability(t, ns, cap) (security_real_capable((t), (ns), (cap)) == 0)
+
 /**
  * has_capability_noaudit - Determine if a task has a superior capability available (unaudited)
  * @t: The task in question
diff -puN kernel/ptrace.c~userns-allow-ptrace-from-non-init-user-namespaces kernel/ptrace.c
--- a/kernel/ptrace.c~userns-allow-ptrace-from-non-init-user-namespaces
+++ a/kernel/ptrace.c
@@ -134,21 +134,24 @@ int __ptrace_may_access(struct task_stru
 		return 0;
 	rcu_read_lock();
 	tcred = __task_cred(task);
-	if ((cred->uid != tcred->euid ||
-	     cred->uid != tcred->suid ||
-	     cred->uid != tcred->uid  ||
-	     cred->gid != tcred->egid ||
-	     cred->gid != tcred->sgid ||
-	     cred->gid != tcred->gid) &&
-	    !capable(CAP_SYS_PTRACE)) {
-		rcu_read_unlock();
-		return -EPERM;
-	}
+	if (cred->user->user_ns == tcred->user->user_ns &&
+	    (cred->uid == tcred->euid &&
+	     cred->uid == tcred->suid &&
+	     cred->uid == tcred->uid  &&
+	     cred->gid == tcred->egid &&
+	     cred->gid == tcred->sgid &&
+	     cred->gid == tcred->gid))
+		goto ok;
+	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+		goto ok;
+	rcu_read_unlock();
+	return -EPERM;
+ok:
 	rcu_read_unlock();
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !capable(CAP_SYS_PTRACE))
+	if (!dumpable && !task_ns_capable(task, CAP_SYS_PTRACE))
 		return -EPERM;
 
 	return security_ptrace_access_check(task, mode);
@@ -198,7 +201,7 @@ int ptrace_attach(struct task_struct *ta
 		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
-	if (capable(CAP_SYS_PTRACE))
+	if (task_ns_capable(task, CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
diff -puN security/commoncap.c~userns-allow-ptrace-from-non-init-user-namespaces security/commoncap.c
--- a/security/commoncap.c~userns-allow-ptrace-from-non-init-user-namespaces
+++ a/security/commoncap.c
@@ -128,18 +128,30 @@ int cap_settime(const struct timespec *t
  * @child: The process to be accessed
  * @mode: The mode of attachment.
  *
+ * If we are in the same or an ancestor user_ns and have all the target
+ * task's capabilities, then ptrace access is allowed.
+ * If we have the ptrace capability to the target user_ns, then ptrace
+ * access is allowed.
+ * Else denied.
+ *
  * Determine whether a process may access another, returning 0 if permission
  * granted, -ve if denied.
  */
 int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
+	const struct cred *cred, *child_cred;
 
 	rcu_read_lock();
-	if (!cap_issubset(__task_cred(child)->cap_permitted,
-			  current_cred()->cap_permitted) &&
-	    !capable(CAP_SYS_PTRACE))
-		ret = -EPERM;
+	cred = current_cred();
+	child_cred = __task_cred(child);
+	if (cred->user->user_ns == child_cred->user->user_ns &&
+	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
+		goto out;
+	if (ns_capable(child_cred->user->user_ns, CAP_SYS_PTRACE))
+		goto out;
+	ret = -EPERM;
+out:
 	rcu_read_unlock();
 	return ret;
 }
@@ -148,18 +160,30 @@ int cap_ptrace_access_check(struct task_
  * cap_ptrace_traceme - Determine whether another process may trace the current
  * @parent: The task proposed to be the tracer
  *
+ * If parent is in the same or an ancestor user_ns and has all current's
+ * capabilities, then ptrace access is allowed.
+ * If parent has the ptrace capability to current's user_ns, then ptrace
+ * access is allowed.
+ * Else denied.
+ *
  * Determine whether the nominated task is permitted to trace the current
  * process, returning 0 if permission is granted, -ve if denied.
  */
 int cap_ptrace_traceme(struct task_struct *parent)
 {
 	int ret = 0;
+	const struct cred *cred, *child_cred;
 
 	rcu_read_lock();
-	if (!cap_issubset(current_cred()->cap_permitted,
-			  __task_cred(parent)->cap_permitted) &&
-	    !has_capability(parent, CAP_SYS_PTRACE))
-		ret = -EPERM;
+	cred = __task_cred(parent);
+	child_cred = current_cred();
+	if (cred->user->user_ns == child_cred->user->user_ns &&
+	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
+		goto out;
+	if (has_ns_capability(parent, child_cred->user->user_ns, CAP_SYS_PTRACE))
+		goto out;
+	ret = -EPERM;
+out:
 	rcu_read_unlock();
 	return ret;
 }
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

