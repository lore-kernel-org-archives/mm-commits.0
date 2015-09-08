From: akpm@linux-foundation.org
Subject: [merged] fsnotify-remove-mark-free_list.patch removed from -mm
 tree
Date: Tue, 08 Sep 2015 11:01:38 -0700
Message-ID: <55ef2282.QPe5ATkObDdprKa+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: remove mark->free_list
has been removed from the -mm tree.  Its filename was
     fsnotify-remove-mark-free_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: fsnotify: remove mark->free_list

Free list is used when all marks on given inode / mount should be
destroyed when inode / mount is going away.  However we can free all of
the marks without using a special list with some care.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c             |    1 
 fs/notify/fsnotify.h             |   21 ++++++++++-----
 fs/notify/inode_mark.c           |   20 --------------
 fs/notify/mark.c                 |   40 ++++++++++++++++++-----------
 fs/notify/vfsmount_mark.c        |   19 -------------
 include/linux/fsnotify_backend.h |    2 -
 6 files changed, 40 insertions(+), 63 deletions(-)

diff -puN fs/notify/fsnotify.c~fsnotify-remove-mark-free_list fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-remove-mark-free_list
+++ a/fs/notify/fsnotify.c
@@ -26,7 +26,6 @@
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
-#include "../mount.h"
 
 /*
  * Clear all of the marks on an inode when it is being evicted from core
diff -puN fs/notify/fsnotify.h~fsnotify-remove-mark-free_list fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-remove-mark-free_list
+++ a/fs/notify/fsnotify.h
@@ -6,6 +6,8 @@
 #include <linux/srcu.h>
 #include <linux/types.h>
 
+#include "../mount.h"
+
 /* destroy all events sitting in this groups notification queue */
 extern void fsnotify_flush_notify(struct fsnotify_group *group);
 
@@ -38,15 +40,22 @@ extern int fsnotify_add_vfsmount_mark(st
 extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark);
 /* inode specific destruction of a mark */
 extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
-/* Destroy all marks in the given list */
-extern void fsnotify_destroy_marks(struct list_head *to_free);
 /* Find mark belonging to given group in the list of marks */
 extern struct fsnotify_mark *fsnotify_find_mark(struct hlist_head *head,
 						struct fsnotify_group *group);
-/* run the list of all marks associated with inode and flag them to be freed */
-extern void fsnotify_clear_marks_by_inode(struct inode *inode);
-/* run the list of all marks associated with vfsmount and flag them to be freed */
-extern void fsnotify_clear_marks_by_mount(struct vfsmount *mnt);
+/* Destroy all marks in the given list protected by 'lock' */
+extern void fsnotify_destroy_marks(struct hlist_head *head, spinlock_t *lock);
+/* run the list of all marks associated with inode and destroy them */
+static inline void fsnotify_clear_marks_by_inode(struct inode *inode)
+{
+	fsnotify_destroy_marks(&inode->i_fsnotify_marks, &inode->i_lock);
+}
+/* run the list of all marks associated with vfsmount and destroy them */
+static inline void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
+{
+	fsnotify_destroy_marks(&real_mount(mnt)->mnt_fsnotify_marks,
+			       &mnt->mnt_root->d_lock);
+}
 /*
  * update the dentry->d_flags of all of inode's children to indicate if inode cares
  * about events that happen to its children.
diff -puN fs/notify/inode_mark.c~fsnotify-remove-mark-free_list fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-remove-mark-free_list
+++ a/fs/notify/inode_mark.c
@@ -65,26 +65,6 @@ void fsnotify_destroy_inode_mark(struct
 }
 
 /*
- * Given an inode, destroy all of the marks associated with that inode.
- */
-void fsnotify_clear_marks_by_inode(struct inode *inode)
-{
-	struct fsnotify_mark *mark;
-	struct hlist_node *n;
-	LIST_HEAD(free_list);
-
-	spin_lock(&inode->i_lock);
-	hlist_for_each_entry_safe(mark, n, &inode->i_fsnotify_marks, obj_list) {
-		list_add(&mark->free_list, &free_list);
-		hlist_del_init_rcu(&mark->obj_list);
-		fsnotify_get_mark(mark);
-	}
-	spin_unlock(&inode->i_lock);
-
-	fsnotify_destroy_marks(&free_list);
-}
-
-/*
  * Given a group clear all of the inode marks associated with that group.
  */
 void fsnotify_clear_inode_marks_by_group(struct fsnotify_group *group)
diff -puN fs/notify/mark.c~fsnotify-remove-mark-free_list fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-remove-mark-free_list
+++ a/fs/notify/mark.c
@@ -203,24 +203,34 @@ void fsnotify_destroy_mark(struct fsnoti
 	mutex_unlock(&group->mark_mutex);
 }
 
-/*
- * Destroy all marks in the given list. The marks must be already detached from
- * the original inode / vfsmount.
- */
-void fsnotify_destroy_marks(struct list_head *to_free)
+void fsnotify_destroy_marks(struct hlist_head *head, spinlock_t *lock)
 {
-	struct fsnotify_mark *mark, *lmark;
-	struct fsnotify_group *group;
+	struct fsnotify_mark *mark;
 
-	list_for_each_entry_safe(mark, lmark, to_free, free_list) {
-		spin_lock(&mark->lock);
-		fsnotify_get_group(mark->group);
-		group = mark->group;
-		spin_unlock(&mark->lock);
-
-		fsnotify_destroy_mark(mark, group);
+	while (1) {
+		/*
+		 * We have to be careful since we can race with e.g.
+		 * fsnotify_clear_marks_by_group() and once we drop 'lock',
+		 * mark can get removed from the obj_list and destroyed. But
+		 * we are holding mark reference so mark cannot be freed and
+		 * calling fsnotify_destroy_mark() more than once is fine.
+		 */
+		spin_lock(lock);
+		if (hlist_empty(head)) {
+			spin_unlock(lock);
+			break;
+		}
+		mark = hlist_entry(head->first, struct fsnotify_mark, obj_list);
+		/*
+		 * We don't update i_fsnotify_mask / mnt_fsnotify_mask here
+		 * since inode / mount is going away anyway. So just remove
+		 * mark from the list.
+		 */
+		hlist_del_init_rcu(&mark->obj_list);
+		fsnotify_get_mark(mark);
+		spin_unlock(lock);
+		fsnotify_destroy_mark(mark, mark->group);
 		fsnotify_put_mark(mark);
-		fsnotify_put_group(group);
 	}
 }
 
diff -puN fs/notify/vfsmount_mark.c~fsnotify-remove-mark-free_list fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~fsnotify-remove-mark-free_list
+++ a/fs/notify/vfsmount_mark.c
@@ -28,25 +28,6 @@
 
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
-#include "../mount.h"
-
-void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
-{
-	struct fsnotify_mark *mark;
-	struct hlist_node *n;
-	struct mount *m = real_mount(mnt);
-	LIST_HEAD(free_list);
-
-	spin_lock(&mnt->mnt_root->d_lock);
-	hlist_for_each_entry_safe(mark, n, &m->mnt_fsnotify_marks, obj_list) {
-		list_add(&mark->free_list, &free_list);
-		hlist_del_init_rcu(&mark->obj_list);
-		fsnotify_get_mark(mark);
-	}
-	spin_unlock(&mnt->mnt_root->d_lock);
