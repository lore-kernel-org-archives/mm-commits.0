From: akpm@linux-foundation.org
Subject: - autofs4-cleanup-autofs-mount-type-usage.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:59 -0700
Message-ID: <200810182314.m9INExcR028508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYJRXPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: cleanup autofs mount type usage
has been removed from the -mm tree.  Its filename was
     autofs4-cleanup-autofs-mount-type-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: cleanup autofs mount type usage
From: Ian Kent <raven@themaw.net>

Usage of the AUTOFS_TYPE_* defines is a little confusing and appears
inconsistent.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h    |    6 ++----
 fs/autofs4/expire.c      |    2 +-
 fs/autofs4/inode.c       |    6 +++---
 fs/autofs4/waitq.c       |    8 ++++----
 include/linux/auto_fs4.h |    5 +++++
 5 files changed, 15 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-cleanup-autofs-mount-type-usage fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-cleanup-autofs-mount-type-usage
+++ a/fs/autofs4/autofs_i.h
@@ -21,6 +21,8 @@
 #define AUTOFS_IOC_FIRST     AUTOFS_IOC_READY
 #define AUTOFS_IOC_COUNT     32
 
+#define AUTOFS_TYPE_TRIGGER	(AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET)
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -92,10 +94,6 @@ struct autofs_wait_queue {
 
 #define AUTOFS_SBI_MAGIC 0x6d4a556d
 
-#define AUTOFS_TYPE_INDIRECT     0x0001
-#define AUTOFS_TYPE_DIRECT       0x0002
-#define AUTOFS_TYPE_OFFSET       0x0004
-
 struct autofs_sb_info {
 	u32 magic;
 	int pipefd;
diff -puN fs/autofs4/expire.c~autofs4-cleanup-autofs-mount-type-usage fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-cleanup-autofs-mount-type-usage
+++ a/fs/autofs4/expire.c
@@ -479,7 +479,7 @@ int autofs4_expire_multi(struct super_bl
 	if (arg && get_user(do_now, arg))
 		return -EFAULT;
 
-	if (sbi->type & AUTOFS_TYPE_DIRECT)
+	if (sbi->type & AUTOFS_TYPE_TRIGGER)
 		dentry = autofs4_expire_direct(sb, mnt, sbi, do_now);
 	else
 		dentry = autofs4_expire_indirect(sb, mnt, sbi, do_now);
diff -puN fs/autofs4/inode.c~autofs4-cleanup-autofs-mount-type-usage fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-cleanup-autofs-mount-type-usage
+++ a/fs/autofs4/inode.c
@@ -288,7 +288,7 @@ static int parse_options(char *options, 
 			*type = AUTOFS_TYPE_DIRECT;
 			break;
 		case Opt_offset:
-			*type = AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET;
+			*type = AUTOFS_TYPE_OFFSET;
 			break;
 		default:
 			return 1;
@@ -336,7 +336,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
-	sbi->type = 0;
+	sbi->type = AUTOFS_TYPE_INDIRECT;
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
 	mutex_init(&sbi->wq_mutex);
@@ -378,7 +378,7 @@ int autofs4_fill_super(struct super_bloc
 	}
 
 	root_inode->i_fop = &autofs4_root_operations;
-	root_inode->i_op = sbi->type & AUTOFS_TYPE_DIRECT ?
+	root_inode->i_op = sbi->type & AUTOFS_TYPE_TRIGGER ?
 			&autofs4_direct_root_inode_operations :
 			&autofs4_indirect_root_inode_operations;
 
diff -puN fs/autofs4/waitq.c~autofs4-cleanup-autofs-mount-type-usage fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-cleanup-autofs-mount-type-usage
+++ a/fs/autofs4/waitq.c
@@ -337,7 +337,7 @@ int autofs4_wait(struct autofs_sb_info *
 		 * is very similar for indirect mounts except only dentrys
 		 * in the root of the autofs file system may be negative.
 		 */
-		if (sbi->type & (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET))
+		if (sbi->type & AUTOFS_TYPE_TRIGGER)
 			return -ENOENT;
 		else if (!IS_ROOT(dentry->d_parent))
 			return -ENOENT;
@@ -348,7 +348,7 @@ int autofs4_wait(struct autofs_sb_info *
 		return -ENOMEM;
 
 	/* If this is a direct mount request create a dummy name */
-	if (IS_ROOT(dentry) && (sbi->type & AUTOFS_TYPE_DIRECT))
+	if (IS_ROOT(dentry) && sbi->type & AUTOFS_TYPE_TRIGGER)
 		qstr.len = sprintf(name, "%p", dentry);
 	else {
 		qstr.len = autofs4_getpath(sbi, dentry, &name);
@@ -406,11 +406,11 @@ int autofs4_wait(struct autofs_sb_info *
 				type = autofs_ptype_expire_multi;
 		} else {
 			if (notify == NFY_MOUNT)
-				type = (sbi->type & AUTOFS_TYPE_DIRECT) ?
+				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
 					autofs_ptype_missing_direct :
 					 autofs_ptype_missing_indirect;
 			else
-				type = (sbi->type & AUTOFS_TYPE_DIRECT) ?
+				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
 					autofs_ptype_expire_direct :
 					autofs_ptype_expire_indirect;
 		}
diff -puN include/linux/auto_fs4.h~autofs4-cleanup-autofs-mount-type-usage include/linux/auto_fs4.h
--- a/include/linux/auto_fs4.h~autofs4-cleanup-autofs-mount-type-usage
+++ a/include/linux/auto_fs4.h
@@ -29,6 +29,11 @@
 #define AUTOFS_EXP_IMMEDIATE		1
 #define AUTOFS_EXP_LEAVES		2
 
+#define AUTOFS_TYPE_ANY			0x0000
+#define AUTOFS_TYPE_INDIRECT		0x0001
+#define AUTOFS_TYPE_DIRECT		0x0002
+#define AUTOFS_TYPE_OFFSET		0x0004
+
 /* Daemon notification packet types */
 enum autofs_notify {
 	NFY_NONE,
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

