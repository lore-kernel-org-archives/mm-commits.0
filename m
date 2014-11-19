From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fsnotify-unify-inode-and-mount-marks-handling.patch removed from -mm tree
Date: Tue, 18 Nov 2014 16:27:31 -0800
Message-ID: <546be3f3.+NT637ZXtbrA7kxE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaKSA1c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 19:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: unify inode and mount marks handling
has been removed from the -mm tree.  Its filename was
     fsnotify-unify-inode-and-mount-marks-handling.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: unify inode and mount marks handling

There's lot of common code in inode and mount marks handling.  Factor it
out to a common helper function.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c          |    4 
 fs/notify/fdinfo.c                   |    6 -
 fs/notify/fsnotify.c                 |    4 
 fs/notify/fsnotify.h                 |   12 ++
 fs/notify/inode_mark.c               |  108 +++----------------------
 fs/notify/inotify/inotify_fsnotify.c |    2 
 fs/notify/inotify/inotify_user.c     |   10 +-
 fs/notify/mark.c                     |   88 +++++++++++++++++++-
 fs/notify/vfsmount_mark.c            |  103 +++--------------------
 include/linux/fsnotify_backend.h     |   24 -----
 kernel/audit_tree.c                  |   16 +--
 11 files changed, 154 insertions(+), 223 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/dnotify/dnotify.c
@@ -69,8 +69,8 @@ static void dnotify_recalc_inode_mask(st
 	if (old_mask == new_mask)
 		return;
 
-	if (fsn_mark->i.inode)
-		fsnotify_recalc_inode_mask(fsn_mark->i.inode);
+	if (fsn_mark->inode)
+		fsnotify_recalc_inode_mask(fsn_mark->inode);
 }
 
 /*
diff -puN fs/notify/fdinfo.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/fdinfo.c
@@ -80,7 +80,7 @@ static void inotify_fdinfo(struct seq_fi
 		return;
 
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
-	inode = igrab(mark->i.inode);
+	inode = igrab(mark->inode);
 	if (inode) {
 		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:%x ",
 			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
@@ -112,7 +112,7 @@ static void fanotify_fdinfo(struct seq_f
 		mflags |= FAN_MARK_IGNORED_SURV_MODIFY;
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
-		inode = igrab(mark->i.inode);
+		inode = igrab(mark->inode);
 		if (!inode)
 			return;
 		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
@@ -122,7 +122,7 @@ static void fanotify_fdinfo(struct seq_f
 		seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
-		struct mount *mnt = real_mount(mark->m.mnt);
+		struct mount *mnt = real_mount(mark->mnt);
 
 		seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x ignored_mask:%x\n",
 			   mnt->mnt_id, mflags, mark->mask, mark->ignored_mask);
diff -puN fs/notify/fsnotify.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/fsnotify.c
@@ -242,13 +242,13 @@ int fsnotify(struct inode *to_tell, __u3
 
 		if (inode_node) {
 			inode_mark = hlist_entry(srcu_dereference(inode_node, &fsnotify_mark_srcu),
-						 struct fsnotify_mark, i.i_list);
+						 struct fsnotify_mark, obj_list);
 			inode_group = inode_mark->group;
 		}
 
 		if (vfsmount_node) {
 			vfsmount_mark = hlist_entry(srcu_dereference(vfsmount_node, &fsnotify_mark_srcu),
-							struct fsnotify_mark, m.m_list);
+						    struct fsnotify_mark, obj_list);
 			vfsmount_group = vfsmount_mark->group;
 		}
 
diff -puN fs/notify/fsnotify.h~fsnotify-unify-inode-and-mount-marks-handling fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/fsnotify.h
@@ -12,12 +12,19 @@ extern void fsnotify_flush_notify(struct
 /* protects reads of inode and vfsmount marks list */
 extern struct srcu_struct fsnotify_mark_srcu;
 
+/* Calculate mask of events for a list of marks */
+extern u32 fsnotify_recalc_mask(struct hlist_head *head);
+
 /* compare two groups for sorting of marks lists */
 extern int fsnotify_compare_groups(struct fsnotify_group *a,
 				   struct fsnotify_group *b);
 
 extern void fsnotify_set_inode_mark_mask_locked(struct fsnotify_mark *fsn_mark,
 						__u32 mask);
+/* Add mark to a proper place in mark list */
+extern int fsnotify_add_mark_list(struct hlist_head *head,
+				  struct fsnotify_mark *mark,
+				  int allow_dups);
 /* add a mark to an inode */
 extern int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 				   struct fsnotify_group *group, struct inode *inode,
@@ -31,6 +38,11 @@ extern int fsnotify_add_vfsmount_mark(st
 extern void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark);
 /* inode specific destruction of a mark */
 extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
+/* Destroy all marks in the given list */
+extern void fsnotify_destroy_marks(struct list_head *to_free);
+/* Find mark belonging to given group in the list of marks */
+extern struct fsnotify_mark *fsnotify_find_mark(struct hlist_head *head,
+						struct fsnotify_group *group);
 /* run the list of all marks associated with inode and flag them to be freed */
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 /* run the list of all marks associated with vfsmount and flag them to be freed */
diff -puN fs/notify/inode_mark.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/inode_mark.c
@@ -31,28 +31,13 @@
 #include "../internal.h"
 
 /*
- * Recalculate the mask of events relevant to a given inode locked.
- */
-static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
-{
-	struct fsnotify_mark *mark;
-	__u32 new_mask = 0;
-
-	assert_spin_locked(&inode->i_lock);
-
-	hlist_for_each_entry(mark, &inode->i_fsnotify_marks, i.i_list)
-		new_mask |= mark->mask;
-	inode->i_fsnotify_mask = new_mask;
-}
-
-/*
  * Recalculate the inode->i_fsnotify_mask, or the mask of all FS_* event types
  * any notifier is interested in hearing for this inode.
  */
 void fsnotify_recalc_inode_mask(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-	fsnotify_recalc_inode_mask_locked(inode);
+	inode->i_fsnotify_mask = fsnotify_recalc_mask(&inode->i_fsnotify_marks);
 	spin_unlock(&inode->i_lock);
 
 	__fsnotify_update_child_dentry_flags(inode);
@@ -60,15 +45,15 @@ void fsnotify_recalc_inode_mask(struct i
 
 void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
 {
-	struct inode *inode = mark->i.inode;
+	struct inode *inode = mark->inode;
 
 	BUG_ON(!mutex_is_locked(&mark->group->mark_mutex));
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&inode->i_lock);
 
-	hlist_del_init_rcu(&mark->i.i_list);
-	mark->i.inode = NULL;
+	hlist_del_init_rcu(&mark->obj_list);
+	mark->inode = NULL;
 
 	/*
 	 * this mark is now off the inode->i_fsnotify_marks list and we
@@ -85,30 +70,19 @@ void fsnotify_destroy_inode_mark(struct
  */
 void fsnotify_clear_marks_by_inode(struct inode *inode)
 {
-	struct fsnotify_mark *mark, *lmark;
+	struct fsnotify_mark *mark;
 	struct hlist_node *n;
 	LIST_HEAD(free_list);
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry_safe(mark, n, &inode->i_fsnotify_marks, i.i_list) {
-		list_add(&mark->i.free_i_list, &free_list);
-		hlist_del_init_rcu(&mark->i.i_list);
+	hlist_for_each_entry_safe(mark, n, &inode->i_fsnotify_marks, obj_list) {
+		list_add(&mark->free_list, &free_list);
+		hlist_del_init_rcu(&mark->obj_list);
 		fsnotify_get_mark(mark);
 	}
 	spin_unlock(&inode->i_lock);
 
-	list_for_each_entry_safe(mark, lmark, &free_list, i.free_i_list) {
-		struct fsnotify_group *group;
-
-		spin_lock(&mark->lock);
-		fsnotify_get_group(mark->group);
-		group = mark->group;
-		spin_unlock(&mark->lock);
-
-		fsnotify_destroy_mark(mark, group);
-		fsnotify_put_mark(mark);
-		fsnotify_put_group(group);
-	}
+	fsnotify_destroy_marks(&free_list);
 }
 
 /*
@@ -123,34 +97,13 @@ void fsnotify_clear_inode_marks_by_group
  * given a group and inode, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
  */
-static struct fsnotify_mark *fsnotify_find_inode_mark_locked(
-		struct fsnotify_group *group,
-		struct inode *inode)
-{
-	struct fsnotify_mark *mark;
-
-	assert_spin_locked(&inode->i_lock);
-
-	hlist_for_each_entry(mark, &inode->i_fsnotify_marks, i.i_list) {
-		if (mark->group == group) {
-			fsnotify_get_mark(mark);
-			return mark;
-		}
-	}
-	return NULL;
-}
-
-/*
- * given a group and inode, find the mark associated with that combination.
- * if found take a reference to that mark and return it, else return NULL
- */
 struct fsnotify_mark *fsnotify_find_inode_mark(struct fsnotify_group *group,
 					       struct inode *inode)
 {
 	struct fsnotify_mark *mark;
 
 	spin_lock(&inode->i_lock);
-	mark = fsnotify_find_inode_mark_locked(group, inode);
+	mark = fsnotify_find_mark(&inode->i_fsnotify_marks, group);
 	spin_unlock(&inode->i_lock);
 
 	return mark;
@@ -168,10 +121,10 @@ void fsnotify_set_inode_mark_mask_locked
 	assert_spin_locked(&mark->lock);
 
 	if (mask &&
-	    mark->i.inode &&
+	    mark->inode &&
 	    !(mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED)) {
 		mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
-		inode = igrab(mark->i.inode);
+		inode = igrab(mark->inode);
 		/*
 		 * we shouldn't be able to get here if the inode wasn't
 		 * already safely held in memory.  But bug in case it
@@ -192,9 +145,7 @@ int fsnotify_add_inode_mark(struct fsnot
 			    struct fsnotify_group *group, struct inode *inode,
 			    int allow_dups)
 {
-	struct fsnotify_mark *lmark, *last = NULL;
-	int ret = 0;
-	int cmp;
+	int ret;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_INODE;
 
@@ -202,36 +153,9 @@ int fsnotify_add_inode_mark(struct fsnot
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&inode->i_lock);
-
-	mark->i.inode = inode;
-
-	/* is mark the first mark? */
-	if (hlist_empty(&inode->i_fsnotify_marks)) {
-		hlist_add_head_rcu(&mark->i.i_list, &inode->i_fsnotify_marks);
-		goto out;
-	}
-
-	/* should mark be in the middle of the current list? */
-	hlist_for_each_entry(lmark, &inode->i_fsnotify_marks, i.i_list) {
-		last = lmark;
-
-		if ((lmark->group == group) && !allow_dups) {
-			ret = -EEXIST;
-			goto out;
-		}
-
-		cmp = fsnotify_compare_groups(lmark->group, mark->group);
-		if (cmp < 0)
-			continue;
-
-		hlist_add_before_rcu(&mark->i.i_list, &lmark->i.i_list);
-		goto out;
-	}
-
-	BUG_ON(last == NULL);
-	/* mark should be the last entry.  last is the current last entry */
-	hlist_add_behind_rcu(&mark->i.i_list, &last->i.i_list);
-out:
+	mark->inode = inode;
+	ret = fsnotify_add_mark_list(&inode->i_fsnotify_marks, mark,
+				     allow_dups);
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
 
diff -puN fs/notify/inotify/inotify_fsnotify.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -156,7 +156,7 @@ static int idr_callback(int id, void *p,
 	 */
 	if (fsn_mark)
 		printk(KERN_WARNING "fsn_mark->group=%p inode=%p wd=%d\n",
-			fsn_mark->group, fsn_mark->i.inode, i_mark->wd);
+			fsn_mark->group, fsn_mark->inode, i_mark->wd);
 	return 0;
 }
 
diff -puN fs/notify/inotify/inotify_user.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/inotify/inotify_user.c
@@ -433,7 +433,7 @@ static void inotify_remove_from_idr(stru
 	if (wd == -1) {
 		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
 			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
-			i_mark->fsn_mark.group, i_mark->fsn_mark.i.inode);
+			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
 		goto out;
 	}
 
@@ -442,7 +442,7 @@ static void inotify_remove_from_idr(stru
 	if (unlikely(!found_i_mark)) {
 		WARN_ONCE(1, "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
 			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
-			i_mark->fsn_mark.group, i_mark->fsn_mark.i.inode);
+			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
 		goto out;
 	}
 
@@ -456,9 +456,9 @@ static void inotify_remove_from_idr(stru
 			"mark->inode=%p found_i_mark=%p found_i_mark->wd=%d "
 			"found_i_mark->group=%p found_i_mark->inode=%p\n",
 			__func__, i_mark, i_mark->wd, i_mark->fsn_mark.group,
-			i_mark->fsn_mark.i.inode, found_i_mark, found_i_mark->wd,
+			i_mark->fsn_mark.inode, found_i_mark, found_i_mark->wd,
 			found_i_mark->fsn_mark.group,
-			found_i_mark->fsn_mark.i.inode);
+			found_i_mark->fsn_mark.inode);
 		goto out;
 	}
 
@@ -470,7 +470,7 @@ static void inotify_remove_from_idr(stru
 	if (unlikely(atomic_read(&i_mark->fsn_mark.refcnt) < 3)) {
 		printk(KERN_ERR "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
 			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
-			i_mark->fsn_mark.group, i_mark->fsn_mark.i.inode);
+			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
 		/* we can't really recover with bad ref cnting.. */
 		BUG();
 	}
diff -puN fs/notify/mark.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/mark.c
@@ -110,6 +110,16 @@ void fsnotify_put_mark(struct fsnotify_m
 	}
 }
 
+/* Calculate mask of events for a list of marks */
+u32 fsnotify_recalc_mask(struct hlist_head *head)
+{
+	u32 new_mask = 0;
+
+	hlist_for_each_entry(mark, head, obj_list)
+		new_mask |= mark->mask;
+	return new_mask;
+}
+
 /*
  * Any time a mark is getting freed we end up here.
  * The caller had better be holding a reference to this mark so we don't actually
@@ -133,7 +143,7 @@ void fsnotify_destroy_mark_locked(struct
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
 
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
-		inode = mark->i.inode;
+		inode = mark->inode;
 		fsnotify_destroy_inode_mark(mark);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT)
 		fsnotify_destroy_vfsmount_mark(mark);
@@ -192,6 +202,27 @@ void fsnotify_destroy_mark(struct fsnoti
 	mutex_unlock(&group->mark_mutex);
 }
 
+/*
+ * Destroy all marks in the given list. The marks must be already detached from
+ * the original inode / vfsmount.
+ */
+void fsnotify_destroy_marks(struct list_head *to_free)
+{
+	struct fsnotify_mark *mark, *lmark;
+	struct fsnotify_group *group;
+
+	list_for_each_entry_safe(mark, lmark, to_free, free_list) {
+		spin_lock(&mark->lock);
+		fsnotify_get_group(mark->group);
+		group = mark->group;
+		spin_unlock(&mark->lock);
+
+		fsnotify_destroy_mark(mark, group);
+		fsnotify_put_mark(mark);
+		fsnotify_put_group(group);
+	}
+}
+
 void fsnotify_set_mark_mask_locked(struct fsnotify_mark *mark, __u32 mask)
 {
 	assert_spin_locked(&mark->lock);
@@ -245,6 +276,39 @@ int fsnotify_compare_groups(struct fsnot
 	return -1;
 }
 
+/* Add mark into proper place in given list of marks */
+int fsnotify_add_mark_list(struct hlist_head *head, struct fsnotify_mark *mark,
+			   int allow_dups)
+{
+	struct fsnotify_mark *lmark, *last = NULL;
+	int cmp;
+
+	/* is mark the first mark? */
+	if (hlist_empty(head)) {
+		hlist_add_head_rcu(&mark->obj_list, head);
+		return 0;
+	}
+
+	/* should mark be in the middle of the current list? */
+	hlist_for_each_entry(lmark, head, obj_list) {
+		last = lmark;
+
+		if ((lmark->group == mark->group) && !allow_dups)
+			return -EEXIST;
+
+		cmp = fsnotify_compare_groups(lmark->group, mark->group);
+		if (cmp >= 0) {
+			hlist_add_before_rcu(&mark->obj_list, &lmark->obj_list);
+			return 0;
+		}
+	}
+
+	BUG_ON(last == NULL);
+	/* mark should be the last entry.  last is the current last entry */
+	hlist_add_behind_rcu(&mark->obj_list, &last->obj_list);
+	return 0;
+}
+
 /*
  * Attach an initialized mark to a given group and fs object.
  * These marks may be used for the fsnotify backend to determine which
@@ -323,6 +387,24 @@ int fsnotify_add_mark(struct fsnotify_ma
 }
 
 /*
+ * Given a list of marks, find the mark associated with given group. If found
+ * take a reference to that mark and return it, else return NULL.
+ */
+struct fsnotify_mark *fsnotify_find_mark(struct hlist_head *head,
+					 struct fsnotify_group *group)
+{
+	struct fsnotify_mark *mark;
+
+	hlist_for_each_entry(mark, head, obj_list) {
+		if (mark->group == group) {
+			fsnotify_get_mark(mark);
+			return mark;
+		}
+	}
+	return NULL;
+}
+
+/*
  * clear any marks in a group in which mark->flags & flags is true
  */
 void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
@@ -352,8 +434,8 @@ void fsnotify_clear_marks_by_group(struc
 void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old)
 {
 	assert_spin_locked(&old->lock);
-	new->i.inode = old->i.inode;
-	new->m.mnt = old->m.mnt;
+	new->inode = old->inode;
+	new->mnt = old->mnt;
 	if (old->group)
 		fsnotify_get_group(old->group);
 	new->group = old->group;
diff -puN fs/notify/vfsmount_mark.c~fsnotify-unify-inode-and-mount-marks-handling fs/notify/vfsmount_mark.c
--- a/fs/notify/vfsmount_mark.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/fs/notify/vfsmount_mark.c
@@ -32,31 +32,20 @@
 
 void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
 {
-	struct fsnotify_mark *mark, *lmark;
+	struct fsnotify_mark *mark;
 	struct hlist_node *n;
 	struct mount *m = real_mount(mnt);
 	LIST_HEAD(free_list);
 
 	spin_lock(&mnt->mnt_root->d_lock);
-	hlist_for_each_entry_safe(mark, n, &m->mnt_fsnotify_marks, m.m_list) {
-		list_add(&mark->m.free_m_list, &free_list);
-		hlist_del_init_rcu(&mark->m.m_list);
+	hlist_for_each_entry_safe(mark, n, &m->mnt_fsnotify_marks, obj_list) {
+		list_add(&mark->free_list, &free_list);
+		hlist_del_init_rcu(&mark->obj_list);
 		fsnotify_get_mark(mark);
 	}
 	spin_unlock(&mnt->mnt_root->d_lock);
 
-	list_for_each_entry_safe(mark, lmark, &free_list, m.free_m_list) {
-		struct fsnotify_group *group;
-
-		spin_lock(&mark->lock);
-		fsnotify_get_group(mark->group);
-		group = mark->group;
-		spin_unlock(&mark->lock);
-
-		fsnotify_destroy_mark(mark, group);
-		fsnotify_put_mark(mark);
-		fsnotify_put_group(group);
-	}
+	fsnotify_destroy_marks(&free_list);
 }
 
 void fsnotify_clear_vfsmount_marks_by_group(struct fsnotify_group *group)
@@ -65,66 +54,35 @@ void fsnotify_clear_vfsmount_marks_by_gr
 }
 
 /*
- * Recalculate the mask of events relevant to a given vfsmount locked.
- */
-static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
-{
-	struct mount *m = real_mount(mnt);
-	struct fsnotify_mark *mark;
-	__u32 new_mask = 0;
-
-	assert_spin_locked(&mnt->mnt_root->d_lock);
-
-	hlist_for_each_entry(mark, &m->mnt_fsnotify_marks, m.m_list)
-		new_mask |= mark->mask;
-	m->mnt_fsnotify_mask = new_mask;
-}
-
-/*
  * Recalculate the mnt->mnt_fsnotify_mask, or the mask of all FS_* event types
  * any notifier is interested in hearing for this mount point
  */
 void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 {
+	struct mount *m = real_mount(mnt);
+
 	spin_lock(&mnt->mnt_root->d_lock);
-	fsnotify_recalc_vfsmount_mask_locked(mnt);
+	m->mnt_fsnotify_mask = fsnotify_recalc_mask(&m->mnt_fsnotify_marks);
 	spin_unlock(&mnt->mnt_root->d_lock);
 }
 
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
 {
-	struct vfsmount *mnt = mark->m.mnt;
+	struct vfsmount *mnt = mark->mnt;
 
 	BUG_ON(!mutex_is_locked(&mark->group->mark_mutex));
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
 
-	hlist_del_init_rcu(&mark->m.m_list);
-	mark->m.mnt = NULL;
+	hlist_del_init_rcu(&mark->obj_list);
+	mark->mnt = NULL;
 
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 
 	spin_unlock(&mnt->mnt_root->d_lock);
 }
 
-static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_group *group,
-								struct vfsmount *mnt)
-{
-	struct mount *m = real_mount(mnt);
-	struct fsnotify_mark *mark;
-
-	assert_spin_locked(&mnt->mnt_root->d_lock);
-
-	hlist_for_each_entry(mark, &m->mnt_fsnotify_marks, m.m_list) {
-		if (mark->group == group) {
-			fsnotify_get_mark(mark);
-			return mark;
-		}
-	}
-	return NULL;
-}
-
 /*
  * given a group and vfsmount, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
@@ -132,10 +90,11 @@ static struct fsnotify_mark *fsnotify_fi
 struct fsnotify_mark *fsnotify_find_vfsmount_mark(struct fsnotify_group *group,
 						  struct vfsmount *mnt)
 {
+	struct mount *m = real_mount(mnt);
 	struct fsnotify_mark *mark;
 
 	spin_lock(&mnt->mnt_root->d_lock);
-	mark = fsnotify_find_vfsmount_mark_locked(group, mnt);
+	mark = fsnotify_find_mark(&m->mnt_fsnotify_marks, group);
 	spin_unlock(&mnt->mnt_root->d_lock);
 
 	return mark;
@@ -151,9 +110,7 @@ int fsnotify_add_vfsmount_mark(struct fs
 			       int allow_dups)
 {
 	struct mount *m = real_mount(mnt);
-	struct fsnotify_mark *lmark, *last = NULL;
-	int ret = 0;
-	int cmp;
+	int ret;
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_VFSMOUNT;
 
@@ -161,36 +118,8 @@ int fsnotify_add_vfsmount_mark(struct fs
 	assert_spin_locked(&mark->lock);
 
 	spin_lock(&mnt->mnt_root->d_lock);
-
-	mark->m.mnt = mnt;
-
-	/* is mark the first mark? */
-	if (hlist_empty(&m->mnt_fsnotify_marks)) {
-		hlist_add_head_rcu(&mark->m.m_list, &m->mnt_fsnotify_marks);
-		goto out;
-	}
-
-	/* should mark be in the middle of the current list? */
-	hlist_for_each_entry(lmark, &m->mnt_fsnotify_marks, m.m_list) {
-		last = lmark;
-
-		if ((lmark->group == group) && !allow_dups) {
-			ret = -EEXIST;
-			goto out;
-		}
-
-		cmp = fsnotify_compare_groups(lmark->group, mark->group);
-		if (cmp < 0)
-			continue;
-
-		hlist_add_before_rcu(&mark->m.m_list, &lmark->m.m_list);
-		goto out;
-	}
-
-	BUG_ON(last == NULL);
-	/* mark should be the last entry.  last is the current last entry */
-	hlist_add_behind_rcu(&mark->m.m_list, &last->m.m_list);
-out:
+	mark->mnt = mnt;
+	ret = fsnotify_add_mark_list(&m->mnt_fsnotify_marks, mark, allow_dups);
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 	spin_unlock(&mnt->mnt_root->d_lock);
 
diff -puN include/linux/fsnotify_backend.h~fsnotify-unify-inode-and-mount-marks-handling include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-unify-inode-and-mount-marks-handling
+++ a/include/linux/fsnotify_backend.h
@@ -197,24 +197,6 @@ struct fsnotify_group {
 #define FSNOTIFY_EVENT_INODE	2
 
 /*
- * Inode specific fields in an fsnotify_mark
- */
-struct fsnotify_inode_mark {
-	struct inode *inode;		/* inode this mark is associated with */
-	struct hlist_node i_list;	/* list of marks by inode->i_fsnotify_marks */
-	struct list_head free_i_list;	/* tmp list used when freeing this mark */
-};
-
-/*
- * Mount point specific fields in an fsnotify_mark
- */
-struct fsnotify_vfsmount_mark {
-	struct vfsmount *mnt;		/* vfsmount this mark is associated with */
-	struct hlist_node m_list;	/* list of marks by inode->i_fsnotify_marks */
-	struct list_head free_m_list;	/* tmp list used when freeing this mark */
-};
-
-/*
  * a mark is simply an object attached to an in core inode which allows an
  * fsnotify listener to indicate they are either no longer interested in events
  * of a type matching mask or only interested in those events.
@@ -232,9 +214,11 @@ struct fsnotify_mark {
 	struct fsnotify_group *group;	/* group this mark is for */
 	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks */
 	spinlock_t lock;		/* protect group and inode */
+	struct hlist_node obj_list;	/* list of marks for inode / vfsmount */
+	struct list_head free_list;	/* tmp list used when freeing this mark */
 	union {
-		struct fsnotify_inode_mark i;
-		struct fsnotify_vfsmount_mark m;
+		struct inode *inode;	/* inode this mark is associated with */
+		struct vfsmount *mnt;	/* vfsmount this mark is associated with */
 	};
 	__u32 ignored_mask;		/* events types to ignore */
 #define FSNOTIFY_MARK_FLAG_INODE		0x01
diff -puN kernel/audit_tree.c~fsnotify-unify-inode-and-mount-marks-handling kernel/audit_tree.c
--- a/kernel/audit_tree.c~fsnotify-unify-inode-and-mount-marks-handling
+++ a/kernel/audit_tree.c
@@ -174,9 +174,9 @@ static void insert_hash(struct audit_chu
 	struct fsnotify_mark *entry = &chunk->mark;
 	struct list_head *list;
 
-	if (!entry->i.inode)
+	if (!entry->inode)
 		return;
-	list = chunk_hash(entry->i.inode);
+	list = chunk_hash(entry->inode);
 	list_add_rcu(&chunk->hash, list);
 }
 
@@ -188,7 +188,7 @@ struct audit_chunk *audit_tree_lookup(co
 
 	list_for_each_entry_rcu(p, list, hash) {
 		/* mark.inode may have gone NULL, but who cares? */
-		if (p->mark.i.inode == inode) {
+		if (p->mark.inode == inode) {
 			atomic_long_inc(&p->refs);
 			return p;
 		}
@@ -231,7 +231,7 @@ static void untag_chunk(struct node *p)
 		new = alloc_chunk(size);
 
 	spin_lock(&entry->lock);
-	if (chunk->dead || !entry->i.inode) {
+	if (chunk->dead || !entry->inode) {
 		spin_unlock(&entry->lock);
 		if (new)
 			free_chunk(new);
@@ -258,7 +258,7 @@ static void untag_chunk(struct node *p)
 		goto Fallback;
 
 	fsnotify_duplicate_mark(&new->mark, entry);
-	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.i.inode, NULL, 1)) {
+	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.inode, NULL, 1)) {
 		fsnotify_put_mark(&new->mark);
 		goto Fallback;
 	}
@@ -386,7 +386,7 @@ static int tag_chunk(struct inode *inode
 	chunk_entry = &chunk->mark;
 
 	spin_lock(&old_entry->lock);
-	if (!old_entry->i.inode) {
+	if (!old_entry->inode) {
 		/* old_entry is being shot, lets just lie */
 		spin_unlock(&old_entry->lock);
 		fsnotify_put_mark(old_entry);
@@ -395,7 +395,7 @@ static int tag_chunk(struct inode *inode
 	}
 
 	fsnotify_duplicate_mark(chunk_entry, old_entry);
-	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->i.inode, NULL, 1)) {
+	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->inode, NULL, 1)) {
 		spin_unlock(&old_entry->lock);
 		fsnotify_put_mark(chunk_entry);
 		fsnotify_put_mark(old_entry);
@@ -611,7 +611,7 @@ void audit_trim_trees(void)
 		list_for_each_entry(node, &tree->chunks, list) {
 			struct audit_chunk *chunk = find_chunk(node);
 			/* this could be NULL if the watch is dying else where... */
-			struct inode *inode = chunk->mark.i.inode;
+			struct inode *inode = chunk->mark.inode;
 			node->index |= 1U<<31;
 			if (iterate_mounts(compare_root, inode, root_mnt))
 				node->index &= ~(1U<<31);
_

Patches currently in -mm which might be from jack@suse.cz are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-fix-error-handling-when-creating-debugfs-root-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-drop-logbuf_cpu-volatile-qualifier.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

