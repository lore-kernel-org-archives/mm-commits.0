From: akpm@linux-foundation.org
Subject: - inotify-send-in_attrib-events-when-link-count-changes-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:16:57 -0800
Message-ID: <200802060716.m167GcaJ031309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247AbYBFHRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:17:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, kamalesh@linux.vnet.ibm.com, mwelinder@gmail.com, rlove@google.com, sfrench@us.ibm.com, ttb@tentacle.dhs.org, mm-commits@vger.kernel.org


The patch titled
     inotify-send-in_attrib-events-when-link-count-changes fix
has been removed from the -mm tree.  Its filename was
     inotify-send-in_attrib-events-when-link-count-changes-fix.patch

This patch was dropped because it was folded into inotify-send-in_attrib-events-when-link-count-changes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify-send-in_attrib-events-when-link-count-changes fix
From: Jan Kara <jack@suse.cz>

OK, it's a problem with CIFS.  Its cifs_hardlink() function doesn't call
d_instantiate() and thus returns a dentry with d_inode set to NULL.  I'm not
sure if such behavior is really correct but anyway, attached is a new version
of the patch which should handle it gracefully.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Morten Welinder <mwelinder@gmail.com>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c               |    2 +-
 include/linux/fsnotify.h |   14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/namei.c~inotify-send-in_attrib-events-when-link-count-changes-fix fs/namei.c
--- a/fs/namei.c~inotify-send-in_attrib-events-when-link-count-changes-fix
+++ a/fs/namei.c
@@ -2362,7 +2362,7 @@ int vfs_link(struct dentry *old_dentry, 
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&old_dentry->d_inode->i_mutex);
 	if (!error)
-		fsnotify_link(dir, new_dentry);
+		fsnotify_link(dir, old_dentry->d_inode, new_dentry);
 	return error;
 }
 
diff -puN include/linux/fsnotify.h~inotify-send-in_attrib-events-when-link-count-changes-fix include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~inotify-send-in_attrib-events-when-link-count-changes-fix
+++ a/include/linux/fsnotify.h
@@ -112,14 +112,16 @@ static inline void fsnotify_create(struc
 
 /*
  * fsnotify_link - new hardlink in 'inode' directory
+ * Note: We have to pass also the linked inode ptr as some filesystems leave
+ *   new_dentry->d_inode NULL and instantiate inode pointer later
  */
-static inline void fsnotify_link(struct inode *inode, struct dentry *new_dentry)
+static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
-	inotify_inode_queue_event(inode, IN_CREATE, 0, new_dentry->d_name.name,
-				  new_dentry->d_inode);
-	fsnotify_link_count(new_dentry->d_inode);
-	audit_inode_child(new_dentry->d_name.name, new_dentry, inode);
+	inode_dir_notify(dir, DN_CREATE);
+	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
+				  inode);
+	fsnotify_link_count(inode);
+	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
 }
 
 /*
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
ext3-fix-lock-inversion-in-direct-io.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
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
