From: akpm@linux-foundation.org
Subject: + userns-security-make-capabilities-relative-to-the-user-namespace.patch added to -mm tree
Date: Fri, 18 Feb 2011 15:59:53 -0800
Message-ID: <201102182359.p1INxs2N025079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758799Ab1BSAA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge@hallyn.com, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, kees.cook@canonical.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com


The patch titled
     userns: security: Make capabilities relative to the user namespace.
has been added to the -mm tree.  Its filename is
     userns-security-make-capabilities-relative-to-the-user-namespace.patch

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
Subject: userns: security: Make capabilities relative to the user namespace.
From: "Serge E. Hallyn" <serge@hallyn.com>

- Introduce ns_capable to test for a capability in a non-default
  user namespace.
- Teach cap_capable to handle capabilities in a non-default
  user namespace.

The motivation is to get to the unprivileged creation of new namespaces. 
It looks like this gets us 90% of the way there, with only potential uid
confusion issues left.

I still need to handle getting all caps after creation but otherwise I
think I have a good starter patch that achieves all of your goals.

Changelog:
	11/05/2010: [serge] add apparmor
	12/14/2010: [serge] fix capabilities to created user namespaces
	Without this, if user serge creates a user_ns, he won't have
	capabilities to the user_ns he created.  THis is because we
	were first checking whether his effective caps had the caps
	he needed and returning -EPERM if not, and THEN checking whether
	he was the creator.  Reverse those checks.
	12/16/2010: [serge] security_real_capable needs ns argument in !security case
	01/11/2011: [serge] add task_ns_capable helper
	01/11/2011: [serge] add nsown_capable() helper per Bastian Blank suggestion
	02/16/2011: [serge] fix a logic bug: the root user is always creator of
		    init_user_ns, but should not always have capabilities to
		    it!  Fix the check in cap_capable().

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |   10 +++++++-
 include/linux/security.h   |   25 ++++++++++++---------
 kernel/capability.c        |   32 ++++++++++++++++++++++++++--
 security/apparmor/lsm.c    |    5 ++--
 security/commoncap.c       |   40 ++++++++++++++++++++++++++++-------
 security/security.c        |   16 ++++++++------
 security/selinux/hooks.c   |   14 +++++++-----
 7 files changed, 107 insertions(+), 35 deletions(-)

diff -puN include/linux/capability.h~userns-security-make-capabilities-relative-to-the-user-namespace include/linux/capability.h
--- a/include/linux/capability.h~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/include/linux/capability.h
@@ -544,7 +544,7 @@ extern const kernel_cap_t __cap_init_eff
  *
  * Note that this does not set PF_SUPERPRIV on the task.
  */
-#define has_capability(t, cap) (security_real_capable((t), (cap)) == 0)
+#define has_capability(t, cap) (security_real_capable((t), &init_user_ns, (cap)) == 0)
 
 /**
  * has_capability_noaudit - Determine if a task has a superior capability available (unaudited)
@@ -558,9 +558,15 @@ extern const kernel_cap_t __cap_init_eff
  * Note that this does not set PF_SUPERPRIV on the task.
  */
 #define has_capability_noaudit(t, cap) \
-	(security_real_capable_noaudit((t), (cap)) == 0)
+	(security_real_capable_noaudit((t), &init_user_ns, (cap)) == 0)
 
+struct user_namespace;
+extern struct user_namespace init_user_ns;
 extern int capable(int cap);
+extern int ns_capable(struct user_namespace *ns, int cap);
+extern int task_ns_capable(struct task_struct *t, int cap);
+
+#define nsown_capable(cap) (ns_capable(current_user_ns(), (cap)))
 
 /* audit system wants to get cap info from files as well */
 struct dentry;
diff -puN include/linux/security.h~userns-security-make-capabilities-relative-to-the-user-namespace include/linux/security.h
--- a/include/linux/security.h~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/include/linux/security.h
@@ -47,13 +47,14 @@
 
 struct ctl_table;
 struct audit_krule;
+struct user_namespace;
 
 /*
  * These functions are in security/capability.c and are used
  * as the default capabilities functions
  */
 extern int cap_capable(struct task_struct *tsk, const struct cred *cred,
-		       int cap, int audit);
+		       struct user_namespace *ns, int cap, int audit);
 extern int cap_settime(const struct timespec *ts, const struct timezone *tz);
 extern int cap_ptrace_access_check(struct task_struct *child, unsigned int mode);
 extern int cap_ptrace_traceme(struct task_struct *parent);
@@ -1256,6 +1257,7 @@ static inline void security_free_mnt_opt
  *	credentials.
  *	@tsk contains the task_struct for the process.
  *	@cred contains the credentials to use.
+ *      @ns contains the user namespace we want the capability in
  *	@cap contains the capability <include/linux/capability.h>.
  *	@audit: Whether to write an audit message or not
  *	Return 0 if the capability is granted for @tsk.
@@ -1378,7 +1380,7 @@ struct security_operations {
 		       const kernel_cap_t *inheritable,
 		       const kernel_cap_t *permitted);
 	int (*capable) (struct task_struct *tsk, const struct cred *cred,
-			int cap, int audit);
+			struct user_namespace *ns, int cap, int audit);
 	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
 	int (*quota_on) (struct dentry *dentry);
 	int (*syslog) (int type);
@@ -1658,9 +1660,9 @@ int security_capset(struct cred *new, co
 		    const kernel_cap_t *effective,
 		    const kernel_cap_t *inheritable,
 		    const kernel_cap_t *permitted);
-int security_capable(const struct cred *cred, int cap);
-int security_real_capable(struct task_struct *tsk, int cap);
-int security_real_capable_noaudit(struct task_struct *tsk, int cap);
+int security_capable(struct user_namespace *ns, const struct cred *cred, int cap);
+int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap);
+int security_real_capable_noaudit(struct task_struct *tsk, struct user_namespace *ns, int cap);
 int security_quotactl(int cmds, int type, int id, struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -1852,28 +1854,29 @@ static inline int security_capset(struct
 	return cap_capset(new, old, effective, inheritable, permitted);
 }
 
-static inline int security_capable(const struct cred *cred, int cap)
+static inline int security_capable(struct user_namespace *ns,
+				   const struct cred *cred, int cap)
 {
-	return cap_capable(current, cred, cap, SECURITY_CAP_AUDIT);
+	return cap_capable(current, cred, ns, cap, SECURITY_CAP_AUDIT);
 }
 
-static inline int security_real_capable(struct task_struct *tsk, int cap)
+static inline int security_real_capable(struct task_struct *tsk, struct user_namespace *ns, int cap)
 {
 	int ret;
 
 	rcu_read_lock();
-	ret = cap_capable(tsk, __task_cred(tsk), cap, SECURITY_CAP_AUDIT);
+	ret = cap_capable(tsk, __task_cred(tsk), ns, cap, SECURITY_CAP_AUDIT);
 	rcu_read_unlock();
 	return ret;
 }
 
 static inline
-int security_real_capable_noaudit(struct task_struct *tsk, int cap)
+int security_real_capable_noaudit(struct task_struct *tsk, struct user_namespace *ns, int cap)
 {
 	int ret;
 
 	rcu_read_lock();
-	ret = cap_capable(tsk, __task_cred(tsk), cap,
+	ret = cap_capable(tsk, __task_cred(tsk), ns, cap,
 			       SECURITY_CAP_NOAUDIT);
 	rcu_read_unlock();
 	return ret;
diff -puN kernel/capability.c~userns-security-make-capabilities-relative-to-the-user-namespace kernel/capability.c
--- a/kernel/capability.c~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/kernel/capability.c
@@ -14,6 +14,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /*
@@ -301,15 +302,42 @@ error:
  */
 int capable(int cap)
 {
+	return ns_capable(&init_user_ns, cap);
+}
+EXPORT_SYMBOL(capable);
+
+/**
+ * ns_capable - Determine if the current task has a superior capability in effect
+ * @ns:  The usernamespace we want the capability in
+ * @cap: The capability to be tested for
+ *
+ * Return true if the current task has the given superior capability currently
+ * available for use, false if not.
+ *
+ * This sets PF_SUPERPRIV on the task if the capability is available on the
+ * assumption that it's about to be used.
+ */
+int ns_capable(struct user_namespace *ns, int cap)
+{
 	if (unlikely(!cap_valid(cap))) {
 		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
 		BUG();
 	}
 
-	if (security_capable(current_cred(), cap) == 0) {
+	if (security_capable(ns, current_cred(), cap) == 0) {
 		current->flags |= PF_SUPERPRIV;
 		return 1;
 	}
 	return 0;
 }
-EXPORT_SYMBOL(capable);
+EXPORT_SYMBOL(ns_capable);
+
+/*
+ * does current have capability 'cap' to the user namespace of task
+ * 't'.  Return true if it does, false otherwise.
+ */
+int task_ns_capable(struct task_struct *t, int cap)
+{
+	return ns_capable(task_cred_xxx(t, user)->user_ns, cap);
+}
+EXPORT_SYMBOL(task_ns_capable);
diff -puN security/apparmor/lsm.c~userns-security-make-capabilities-relative-to-the-user-namespace security/apparmor/lsm.c
--- a/security/apparmor/lsm.c~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/security/apparmor/lsm.c
@@ -22,6 +22,7 @@
 #include <linux/ctype.h>
 #include <linux/sysctl.h>
 #include <linux/audit.h>
+#include <linux/user_namespace.h>
 #include <net/sock.h>
 
 #include "include/apparmor.h"
@@ -136,11 +137,11 @@ static int apparmor_capget(struct task_s
 }
 
 static int apparmor_capable(struct task_struct *task, const struct cred *cred,
-			    int cap, int audit)
+			    struct user_namespace *ns, int cap, int audit)
 {
 	struct aa_profile *profile;
 	/* cap_capable returns 0 on success, else -EPERM */
-	int error = cap_capable(task, cred, cap, audit);
+	int error = cap_capable(task, cred, ns, cap, audit);
 	if (!error) {
 		profile = aa_cred_profile(cred);
 		if (!unconfined(profile))
diff -puN security/commoncap.c~userns-security-make-capabilities-relative-to-the-user-namespace security/commoncap.c
--- a/security/commoncap.c~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/security/commoncap.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/prctl.h>
 #include <linux/securebits.h>
+#include <linux/user_namespace.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
@@ -68,6 +69,7 @@ EXPORT_SYMBOL(cap_netlink_recv);
  * cap_capable - Determine whether a task has a particular effective capability
  * @tsk: The task to query
  * @cred: The credentials to use
+ * @ns:  The user namespace in which we need the capability
  * @cap: The capability to check for
  * @audit: Whether to write an audit message or not
  *
@@ -79,10 +81,32 @@ EXPORT_SYMBOL(cap_netlink_recv);
  * cap_has_capability() returns 0 when a task has a capability, but the
  * kernel's capable() and has_capability() returns 1 for this case.
  */
-int cap_capable(struct task_struct *tsk, const struct cred *cred, int cap,
-		int audit)
+int cap_capable(struct task_struct *tsk, const struct cred *cred,
+		struct user_namespace *targ_ns, int cap, int audit)
 {
-	return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
+	for (;;) {
+		/* The creator of the user namespace has all caps. */
+		if (targ_ns != &init_user_ns && targ_ns->creator == cred->user)
+			return 0;
+
+		/* Do we have the necessary capabilities? */
+		if (targ_ns == cred->user->user_ns)
+			return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
+
+		/* Have we tried all of the parent namespaces? */
+		if (targ_ns == &init_user_ns)
+			return -EPERM;
+
+		/* If you have the capability in a parent user ns you have it
+		 * in the over all children user namespaces as well, so see
+		 * if this process has the capability in the parent user
+		 * namespace.
+		 */
+		targ_ns = targ_ns->creator->user_ns;
+	}
+
+	/* We never get here */
+	return -EPERM;
 }
 
 /**
@@ -177,7 +201,8 @@ static inline int cap_inh_is_capped(void
 	/* they are so limited unless the current task has the CAP_SETPCAP
 	 * capability
 	 */
-	if (cap_capable(current, current_cred(), CAP_SETPCAP,
+	if (cap_capable(current, current_cred(),
+			current_cred()->user->user_ns, CAP_SETPCAP,
 			SECURITY_CAP_AUDIT) == 0)
 		return 0;
 	return 1;
@@ -829,7 +854,8 @@ int cap_task_prctl(int option, unsigned 
 		     & (new->securebits ^ arg2))			/*[1]*/
 		    || ((new->securebits & SECURE_ALL_LOCKS & ~arg2))	/*[2]*/
 		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
-		    || (cap_capable(current, current_cred(), CAP_SETPCAP,
+		    || (cap_capable(current, current_cred(),
+				    current_cred()->user->user_ns, CAP_SETPCAP,
 				    SECURITY_CAP_AUDIT) != 0)		/*[4]*/
 			/*
 			 * [1] no changing of bits that are locked
@@ -894,7 +920,7 @@ int cap_vm_enough_memory(struct mm_struc
 {
 	int cap_sys_admin = 0;
 
-	if (cap_capable(current, current_cred(), CAP_SYS_ADMIN,
+	if (cap_capable(current, current_cred(), &init_user_ns, CAP_SYS_ADMIN,
 			SECURITY_CAP_NOAUDIT) == 0)
 		cap_sys_admin = 1;
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
@@ -921,7 +947,7 @@ int cap_file_mmap(struct file *file, uns
 	int ret = 0;
 
 	if (addr < dac_mmap_min_addr) {
-		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
+		ret = cap_capable(current, current_cred(), &init_user_ns, CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
 		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
 		if (ret == 0)
diff -puN security/security.c~userns-security-make-capabilities-relative-to-the-user-namespace security/security.c
--- a/security/security.c~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/security/security.c
@@ -154,29 +154,33 @@ int security_capset(struct cred *new, co
 				    effective, inheritable, permitted);
 }
 
-int security_capable(const struct cred *cred, int cap)
+int security_capable(struct user_namespace *ns, const struct cred *cred,
+		     int cap)
 {
-	return security_ops->capable(current, cred, cap, SECURITY_CAP_AUDIT);
+	return security_ops->capable(current, cred, ns, cap,
+				     SECURITY_CAP_AUDIT);
 }
 
-int security_real_capable(struct task_struct *tsk, int cap)
+int security_real_capable(struct task_struct *tsk, struct user_namespace *ns,
+			  int cap)
 {
 	const struct cred *cred;
 	int ret;
 
 	cred = get_task_cred(tsk);
-	ret = security_ops->capable(tsk, cred, cap, SECURITY_CAP_AUDIT);
+	ret = security_ops->capable(tsk, cred, ns, cap, SECURITY_CAP_AUDIT);
 	put_cred(cred);
 	return ret;
 }
 
-int security_real_capable_noaudit(struct task_struct *tsk, int cap)
+int security_real_capable_noaudit(struct task_struct *tsk,
+				  struct user_namespace *ns, int cap)
 {
 	const struct cred *cred;
 	int ret;
 
 	cred = get_task_cred(tsk);
-	ret = security_ops->capable(tsk, cred, cap, SECURITY_CAP_NOAUDIT);
+	ret = security_ops->capable(tsk, cred, ns, cap, SECURITY_CAP_NOAUDIT);
 	put_cred(cred);
 	return ret;
 }
diff -puN security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace security/selinux/hooks.c
--- a/security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace
+++ a/security/selinux/hooks.c
@@ -76,6 +76,7 @@
 #include <linux/mutex.h>
 #include <linux/posix-timers.h>
 #include <linux/syslog.h>
+#include <linux/user_namespace.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -1415,6 +1416,7 @@ static int current_has_perm(const struct
 /* Check whether a task is allowed to use a capability. */
 static int task_has_capability(struct task_struct *tsk,
 			       const struct cred *cred,
+			       struct user_namespace *ns,
 			       int cap, int audit)
 {
 	struct common_audit_data ad;
@@ -1843,15 +1845,15 @@ static int selinux_capset(struct cred *n
  */
 
 static int selinux_capable(struct task_struct *tsk, const struct cred *cred,
-			   int cap, int audit)
+			   struct user_namespace *ns, int cap, int audit)
 {
 	int rc;
 
-	rc = cap_capable(tsk, cred, cap, audit);
+	rc = cap_capable(tsk, cred, ns, cap, audit);
 	if (rc)
 		return rc;
 
-	return task_has_capability(tsk, cred, cap, audit);
+	return task_has_capability(tsk, cred, ns, cap, audit);
 }
 
 static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
@@ -1928,7 +1930,8 @@ static int selinux_vm_enough_memory(stru
 {
 	int rc, cap_sys_admin = 0;
 
-	rc = selinux_capable(current, current_cred(), CAP_SYS_ADMIN,
+	rc = selinux_capable(current, current_cred(),
+			     &init_user_ns, CAP_SYS_ADMIN,
 			     SECURITY_CAP_NOAUDIT);
 	if (rc == 0)
 		cap_sys_admin = 1;
@@ -2746,7 +2749,8 @@ static int selinux_inode_getsecurity(con
 	 * and lack of permission just means that we fall back to the
 	 * in-core context value, not a denial.
 	 */
-	error = selinux_capable(current, current_cred(), CAP_MAC_ADMIN,
+	error = selinux_capable(current, current_cred(),
+				&init_user_ns, CAP_MAC_ADMIN,
 				SECURITY_CAP_NOAUDIT);
 	if (!error)
 		error = security_sid_to_context_force(isec->sid, &context,
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

