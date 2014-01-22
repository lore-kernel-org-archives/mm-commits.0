From: akpm@linux-foundation.org
Subject: [merged] fsnotify-remove-should_send_event-callback.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:11:27 -0800
Message-ID: <52e025ef.wW9xBTVWf/uytcPd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaAVUL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:11:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de, eparis@parisplace.org, jack@suse.cz

Subject: [merged] fsnotify-remove-should_send_event-callback.patch removed from -mm tree
To: jack@suse.cz,eparis@parisplace.org,hch@lst.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:11:27 -0800


The patch titled
     Subject: fsnotify: remove .should_send_event callback
has been removed from the -mm tree.  Its filename was
     fsnotify-remove-should_send_event-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: remove .should_send_event callback

After removing event structure creation from the generic layer there is no
reason for separate .should_send_event and .handle_event callbacks.  So
just remove the first one.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c          |   22 ++++------------------
 fs/notify/fanotify/fanotify.c        |   18 ++++++++++--------
 fs/notify/fsnotify.c                 |    5 -----
 fs/notify/inotify/inotify_fsnotify.c |   24 +++++++-----------------
 include/linux/fsnotify_backend.h     |    4 ----
 kernel/audit_tree.c                  |   12 +-----------
 kernel/audit_watch.c                 |    9 ---------
 7 files changed, 22 insertions(+), 72 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~fsnotify-remove-should_send_event-callback fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~fsnotify-remove-should_send_event-callback
+++ a/fs/notify/dnotify/dnotify.c
@@ -94,6 +94,10 @@ static int dnotify_handle_event(struct f
 	struct fown_struct *fown;
 	__u32 test_mask = mask & ~FS_EVENT_ON_CHILD;
 
+	/* not a dir, dnotify doesn't care */
+	if (!S_ISDIR(inode->i_mode))
+		return 0;
+
 	BUG_ON(vfsmount_mark);
 
 	dn_mark = container_of(inode_mark, struct dnotify_mark, fsn_mark);
@@ -121,23 +125,6 @@ static int dnotify_handle_event(struct f
 	return 0;
 }
 
-/*
- * Given an inode and mask determine if dnotify would be interested in sending
- * userspace notification for that pair.
- */
-static bool dnotify_should_send_event(struct fsnotify_group *group,
-				      struct inode *inode,
-				      struct fsnotify_mark *inode_mark,
-				      struct fsnotify_mark *vfsmount_mark,
-				      __u32 mask, void *data, int data_type)
-{
-	/* not a dir, dnotify doesn't care */
-	if (!S_ISDIR(inode->i_mode))
-		return false;
-
-	return true;
-}
-
 static void dnotify_free_mark(struct fsnotify_mark *fsn_mark)
 {
 	struct dnotify_mark *dn_mark = container_of(fsn_mark,
@@ -151,7 +138,6 @@ static void dnotify_free_mark(struct fsn
 
 static struct fsnotify_ops dnotify_fsnotify_ops = {
 	.handle_event = dnotify_handle_event,
-	.should_send_event = dnotify_should_send_event,
 	.free_group_priv = NULL,
 	.freeing_mark = NULL,
 	.free_event = NULL,
diff -puN fs/notify/fanotify/fanotify.c~fsnotify-remove-should_send_event-callback fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fsnotify-remove-should_send_event-callback
+++ a/fs/notify/fanotify/fanotify.c
@@ -88,18 +88,17 @@ static int fanotify_get_response_from_ac
 }
 #endif
 
-static bool fanotify_should_send_event(struct fsnotify_group *group,
-				       struct inode *inode,
-				       struct fsnotify_mark *inode_mark,
+static bool fanotify_should_send_event(struct fsnotify_mark *inode_mark,
 				       struct fsnotify_mark *vfsmnt_mark,
-				       __u32 event_mask, void *data, int data_type)
+				       u32 event_mask,
+				       void *data, int data_type)
 {
 	__u32 marks_mask, marks_ignored_mask;
 	struct path *path = data;
 
-	pr_debug("%s: group=%p inode=%p inode_mark=%p vfsmnt_mark=%p "
-		 "mask=%x data=%p data_type=%d\n", __func__, group, inode,
-		 inode_mark, vfsmnt_mark, event_mask, data, data_type);
+	pr_debug("%s: inode_mark=%p vfsmnt_mark=%p mask=%x data=%p"
+		 " data_type=%d\n", __func__, inode_mark, vfsmnt_mark,
+		 event_mask, data, data_type);
 
 	/* if we don't have enough info to send an event to userspace say no */
 	if (data_type != FSNOTIFY_EVENT_PATH)
@@ -163,6 +162,10 @@ static int fanotify_handle_event(struct
 	BUILD_BUG_ON(FAN_ACCESS_PERM != FS_ACCESS_PERM);
 	BUILD_BUG_ON(FAN_ONDIR != FS_ISDIR);
 
+	if (!fanotify_should_send_event(inode_mark, fanotify_mark, mask, data,
+					data_type))
+		return 0;
+
 	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__, group, inode,
 		 mask);
 
@@ -225,7 +228,6 @@ static void fanotify_free_event(struct f
 
 const struct fsnotify_ops fanotify_fsnotify_ops = {
 	.handle_event = fanotify_handle_event,
-	.should_send_event = fanotify_should_send_event,
 	.free_group_priv = fanotify_free_group_priv,
 	.free_event = fanotify_free_event,
 	.freeing_mark = NULL,
diff -puN fs/notify/fsnotify.c~fsnotify-remove-should_send_event-callback fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-remove-should_send_event-callback
+++ a/fs/notify/fsnotify.c
@@ -177,11 +177,6 @@ static int send_to_group(struct inode *t
 	if (!inode_test_mask && !vfsmount_test_mask)
 		return 0;
 
-	if (group->ops->should_send_event(group, to_tell, inode_mark,
-					  vfsmount_mark, mask, data,
-					  data_is) == false)
-		return 0;
-
 	return group->ops->handle_event(group, to_tell, inode_mark,
 					vfsmount_mark, mask, data, data_is,
 					file_name);
diff -puN fs/notify/inotify/inotify_fsnotify.c~fsnotify-remove-should_send_event-callback fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~fsnotify-remove-should_send_event-callback
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -81,6 +81,13 @@ int inotify_handle_event(struct fsnotify
 
 	BUG_ON(vfsmount_mark);
 
+	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
+	    (data_type == FSNOTIFY_EVENT_PATH)) {
+		struct path *path = data;
+
+		if (d_unlinked(path->dentry))
+			return 0;
+	}
 	if (file_name) {
 		len = strlen(file_name);
 		alloc_len += len + 1;
@@ -122,22 +129,6 @@ static void inotify_freeing_mark(struct
 	inotify_ignored_and_remove_idr(fsn_mark, group);
 }
 
-static bool inotify_should_send_event(struct fsnotify_group *group, struct inode *inode,
-				      struct fsnotify_mark *inode_mark,
-				      struct fsnotify_mark *vfsmount_mark,
-				      __u32 mask, void *data, int data_type)
-{
-	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
-	    (data_type == FSNOTIFY_EVENT_PATH)) {
-		struct path *path = data;
-
-		if (d_unlinked(path->dentry))
-			return false;
-	}
-
-	return true;
-}
-
 /*
  * This is NEVER supposed to be called.  Inotify marks should either have been
  * removed from the idr when the watch was removed or in the
@@ -189,7 +180,6 @@ static void inotify_free_event(struct fs
 
 const struct fsnotify_ops inotify_fsnotify_ops = {
 	.handle_event = inotify_handle_event,
-	.should_send_event = inotify_should_send_event,
 	.free_group_priv = inotify_free_group_priv,
 	.free_event = inotify_free_event,
 	.freeing_mark = inotify_freeing_mark,
diff -puN include/linux/fsnotify_backend.h~fsnotify-remove-should_send_event-callback include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-remove-should_send_event-callback
+++ a/include/linux/fsnotify_backend.h
@@ -94,10 +94,6 @@ struct fsnotify_fname;
  * 		userspace messages that marks have been removed.
  */
 struct fsnotify_ops {
-	bool (*should_send_event)(struct fsnotify_group *group, struct inode *inode,
-				  struct fsnotify_mark *inode_mark,
-				  struct fsnotify_mark *vfsmount_mark,
-				  __u32 mask, void *data, int data_type);
 	int (*handle_event)(struct fsnotify_group *group,
 			    struct inode *inode,
 			    struct fsnotify_mark *inode_mark,
diff -puN kernel/audit_tree.c~fsnotify-remove-should_send_event-callback kernel/audit_tree.c
--- a/kernel/audit_tree.c~fsnotify-remove-should_send_event-callback
+++ a/kernel/audit_tree.c
@@ -918,8 +918,7 @@ static int audit_tree_handle_event(struc
 				   u32 mask, void *data, int data_type,
 				   const unsigned char *file_name)
 {
-	BUG();
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 static void audit_tree_freeing_mark(struct fsnotify_mark *entry, struct fsnotify_group *group)
@@ -935,17 +934,8 @@ static void audit_tree_freeing_mark(stru
 	BUG_ON(atomic_read(&entry->refcnt) < 1);
 }
 
-static bool audit_tree_send_event(struct fsnotify_group *group, struct inode *inode,
-				  struct fsnotify_mark *inode_mark,
-				  struct fsnotify_mark *vfsmount_mark,
-				  __u32 mask, void *data, int data_type)
-{
-	return false;
-}
-
 static const struct fsnotify_ops audit_tree_ops = {
 	.handle_event = audit_tree_handle_event,
-	.should_send_event = audit_tree_send_event,
 	.free_group_priv = NULL,
 	.free_event = NULL,
 	.freeing_mark = audit_tree_freeing_mark,
diff -puN kernel/audit_watch.c~fsnotify-remove-should_send_event-callback kernel/audit_watch.c
--- a/kernel/audit_watch.c~fsnotify-remove-should_send_event-callback
+++ a/kernel/audit_watch.c
@@ -465,14 +465,6 @@ void audit_remove_watch_rule(struct audi
 	}
 }
 
-static bool audit_watch_should_send_event(struct fsnotify_group *group, struct inode *inode,
-					  struct fsnotify_mark *inode_mark,
-					  struct fsnotify_mark *vfsmount_mark,
-					  __u32 mask, void *data, int data_type)
-{
-       return true;
-}
-
 /* Update watch data in audit rules based on fsnotify events. */
 static int audit_watch_handle_event(struct fsnotify_group *group,
 				    struct inode *to_tell,
@@ -512,7 +504,6 @@ static int audit_watch_handle_event(stru
 }
 
 static const struct fsnotify_ops audit_watch_fsnotify_ops = {
-	.should_send_event = 	audit_watch_should_send_event,
 	.handle_event = 	audit_watch_handle_event,
 	.free_group_priv = 	NULL,
 	.freeing_mark = 	NULL,
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-pipec-skip-file_update_time-on-frozen-fs.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch
userns-relax-the-posix_acl_valid-checks.patch
linux-next.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
mm-add-strictlimit-knob-v2.patch

