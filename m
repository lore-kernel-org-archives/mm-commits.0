From: akpm@osdl.org
Subject: + add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:35:02 -0800
Message-ID: <200701022135.l02LZ3jM030492@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbXABVfP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:35:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tytso@mit.edu


The patch titled
     Add TAINT_USER and ability to set taint flags from userspace
has been added to the -mm tree.  Its filename is
     add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/kernel.h |    1 +
 include/linux/sysctl.h |    2 ++
 kernel/panic.c         |    6 ++++--
 kernel/sysctl.c        |   23 +++++++++++++++++++++--
 4 files changed, 28 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace include/linux/kernel.h
--- a/include/linux/kernel.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace
+++ a/include/linux/kernel.h
@@ -197,6 +197,7 @@ extern enum system_states {
 #define TAINT_FORCED_RMMOD		(1<<3)
 #define TAINT_MACHINE_CHECK		(1<<4)
 #define TAINT_BAD_PAGE			(1<<5)
+#define TAINT_USER			(1<<6)
 
 extern void dump_stack(void);
 
diff -puN include/linux/sysctl.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace include/linux/sysctl.h
--- a/include/linux/sysctl.h~add-taint_user-and-ability-to-set-taint-flags-from-userspace
+++ a/include/linux/sysctl.h
@@ -929,6 +929,8 @@ extern int proc_dointvec(ctl_table *, in
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_bset(ctl_table *, int, struct file *,
 			      void __user *, size_t *, loff_t *);
+extern int proc_dointvec_taint(ctl_table *, int, struct file *,
+			       void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(ctl_table *, int, struct file *,
 				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(ctl_table *, int, struct file *,
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
@@ -349,8 +349,8 @@ static ctl_table kern_table[] = {
 		.procname	= "tainted",
 		.data		= &tainted,
 		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_taint,
 	},
 	{
 		.ctl_name	= KERN_CAP_BSET,
@@ -1927,6 +1927,7 @@ int proc_dointvec(ctl_table *table, int 
 
 #define OP_SET	0
 #define OP_AND	1
+#define OP_OR	2
 
 static int do_proc_dointvec_bset_conv(int *negp, unsigned long *lvalp,
 				      int *valp,
@@ -1938,6 +1939,7 @@ static int do_proc_dointvec_bset_conv(in
 		switch(op) {
 		case OP_SET:	*valp = val; break;
 		case OP_AND:	*valp &= val; break;
+		case OP_OR:	*valp |= val; break;
 		}
 	} else {
 		int val = *valp;
@@ -1970,6 +1972,23 @@ int proc_dointvec_bset(ctl_table *table,
 				do_proc_dointvec_bset_conv,&op);
 }
 
+/*
+ *	Taint values can only be increased
+ */
+int proc_dointvec_taint(ctl_table *table, int write, struct file *filp,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int op;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		return -EPERM;
+	}
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

add-taint_user-and-ability-to-set-taint-flags-from-userspace.patch
inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch
inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
