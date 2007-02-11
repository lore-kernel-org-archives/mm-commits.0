From: akpm@linux-foundation.org
Subject: - add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:16 -0800
Message-ID: <200702112252.l1BMqGSr016002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872AbXBKWzb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tytso@mit.edu, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     Add TAINT_USER and ability to set taint flags from userspace
has been removed from the -mm tree.  Its filename was
     add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add TAINT_USER and ability to set taint flags from userspace
From: "Theodore Ts'o" <tytso@mit.edu>

Allow taint flags to be set from userspace by writing to
/proc/sys/kernel/tainted, and add a new taint flag, TAINT_USER, to be used
when userspace has potentially done something dangerous that might
compromise the kernel.  This will allow support personnel to ask further
questions about what may have caused the user taint flag to have been set.

For example, they might examine the logs of the realtime JVM to see if the
Java program has used the really silly, stupid, dangerous, and
completely-non-portable direct access to physical memory feature which MUST
be implemented according to the Real-Time Specification for Java (RTSJ). 
Sigh.  What were those silly people at Sun thinking?

[akpm@osdl.org: build fix]
[bunk@stusta.de: cleanup]
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 kernel/panic.c         |    6 ++++--
 kernel/sysctl.c        |   27 +++++++++++++++++++++++++--
 3 files changed, 30 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace include/linux/kernel.h
--- a/include/linux/kernel.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace
+++ a/include/linux/kernel.h
@@ -200,6 +200,7 @@ extern enum system_states {
 #define TAINT_FORCED_RMMOD		(1<<3)
 #define TAINT_MACHINE_CHECK		(1<<4)
 #define TAINT_BAD_PAGE			(1<<5)
+#define TAINT_USER			(1<<6)
 
 extern void dump_stack(void);
 
diff -puN kernel/panic.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace kernel/panic.c
--- a/kernel/panic.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace
+++ a/kernel/panic.c
@@ -150,6 +150,7 @@ EXPORT_SYMBOL(panic);
  *  'R' - User forced a module unload.
  *  'M' - Machine had a machine check experience.
  *  'B' - System has hit bad_page.
+ *  'U' - Userspace-defined naughtiness.
  *
  *	The string is overwritten by the next call to print_taint().
  */
@@ -158,13 +159,14 @@ const char *print_tainted(void)
 {
 	static char buf[20];
 	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c",
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
 			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
  			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
-			tainted & TAINT_BAD_PAGE ? 'B' : ' ');
+			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
+			tainted & TAINT_USER ? 'U' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
diff -puN kernel/sysctl.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace kernel/sysctl.c
--- a/kernel/sysctl.c~add-taint_user-and-ability-to-set-taint-flags-from-userspace
+++ a/kernel/sysctl.c
@@ -151,6 +151,8 @@ static int sysctl_ipc_data(ctl_table *ta
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
 static ctl_table root_table[];
@@ -174,6 +176,7 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
@@ -344,14 +347,16 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_PROC_SYSCTL
 	{
 		.ctl_name	= KERN_TAINTED,
 		.procname	= "tainted",
 		.data		= &tainted,
 		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_taint,
 	},
+#endif
 	{
 		.ctl_name	= KERN_CAP_BSET,
 		.procname	= "cap-bound",
@@ -1927,6 +1932,7 @@ int proc_dointvec(ctl_table *table, int 
 
 #define OP_SET	0
 #define OP_AND	1
+#define OP_OR	2
 
 static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
 				      int *valp,
@@ -1938,6 +1944,7 @@ static int do_proc_dointvec_bset_conv(in
 		switch(op) {
 		case OP_SET:	*valp = val; break;
 		case OP_AND:	*valp &= val; break;
+		case OP_OR:	*valp |= val; break;
 		}
 	} else {
 		int val = *valp;
@@ -1970,6 +1977,22 @@ int proc_dointvec_bset(ctl_table *table,
 				do_proc_dointvec_bset_conv,&op);
 }
 
+/*
+ *	Taint values can only be increased
+ */
+static int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int op;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	op = OP_OR;
+	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
+				do_proc_dointvec_bset_conv,&op);
+}
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;
_

Patches currently in -mm which might be from tytso@mit.edu are

origin.patch
inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch
inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
