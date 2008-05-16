From: akpm@linux-foundation.org
Subject: + bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch added to -mm tree
Date: Thu, 15 May 2008 19:45:09 -0700
Message-ID: <200805160245.m4G2j9d9022910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804AbYEPCpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com


The patch titled
     bsdacct: switch from global bsd_acct_struct instance to per-pidns one
has been added to the -mm tree.  Its filename is
     bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: switch from global bsd_acct_struct instance to per-pidns one
From: Pavel Emelyanov <xemul@openvz.org>

Allocate the structure on the first call to sys_acct().  After this each
namespace, that ordered the accounting, will live with this structure till
its own death.

Two notes
- routines, that close the accounting on fs umount time use
  the init_pid_ns's acct by now;
- accounting routine accounts to dying task's namespace
  (also by now).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acct.h   |    3 +
 kernel/acct.c          |   84 ++++++++++++++++++++++++++++++---------
 kernel/pid_namespace.c |    2 
 3 files changed, 71 insertions(+), 18 deletions(-)

diff -puN include/linux/acct.h~bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one include/linux/acct.h
--- a/include/linux/acct.h~bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one
+++ a/include/linux/acct.h
@@ -120,17 +120,20 @@ struct acct_v3
 struct vfsmount;
 struct super_block;
 struct pacct_struct;
+struct pid_namespace;
 extern void acct_auto_close_mnt(struct vfsmount *m);
 extern void acct_auto_close(struct super_block *sb);
 extern void acct_init_pacct(struct pacct_struct *pacct);
 extern void acct_collect(long exitcode, int group_dead);
 extern void acct_process(void);
+extern void acct_exit_ns(struct pid_namespace *);
 #else
 #define acct_auto_close_mnt(x)	do { } while (0)
 #define acct_auto_close(x)	do { } while (0)
 #define acct_init_pacct(x)	do { } while (0)
 #define acct_collect(x,y)	do { } while (0)
 #define acct_process()		do { } while (0)
+#define acct_exit_ns(ns)	do { } while (0)
 #endif
 
 /*
diff -puN kernel/acct.c~bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one kernel/acct.c
--- a/kernel/acct.c~bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one
+++ a/kernel/acct.c
@@ -93,8 +93,6 @@ struct bsd_acct_struct {
 
 static DEFINE_SPINLOCK(acct_lock);
 
-static struct bsd_acct_struct acct_globals __cacheline_aligned;
-
 /*
  * Called whenever the timer says to check the free space.
  */
@@ -176,7 +174,8 @@ out:
  *
  * NOTE: acct_lock MUST be held on entry and exit.
  */
-static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file)
+static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
+		struct pid_namespace *ns)
 {
 	struct file *old_acct = NULL;
 	struct pid_namespace *old_ns = NULL;
@@ -188,10 +187,11 @@ static void acct_file_reopen(struct bsd_
 		acct->active = 0;
 		acct->needcheck = 0;
 		acct->file = NULL;
+		acct->ns = NULL;
 	}
 	if (file) {
 		acct->file = file;
-		acct->ns = get_pid_ns(task_active_pid_ns(current));
+		acct->ns = ns;
 		acct->needcheck = 0;
 		acct->active = 1;
 		/* It's been deleted if it was used before so this is safe */
@@ -204,7 +204,6 @@ static void acct_file_reopen(struct bsd_
 		spin_unlock(&acct_lock);
 		do_acct_process(acct, old_ns, old_acct);
 		filp_close(old_acct, NULL);
-		put_pid_ns(old_ns);
 		spin_lock(&acct_lock);
 	}
 }
@@ -213,6 +212,8 @@ static int acct_on(char *name)
 {
 	struct file *file;
 	int error;
+	struct pid_namespace *ns;
+	struct bsd_acct_struct *acct = NULL;
 
 	/* Difference from BSD - they don't do O_APPEND */
 	file = filp_open(name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
@@ -229,18 +230,34 @@ static int acct_on(char *name)
 		return -EIO;
 	}
 
+	ns = task_active_pid_ns(current);
+	if (ns->bacct == NULL) {
+		acct = kzalloc(sizeof(struct bsd_acct_struct), GFP_KERNEL);
+		if (acct == NULL) {
+			filp_close(file, NULL);
+			return -ENOMEM;
+		}
+	}
+
 	error = security_acct(file);
 	if (error) {
+		kfree(acct);
 		filp_close(file, NULL);
 		return error;
 	}
 
 	spin_lock(&acct_lock);
+	if (ns->bacct == NULL) {
+		ns->bacct = acct;
+		acct = NULL;
+	}
+
 	mnt_pin(file->f_path.mnt);
-	acct_file_reopen(&acct_globals, file);
+	acct_file_reopen(ns->bacct, file, ns);
 	spin_unlock(&acct_lock);
 
 	mntput(file->f_path.mnt); /* it's pinned, now give up active reference */
+	kfree(acct);
 
 	return 0;
 }
@@ -270,10 +287,16 @@ asmlinkage long sys_acct(const char __us
 		error = acct_on(tmp);
 		putname(tmp);
 	} else {
+		struct bsd_acct_struct *acct;
+
+		acct = task_active_pid_ns(current)->bacct;
+		if (acct == NULL)
+			return 0;
+
 		error = security_acct(NULL);
 		if (!error) {
 			spin_lock(&acct_lock);
-			acct_file_reopen(&acct_globals, NULL);
+			acct_file_reopen(acct, NULL, NULL);
 			spin_unlock(&acct_lock);
 		}
 	}
@@ -289,9 +312,15 @@ asmlinkage long sys_acct(const char __us
  */
 void acct_auto_close_mnt(struct vfsmount *m)
 {
+	struct bsd_acct_struct *acct;
+
+	acct = init_pid_ns.bacct;
+	if (acct == NULL)
+		return;
+
 	spin_lock(&acct_lock);
-	if (acct_globals.file && acct_globals.file->f_path.mnt == m)
-		acct_file_reopen(&acct_globals, NULL);
+	if (acct->file && acct->file->f_path.mnt == m)
+		acct_file_reopen(acct, NULL, NULL);
 	spin_unlock(&acct_lock);
 }
 
@@ -304,10 +333,29 @@ void acct_auto_close_mnt(struct vfsmount
  */
 void acct_auto_close(struct super_block *sb)
 {
+	struct bsd_acct_struct *acct;
+
+	acct = init_pid_ns.bacct;
+	if (acct == NULL)
+		return;
+
 	spin_lock(&acct_lock);
-	if (acct_globals.file &&
-	    acct_globals.file->f_path.mnt->mnt_sb == sb) {
-		acct_file_reopen(&acct_globals, NULL);
+	if (acct->file && acct->file->f_path.mnt->mnt_sb == sb)
+		acct_file_reopen(acct, NULL, NULL);
+	spin_unlock(&acct_lock);
+}
+
+void acct_exit_ns(struct pid_namespace *ns)
+{
+	struct bsd_acct_struct *acct;
+
+	spin_lock(&acct_lock);
+	acct = ns->bacct;
+	if (acct != NULL) {
+		if (acct->file != NULL)
+			acct_file_reopen(acct, NULL, NULL);
+
+		kfree(acct);
 	}
 	spin_unlock(&acct_lock);
 }
@@ -587,25 +635,25 @@ void acct_collect(long exitcode, int gro
 void acct_process(void)
 {
 	struct file *file = NULL;
-	struct pid_namespace *ns;
+	struct pid_namespace *ns = task_active_pid_ns(current);
+	struct bsd_acct_struct *acct;
 
+	acct = ns->bacct;
 	/*
 	 * accelerate the common fastpath:
 	 */
-	if (!acct_globals.file)
+	if (!acct || !acct->file)
 		return;
 
 	spin_lock(&acct_lock);
-	file = acct_globals.file;
+	file = acct->file;
 	if (unlikely(!file)) {
 		spin_unlock(&acct_lock);
 		return;
 	}
 	get_file(file);
-	ns = get_pid_ns(acct_globals.ns);
 	spin_unlock(&acct_lock);
 
-	do_acct_process(&acct_globals, ns, file);
+	do_acct_process(acct, ns, file);
 	fput(file);
-	put_pid_ns(ns);
 }
diff -puN kernel/pid_namespace.c~bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one
+++ a/kernel/pid_namespace.c
@@ -12,6 +12,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/err.h>
+#include <linux/acct.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -181,6 +182,7 @@ void zap_pid_ns_processes(struct pid_nam
 
 	/* Child reaper for the pid namespace is going away */
 	pid_ns->child_reaper = NULL;
+	acct_exit_ns(pid_ns);
 	return;
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

