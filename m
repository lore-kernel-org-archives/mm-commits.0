From: akpm@linux-foundation.org
Subject: - autofs4-make-autofs-type-usage-explicit.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:44 -0800
Message-ID: <200901072218.n07MIiXc018187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761903AbZAGWTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: make autofs type usage explicit
has been removed from the -mm tree.  Its filename was
     autofs4-make-autofs-type-usage-explicit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: make autofs type usage explicit
From: Ian Kent <raven@themaw.net>

- the type assigned at mount when no type is given is changed
  from 0 to AUTOFS_TYPE_INDIRECT. This was done because 0 and
  AUTOFS_TYPE_INDIRECT were being treated implicitly as the same
  type.

- previously, an offset mount had it's type set to
  AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET but the mount control
  re-implementation needs to be able distinguish all three types.
  So this was changed to make the type setting explicit.

- a type AUTOFS_TYPE_ANY was added for use by the re-implementation
  when checking if a given path is a mountpoint. It's not really a
  type as we use this to ask if a given path is a mountpoint in the
  autofs_dev_ioctl_ismountpoint() function.

- functions to set and test the autofs mount types have been added to
  improve readability and make the type usage explicit.

- the mount type is used from user space for the mount control
  re-implementtion so, for consistency, all the definitions have
  been moved to the user space include file include/linux/auto_fs4.h.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h    |    2 -
 fs/autofs4/dev-ioctl.c   |    4 +-
 fs/autofs4/expire.c      |    4 +-
 fs/autofs4/inode.c       |   14 ++++----
 fs/autofs4/waitq.c       |    8 ++--
 include/linux/auto_fs4.h |   62 ++++++++++++++++++++++++++++++++++---
 6 files changed, 73 insertions(+), 21 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-make-autofs-type-usage-explicit fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-make-autofs-type-usage-explicit
+++ a/fs/autofs4/autofs_i.h
@@ -25,8 +25,6 @@
 #define AUTOFS_DEV_IOCTL_IOC_FIRST	(AUTOFS_DEV_IOCTL_VERSION)
 #define AUTOFS_DEV_IOCTL_IOC_COUNT	(AUTOFS_IOC_COUNT - 11)
 
-#define AUTOFS_TYPE_TRIGGER	(AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET)
-
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff -puN fs/autofs4/dev-ioctl.c~autofs4-make-autofs-type-usage-explicit fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-make-autofs-type-usage-explicit
+++ a/fs/autofs4/dev-ioctl.c
@@ -532,7 +532,7 @@ static int autofs_dev_ioctl_expire(struc
 	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
-	if (sbi->type & AUTOFS_TYPE_TRIGGER)
+	if (autofs_type_trigger(sbi->type))
 		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, how);
 	else
 		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, how);
@@ -615,7 +615,7 @@ static int autofs_dev_ioctl_ismountpoint
 	param->ismountpoint.out.magic = magic = 0;
 
 	if (!fp || param->ioctlfd == -1) {
-		if (type == AUTOFS_TYPE_ANY) {
+		if (autofs_type_any(type)) {
 			struct super_block *sb;
 
 			err = path_lookup(path, LOOKUP_FOLLOW, &nd);
diff -puN fs/autofs4/expire.c~autofs4-make-autofs-type-usage-explicit fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-make-autofs-type-usage-explicit
+++ a/fs/autofs4/expire.c
@@ -63,7 +63,7 @@ static int autofs4_mount_busy(struct vfs
 		struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 
 		/* This is an autofs submount, we can't expire it */
-		if (sbi->type == AUTOFS_TYPE_INDIRECT)
+		if (autofs_type_indirect(sbi->type))
 			goto done;
 
 		/*
@@ -490,7 +490,7 @@ int autofs4_expire_multi(struct super_bl
 	if (arg && get_user(do_now, arg))
 		return -EFAULT;
 
-	if (sbi->type & AUTOFS_TYPE_TRIGGER)
+	if (autofs_type_trigger(sbi->type))
 		dentry = autofs4_expire_direct(sb, mnt, sbi, do_now);
 	else
 		dentry = autofs4_expire_indirect(sb, mnt, sbi, do_now);
diff -puN fs/autofs4/inode.c~autofs4-make-autofs-type-usage-explicit fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-make-autofs-type-usage-explicit
+++ a/fs/autofs4/inode.c
@@ -197,9 +197,9 @@ static int autofs4_show_options(struct s
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
 	seq_printf(m, ",maxproto=%d", sbi->max_proto);
 
-	if (sbi->type & AUTOFS_TYPE_OFFSET)
+	if (autofs_type_offset(sbi->type))
 		seq_printf(m, ",offset");
-	else if (sbi->type & AUTOFS_TYPE_DIRECT)
+	else if (autofs_type_direct(sbi->type))
 		seq_printf(m, ",direct");
 	else
 		seq_printf(m, ",indirect");
@@ -284,13 +284,13 @@ static int parse_options(char *options, 
 			*maxproto = option;
 			break;
 		case Opt_indirect:
-			*type = AUTOFS_TYPE_INDIRECT;
+			set_autofs_type_indirect(type);
 			break;
 		case Opt_direct:
-			*type = AUTOFS_TYPE_DIRECT;
+			set_autofs_type_direct(type);
 			break;
 		case Opt_offset:
-			*type = AUTOFS_TYPE_OFFSET;
+			set_autofs_type_offset(type);
 			break;
 		default:
 			return 1;
@@ -338,7 +338,7 @@ int autofs4_fill_super(struct super_bloc
 	sbi->sb = s;
 	sbi->version = 0;
 	sbi->sub_version = 0;
-	sbi->type = AUTOFS_TYPE_INDIRECT;
+	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
 	mutex_init(&sbi->wq_mutex);
@@ -380,7 +380,7 @@ int autofs4_fill_super(struct super_bloc
 	}
 
 	root_inode->i_fop = &autofs4_root_operations;
-	root_inode->i_op = sbi->type & AUTOFS_TYPE_TRIGGER ?
+	root_inode->i_op = autofs_type_trigger(sbi->type) ?
 			&autofs4_direct_root_inode_operations :
 			&autofs4_indirect_root_inode_operations;
 
diff -puN fs/autofs4/waitq.c~autofs4-make-autofs-type-usage-explicit fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-make-autofs-type-usage-explicit
+++ a/fs/autofs4/waitq.c
@@ -337,7 +337,7 @@ int autofs4_wait(struct autofs_sb_info *
 		 * is very similar for indirect mounts except only dentrys
 		 * in the root of the autofs file system may be negative.
 		 */
-		if (sbi->type & AUTOFS_TYPE_TRIGGER)
+		if (autofs_type_trigger(sbi->type))
 			return -ENOENT;
 		else if (!IS_ROOT(dentry->d_parent))
 			return -ENOENT;
@@ -348,7 +348,7 @@ int autofs4_wait(struct autofs_sb_info *
 		return -ENOMEM;
 
 	/* If this is a direct mount request create a dummy name */
-	if (IS_ROOT(dentry) && sbi->type & AUTOFS_TYPE_TRIGGER)
+	if (IS_ROOT(dentry) && autofs_type_trigger(sbi->type))
 		qstr.len = sprintf(name, "%p", dentry);
 	else {
 		qstr.len = autofs4_getpath(sbi, dentry, &name);
@@ -406,11 +406,11 @@ int autofs4_wait(struct autofs_sb_info *
 				type = autofs_ptype_expire_multi;
 		} else {
 			if (notify == NFY_MOUNT)
-				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
+				type = autofs_type_trigger(sbi->type) ?
 					autofs_ptype_missing_direct :
 					 autofs_ptype_missing_indirect;
 			else
-				type = (sbi->type & AUTOFS_TYPE_TRIGGER) ?
+				type = autofs_type_trigger(sbi->type) ?
 					autofs_ptype_expire_direct :
 					autofs_ptype_expire_indirect;
 		}
diff -puN include/linux/auto_fs4.h~autofs4-make-autofs-type-usage-explicit include/linux/auto_fs4.h
--- a/include/linux/auto_fs4.h~autofs4-make-autofs-type-usage-explicit
+++ a/include/linux/auto_fs4.h
@@ -29,10 +29,64 @@
 #define AUTOFS_EXP_IMMEDIATE		1
 #define AUTOFS_EXP_LEAVES		2
 
-#define AUTOFS_TYPE_ANY			0x0000
-#define AUTOFS_TYPE_INDIRECT		0x0001
-#define AUTOFS_TYPE_DIRECT		0x0002
-#define AUTOFS_TYPE_OFFSET		0x0004
+#define AUTOFS_TYPE_ANY			0U
+#define AUTOFS_TYPE_INDIRECT		1U
+#define AUTOFS_TYPE_DIRECT		2U
+#define AUTOFS_TYPE_OFFSET		4U
+
+static inline void set_autofs_type_indirect(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_INDIRECT;
+	return;
+}
+
+static inline unsigned int autofs_type_indirect(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_INDIRECT);
+}
+
+static inline void set_autofs_type_direct(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_DIRECT;
+	return;
+}
+
+static inline unsigned int autofs_type_direct(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_DIRECT);
+}
+
+static inline void set_autofs_type_offset(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_OFFSET;
+	return;
+}
+
+static inline unsigned int autofs_type_offset(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_OFFSET);
+}
+
+static inline unsigned int autofs_type_trigger(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_DIRECT || type == AUTOFS_TYPE_OFFSET);
+}
+
+/*
+ * This isn't really a type as we use it to say "no type set" to
+ * indicate we want to search for "any" mount in the
+ * autofs_dev_ioctl_ismountpoint() device ioctl function.
+ */
+static inline void set_autofs_type_any(unsigned int *type)
+{
+	*type = AUTOFS_TYPE_ANY;
+	return;
+}
+
+static inline unsigned int autofs_type_any(unsigned int type)
+{
+	return (type == AUTOFS_TYPE_ANY);
+}
 
 /* Daemon notification packet types */
 enum autofs_notify {
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

