From: akpm@linux-foundation.org
Subject: + fsnotify-get-rid-of-fsnotify_destroy_mark_locked.patch added to -mm tree
Date: Tue, 28 Jul 2015 14:01:53 -0700
Message-ID: <55b7edc1.cBZk/+7cPVYWL1VW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbG1VBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jul 2015 17:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: get rid of fsnotify_destroy_mark_locked()
has been added to the -mm tree.  Its filename is
     fsnotify-get-rid-of-fsnotify_destroy_mark_locked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-get-rid-of-fsnotify_destroy_mark_locked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-get-rid-of-fsnotify_destroy_mark_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: fsnotify: get rid of fsnotify_destroy_mark_locked()

fsnotify_destroy_mark_locked() is subtle to use because it temporarily
releases group->mark_mutex.  To avoid future problems with this function,
split it into two.

fsnotify_detach_mark() is the part that needs group->mark_mutex and
fsnotify_free_mark() is the part that must be called outside of
group->mark_mutex.  This way it's much clearer what's going on and we also
avoid some pointless acquisitions of group->mark_mutex.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c        |   14 +++--
 fs/notify/fanotify/fanotify_user.c |    8 ++
 fs/notify/mark.c                   |   73 ++++++++++++++-------------
 include/linux/fsnotify_backend.h   |    7 +-
 4 files changed, 61 insertions(+), 41 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~fsnotify-get-rid-of-fsnotify_destroy_mark_locked fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~fsnotify-get-rid-of-fsnotify_destroy_mark_locked
+++ a/fs/notify/dnotify/dnotify.c
@@ -154,6 +154,7 @@ void dnotify_flush(struct file *filp, fl
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct inode *inode;
+	bool free = false;
 
 	inode = file_inode(filp);
 	if (!S_ISDIR(inode->i_mode))
@@ -182,11 +183,15 @@ void dnotify_flush(struct file *filp, fl
 
 	/* nothing else could have found us thanks to the dnotify_groups
 	   mark_mutex */
-	if (dn_mark->dn == NULL)
-		fsnotify_destroy_mark_locked(fsn_mark, dnotify_group);
+	if (dn_mark->dn == NULL) {
+		fsnotify_detach_mark(fsn_mark);
+		free = true;
+	}
 
 	mutex_unlock(&dnotify_group->mark_mutex);
 
+	if (free)
+		fsnotify_free_mark(fsn_mark);
 	fsnotify_put_mark(fsn_mark);
 }
 
@@ -362,9 +367,10 @@ out:
 	spin_unlock(&fsn_mark->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark_locked(fsn_mark, dnotify_group);
-
+		fsnotify_detach_mark(fsn_mark);
 	mutex_unlock(&dnotify_group->mark_mutex);
+	if (destroy)
+		fsnotify_free_mark(fsn_mark);
 	fsnotify_put_mark(fsn_mark);
 out_err:
 	if (new_fsn_mark)
diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-get-rid-of-fsnotify_destroy_mark_locked fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-get-rid-of-fsnotify_destroy_mark_locked
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -529,8 +529,10 @@ static int fanotify_remove_vfsmount_mark
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark_locked(fsn_mark, group);
+		fsnotify_detach_mark(fsn_mark);
 	mutex_unlock(&group->mark_mutex);
+	if (destroy_mark)
+		fsnotify_free_mark(fsn_mark);
 
 	fsnotify_put_mark(fsn_mark);
 	if (removed & real_mount(mnt)->mnt_fsnotify_mask)
@@ -557,8 +559,10 @@ static int fanotify_remove_inode_mark(st
 	removed = fanotify_mark_remove_from_mask(fsn_mark, mask, flags,
 						 &destroy_mark);
 	if (destroy_mark)
-		fsnotify_destroy_mark_locked(fsn_mark, group);
+		fsnotify_detach_mark(fsn_mark);
 	mutex_unlock(&group->mark_mutex);
+	if (destroy_mark)
+		fsnotify_free_mark(fsn_mark);
 
 	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
diff -puN fs/notify/mark.c~fsnotify-get-rid-of-fsnotify_destroy_mark_locked fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-get-rid-of-fsnotify_destroy_mark_locked
+++ a/fs/notify/mark.c
@@ -122,26 +122,27 @@ u32 fsnotify_recalc_mask(struct hlist_he
 }
 
 /*
- * Any time a mark is getting freed we end up here.
- * The caller had better be holding a reference to this mark so we don't actually
- * do the final put under the mark->lock
+ * Remove mark from inode / vfsmount list, group list, drop inode reference
+ * if we got one.
+ *
+ * Must be called with group->mark_mutex held.
  */
-void fsnotify_destroy_mark_locked(struct fsnotify_mark *mark,
-				  struct fsnotify_group *group)
+void fsnotify_detach_mark(struct fsnotify_mark *mark)
 {
 	struct inode *inode = NULL;
+	struct fsnotify_group *group = mark->group;
 
 	BUG_ON(!mutex_is_locked(&group->mark_mutex));
 
 	spin_lock(&mark->lock);
 
 	/* something else already called this function on this mark */
-	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ATTACHED)) {
 		spin_unlock(&mark->lock);
 		return;
 	}
 
-	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_ATTACHED;
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		inode = mark->inode;
@@ -150,6 +151,12 @@ void fsnotify_destroy_mark_locked(struct
 		fsnotify_destroy_vfsmount_mark(mark);
 	else
 		BUG();
+	/*
+	 * Note that we didn't update flags telling whether inode cares about
+	 * what's happening with children. We update these flags from
+	 * __fsnotify_parent() lazily when next event happens on one of our
+	 * children.
+	 */
 
 	list_del_init(&mark->g_list);
 
@@ -157,18 +164,32 @@ void fsnotify_destroy_mark_locked(struct
 
 	if (inode && (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED))
 		iput(inode);
-	/* release lock temporarily */
-	mutex_unlock(&group->mark_mutex);
+
+	atomic_dec(&group->num_marks);
+}
+
+/*
+ * Free fsnotify mark. The freeing is actually happening from a kthread which
+ * first waits for srcu period end. Caller must have a reference to the mark
+ * or be protected by fsnotify_mark_srcu.
+ */
+void fsnotify_free_mark(struct fsnotify_mark *mark)
+{
+	struct fsnotify_group *group = mark->group;
+
+	spin_lock(&mark->lock);
+	/* something else already called this function on this mark */
+	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
+		spin_unlock(&mark->lock);
+		return;
+	}
+	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+	spin_unlock(&mark->lock);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
 	wake_up(&destroy_waitq);
-	/*
-	 * We don't necessarily have a ref on mark from caller so the above destroy
-	 * may have actually freed it, unless this group provides a 'freeing_mark'
-	 * function which must be holding a reference.
-	 */
 
 	/*
 	 * Some groups like to know that marks are being freed.  This is a
@@ -177,30 +198,15 @@ void fsnotify_destroy_mark_locked(struct
 	 */
 	if (group->ops->freeing_mark)
 		group->ops->freeing_mark(mark, group);
-
-	/*
-	 * __fsnotify_update_child_dentry_flags(inode);
-	 *
-	 * I really want to call that, but we can't, we have no idea if the inode
-	 * still exists the second we drop the mark->lock.
-	 *
-	 * The next time an event arrive to this inode from one of it's children
-	 * __fsnotify_parent will see that the inode doesn't care about it's
-	 * children and will update all of these flags then.  So really this
-	 * is just a lazy update (and could be a perf win...)
-	 */
-
-	atomic_dec(&group->num_marks);
-
-	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
 }
 
 void fsnotify_destroy_mark(struct fsnotify_mark *mark,
 			   struct fsnotify_group *group)
 {
 	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
-	fsnotify_destroy_mark_locked(mark, group);
+	fsnotify_detach_mark(mark);
 	mutex_unlock(&group->mark_mutex);
+	fsnotify_free_mark(mark);
 }
 
 void fsnotify_destroy_marks(struct hlist_head *head, spinlock_t *lock)
@@ -342,7 +348,7 @@ int fsnotify_add_mark_locked(struct fsno
 	 * inode->i_lock
 	 */
 	spin_lock(&mark->lock);
-	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
+	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE | FSNOTIFY_MARK_FLAG_ATTACHED;
 
 	fsnotify_get_group(group);
 	mark->group = group;
@@ -448,8 +454,9 @@ void fsnotify_clear_marks_by_group_flags
 		}
 		mark = list_first_entry(&to_free, struct fsnotify_mark, g_list);
 		fsnotify_get_mark(mark);
-		fsnotify_destroy_mark_locked(mark, group);
+		fsnotify_detach_mark(mark);
 		mutex_unlock(&group->mark_mutex);
+		fsnotify_free_mark(mark);
 		fsnotify_put_mark(mark);
 	}
 }
diff -puN include/linux/fsnotify_backend.h~fsnotify-get-rid-of-fsnotify_destroy_mark_locked include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-get-rid-of-fsnotify_destroy_mark_locked
+++ a/include/linux/fsnotify_backend.h
@@ -236,6 +236,7 @@ struct fsnotify_mark {
 #define FSNOTIFY_MARK_FLAG_OBJECT_PINNED	0x04
 #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x08
 #define FSNOTIFY_MARK_FLAG_ALIVE		0x10
+#define FSNOTIFY_MARK_FLAG_ATTACHED		0x20
 	unsigned int flags;		/* flags [mark->lock] */
 	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
 };
@@ -353,8 +354,10 @@ extern int fsnotify_add_mark_locked(stru
 /* given a group and a mark, flag mark to be freed when all references are dropped */
 extern void fsnotify_destroy_mark(struct fsnotify_mark *mark,
 				  struct fsnotify_group *group);
-extern void fsnotify_destroy_mark_locked(struct fsnotify_mark *mark,
-					 struct fsnotify_group *group);
+/* detach mark from inode / mount list, group list, drop inode reference */
+extern void fsnotify_detach_mark(struct fsnotify_mark *mark);
+/* free mark */
+extern void fsnotify_free_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and clear all of the vfsmount marks */
 extern void fsnotify_clear_vfsmount_marks_by_group(struct fsnotify_group *group);
 /* run all the marks in a group, and clear all of the inode marks */
_

Patches currently in -mm which might be from jack@suse.com are

fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
fsnotify-document-mark-locking.patch
fsnotify-remove-mark-free_list.patch
fsnotify-get-rid-of-fsnotify_destroy_mark_locked.patch
linux-next.patch

