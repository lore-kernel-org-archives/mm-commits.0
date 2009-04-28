From: akpm@linux-foundation.org
Subject: + fsnotify-parent-event-notification.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:28:04 -0700
Message-ID: <200904282028.n3SKS44J021034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbZD1Ubj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: parent event notification
has been added to the -mm tree.  Its filename is
     fsnotify-parent-event-notification.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: parent event notification
From: Eric Paris <eparis@redhat.com>

inotify and dnotify both use a similar parent notification mechanism.  We
add a generic parent notification mechanism to fsnotify for both of these
to use.  This new machanism also adds the dentry flag optimization which
exists for inotify to dnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.c             |   91 +++++++++++++++++++++++++++++
 fs/notify/fsnotify.h             |    5 +
 fs/notify/inode_mark.c           |   17 +++++
 include/linux/dcache.h           |    3 
 include/linux/fsnotify.h         |   34 +++++++---
 include/linux/fsnotify_backend.h |   64 ++++++++++++++++++++
 6 files changed, 204 insertions(+), 10 deletions(-)

diff -puN fs/notify/fsnotify.c~fsnotify-parent-event-notification fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-parent-event-notification
+++ a/fs/notify/fsnotify.c
@@ -35,6 +35,97 @@ void __fsnotify_inode_delete(struct inod
 EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
 
 /*
+ * Given an inode, first check if we care what happens to our children.  Inotify
+ * and dnotify both tell their parents about events.  If we care about any event
+ * on a child we run all of our children and set a dentry flag saying that the
+ * parent cares.  Thus when an event happens on a child it can quickly tell if
+ * if there is a need to find a parent and send the event to the parent.
+ */
+void __fsnotify_update_child_dentry_flags(struct inode *inode)
+{
+	struct dentry *alias;
+	int watched;
+
+	if (!S_ISDIR(inode->i_mode))
+		return;
+
+	/* determine if the children should tell inode about their events */
+	watched = fsnotify_inode_watches_children(inode);
+
+	spin_lock(&dcache_lock);
+	/* run all of the dentries associated with this inode.  Since this is a
+	 * directory, there damn well better only be one item on this list */
+	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+		struct dentry *child;
+
+		/* run all of the children of the original inode and fix their
+		 * d_flags to indicate parental interest (their parent is the
+		 * original inode) */
+		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
+			if (!child->d_inode)
+				continue;
+
+			spin_lock(&child->d_lock);
+			if (watched)
+				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+			else
+				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+			spin_unlock(&child->d_lock);
+		}
+	}
+	spin_unlock(&dcache_lock);
+}
+
+/* Notify this dentry's parent about a child's events. */
+void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+{
+	struct dentry *parent;
+	struct inode *p_inode;
+	bool send = false;
+	bool should_update_children = false;
+
+	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
+		return;
+
+	spin_lock(&dentry->d_lock);
+	parent = dentry->d_parent;
+	p_inode = parent->d_inode;
+
+	if (fsnotify_inode_watches_children(p_inode)) {
+		if (p_inode->i_fsnotify_mask & mask) {
+			dget(parent);
+			send = true;
+		}
+	} else {
+		/*
+		 * The parent doesn't care about events on it's children but
+		 * at least one child thought it did.  We need to run all the
+		 * children and update their d_flags to let them know p_inode
+		 * doesn't care about them any more.
+		 */
+		dget(parent);
+		should_update_children = true;
+	}
+
+	spin_unlock(&dentry->d_lock);
+
+	if (send) {
+		/* we are notifying a parent so come up with the new mask which
+		 * specifies these are events which came from a child. */
+		mask |= FS_EVENT_ON_CHILD;
+
+		fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE);
+		dput(parent);
+	}
+
+	if (unlikely(should_update_children)) {
+		__fsnotify_update_child_dentry_flags(p_inode);
+		dput(parent);
+	}
+}
+EXPORT_SYMBOL_GPL(__fsnotify_parent);
+
+/*
  * This is the main call to fsnotify.  The VFS calls into hook specific functions
  * in linux/fsnotify.h.  Those functions then in turn call here.  Here will call
  * out to all of the registered fsnotify_group.  Those groups can then use the
diff -puN fs/notify/fsnotify.h~fsnotify-parent-event-notification fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-parent-event-notification
+++ a/fs/notify/fsnotify.h
@@ -17,4 +17,9 @@ extern __u32 fsnotify_mask;
 extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
 /* run the list of all marks associated with inode and flag them to be freed */
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
+/*
+ * update the dentry->d_flags of all of inode's children to indicate if inode cares
+ * about events that happen to its children.
+ */
+extern void __fsnotify_update_child_dentry_flags(struct inode *inode);
 #endif	/* __FS_NOTIFY_FSNOTIFY_H_ */
diff -puN fs/notify/inode_mark.c~fsnotify-parent-event-notification fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-parent-event-notification
+++ a/fs/notify/inode_mark.c
@@ -131,6 +131,8 @@ void fsnotify_recalc_inode_mask(struct i
 	spin_lock(&inode->i_lock);
 	fsnotify_recalc_inode_mask_locked(inode);
 	spin_unlock(&inode->i_lock);
+
+	__fsnotify_update_child_dentry_flags(inode);
 }
 
 /*
@@ -190,6 +192,19 @@ void fsnotify_destroy_mark_by_entry(stru
 	group->ops->freeing_mark(entry, group);
 
 	/*
+	 * __fsnotify_update_child_dentry_flags(inode);
+	 *
+	 * I really want to call that, but we can't, we have no idea if the inode
+	 * still exists the second we drop the entry->lock.
+	 *
+	 * The next time an event arrive to this inode from one of it's children
+	 * __fsnotify_parent will see that the inode doesn't care about it's
+	 * children and will update all of these flags then.  So really this
+	 * is just a lazy update (and could be a perf win...)
+	 */
+
+
+	/*
 	 * it's possible that this group tried to destroy itself, but this
 	 * this mark was simultaneously being freed by inode.  If that's the
 	 * case, we finish freeing the group here.
@@ -323,6 +338,8 @@ int fsnotify_add_mark(struct fsnotify_ma
 	if (lentry) {
 		ret = -EEXIST;
 		fsnotify_put_mark(lentry);
+	} else {
+		__fsnotify_update_child_dentry_flags(inode);
 	}
 
 	return ret;
diff -puN include/linux/dcache.h~fsnotify-parent-event-notification include/linux/dcache.h
--- a/include/linux/dcache.h~fsnotify-parent-event-notification
+++ a/include/linux/dcache.h
@@ -180,7 +180,8 @@ d_iput:		no		no		no       yes
 #define DCACHE_REFERENCED	0x0008  /* Recently used, don't discard. */
 #define DCACHE_UNHASHED		0x0010	
 
-#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched */
+#define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
+#define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0040 /* Parent inode is watched by some fsnotify listener */
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 
diff -puN include/linux/fsnotify.h~fsnotify-parent-event-notification include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-parent-event-notification
+++ a/include/linux/fsnotify.h
@@ -23,15 +23,31 @@
 static inline void fsnotify_d_instantiate(struct dentry *entry,
 						struct inode *inode)
 {
+	__fsnotify_d_instantiate(entry, inode);
+
 	inotify_d_instantiate(entry, inode);
 }
 
+/* Notify this dentry's parent about a child's events. */
+static inline void fsnotify_parent(struct dentry *dentry, __u32 mask)
+{
+	__fsnotify_parent(dentry, mask);
+
+	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
+}
+
 /*
  * fsnotify_d_move - entry has been moved
  * Called with dcache_lock and entry->d_lock held.
  */
 static inline void fsnotify_d_move(struct dentry *entry)
 {
+	/*
+	 * On move we need to update entry->d_flags to indicate if the new parent
+	 * cares about events from this entry.
+	 */
+	__fsnotify_update_dcache_flags(entry);
+
 	inotify_d_move(entry);
 }
 
@@ -117,7 +133,8 @@ static inline void fsnotify_nameremove(s
 	if (isdir)
 		mask |= FS_IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
+
+	fsnotify_parent(dentry, mask);
 }
 
 /*
@@ -187,9 +204,9 @@ static inline void fsnotify_access(struc
 		mask |= FS_IN_ISDIR;
 
 	dnotify_parent(dentry, DN_ACCESS);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -205,9 +222,9 @@ static inline void fsnotify_modify(struc
 		mask |= FS_IN_ISDIR;
 
 	dnotify_parent(dentry, DN_MODIFY);
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -222,9 +239,9 @@ static inline void fsnotify_open(struct 
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -235,16 +252,15 @@ static inline void fsnotify_close(struct
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	const char *name = dentry->d_name.name;
 	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
@@ -259,9 +275,9 @@ static inline void fsnotify_xattr(struct
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
+	fsnotify_parent(dentry, mask);
 	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
@@ -310,8 +326,8 @@ static inline void fsnotify_change(struc
 		if (S_ISDIR(inode->i_mode))
 			in_mask |= FS_IN_ISDIR;
 		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
-		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
-						  dentry->d_name.name);
+
+		fsnotify_parent(dentry, in_mask);
 		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
diff -puN include/linux/fsnotify_backend.h~fsnotify-parent-event-notification include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-parent-event-notification
+++ a/include/linux/fsnotify_backend.h
@@ -46,6 +46,17 @@
 #define FS_DN_RENAME		0x10000000	/* file renamed */
 #define FS_DN_MULTISHOT		0x20000000	/* dnotify multishot */
 
+/* This inode cares about things that happen to its children.  Always set for
+ * dnotify and inotify. */
+#define FS_EVENT_ON_CHILD	0x08000000
+
+/* This is a list of all events that may get sent to a parernt based on fs event
+ * happening to inodes inside that directory */
+#define FS_EVENTS_POSS_ON_CHILD   (FS_ACCESS | FS_MODIFY | FS_ATTRIB |\
+				   FS_CLOSE_WRITE | FS_CLOSE_NOWRITE | FS_OPEN |\
+				   FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
+				   FS_DELETE)
+
 struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark_entry;
@@ -183,8 +194,52 @@ struct fsnotify_mark_entry {
 
 /* main fsnotify call to send events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+extern void __fsnotify_parent(struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
 
+static inline int fsnotify_inode_watches_children(struct inode *inode)
+{
+	/* FS_EVENT_ON_CHILD is set if the inode may care */
+	if (!(inode->i_fsnotify_mask & FS_EVENT_ON_CHILD))
+		return 0;
+	/* this inode might care about child events, does it care about the
+	 * specific set of events that can happen on a child? */
+	return inode->i_fsnotify_mask & FS_EVENTS_POSS_ON_CHILD;
+}
+
+/*
+ * Update the dentry with a flag indicating the interest of its parent to receive
+ * filesystem events when those events happens to this dentry->d_inode.
+ */
+static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
+{
+	struct dentry *parent;
+
+	assert_spin_locked(&dcache_lock);
+	assert_spin_locked(&dentry->d_lock);
+
+	parent = dentry->d_parent;
+	if (fsnotify_inode_watches_children(parent->d_inode))
+		dentry->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
+	else
+		dentry->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
+}
+
+/*
+ * fsnotify_d_instantiate - instantiate a dentry for inode
+ * Called with dcache_lock held.
+ */
+static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	if (!inode)
+		return;
+
+	assert_spin_locked(&dcache_lock);
+
+	spin_lock(&dentry->d_lock);
+	__fsnotify_update_dcache_flags(dentry);
+	spin_unlock(&dentry->d_lock);
+}
 
 /* called from fsnotify listeners, such as fanotify or dnotify */
 
@@ -230,9 +285,18 @@ extern struct fsnotify_event *fsnotify_c
 static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
 {}
 
+static inline void __fsnotify_parent(struct dentry *dentry, __u32 mask)
+{}
+
 static inline void __fsnotify_inode_delete(struct inode *inode)
 {}
 
+static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
+{}
+
+static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode *inode)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
mutex-add-atomic_dec_and_mutex_lock.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

