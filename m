From: akpm@linux-foundation.org
Subject: [merged] fs-devpts-inodec-convert-printk-to-pr_foo.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:36:47 -0700
Message-ID: <53960ccf.LjxyG5AFAOzjR1R2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, joe@perches.com, fabf@skynet.be

Subject: [merged] fs-devpts-inodec-convert-printk-to-pr_foo.patch removed from -mm tree
To: fabf@skynet.be,joe@perches.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:47 -0700


The patch titled
     Subject: fs/devpts/inode.c: convert printk to pr_foo()
has been removed from the -mm tree.  Its filename was
     fs-devpts-inodec-convert-printk-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/devpts/inode.c: convert printk to pr_foo()

Also convert spaces to tabs (checkpatch warnings) if (!dentry) KERN_NOTICE
converted to pr_err (like if (!inode) error process)

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN fs/devpts/inode.c~fs-devpts-inodec-convert-printk-to-pr_foo fs/devpts/inode.c
--- a/fs/devpts/inode.c~fs-devpts-inodec-convert-printk-to-pr_foo
+++ a/fs/devpts/inode.c
@@ -10,6 +10,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
@@ -148,10 +150,10 @@ static inline struct super_block *pts_sb
 
 /*
  * parse_mount_options():
- * 	Set @opts to mount options specified in @data. If an option is not
- * 	specified in @data, set it to its default value. The exception is
- * 	'newinstance' option which can only be set/cleared on a mount (i.e.
- * 	cannot be changed during remount).
+ *	Set @opts to mount options specified in @data. If an option is not
+ *	specified in @data, set it to its default value. The exception is
+ *	'newinstance' option which can only be set/cleared on a mount (i.e.
+ *	cannot be changed during remount).
  *
  * Note: @data may be NULL (in which case all options are set to default).
  */
@@ -225,7 +227,7 @@ static int parse_mount_options(char *dat
 			break;
 #endif
 		default:
-			printk(KERN_ERR "devpts: called with bogus options\n");
+			pr_err("called with bogus options\n");
 			return -EINVAL;
 		}
 	}
@@ -261,7 +263,7 @@ static int mknod_ptmx(struct super_block
 
 	dentry = d_alloc_name(root, "ptmx");
 	if (!dentry) {
-		printk(KERN_NOTICE "Unable to alloc dentry for ptmx node\n");
+		pr_err("Unable to alloc dentry for ptmx node\n");
 		goto out;
 	}
 
@@ -270,7 +272,7 @@ static int mknod_ptmx(struct super_block
 	 */
 	inode = new_inode(sb);
 	if (!inode) {
-		printk(KERN_ERR "Unable to alloc inode for ptmx node\n");
+		pr_err("Unable to alloc inode for ptmx node\n");
 		dput(dentry);
 		goto out;
 	}
@@ -303,7 +305,7 @@ static void update_ptmx_mode(struct pts_
 #else
 static inline void update_ptmx_mode(struct pts_fs_info *fsi)
 {
-       return;
+	return;
 }
 #endif
 
@@ -333,9 +335,11 @@ static int devpts_show_options(struct se
 	struct pts_mount_opts *opts = &fsi->mount_opts;
 
 	if (opts->setuid)
-		seq_printf(seq, ",uid=%u", from_kuid_munged(&init_user_ns, opts->uid));
+		seq_printf(seq, ",uid=%u",
+			   from_kuid_munged(&init_user_ns, opts->uid));
 	if (opts->setgid)
-		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, opts->gid));
+		seq_printf(seq, ",gid=%u",
+			   from_kgid_munged(&init_user_ns, opts->gid));
 	seq_printf(seq, ",mode=%03o", opts->mode);
 #ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	seq_printf(seq, ",ptmxmode=%03o", opts->ptmxmode);
@@ -396,7 +400,7 @@ devpts_fill_super(struct super_block *s,
 	if (s->s_root)
 		return 0;
 
-	printk(KERN_ERR "devpts: get root dentry failed\n");
+	pr_err("get root dentry failed\n");
 
 fail:
 	return -ENOMEM;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

