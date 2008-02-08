From: akpm@linux-foundation.org
Subject: - mount-options-fix-devpts.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:48 -0800
Message-ID: <200802082019.m18KJTg3011057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933561AbYBHUjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:39:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     mount options: fix devpts
has been removed from the -mm tree.  Its filename was
     mount-options-fix-devpts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix devpts
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to devpts.

Small cleanup: when parsing the "mode" option, mask with S_IALLUGO
instead of ~S_IFMT.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN fs/devpts/inode.c~mount-options-fix-devpts fs/devpts/inode.c
--- a/fs/devpts/inode.c~mount-options-fix-devpts
+++ a/fs/devpts/inode.c
@@ -20,9 +20,12 @@
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
+#include <linux/seq_file.h>
 
 #define DEVPTS_SUPER_MAGIC 0x1cd1
 
+#define DEVPTS_DEFAULT_MODE 0600
+
 static struct vfsmount *devpts_mnt;
 static struct dentry *devpts_root;
 
@@ -32,7 +35,7 @@ static struct {
 	uid_t   uid;
 	gid_t   gid;
 	umode_t mode;
-} config = {.mode = 0600};
+} config = {.mode = DEVPTS_DEFAULT_MODE};
 
 enum {
 	Opt_uid, Opt_gid, Opt_mode,
@@ -54,7 +57,7 @@ static int devpts_remount(struct super_b
 	config.setgid  = 0;
 	config.uid     = 0;
 	config.gid     = 0;
-	config.mode    = 0600;
+	config.mode    = DEVPTS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
@@ -81,7 +84,7 @@ static int devpts_remount(struct super_b
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
 				return -EINVAL;
-			config.mode = option & ~S_IFMT;
+			config.mode = option & S_IALLUGO;
 			break;
 		default:
 			printk(KERN_ERR "devpts: called with bogus options\n");
@@ -92,9 +95,21 @@ static int devpts_remount(struct super_b
 	return 0;
 }
 
+static int devpts_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	if (config.setuid)
+		seq_printf(seq, ",uid=%u", config.uid);
+	if (config.setgid)
+		seq_printf(seq, ",gid=%u", config.gid);
+	seq_printf(seq, ",mode=%03o", config.mode);
+
+	return 0;
+}
+
 static const struct super_operations devpts_sops = {
 	.statfs		= simple_statfs,
 	.remount_fs	= devpts_remount,
+	.show_options	= devpts_show_options,
 };
 
 static int
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
