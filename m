From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fsnotify-remove-free_list-list_head-from-fsnotify_mark.patch removed from
 -mm tree
Date: Thu, 13 Nov 2014 14:03:31 -0800
Message-ID: <54652ab3.8BoxJbjcdW+h5k9m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 17:03:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: remove free_list list_head from fsnotify_mark
has been removed from the -mm tree.  Its filename was
     fsnotify-remove-free_list-list_head-from-fsnotify_mark.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: remove free_list list_head from fsnotify_mark

free_list list head is used only when all marks for an inode / mount need
to be destroyed.  However we can just use obj_list for this temporary
tracking thus saving two pointers for each fsnotify_mark.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.h             |    2 +-
 fs/notify/inode_mark.c           |    6 +++---
 fs/notify/mark.c                 |    7 ++++---
 fs/notify/vfsmount_mark.c        |    6 +++---
 include/linux/fsnotify_backend.h |    1 -
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/notify/fsnotify.h~fsnotify-remove-free_list-list_head-from-fsnotify_mark fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-remove-free_list-list_head-from-fsnotify_mark
+++ a/fs/notify/fsnotify.h
@@ -36,7 +36,7 @@ extern void fsnotify_destroy_vfsmount_ma
 /* inode specific destruction of a mark */
 extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
 /* Destroy all marks in the given list */
-extern void fsnotify_destroy_marks(struct list_head *to_free);
+extern void fsnotify_destroy_marks(struct hlist_head *to_free);
 /* Find mark belonging to given group in the list of marks */
 extern struct fsnotify_mark *fsnotify_find_mark(struct hlist_head *head,
 						struct fsnotify_group *group);
diff -puN fs/notify/inode_mark.c~fsnotify-remove-free_list-list_head-from-fsnotify_mark fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-remove-free_list-list_head-from-fsnotify_mark
+++ a/fs/notify/inode_mark.c
@@ -87,14 +87,14 @@ void fsnotify_clear_marks_by_inode(struc
 {
 	struct fsnotify_mark *mark;
 	struct hlist_node *n;
-	LIST_HEAD(free_list);
+	HLIST_HEAD(free_list);
 
+	/* Detach list from inode and grab us reference to each mark */
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry_safe(mark, n, &inode->i_fsnotify_marks, obj_list) {
-		list_add(&mark->free_list, &free_list);
-		hlist_del_init_rcu(&mark->obj_list);
 		fsnotify_get_mark(mark);
 	}
+	hlist_move_list(&inode->i_fsnotify_marks, &free_list);
 	spin_unlock(&inode->i_lock);
 
 	fsnotify_destroy_marks(&free_list);
diff -puN fs/notify/mark.c~fsnotify-remove-free_list-list_head-from-fsnotify_mark fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-remove-free_list-list_head-from-fsnotify_mark
+++ a/fs/notify/mark.c
@@ -196,12 +196,13 @@ void fsnotify_destroy_mark(struct fsnoti
  * Destroy all marks in the given list. The marks must be already detached from
  * the original inode / vfsmount.
  */
-void fsnotify_destroy_marks(struct list_head *to_free)
+void fsnotify_destroy_marks(struct hlist_head *to_free)
 {
-	struct fsnotify_mark *mark, *lmark;
+	struct fsnotify_mark *mark;
+	struct hlist_node *next;
 	struct fsnotify_group *group;
 
-	list_for_each_entry_safe(mark, lmark, to_free, free_list) {
+	hlist_for_each_entry_safe(mark, next, to_free, obj_list) {
 		spin_lock(&mark->lock);
 		fsnotify_get_group(mark->group);
 		group = mark->group;
diff -puN fs/notify/vfsmount_mark.c~fsnotify-remove-free_list-list_head-from-fsnotify_mark fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~fsnotify-remove-free_list-list_head-from-fsnotify_mark
+++ a/fs/notify/vfsmount_mark.c
@@ -35,14 +35,14 @@ void fsnotify_clear_marks_by_mount(struc
 	struct fsnotify_mark *mark;
 	struct hlist_node *n;
 	struct mount *m = real_mount(mnt);
-	LIST_HEAD(free_list);
+	HLIST_HEAD(free_list);
 
+	/* Detach list from mount and grab us reference to each mark */
 	spin_lock(&mnt->mnt_root->d_lock);
 	hlist_for_each_entry_safe(mark, n, &m->mnt_fsnotify_marks, obj_list) {
-		list_add(&mark->free_list, &free_list);
-		hlist_del_init_rcu(&mark->obj_list);
 		fsnotify_get_mark(mark);
 	}
+	hlist_move_list(&m->mnt_fsnotify_marks, &free_list);
 	spin_unlock(&mnt->mnt_root->d_lock);
 
 	fsnotify_destroy_marks(&free_list);
diff -puN include/linux/fsnotify_backend.h~fsnotify-remove-free_list-list_head-from-fsnotify_mark include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-remove-free_list-list_head-from-fsnotify_mark
+++ a/include/linux/fsnotify_backend.h
@@ -215,7 +215,6 @@ struct fsnotify_mark {
 	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks */
 	spinlock_t lock;		/* protect group and inode */
 	struct hlist_node obj_list;	/* list of marks for inode / vfsmount */
-	struct list_head free_list;	/* tmp list used when freeing this mark */
 	union {
 		struct inode *inode;	/* inode this mark is associated with */
 		struct vfsmount *mnt;	/* vfsmount this mark is associated with */
_

Patches currently in -mm which might be from jack@suse.cz are

fanotify-fix-notification-of-groups-with-inode-mount-marks.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

