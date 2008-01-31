From: akpm@linux-foundation.org
Subject: + mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch added to -mm tree
Date: Wed, 30 Jan 2008 16:39:56 -0800
Message-ID: <200801310039.m0V0duGa000403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756820AbYAaAk2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 19:40:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, a.p.zijlstra@chello.nl


The patch titled
     mm: bdi: expose the BDI object in sysfs for FUSE
has been added to the -mm tree.  Its filename is
     mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch

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
 fs/fuse/inode.c   |   31 ++++++++++++++++---------------
 3 files changed, 19 insertions(+), 18 deletions(-)

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
@@ -448,7 +448,7 @@ static int fuse_show_options(struct seq_
 	return 0;
 }
 
-static struct fuse_conn *new_conn(void)
+static struct fuse_conn *new_conn(struct super_block *sb)
 {
 	struct fuse_conn *fc;
 	int err;
@@ -469,19 +469,27 @@ static struct fuse_conn *new_conn(void)
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
+		err = bdi_register(&fc->bdi, NULL, "fuse-%u:%u",
+				   MAJOR(fc->dev), MINOR(fc->dev));
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
@@ -579,12 +587,6 @@ static void fuse_send_init(struct fuse_c
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
@@ -622,7 +624,7 @@ static int fuse_fill_super(struct super_
 	if (file->f_op != &fuse_dev_operations)
 		return -EINVAL;
 
-	fc = new_conn();
+	fc = new_conn(sb);
 	if (!fc)
 		return -ENOMEM;
 
@@ -660,7 +662,6 @@ static int fuse_fill_super(struct super_
 	if (file->private_data)
 		goto err_unlock;
 
-	fc->id = conn_id();
 	err = fuse_ctl_add_conn(fc);
 	if (err)
 		goto err_unlock;
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
vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
