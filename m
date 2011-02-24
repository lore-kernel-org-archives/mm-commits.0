From: akpm@linux-foundation.org
Subject: + userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric.patch added to -mm tree
Date: Wed, 23 Feb 2011 16:56:13 -0800
Message-ID: <201102240056.p1O0uDTj002576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab1BXA4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, kees.cook@canonical.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com


The patch titled
     userns: ptrace: incorporate feedback from Eric
has been added to the -mm tree.  Its filename is
     userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric.patch

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
Subject: userns: ptrace: incorporate feedback from Eric
From: "Serge E. Hallyn" <serge@hallyn.com>

same_or_ancestore_user_ns() was not an appropriate check to
constrain cap_issubset.  Rather, cap_issubset() only is
meaningful when both capsets are in the same user_ns.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |    9 ---------
 kernel/user_namespace.c        |   16 ----------------
 security/commoncap.c           |   28 ++++++++++------------------
 3 files changed, 10 insertions(+), 43 deletions(-)

diff -puN include/linux/user_namespace.h~userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric
+++ a/include/linux/user_namespace.h
@@ -39,9 +39,6 @@ static inline void put_user_ns(struct us
 uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t uid);
 gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t gid);
 
-int same_or_ancestor_user_ns(struct task_struct *task,
-	struct task_struct *victim);
-
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -69,12 +66,6 @@ static inline gid_t user_ns_map_gid(stru
 	return gid;
 }
 
-static inline int same_or_ancestor_user_ns(struct task_struct *task,
-	struct task_struct *victim)
-{
-	return 1;
-}
-
 #endif
 
 #endif /* _LINUX_USER_H */
diff -puN kernel/user_namespace.c~userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric kernel/user_namespace.c
--- a/kernel/user_namespace.c~userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric
+++ a/kernel/user_namespace.c
@@ -129,22 +129,6 @@ gid_t user_ns_map_gid(struct user_namesp
 	return overflowgid;
 }
 
-int same_or_ancestor_user_ns(struct task_struct *task,
-	struct task_struct *victim)
-{
-	struct user_namespace *u1 = task_cred_xxx(task, user)->user_ns;
-	struct user_namespace *u2 = task_cred_xxx(victim, user)->user_ns;
-	for (;;) {
-		if (u1 == u2)
-			return 1;
-		if (u1 == &init_user_ns)
-			return 0;
-		u1 = u1->creator->user_ns;
-	}
-	/* We never get here */
-	return 0;
-}
-
 static __init int user_namespaces_init(void)
 {
 	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
diff -puN security/commoncap.c~userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric security/commoncap.c
--- a/security/commoncap.c~userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric
+++ a/security/commoncap.c
@@ -142,19 +142,15 @@ int cap_settime(const struct timespec *t
 int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
-	const struct cred *cred, *tcred;
+	const struct cred *cred, *child_cred;
 
 	rcu_read_lock();
 	cred = current_cred();
-	tcred = __task_cred(child);
-	/*
-	 * The ancestor user_ns check may be gratuitous, as I think
-	 * we've already guaranteed that in kernel/ptrace.c.
-	 */
-	if (same_or_ancestor_user_ns(current, child) &&
-	    cap_issubset(tcred->cap_permitted, cred->cap_permitted))
+	child_cred = __task_cred(child);
+	if (cred->user->user_ns == child_cred->user->user_ns &&
+	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
 		goto out;
-	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+	if (ns_capable(child_cred->user->user_ns, CAP_SYS_PTRACE))
 		goto out;
 	ret = -EPERM;
 out:
@@ -178,19 +174,15 @@ out:
 int cap_ptrace_traceme(struct task_struct *parent)
 {
 	int ret = 0;
-	const struct cred *cred, *tcred;
+	const struct cred *cred, *child_cred;
 
 	rcu_read_lock();
 	cred = __task_cred(parent);
-	tcred = current_cred();
-	/*
-	 * The ancestor user_ns check may be gratuitous, as I think
-	 * we've already guaranteed that in kernel/ptrace.c.
-	 */
-	if (same_or_ancestor_user_ns(parent, current) &&
-	    cap_issubset(tcred->cap_permitted, cred->cap_permitted))
+	child_cred = current_cred();
+	if (cred->user->user_ns == child_cred->user->user_ns &&
+	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
 		goto out;
-	if (has_ns_capability(parent, tcred->user->user_ns, CAP_SYS_PTRACE))
+	if (has_ns_capability(parent, child_cred->user->user_ns, CAP_SYS_PTRACE))
 		goto out;
 	ret = -EPERM;
 out:
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
userns-allow-ptrace-from-non-init-user-namespaces-incorporate-feedback-from-eric.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch

