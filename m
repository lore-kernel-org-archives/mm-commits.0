From: akpm@linux-foundation.org
Subject: - inotify-send-in_attrib-events-when-link-count-changes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:11 -0800
Message-ID: <200802070022.m170MqQ7006476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934003AbYBGAq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, kamalesh@linux.vnet.ibm.com, mwelinder@gmail.com, rlove@google.com, sfrench@us.ibm.com, ttb@tentacle.dhs.org, mm-commits@vger.kernel.org


The patch titled
     inotify: send IN_ATTRIB events when link count changes
has been removed from the -mm tree.  Its filename was
     inotify-send-in_attrib-events-when-link-count-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: send IN_ATTRIB events when link count changes
From: Jan Kara <jack@suse.cz>

Currently, no notification event has been sent when inode's link count
changed.  This is inconvenient for the application in some cases:

Suppose you have the following directory structure

    foo/test
    bar/

and you watch test.  If someone does "mv foo/test bar/", you get event
IN_MOVE_SELF and you know something has happened with the file "test". 
However if someone does "ln foo/test bar/test" and "rm foo/test" you get no
inotify event for the file "test" (only directories "foo" and "bar" receive
events).

Furthermore it could be argued that link count belongs to file's metadata and
thus IN_ATTRIB should be sent when it changes.

The following patch implements sending of IN_ATTRIB inotify events when link
count of the inode changes, i.e., when a hardlink to the inode is created or
when it is removed.  This event is sent in addition to all the events sent so
far.  In particular, when a last link to a file is removed, IN_ATTRIB event is
sent in addition to IN_DELETE_SELF event.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Morten Welinder <mwelinder@gmail.com>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c               |    3 ++-
 include/linux/fsnotify.h |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~inotify-send-in_attrib-events-when-link-count-changes fs/namei.c
--- a/fs/namei.c~inotify-send-in_attrib-events-when-link-count-changes
+++ a/fs/namei.c
@@ -2188,6 +2188,7 @@ int vfs_unlink(struct inode *dir, struct
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
 	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+		fsnotify_link_count(dentry->d_inode);
 		d_delete(dentry);
 	}
 
@@ -2360,7 +2361,7 @@ int vfs_link(struct dentry *old_dentry, 
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&old_dentry->d_inode->i_mutex);
 	if (!error)
-		fsnotify_create(dir, new_dentry);
+		fsnotify_link(dir, old_dentry->d_inode, new_dentry);
 	return error;
 }
 
diff -puN include/linux/fsnotify.h~inotify-send-in_attrib-events-when-link-count-changes include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~inotify-send-in_attrib-events-when-link-count-changes
+++ a/include/linux/fsnotify.h
@@ -92,6 +92,14 @@ static inline void fsnotify_inoderemove(
 }
 
 /*
+ * fsnotify_link_count - inode's link count changed
+ */
+static inline void fsnotify_link_count(struct inode *inode)
+{
+	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+}
+
+/*
  * fsnotify_create - 'name' was linked in
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
@@ -103,6 +111,20 @@ static inline void fsnotify_create(struc
 }
 
 /*
+ * fsnotify_link - new hardlink in 'inode' directory
+ * Note: We have to pass also the linked inode ptr as some filesystems leave
+ *   new_dentry->d_inode NULL and instantiate inode pointer later
+ */
+static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
+{
+	inode_dir_notify(dir, DN_CREATE);
+	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
+				  inode);
+	fsnotify_link_count(inode);
+	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
+}
+
+/*
  * fsnotify_mkdir - directory 'name' was created
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
udf-cleanup-directory-offset-handling.patch
udf-fix-adding-entry-to-a-directory.patch
change-udf-maintainer.patch
isofs-implement-dmode-option.patch
isofs-implement-dmode-option-fix.patch
mount-options-fix-ext2.patch
mount-options-fix-isofs.patch
mount-options-fix-udf.patch
buffer_head-fix-private_list-handling.patch
