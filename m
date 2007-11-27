From: akpm@linux-foundation.org
Subject: + inotify-send-in_attrib-events-when-link-count-changes.patch added to -mm tree
Date: Tue, 27 Nov 2007 12:46:49 -0800
Message-ID: <200711272046.lARKkndl029568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756617AbXK0UrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, mwelinder@gmail.com, rlove@google.com, ttb@tentacle.dhs.org


The patch titled
     inotify: send IN_ATTRIB events when link count changes
has been added to the -mm tree.  Its filename is
     inotify-send-in_attrib-events-when-link-count-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: inotify: send IN_ATTRIB events when link count changes
From: Jan Kara <jack@suse.cz>

Send inotify events to the inode itself when its link count has changed.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Morten Welinder <mwelinder@gmail.com>
Cc: Robert Love <rlove@google.com>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c               |    3 ++-
 include/linux/fsnotify.h |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~inotify-send-in_attrib-events-when-link-count-changes fs/namei.c
--- a/fs/namei.c~inotify-send-in_attrib-events-when-link-count-changes
+++ a/fs/namei.c
@@ -2189,6 +2189,7 @@ int vfs_unlink(struct inode *dir, struct
 
 	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
 	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
+		fsnotify_link_count(dentry->d_inode);
 		d_delete(dentry);
 	}
 
@@ -2361,7 +2362,7 @@ int vfs_link(struct dentry *old_dentry, 
 	error = dir->i_op->link(old_dentry, dir, new_dentry);
 	mutex_unlock(&old_dentry->d_inode->i_mutex);
 	if (!error)
-		fsnotify_create(dir, new_dentry);
+		fsnotify_link(dir, new_dentry);
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
@@ -103,6 +111,18 @@ static inline void fsnotify_create(struc
 }
 
 /*
+ * fsnotify_link - new hardlink in 'inode' directory
+ */
+static inline void fsnotify_link(struct inode *inode, struct dentry *new_dentry)
+{
+	inode_dir_notify(inode, DN_CREATE);
+	inotify_inode_queue_event(inode, IN_CREATE, 0, new_dentry->d_name.name,
+				  new_dentry->d_inode);
+	fsnotify_link_count(new_dentry->d_inode);
+	audit_inode_child(new_dentry->d_name.name, new_dentry, inode);
+}
+
+/*
  * fsnotify_mkdir - directory 'name' was created
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
_

Patches currently in -mm which might be from jack@suse.cz are

git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
