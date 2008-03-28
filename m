From: akpm@linux-foundation.org
Subject: - vfs-mountinfo-add-mount-id.patch removed from -mm tree
Date: Fri, 28 Mar 2008 12:06:32 -0700
Message-ID: <200803281906.m2SJ6W6c005395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbYC1TGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 15:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: mountinfo: add mount ID
has been removed from the -mm tree.  Its filename was
     vfs-mountinfo-add-mount-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo: add mount ID
From: Miklos Szeredi <mszeredi@suse.cz>

Add a unique ID to each vfsmount using the IDR infrastructure.  The
identifiers are reused after the vfsmount is freed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   34 ++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    1 +
 2 files changed, 35 insertions(+)

diff -puN fs/namespace.c~vfs-mountinfo-add-mount-id fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-add-mount-id
+++ a/fs/namespace.c
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/ramfs.h>
 #include <linux/log2.h>
+#include <linux/idr.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -39,6 +40,7 @@
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
 
 static int event;
+static DEFINE_IDA(mnt_id_ida);
 
 static struct list_head *mount_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
@@ -58,10 +60,41 @@ static inline unsigned long hash(struct 
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
+static int mnt_alloc_id(struct vfsmount *mnt)
+{
+	int res;
+
+ retry:
+	spin_lock(&vfsmount_lock);
+	res = ida_get_new(&mnt_id_ida, &mnt->mnt_id);
+	spin_unlock(&vfsmount_lock);
+	if (res == -EAGAIN) {
+		if (ida_pre_get(&mnt_id_ida, GFP_KERNEL))
+			goto retry;
+		res = -ENOMEM;
+	}
+	return res;
+}
+
+static void mnt_free_id(struct vfsmount *mnt)
+{
+	spin_lock(&vfsmount_lock);
+	ida_remove(&mnt_id_ida, mnt->mnt_id);
+	spin_unlock(&vfsmount_lock);
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
 	if (mnt) {
+		int err;
+
+		err = mnt_alloc_id(mnt);
+		if (err) {
+			kmem_cache_free(mnt_cache, mnt);
+			return NULL;
+		}
+
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
@@ -353,6 +386,7 @@ EXPORT_SYMBOL(simple_set_mnt);
 void free_vfsmnt(struct vfsmount *mnt)
 {
 	kfree(mnt->mnt_devname);
+	mnt_free_id(mnt);
 	kmem_cache_free(mnt_cache, mnt);
 }
 
diff -puN include/linux/mount.h~vfs-mountinfo-add-mount-id include/linux/mount.h
--- a/include/linux/mount.h~vfs-mountinfo-add-mount-id
+++ a/include/linux/mount.h
@@ -56,6 +56,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	int mnt_id;			/* mount identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-vfs.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

