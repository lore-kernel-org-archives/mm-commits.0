From: akpm@linux-foundation.org
Subject: - v3-file-capabilities-alter-behavior-of-cap_setpcap.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:16 -0700
Message-ID: <200710190343.l9J3hGmG013040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966503AbXJSD47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, casey@schaufler-ca.com, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     V3 file capabilities: alter behavior of cap_setpcap
has been removed from the -mm tree.  Its filename was
     v3-file-capabilities-alter-behavior-of-cap_setpcap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: V3 file capabilities: alter behavior of cap_setpcap
From: Andrew Morgan <morgan@kernel.org>

The non-filesystem capability meaning of CAP_SETPCAP is that a process, p1,
can change the capabilities of another process, p2.  This is not the
meaning that was intended for this capability at all, and this
implementation came about purely because, without filesystem capabilities,
there was no way to use capabilities without one process bestowing them on
another.

Since we now have a filesystem support for capabilities we can fix the
implementation of CAP_SETPCAP.

The most significant thing about this change is that, with it in effect, no
process can set the capabilities of another process.

The capabilities of a program are set via the capability convolution
rules:

   pI(post-exec) = pI(pre-exec)
   pP(post-exec) = (X(aka cap_bset) & fP) | (pI(post-exec) & fI)
   pE(post-exec) = fE ? pP(post-exec) : 0

at exec() time.  As such, the only influence the pre-exec() program can
have on the post-exec() program's capabilities are through the pI
capability set.

The correct implementation for CAP_SETPCAP (and that enabled by this patch)
is that it can be used to add extra pI capabilities to the current process
- to be picked up by subsequent exec()s when the above convolution rules
are applied.

Here is how it works:

Let's say we have a process, p. It has capability sets, pE, pP and pI.
Generally, p, can change the value of its own pI to pI' where

   (pI' & ~pI) & ~pP = 0.

That is, the only new things in pI' that were not present in pI need to
be present in pP.

The role of CAP_SETPCAP is basically to permit changes to pI beyond
the above:

   if (pE & CAP_SETPCAP) {
      pI' = anything; /* ie., even (pI' & ~pI) & ~pP != 0  */
   }

This capability is useful for things like login, which (say, via
pam_cap) might want to raise certain inheritable capabilities for use
by the children of the logged-in user's shell, but those capabilities
are not useful to or needed by the login program itself.

One such use might be to limit who can run ping. You set the
capabilities of the 'ping' program to be "= cap_net_raw+i", and then
only shells that have (pI & CAP_NET_RAW) will be able to run
it. Without CAP_SETPCAP implemented as described above, login(pam_cap)
would have to also have (pP & CAP_NET_RAW) in order to raise this
capability and pass it on through the inheritable set.

Signed-off-by: Andrew Morgan <morgan@kernel.org>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    4 --
 include/linux/security.h   |    7 ++++
 kernel/capability.c        |    5 --
 kernel/sysctl.c            |    8 +++-
 kernel/sysctl_check.c      |    5 ++
 security/commoncap.c       |   59 ++++++++++++++++++++++++++++++++---
 security/dummy.c           |   16 ++++-----
 7 files changed, 80 insertions(+), 24 deletions(-)

diff -puN include/linux/capability.h~v3-file-capabilities-alter-behavior-of-cap_setpcap include/linux/capability.h
--- a/include/linux/capability.h~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/include/linux/capability.h
@@ -310,10 +310,6 @@ typedef __u32 kernel_cap_t;
 #define CAP_SETFCAP	     31
 
 #ifdef __KERNEL__
-/*
- * Bounding set
- */
-extern kernel_cap_t cap_bset;
 
 /*
  * Internal kernel functions only
diff -puN include/linux/security.h~v3-file-capabilities-alter-behavior-of-cap_setpcap include/linux/security.h
--- a/include/linux/security.h~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/include/linux/security.h
@@ -34,6 +34,13 @@
 #include <linux/xfrm.h>
 #include <net/flow.h>
 
+/*
+ * Bounding set
+ */
+extern kernel_cap_t cap_bset;
+
+extern unsigned securebits;
+
 struct ctl_table;
 
 /*
diff -puN kernel/capability.c~v3-file-capabilities-alter-behavior-of-cap_setpcap kernel/capability.c
--- a/kernel/capability.c~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/kernel/capability.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 1997  Andrew Main <zefram@fysh.org>
  *
- * Integrated into 2.1.97+,  Andrew G. Morgan <morgan@transmeta.com>
+ * Integrated into 2.1.97+,  Andrew G. Morgan <morgan@kernel.org>
  * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
  */ 
 
@@ -14,9 +14,6 @@
 #include <linux/syscalls.h>
 #include <asm/uaccess.h>
 
-unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
-kernel_cap_t cap_bset = CAP_INIT_EFF_SET;
-
 /*
  * This lock protects task->cap_* for all tasks including current.
  * Locking rule: acquire this prior to tasklist_lock.
diff -puN kernel/sysctl.c~v3-file-capabilities-alter-behavior-of-cap_setpcap kernel/sysctl.c
--- a/kernel/sysctl.c~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/kernel/sysctl.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
-#include <linux/capability.h>
+#include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
 #include <linux/smp_lock.h>
@@ -371,6 +371,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec_taint,
 	},
 #endif
+#ifdef CONFIG_SECURITY_CAPABILITIES
 	{
 		.procname	= "cap-bound",
 		.data		= &cap_bset,
@@ -378,6 +379,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0600,
 		.proc_handler	= &proc_dointvec_bset,
 	},
+#endif /* def CONFIG_SECURITY_CAPABILITIES */
 #ifdef CONFIG_BLK_DEV_INITRD
 	{
 		.ctl_name	= KERN_REALROOTDEV,
@@ -1872,10 +1874,11 @@ static int do_proc_dointvec_bset_conv(in
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY_CAPABILITIES
 /*
  *	init may raise the set.
  */
- 
+
 int proc_dointvec_bset(struct ctl_table *table, int write, struct file *filp,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -1889,6 +1892,7 @@ int proc_dointvec_bset(struct ctl_table 
 	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
 				do_proc_dointvec_bset_conv,&op);
 }
+#endif /* def CONFIG_SECURITY_CAPABILITIES */
 
 /*
  *	Taint values can only be increased
diff -puN kernel/sysctl_check.c~v3-file-capabilities-alter-behavior-of-cap_setpcap kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/kernel/sysctl_check.c
@@ -38,7 +38,10 @@ static struct trans_ctl_table trans_kern
 	{ KERN_NODENAME,		"hostname" },
 	{ KERN_DOMAINNAME,		"domainname" },
 
+#ifdef CONFIG_SECURITY_CAPABILITIES
 	{ KERN_CAP_BSET,		"cap-bound" },
+#endif /* def CONFIG_SECURITY_CAPABILITIES */
+
 	{ KERN_PANIC,			"panic" },
 	{ KERN_REALROOTDEV,		"real-root-dev" },
 
@@ -1532,7 +1535,9 @@ int sysctl_check_table(struct ctl_table 
 			    (table->strategy == sysctl_ms_jiffies) ||
 			    (table->proc_handler == proc_dostring) ||
 			    (table->proc_handler == proc_dointvec) ||
+#ifdef CONFIG_SECURITY_CAPABILITIES
 			    (table->proc_handler == proc_dointvec_bset) ||
+#endif /* def CONFIG_SECURITY_CAPABILITIES */
 			    (table->proc_handler == proc_dointvec_minmax) ||
 			    (table->proc_handler == proc_dointvec_jiffies) ||
 			    (table->proc_handler == proc_dointvec_userhz_jiffies) ||
diff -puN security/commoncap.c~v3-file-capabilities-alter-behavior-of-cap_setpcap security/commoncap.c
--- a/security/commoncap.c~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/security/commoncap.c
@@ -24,6 +24,25 @@
 #include <linux/hugetlb.h>
 #include <linux/mount.h>
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+/*
+ * Because of the reduced scope of CAP_SETPCAP when filesystem
+ * capabilities are in effect, it is safe to allow this capability to
+ * be available in the default configuration.
+ */
+# define CAP_INIT_BSET  CAP_FULL_SET
+#else /* ie. ndef CONFIG_SECURITY_FILE_CAPABILITIES */
+# define CAP_INIT_BSET  CAP_INIT_EFF_SET
+#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
+
+kernel_cap_t cap_bset = CAP_INIT_BSET;    /* systemwide capability bound */
+EXPORT_SYMBOL(cap_bset);
+
+/* Global security state */
+
+unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
+EXPORT_SYMBOL(securebits);
+
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
 	NETLINK_CB(skb).eff_cap = current->cap_effective;
@@ -73,14 +92,44 @@ int cap_capget (struct task_struct *targ
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
+
+static inline int cap_block_setpcap(struct task_struct *target)
+{
+	/*
+	 * No support for remote process capability manipulation with
+	 * filesystem capability support.
+	 */
+	return (target != current);
+}
+
+static inline int cap_inh_is_capped(void)
+{
+	/*
+	 * return 1 if changes to the inheritable set are limited
+	 * to the old permitted set.
+	 */
+	return !cap_capable(current, CAP_SETPCAP);
+}
+
+#else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
+
+static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
+static inline int cap_inh_is_capped(void) { return 1; }
+
+#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
+
 int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	/* Derived from kernel/capability.c:sys_capset. */
-	/* verify restrictions on target's new Inheritable set */
-	if (!cap_issubset (*inheritable,
-			   cap_combine (target->cap_inheritable,
-					current->cap_permitted))) {
+	if (cap_block_setpcap(target)) {
+		return -EPERM;
+	}
+	if (cap_inh_is_capped()
+	    && !cap_issubset(*inheritable,
+			     cap_combine(target->cap_inheritable,
+					 current->cap_permitted))) {
+		/* incapable of using this inheritable set */
 		return -EPERM;
 	}
 
diff -puN security/dummy.c~v3-file-capabilities-alter-behavior-of-cap_setpcap security/dummy.c
--- a/security/dummy.c~v3-file-capabilities-alter-behavior-of-cap_setpcap
+++ a/security/dummy.c
@@ -37,15 +37,13 @@ static int dummy_capget (struct task_str
 			 kernel_cap_t * inheritable, kernel_cap_t * permitted)
 {
 	*effective = *inheritable = *permitted = 0;
-	if (!issecure(SECURE_NOROOT)) {
-		if (target->euid == 0) {
-			*permitted |= (~0 & ~CAP_FS_MASK);
-			*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
-		}
-		if (target->fsuid == 0) {
-			*permitted |= CAP_FS_MASK;
-			*effective |= CAP_FS_MASK;
-		}
+	if (target->euid == 0) {
+		*permitted |= (~0 & ~CAP_FS_MASK);
+		*effective |= (~0 & ~CAP_TO_MASK(CAP_SETPCAP) & ~CAP_FS_MASK);
+	}
+	if (target->fsuid == 0) {
+		*permitted |= CAP_FS_MASK;
+		*effective |= CAP_FS_MASK;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch
capabilities-clean-up-file-capability-reading.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
