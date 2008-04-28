From: akpm@linux-foundation.org
Subject: - capabilities-implement-per-process-securebits.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:13 -0700
Message-ID: <200804282154.m3SLsDrg017984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935033AbYD1Vyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     capabilities: implement per-process securebits
has been removed from the -mm tree.  Its filename was
     capabilities-implement-per-process-securebits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capabilities: implement per-process securebits
From: Andrew G. Morgan <morgan@kernel.org>

Filesystem capability support makes it possible to do away with (set)uid-0
based privilege and use capabilities instead.  That is, with filesystem
support for capabilities but without this present patch, it is (conceptually)
possible to manage a system with capabilities alone and never need to obtain
privilege via (set)uid-0.

Of course, conceptually isn't quite the same as currently possible since few
user applications, certainly not enough to run a viable system, are currently
prepared to leverage capabilities to exercise privilege.  Further, many
applications exist that may never get upgraded in this way, and the kernel
will continue to want to support their setuid-0 base privilege needs.

Where pure-capability applications evolve and replace setuid-0 binaries, it is
desirable that there be a mechanisms by which they can contain their
privilege.  In addition to leveraging the per-process bounding and inheritable
sets, this should include suppressing the privilege of the uid-0 superuser
from the process' tree of children.

The feature added by this patch can be leveraged to suppress the privilege
associated with (set)uid-0.  This suppression requires CAP_SETPCAP to
initiate, and only immediately affects the 'current' process (it is inherited
through fork()/exec()).  This reimplementation differs significantly from the
historical support for securebits which was system-wide, unwieldy and which
has ultimately withered to a dead relic in the source of the modern kernel.

With this patch applied a process, that is capable(CAP_SETPCAP), can now drop
all legacy privilege (through uid=0) for itself and all subsequently
fork()'d/exec()'d children with:

  prctl(PR_SET_SECUREBITS, 0x2f);

This patch represents a no-op unless CONFIG_SECURITY_FILE_CAPABILITIES is
enabled at configure time.

[akpm@linux-foundation.org: fix uninitialised var warning]
[serue@us.ibm.com: capabilities: use cap_task_prctl when !CONFIG_SECURITY]
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    3 -
 include/linux/init_task.h  |    3 -
 include/linux/prctl.h      |    9 ++-
 include/linux/sched.h      |    3 -
 include/linux/securebits.h |   25 ++++++--
 include/linux/security.h   |   16 +++--
 kernel/sys.c               |   27 ---------
 security/capability.c      |    1 
 security/commoncap.c       |  103 +++++++++++++++++++++++++++++++----
 security/dummy.c           |    2 
 security/security.c        |    4 -
 security/selinux/hooks.c   |    5 +
 12 files changed, 141 insertions(+), 60 deletions(-)

diff -puN include/linux/capability.h~capabilities-implement-per-process-securebits include/linux/capability.h
--- a/include/linux/capability.h~capabilities-implement-per-process-securebits
+++ a/include/linux/capability.h
@@ -155,6 +155,7 @@ typedef struct kernel_cap_struct {
  *   Add any capability from current's capability bounding set
  *       to the current process' inheritable set
  *   Allow taking bits out of capability bounding set
+ *   Allow modification of the securebits for a process
  */
 
 #define CAP_SETPCAP          8
@@ -490,8 +491,6 @@ extern const kernel_cap_t __cap_init_eff
 int capable(int cap);
 int __capable(struct task_struct *t, int cap);
 
-extern long cap_prctl_drop(unsigned long cap);
-
 #endif /* __KERNEL__ */
 
 #endif /* !_LINUX_CAPABILITY_H */
diff -puN include/linux/init_task.h~capabilities-implement-per-process-securebits include/linux/init_task.h
--- a/include/linux/init_task.h~capabilities-implement-per-process-securebits
+++ a/include/linux/init_task.h
@@ -9,6 +9,7 @@
 #include <linux/ipc.h>
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/securebits.h>
 #include <net/net_namespace.h>
 
 #define INIT_FDTABLE \
@@ -172,7 +173,7 @@ extern struct group_info init_groups;
 	.cap_inheritable = CAP_INIT_INH_SET,				\
 	.cap_permitted	= CAP_FULL_SET,					\
 	.cap_bset 	= CAP_INIT_BSET,				\
-	.keep_capabilities = 0,						\
+	.securebits     = SECUREBITS_DEFAULT,				\
 	.user		= INIT_USER,					\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
diff -puN include/linux/prctl.h~capabilities-implement-per-process-securebits include/linux/prctl.h
--- a/include/linux/prctl.h~capabilities-implement-per-process-securebits
+++ a/include/linux/prctl.h
@@ -16,7 +16,8 @@
 # define PR_UNALIGN_NOPRINT	1	/* silently fix up unaligned user accesses */
 # define PR_UNALIGN_SIGBUS	2	/* generate SIGBUS on unaligned user access */
 
-/* Get/set whether or not to drop capabilities on setuid() away from uid 0 */
+/* Get/set whether or not to drop capabilities on setuid() away from
+ * uid 0 (as per security/commoncap.c) */
 #define PR_GET_KEEPCAPS   7
 #define PR_SET_KEEPCAPS   8
 
@@ -63,7 +64,7 @@
 #define PR_GET_SECCOMP	21
 #define PR_SET_SECCOMP	22
 
-/* Get/set the capability bounding set */
+/* Get/set the capability bounding set (as per security/commoncap.c) */
 #define PR_CAPBSET_READ 23
 #define PR_CAPBSET_DROP 24
 
@@ -73,4 +74,8 @@
 # define PR_TSC_ENABLE		1	/* allow the use of the timestamp counter */
 # define PR_TSC_SIGSEGV		2	/* throw a SIGSEGV instead of reading the TSC */
 
+/* Get/set securebits (as per security/commoncap.c) */
+#define PR_GET_SECUREBITS 27
+#define PR_SET_SECUREBITS 28
+
 #endif /* _LINUX_PRCTL_H */
diff -puN include/linux/sched.h~capabilities-implement-per-process-securebits include/linux/sched.h
--- a/include/linux/sched.h~capabilities-implement-per-process-securebits
+++ a/include/linux/sched.h
@@ -68,7 +68,6 @@ struct sched_param {
 #include <linux/smp.h>
 #include <linux/sem.h>
 #include <linux/signal.h>
-#include <linux/securebits.h>
 #include <linux/fs_struct.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
@@ -1133,7 +1132,7 @@ struct task_struct {
 	gid_t gid,egid,sgid,fsgid;
 	struct group_info *group_info;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted, cap_bset;
-	unsigned keep_capabilities:1;
+	unsigned securebits;
 	struct user_struct *user;
 #ifdef CONFIG_KEYS
 	struct key *request_key_auth;	/* assumed request_key authority */
diff -puN include/linux/securebits.h~capabilities-implement-per-process-securebits include/linux/securebits.h
--- a/include/linux/securebits.h~capabilities-implement-per-process-securebits
+++ a/include/linux/securebits.h
@@ -3,28 +3,39 @@
 
 #define SECUREBITS_DEFAULT 0x00000000
 
-extern unsigned securebits;
-
 /* When set UID 0 has no special privileges. When unset, we support
    inheritance of root-permissions and suid-root executable under
    compatibility mode. We raise the effective and inheritable bitmasks
    *of the executable file* if the effective uid of the new process is
    0. If the real uid is 0, we raise the inheritable bitmask of the
    executable file. */
-#define SECURE_NOROOT            0
+#define SECURE_NOROOT			0
+#define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
 
 /* When set, setuid to/from uid 0 does not trigger capability-"fixes"
    to be compatible with old programs relying on set*uid to loose
    privileges. When unset, setuid doesn't change privileges. */
-#define SECURE_NO_SETUID_FIXUP   2
+#define SECURE_NO_SETUID_FIXUP		2
+#define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
+
+/* When set, a process can retain its capabilities even after
+   transitioning to a non-root user (the set-uid fixup suppressed by
+   bit 2). Bit-4 is cleared when a process calls exec(); setting both
+   bit 4 and 5 will create a barrier through exec that no exec()'d
+   child can use this feature again. */
+#define SECURE_KEEP_CAPS		4
+#define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
 
 /* Each securesetting is implemented using two bits. One bit specify
    whether the setting is on or off. The other bit specify whether the
    setting is fixed or not. A setting which is fixed cannot be changed
    from user-level. */
+#define issecure_mask(X)	(1 << (X))
+#define issecure(X)		(issecure_mask(X) & current->securebits)
 
-#define issecure(X) ( (1 << (X+1)) & SECUREBITS_DEFAULT ? 	\
-		      (1 << (X)) & SECUREBITS_DEFAULT :		\
-		      (1 << (X)) & securebits )
+#define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
+				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
+				 issecure_mask(SECURE_KEEP_CAPS))
+#define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
 
 #endif /* !_LINUX_SECUREBITS_H */
diff -puN include/linux/security.h~capabilities-implement-per-process-securebits include/linux/security.h
--- a/include/linux/security.h~capabilities-implement-per-process-securebits
+++ a/include/linux/security.h
@@ -34,8 +34,6 @@
 #include <linux/xfrm.h>
 #include <net/flow.h>
 
-extern unsigned securebits;
-
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
@@ -61,6 +59,8 @@ extern int cap_inode_need_killpriv(struc
 extern int cap_inode_killpriv(struct dentry *dentry);
 extern int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid, int flags);
 extern void cap_task_reparent_to_init (struct task_struct *p);
+extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+			  unsigned long arg4, unsigned long arg5, long *rc_p);
 extern int cap_task_setscheduler (struct task_struct *p, int policy, struct sched_param *lp);
 extern int cap_task_setioprio (struct task_struct *p, int ioprio);
 extern int cap_task_setnice (struct task_struct *p, int nice);
@@ -720,7 +720,9 @@ static inline void security_free_mnt_opt
  *	@arg3 contains a argument.
  *	@arg4 contains a argument.
  *	@arg5 contains a argument.
- *	Return 0 if permission is granted.
+ *      @rc_p contains a pointer to communicate back the forced return code
+ *	Return 0 if permission is granted, and non-zero if the security module
+ *      has taken responsibility (setting *rc_p) for the prctl call.
  * @task_reparent_to_init:
  * 	Set the security attributes in @p->security for a kernel thread that
  * 	is being reparented to the init task.
@@ -1420,7 +1422,7 @@ struct security_operations {
 	int (*task_wait) (struct task_struct * p);
 	int (*task_prctl) (int option, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4,
-			   unsigned long arg5);
+			   unsigned long arg5, long *rc_p);
 	void (*task_reparent_to_init) (struct task_struct * p);
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
 
@@ -1684,7 +1686,7 @@ int security_task_kill(struct task_struc
 			int sig, u32 secid);
 int security_task_wait(struct task_struct *p);
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5);
+			 unsigned long arg4, unsigned long arg5, long *rc_p);
 void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
@@ -2271,9 +2273,9 @@ static inline int security_task_wait (st
 static inline int security_task_prctl (int option, unsigned long arg2,
 				       unsigned long arg3,
 				       unsigned long arg4,
-				       unsigned long arg5)
+				       unsigned long arg5, long *rc_p)
 {
-	return 0;
+	return cap_task_prctl(option, arg2, arg3, arg3, arg5, rc_p);
 }
 
 static inline void security_task_reparent_to_init (struct task_struct *p)
diff -puN kernel/sys.c~capabilities-implement-per-process-securebits kernel/sys.c
--- a/kernel/sys.c~capabilities-implement-per-process-securebits
+++ a/kernel/sys.c
@@ -1632,10 +1632,9 @@ asmlinkage long sys_umask(int mask)
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5)
 {
-	long error;
+	long uninitialized_var(error);
 
-	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
-	if (error)
+	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
 		return error;
 
 	switch (option) {
@@ -1688,17 +1687,6 @@ asmlinkage long sys_prctl(int option, un
 				error = -EINVAL;
 			break;
 
-		case PR_GET_KEEPCAPS:
-			if (current->keep_capabilities)
-				error = 1;
-			break;
-		case PR_SET_KEEPCAPS:
-			if (arg2 != 0 && arg2 != 1) {
-				error = -EINVAL;
-				break;
-			}
-			current->keep_capabilities = arg2;
-			break;
 		case PR_SET_NAME: {
 			struct task_struct *me = current;
 			unsigned char ncomm[sizeof(me->comm)];
@@ -1732,17 +1720,6 @@ asmlinkage long sys_prctl(int option, un
 		case PR_SET_SECCOMP:
 			error = prctl_set_seccomp(arg2);
 			break;
-
-		case PR_CAPBSET_READ:
-			if (!cap_valid(arg2))
-				return -EINVAL;
-			return !!cap_raised(current->cap_bset, arg2);
-		case PR_CAPBSET_DROP:
-#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
-			return cap_prctl_drop(arg2);
-#else
-			return -EINVAL;
-#endif
 		case PR_GET_TSC:
 			error = GET_TSC_CTL(arg2);
 			break;
diff -puN security/capability.c~capabilities-implement-per-process-securebits security/capability.c
--- a/security/capability.c~capabilities-implement-per-process-securebits
+++ a/security/capability.c
@@ -44,6 +44,7 @@ static struct security_operations capabi
 	.task_setioprio =		cap_task_setioprio,
 	.task_setnice =			cap_task_setnice,
 	.task_post_setuid =		cap_task_post_setuid,
+	.task_prctl =                   cap_task_prctl,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 
 	.syslog =                       cap_syslog,
diff -puN security/commoncap.c~capabilities-implement-per-process-securebits security/commoncap.c
--- a/security/commoncap.c~capabilities-implement-per-process-securebits
+++ a/security/commoncap.c
@@ -24,11 +24,8 @@
 #include <linux/hugetlb.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
-
-/* Global security state */
-
-unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
-EXPORT_SYMBOL(securebits);
+#include <linux/prctl.h>
+#include <linux/securebits.h>
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -368,7 +365,7 @@ void cap_bprm_apply_creds (struct linux_
 
 	/* AUD: Audit candidate if current->cap_effective is set */
 
-	current->keep_capabilities = 0;
+	current->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
 }
 
 int cap_bprm_secureexec (struct linux_binprm *bprm)
@@ -448,7 +445,7 @@ static inline void cap_emulate_setxuid (
 {
 	if ((old_ruid == 0 || old_euid == 0 || old_suid == 0) &&
 	    (current->uid != 0 && current->euid != 0 && current->suid != 0) &&
-	    !current->keep_capabilities) {
+	    !issecure(SECURE_KEEP_CAPS)) {
 		cap_clear (current->cap_permitted);
 		cap_clear (current->cap_effective);
 	}
@@ -547,7 +544,7 @@ int cap_task_setnice (struct task_struct
  * this task could get inconsistent info.  There can be no
  * racing writer bc a task can only change its own caps.
  */
-long cap_prctl_drop(unsigned long cap)
+static long cap_prctl_drop(unsigned long cap)
 {
 	if (!capable(CAP_SETPCAP))
 		return -EPERM;
@@ -556,6 +553,7 @@ long cap_prctl_drop(unsigned long cap)
 	cap_lower(current->cap_bset, cap);
 	return 0;
 }
+
 #else
 int cap_task_setscheduler (struct task_struct *p, int policy,
 			   struct sched_param *lp)
@@ -572,12 +570,99 @@ int cap_task_setnice (struct task_struct
 }
 #endif
 
+int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+		   unsigned long arg4, unsigned long arg5, long *rc_p)
+{
+	long error = 0;
+
+	switch (option) {
+	case PR_CAPBSET_READ:
+		if (!cap_valid(arg2))
+			error = -EINVAL;
+		else
+			error = !!cap_raised(current->cap_bset, arg2);
+		break;
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+	case PR_CAPBSET_DROP:
+		error = cap_prctl_drop(arg2);
+		break;
+
+	/*
+	 * The next four prctl's remain to assist with transitioning a
+	 * system from legacy UID=0 based privilege (when filesystem
+	 * capabilities are not in use) to a system using filesystem
+	 * capabilities only - as the POSIX.1e draft intended.
+	 *
+	 * Note:
+	 *
+	 *  PR_SET_SECUREBITS =
+	 *      issecure_mask(SECURE_KEEP_CAPS_LOCKED)
+	 *    | issecure_mask(SECURE_NOROOT)
+	 *    | issecure_mask(SECURE_NOROOT_LOCKED)
+	 *    | issecure_mask(SECURE_NO_SETUID_FIXUP)
+	 *    | issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED)
+	 *
+	 * will ensure that the current process and all of its
+	 * children will be locked into a pure
+	 * capability-based-privilege environment.
+	 */
+	case PR_SET_SECUREBITS:
+		if ((((current->securebits & SECURE_ALL_LOCKS) >> 1)
+		     & (current->securebits ^ arg2))                  /*[1]*/
+		    || ((current->securebits & SECURE_ALL_LOCKS
+			 & ~arg2))                                    /*[2]*/
+		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS)) /*[3]*/
+		    || (cap_capable(current, CAP_SETPCAP) != 0)) {    /*[4]*/
+			/*
+			 * [1] no changing of bits that are locked
+			 * [2] no unlocking of locks
+			 * [3] no setting of unsupported bits
+			 * [4] doing anything requires privilege (go read about
+			 *     the "sendmail capabilities bug")
+			 */
+			error = -EPERM;  /* cannot change a locked bit */
+		} else {
+			current->securebits = arg2;
+		}
+		break;
+	case PR_GET_SECUREBITS:
+		error = current->securebits;
+		break;
+
+#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
+
+	case PR_GET_KEEPCAPS:
+		if (issecure(SECURE_KEEP_CAPS))
+			error = 1;
+		break;
+	case PR_SET_KEEPCAPS:
+		if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
+			error = -EINVAL;
+		else if (issecure(SECURE_KEEP_CAPS_LOCKED))
+			error = -EPERM;
+		else if (arg2)
+			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
+		else
+			current->securebits &=
+				~issecure_mask(SECURE_KEEP_CAPS);
+		break;
+
+	default:
+		/* No functionality available - continue with default */
+		return 0;
+	}
+
+	/* Functionality provided */
+	*rc_p = error;
+	return 1;
+}
+
 void cap_task_reparent_to_init (struct task_struct *p)
 {
 	cap_set_init_eff(p->cap_effective);
 	cap_clear(p->cap_inheritable);
 	cap_set_full(p->cap_permitted);
-	p->keep_capabilities = 0;
+	p->securebits = SECUREBITS_DEFAULT;
 	return;
 }
 
diff -puN security/dummy.c~capabilities-implement-per-process-securebits security/dummy.c
--- a/security/dummy.c~capabilities-implement-per-process-securebits
+++ a/security/dummy.c
@@ -604,7 +604,7 @@ static int dummy_task_kill (struct task_
 }
 
 static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
-			     unsigned long arg4, unsigned long arg5)
+			     unsigned long arg4, unsigned long arg5, long *rc_p)
 {
 	return 0;
 }
diff -puN security/security.c~capabilities-implement-per-process-securebits security/security.c
--- a/security/security.c~capabilities-implement-per-process-securebits
+++ a/security/security.c
@@ -733,9 +733,9 @@ int security_task_wait(struct task_struc
 }
 
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
-			 unsigned long arg4, unsigned long arg5)
+			 unsigned long arg4, unsigned long arg5, long *rc_p)
 {
-	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
+	return security_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
 }
 
 void security_task_reparent_to_init(struct task_struct *p)
diff -puN security/selinux/hooks.c~capabilities-implement-per-process-securebits security/selinux/hooks.c
--- a/security/selinux/hooks.c~capabilities-implement-per-process-securebits
+++ a/security/selinux/hooks.c
@@ -3303,12 +3303,13 @@ static int selinux_task_prctl(int option
 			      unsigned long arg2,
 			      unsigned long arg3,
 			      unsigned long arg4,
-			      unsigned long arg5)
+			      unsigned long arg5,
+			      long *rc_p)
 {
 	/* The current prctl operations do not appear to require
 	   any SELinux controls since they merely observe or modify
 	   the state of the current process. */
-	return 0;
+	return secondary_ops->task_prctl(option, arg2, arg3, arg4, arg5, rc_p);
 }
 
 static int selinux_task_wait(struct task_struct *p)
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch

