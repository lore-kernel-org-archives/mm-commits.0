From: akpm@linux-foundation.org
Subject: + mount-options-fix-devpts.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:30 -0800
Message-ID: <200801292322.m0TNMUss009701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYA2XWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hpa@zytor.com


The patch titled
     mount options: fix devpts
has been added to the -mm tree.  Its filename is
     mount-options-fix-devpts.patch

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
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
