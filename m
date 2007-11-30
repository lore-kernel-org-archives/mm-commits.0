From: akpm@linux-foundation.org
Subject: + inotify-send-in_attrib-events-when-link-count-changes-fix.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:02:42 -0800
Message-ID: <200711300002.lAU02grJ014012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763746AbXK3ADc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:03:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, kamalesh@linux.vnet.ibm.com, mwelinder@gmail.com, rlove@google.com, sfrench@us.ibm.com, ttb@tentacle.dhs.org


The patch titled
     inotify-send-in_attrib-events-when-link-count-changes fix
has been added to the -mm tree.  Its filename is
     inotify-send-in_attrib-events-when-link-count-changes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
jbd-fix-assertion-failure-in-fs-jbd-checkpointc.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
jbd2-fix-assertion-failure-in-fs-jbd2-checkpointc.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
