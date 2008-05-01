From: akpm@linux-foundation.org
Subject: - mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:43 -0700
Message-ID: <200805010931.m419Vh2a030896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757636AbYEAJbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: expose the BDI object in sysfs for FUSE
has been removed from the -mm tree.  Its filename was
     mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: expose the BDI object in sysfs for FUSE
From: Miklos Szeredi <mszeredi@suse.cz>

Register FUSE's backing_dev_info under sysfs with the name "fuse-MAJOR:MINOR"

Make the fuse control filesystem use s_dev instead of a fuse specific ID. 
This makes it easier to match directories under /sys/fs/fuse/connections/ with
directories under /sys/class/bdi, and with actual mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/control.c |    2 +-
 fs/fuse/fuse_i.h  |    4 ++--
 fs/fuse/inode.c   |   30 +++++++++++++++---------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff -puN fs/fuse/control.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse fs/fuse/control.c
--- a/fs/fuse/control.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse
+++ a/fs/fuse/control.c
@@ -117,7 +117,7 @@ int fuse_ctl_add_conn(struct fuse_conn *
 
 	parent = fuse_control_sb->s_root;
 	inc_nlink(parent->d_inode);
-	sprintf(name, "%llu", (unsigned long long) fc->id);
+	sprintf(name, "%u", fc->dev);
 	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500, 2,
 				     &simple_dir_inode_operations,
 				     &simple_dir_operations);
diff -puN fs/fuse/fuse_i.h~mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse
+++ a/fs/fuse/fuse_i.h
@@ -390,8 +390,8 @@ struct fuse_conn {
 	/** Entry on the fuse_conn_list */
 	struct list_head entry;
 
-	/** Unique ID */
-	u64 id;
+	/** Device ID from super block */
+	dev_t dev;
 
 	/** Dentries in the control filesystem */
 	struct dentry *ctl_dentry[FUSE_CTL_NUM_DENTRIES];
diff -puN fs/fuse/inode.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse fs/fuse/inode.c
--- a/fs/fuse/inode.c~mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse
+++ a/fs/fuse/inode.c
@@ -447,7 +447,7 @@ static int fuse_show_options(struct seq_
 	return 0;
 }
 
-static struct fuse_conn *new_conn(void)
+static struct fuse_conn *new_conn(struct super_block *sb)
 {
 	struct fuse_conn *fc;
 	int err;
@@ -468,19 +468,26 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
+		fc->dev = sb->s_dev;
 		err = bdi_init(&fc->bdi);
-		if (err) {
-			kfree(fc);
-			fc = NULL;
-			goto out;
-		}
+		if (err)
+			goto error_kfree;
+		err = bdi_register_dev(&fc->bdi, fc->dev);
+		if (err)
+			goto error_bdi_destroy;
 		fc->reqctr = 0;
 		fc->blocked = 1;
 		fc->attr_version = 1;
 		get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 	}
-out:
 	return fc;
+
+error_bdi_destroy:
+	bdi_destroy(&fc->bdi);
+error_kfree:
+	mutex_destroy(&fc->inst_mutex);
+	kfree(fc);
+	return NULL;
 }
 
 void fuse_conn_put(struct fuse_conn *fc)
@@ -578,12 +585,6 @@ static void fuse_send_init(struct fuse_c
 	request_send_background(fc, req);
 }
 
-static u64 conn_id(void)
-{
-	static u64 ctr = 1;
-	return ctr++;
-}
-
 static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct fuse_conn *fc;
@@ -621,7 +622,7 @@ static int fuse_fill_super(struct super_
 	if (file->f_op != &fuse_dev_operations)
 		return -EINVAL;
 
-	fc = new_conn();
+	fc = new_conn(sb);
 	if (!fc)
 		return -ENOMEM;
 
@@ -659,7 +660,6 @@ static int fuse_fill_super(struct super_
 	if (file->private_data)
 		goto err_unlock;
 
-	fc->id = conn_id();
 	err = fuse_ctl_add_conn(fc);
 	if (err)
 		goto err_unlock;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

