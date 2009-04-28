From: akpm@linux-foundation.org
Subject: + fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:28:00 -0700
Message-ID: <200904282028.n3SKS1ro021025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666AbZD1Uc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: add marks to inodes so groups can interpret how to handle those inodes
has been added to the -mm tree.  Its filename is
     fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch

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
Subject: fsnotify: add marks to inodes so groups can interpret how to handle those inodes
From: Eric Paris <eparis@redhat.com>

This patch creates a way for fsnotify groups to attach marks to inodes. 
These marks have little meaning to the generic fsnotify infrastructure and
thus their meaning should be interpreted by the group that attached them
to the inode's list.

dnotify and inotify will make use of these markings to indicate which
inodes are of interest to their respective groups.  But this
implementation has the useful property that in the future other listeners
could actually use the marks for the exact opposite reason, aka to
indicate which inodes it had NO interest in.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c                       |    9 
 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.c             |   13 +
 fs/notify/fsnotify.h             |    5 
 fs/notify/group.c                |   49 ++++
 fs/notify/inode_mark.c           |  329 +++++++++++++++++++++++++++++
 include/linux/fs.h               |    5 
 include/linux/fsnotify.h         |    8 
 include/linux/fsnotify_backend.h |   65 +++++
 9 files changed, 482 insertions(+), 3 deletions(-)

diff -puN fs/inode.c~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes fs/inode.c
--- a/fs/inode.c~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/fs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify.h>
 #include <linux/mount.h>
 #include <linux/async.h>
 
@@ -189,6 +190,10 @@ struct inode *inode_init_always(struct s
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 
+#ifdef CONFIG_FSNOTIFY
+	inode->i_fsnotify_mask = 0;
+#endif
+
 	return inode;
 
 out_free_security:
@@ -220,6 +225,7 @@ void destroy_inode(struct inode *inode) 
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	fsnotify_inode_delete(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
@@ -251,6 +257,9 @@ void inode_init_once(struct inode *inode
 	INIT_LIST_HEAD(&inode->inotify_watches);
 	mutex_init(&inode->inotify_mutex);
 #endif
+#ifdef CONFIG_FSNOTIFY
+	INIT_HLIST_HEAD(&inode->i_fsnotify_mark_entries);
+#endif
 }
 
 EXPORT_SYMBOL(inode_init_once);
diff -puN fs/notify/Makefile~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes fs/notify/Makefile
--- a/fs/notify/Makefile~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/fs/notify/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o
+obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff -puN fs/notify/fsnotify.c~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/fs/notify/fsnotify.c
@@ -26,6 +26,15 @@
 #include "fsnotify.h"
 
 /*
+ * Clear all of the marks on an inode when it is being evicted from core
+ */
+void __fsnotify_inode_delete(struct inode *inode)
+{
+	fsnotify_clear_marks_by_inode(inode);
+}
+EXPORT_SYMBOL_GPL(__fsnotify_inode_delete);
+
+/*
  * This is the main call to fsnotify.  The VFS calls into hook specific functions
  * in linux/fsnotify.h.  Those functions then in turn call here.  Here will call
  * out to all of the registered fsnotify_group.  Those groups can then use the
@@ -43,6 +52,8 @@ void fsnotify(struct inode *to_tell, __u
 	if (!(mask & fsnotify_mask))
 		return;
 
+	if (!(mask & to_tell->i_fsnotify_mask))
+		return;
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
 	 * very hot.  The VAST majority of events are not going to need to do
@@ -51,6 +62,8 @@ void fsnotify(struct inode *to_tell, __u
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
 		if (mask & group->mask) {
+			if (!group->ops->should_send_event(group, to_tell, mask))
+				continue;
 			if (!event) {
 				event = fsnotify_create_event(to_tell, mask, data, data_is);
 				/* shit, we OOM'd and now we can't tell, maybe
diff -puN fs/notify/fsnotify.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/fs/notify/fsnotify.h
@@ -12,4 +12,9 @@ extern struct srcu_struct fsnotify_grp_s
 extern struct list_head fsnotify_groups;
 /* all bitwise OR of all event types (FS_*) for all fsnotify_groups */
 extern __u32 fsnotify_mask;
+
+/* final kfree of a group */
+extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
+/* run the list of all marks associated with inode and flag them to be freed */
+extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 #endif	/* __FS_NOTIFY_FSNOTIFY_H_ */
diff -puN fs/notify/group.c~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes fs/notify/group.c
--- a/fs/notify/group.c~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/fs/notify/group.c
@@ -55,6 +55,29 @@ void fsnotify_recalc_global_mask(void)
 }
 
 /*
+ * Update the group->mask by running all of the marks associated with this
+ * group and finding the bitwise | of all of the mark->mask.  If we change
+ * the group->mask we need to update the global mask of events interesting
+ * to the system.
+ */
+void fsnotify_recalc_group_mask(struct fsnotify_group *group)
+{
+	__u32 mask = 0;
+	__u32 old_mask = group->mask;
+	struct fsnotify_mark_entry *entry;
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry(entry, &group->mark_entries, g_list)
+		mask |= entry->mask;
+	spin_unlock(&group->mark_lock);
+
+	group->mask = mask;
+
+	if (old_mask != mask)
+		fsnotify_recalc_global_mask();
+}
+
+/*
  * Take a reference to a group so things found under the fsnotify_grp_mutex
  * can't get freed under us
  */
@@ -66,7 +89,7 @@ static void fsnotify_get_group(struct fs
 /*
  * Final freeing of a group
  */
-static void fsnotify_destroy_group(struct fsnotify_group *group)
+void fsnotify_final_destroy_group(struct fsnotify_group *group)
 {
 	if (group->ops->free_group_priv)
 		group->ops->free_group_priv(group);
@@ -75,6 +98,24 @@ static void fsnotify_destroy_group(struc
 }
 
 /*
+ * Trying to get rid of a group.  We need to first get rid of any outstanding
+ * allocations and then free the group.  Remember that fsnotify_clear_marks_by_group
+ * could miss marks that are being freed by inode and those marks could still
+ * hold a reference to this group (via group->num_marks)  If we get into that
+ * situtation, the fsnotify_final_destroy_group will get called when that final
+ * mark is freed.
+ */
+static void fsnotify_destroy_group(struct fsnotify_group *group)
+{
+	/* clear all inode mark entries for this group */
+	fsnotify_clear_marks_by_group(group);
+
+	/* past the point of no return, matches the initial value of 1 */
+	if (atomic_dec_and_test(&group->num_marks))
+		fsnotify_final_destroy_group(group);
+}
+
+/*
  * Remove this group from the global list of groups that will get events
  * this can be done even if there are still references and things still using
  * this group.  This just stops the group from getting new events.
@@ -173,6 +214,10 @@ struct fsnotify_group *fsnotify_obtain_g
 	group->group_num = group_num;
 	group->mask = mask;
 
+	spin_lock_init(&group->mark_lock);
+	atomic_set(&group->num_marks, 0);
+	INIT_LIST_HEAD(&group->mark_entries);
+
 	group->ops = ops;
 
 	mutex_lock(&fsnotify_grp_mutex);
@@ -188,6 +233,8 @@ struct fsnotify_group *fsnotify_obtain_g
 	/* group not found, add a new one */
 	list_add_rcu(&group->group_list, &fsnotify_groups);
 	group->on_group_list = 1;
+	/* being on the fsnotify_groups list holds one num_marks */
+	atomic_inc(&group->num_marks);
 
 	mutex_unlock(&fsnotify_grp_mutex);
 
diff -puN /dev/null fs/notify/inode_mark.c
--- /dev/null
+++ a/fs/notify/inode_mark.c
@@ -0,0 +1,329 @@
+/*
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/*
+ * fsnotify inode mark locking/lifetime/and refcnting
+ *
+ * REFCNT:
+ * The mark->refcnt tells how many "things" in the kernel currently are
+ * referencing this object.  The object typically will live inside the kernel
+ * with a refcnt of 2, one for each list it is on (i_list, g_list).  Any task
+ * which can find this object holding the appropriete locks, can take a reference
+ * and the object itself is guarenteed to survive until the reference is dropped.
+ *
+ * LOCKING:
+ * There are 3 spinlocks involved with fsnotify inode marks and they MUST
+ * be taken in order as follows:
+ *
+ * entry->lock
+ * group->mark_lock
+ * inode->i_lock
+ *
+ * entry->lock protects 2 things, entry->group and entry->inode.  You must hold
+ * that lock to dereference either of these things (they could be NULL even with
+ * the lock)
+ *
+ * group->mark_lock protects the mark_entries list anchored inside a given group
+ * and each entry is hooked via the g_list.  It also sorta protects the
+ * free_g_list, which when used is anchored by a private list on the stack of the
+ * task which held the group->mark_lock.
+ *
+ * inode->i_lock protects the i_fsnotify_mark_entries list anchored inside a
+ * given inode and each entry is hooked via the i_list. (and sorta the
+ * free_i_list)
+ *
+ *
+ * LIFETIME:
+ * Inode marks survive between when they are added to an inode and when their
+ * refcnt==0.
+ *
+ * The inode mark can be cleared for a number of different reasons including:
+ * - The inode is unlinked for the last time.  (fsnotify_inode_remove)
+ * - The inode is being evicted from cache. (fsnotify_inode_delete)
+ * - The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)
+ * - Something explicitly requests that it be removed.  (fsnotify_destroy_mark_by_entry)
+ * - The fsnotify_group associated with the mark is going away and all such marks
+ *   need to be cleaned up. (fsnotify_clear_marks_by_group)
+ *
+ * Worst case we are given an inode and need to clean up all the marks on that
+ * inode.  We take i_lock and walk the i_fsnotify_mark_entries safely.  For each
+ * mark on the list we take a reference (so the mark can't disappear under us).
+ * We remove that mark form the inode's list of marks and we add this mark to a
+ * private list anchored on the stack using i_free_list;  At this point we no
+ * longer fear anything finding the mark using the inode's list of marks.
+ *
+ * We can safely and locklessly run the private list on the stack of everything
+ * we just unattached from the original inode.  For each mark on the private list
+ * we grab the mark-> and can thus dereference mark->group and mark->inode.  If
+ * we see the group and inode are not NULL we take those locks.  Now holding all
+ * 3 locks we can completely remove the mark from other tasks finding it in the
+ * future.  Remember, 10 things might already be referencing this mark, but they
+ * better be holding a ref.  We drop our reference we took before we unhooked it
+ * from the inode.  When the ref hits 0 we can free the mark.
+ *
+ * Very similarly for freeing by group, except we use free_g_list.
+ *
+ * This has the very interesting property of being able to run concurrently with
+ * any (or all) other directions.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/atomic.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+void fsnotify_get_mark(struct fsnotify_mark_entry *entry)
+{
+	atomic_inc(&entry->refcnt);
+}
+
+void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
+{
+	if (atomic_dec_and_test(&entry->refcnt))
+		entry->free_mark(entry);
+}
+
+/*
+ * Recalculate the mask of events relevant to a given inode locked.
+ */
+static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry;
+	struct hlist_node *pos;
+	__u32 new_mask = 0;
+
+	assert_spin_locked(&inode->i_lock);
+
+	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_mark_entries, i_list)
+		new_mask |= entry->mask;
+	inode->i_fsnotify_mask = new_mask;
+}
+
+/*
+ * Recalculate the inode->i_fsnotify_mask, or the mask of all FS_* event types
+ * any notifier is interested in hearing for this inode.
+ */
+void fsnotify_recalc_inode_mask(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	fsnotify_recalc_inode_mask_locked(inode);
+	spin_unlock(&inode->i_lock);
+}
+
+/*
+ * Any time a mark is getting freed we end up here.
+ * The caller had better be holding a reference to this mark so we don't actually
+ * do the final put under the entry->lock
+ */
+void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
+{
+	struct fsnotify_group *group;
+	struct inode *inode;
+
+	spin_lock(&entry->lock);
+
+	group = entry->group;
+	inode = entry->inode;
+
+	BUG_ON(group && !inode);
+	BUG_ON(!group && inode);
+
+	/* if !group something else already marked this to die */
+	if (!group) {
+		spin_unlock(&entry->lock);
+		return;
+	}
+
+	/* 1 from caller and 1 for being on i_list/g_list */
+	BUG_ON(atomic_read(&entry->refcnt) < 2);
+
+	spin_lock(&group->mark_lock);
+	spin_lock(&inode->i_lock);
+
+	hlist_del_init(&entry->i_list);
+	entry->inode = NULL;
+
+	list_del_init(&entry->g_list);
+	entry->group = NULL;
+
+	fsnotify_put_mark(entry); /* for i_list and g_list */
+
+	/*
+	 * this mark is now off the inode->i_fsnotify_mark_entries list and we
+	 * hold the inode->i_lock, so this is the perfect time to update the
+	 * inode->i_fsnotify_mask
+	 */
+	fsnotify_recalc_inode_mask_locked(inode);
+
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&entry->lock);
+
+	/*
+	 * Some groups like to know that marks are being freed.  This is a
+	 * callback to the group function to let it know that this entry
+	 * is being freed.
+	 */
+	group->ops->freeing_mark(entry, group);
+
+	/*
+	 * it's possible that this group tried to destroy itself, but this
+	 * this mark was simultaneously being freed by inode.  If that's the
+	 * case, we finish freeing the group here.
+	 */
+	if (unlikely(atomic_dec_and_test(&group->num_marks)))
+		fsnotify_final_destroy_group(group);
+}
+
+/*
+ * Given a group, destroy all of the marks associated with that group.
+ */
+void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
+{
+	struct fsnotify_mark_entry *lentry, *entry;
+	LIST_HEAD(free_list);
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry_safe(entry, lentry, &group->mark_entries, g_list) {
+		list_add(&entry->free_g_list, &free_list);
+		list_del_init(&entry->g_list);
+		fsnotify_get_mark(entry);
+	}
+	spin_unlock(&group->mark_lock);
+
+	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_mark(entry);
+	}
+}
+
+/*
+ * Given an inode, destroy all of the marks associated with that inode.
+ */
+void fsnotify_clear_marks_by_inode(struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry, *lentry;
+	struct hlist_node *pos, *n;
+	LIST_HEAD(free_list);
+
+	spin_lock(&inode->i_lock);
+	hlist_for_each_entry_safe(entry, pos, n, &inode->i_fsnotify_mark_entries, i_list) {
+		list_add(&entry->free_i_list, &free_list);
+		hlist_del_init(&entry->i_list);
+		fsnotify_get_mark(entry);
+	}
+	spin_unlock(&inode->i_lock);
+
+	list_for_each_entry_safe(entry, lentry, &free_list, free_i_list) {
+		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_put_mark(entry);
+	}
+}
+
+/*
+ * given a group and inode, find the mark associated with that combination.
+ * if found take a reference to that mark and return it, else return NULL
+ */
+struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group,
+						     struct inode *inode)
+{
+	struct fsnotify_mark_entry *entry;
+	struct hlist_node *pos;
+
+	assert_spin_locked(&inode->i_lock);
+
+	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_mark_entries, i_list) {
+		if (entry->group == group) {
+			fsnotify_get_mark(entry);
+			return entry;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Nothing fancy, just initialize lists and locks and counters.
+ */
+void fsnotify_init_mark(struct fsnotify_mark_entry *entry,
+			void (*free_mark)(struct fsnotify_mark_entry *entry))
+
+{
+	spin_lock_init(&entry->lock);
+	atomic_set(&entry->refcnt, 1);
+	INIT_HLIST_NODE(&entry->i_list);
+	entry->group = NULL;
+	entry->mask = 0;
+	entry->inode = NULL;
+	entry->free_mark = free_mark;
+}
+
+/*
+ * Attach an initialized mark entry to a given group and inode.
+ * These marks may be used for the fsnotify backend to determine which
+ * event types should be delivered to which group and for which inodes.
+ */
+int fsnotify_add_mark(struct fsnotify_mark_entry *entry,
+		      struct fsnotify_group *group, struct inode *inode)
+{
+	struct fsnotify_mark_entry *lentry;
+	int ret = 0;
+
+	/*
+	 * LOCKING ORDER!!!!
+	 * entry->lock
+	 * group->mark_lock
+	 * inode->i_lock
+	 */
+	spin_lock(&entry->lock);
+	spin_lock(&group->mark_lock);
+	spin_lock(&inode->i_lock);
+
+	entry->group = group;
+	entry->inode = inode;
+
+	lentry = fsnotify_find_mark_entry(group, inode);
+	if (!lentry) {
+		hlist_add_head(&entry->i_list, &inode->i_fsnotify_mark_entries);
+		list_add(&entry->g_list, &group->mark_entries);
+
+		fsnotify_get_mark(entry); /* for i_list and g_list */
+
+		atomic_inc(&group->num_marks);
+
+		fsnotify_recalc_inode_mask_locked(inode);
+	}
+
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&entry->lock);
+
+	if (lentry) {
+		ret = -EEXIST;
+		fsnotify_put_mark(lentry);
+	}
+
+	return ret;
+}
diff -puN include/linux/fs.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes include/linux/fs.h
--- a/include/linux/fs.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/include/linux/fs.h
@@ -755,6 +755,11 @@ struct inode {
 
 	__u32			i_generation;
 
+#ifdef CONFIG_FSNOTIFY
+	__u32			i_fsnotify_mask; /* all events this inode cares about */
+	struct hlist_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
+#endif
+
 #ifdef CONFIG_DNOTIFY
 	unsigned long		i_dnotify_mask; /* Directory notify events */
 	struct dnotify_struct	*i_dnotify; /* for directory notifications */
diff -puN include/linux/fsnotify.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/include/linux/fsnotify.h
@@ -100,6 +100,14 @@ static inline void fsnotify_move(struct 
 }
 
 /*
+ * fsnotify_inode_delete - and inode is being evicted from cache, clean up is needed
+ */
+static inline void fsnotify_inode_delete(struct inode *inode)
+{
+	__fsnotify_inode_delete(inode);
+}
+
+/*
  * fsnotify_nameremove - a filename was removed from a directory
  */
 static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
diff -puN include/linux/fsnotify_backend.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes
+++ a/include/linux/fsnotify_backend.h
@@ -48,17 +48,25 @@
 
 struct fsnotify_group;
 struct fsnotify_event;
+struct fsnotify_mark_entry;
 
 /*
  * Each group much define these ops.  The fsnotify infrastructure will call
  * these operations for each relevant group.
  *
+ * should_send_event - given a group, inode, and mask this function determines
+ *		if the group is interested in this event.
  * handle_event - main call for a group to handle an fs event
  * free_group_priv - called when a group refcnt hits 0 to clean up the private union
+ * freeing-mark - this means that a mark has been flagged to die when everything
+ *		finishes using it.  The function is supplied with what must be a
+ *		valid group and inode to use to clean up.
  */
 struct fsnotify_ops {
+	bool (*should_send_event)(struct fsnotify_group *group, struct inode *inode, __u32 mask);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
+	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
 };
 
 /*
@@ -97,7 +105,14 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
-	/* prevents double list_del of group_list.  protected by global fsnotify_gr_mutex */
+	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
+	spinlock_t mark_lock;		/* protect mark_entries list */
+	atomic_t num_marks;		/* 1 for each mark entry and 1 for not being
+					 * past the point of no return when freeing
+					 * a group */
+	struct list_head mark_entries;	/* all inode mark entries for this group */
+
+	/* prevents double list_del of group_list.  protected by global fsnotify_grp_mutex */
 	bool on_group_list;
 
 	/* groups can define private fields here or use the void *private */
@@ -137,12 +152,38 @@ struct fsnotify_event {
 	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
 };
 
+/*
+ * a mark is simply an entry attached to an in core inode which allows an
+ * fsnotify listener to indicate they are either no longer interested in events
+ * of a type matching mask or only interested in those events.
+ *
+ * these are flushed when an inode is evicted from core and may be flushed
+ * when the inode is modified (as seen by fsnotify_access).  Some fsnotify users
+ * (such as dnotify) will flush these when the open fd is closed and not at
+ * inode eviction or modification.
+ */
+struct fsnotify_mark_entry {
+	__u32 mask;			/* mask this mark entry is for */
+	/* we hold ref for each i_list and g_list.  also one ref for each 'thing'
+	 * in kernel that found and may be using this mark. */
+	atomic_t refcnt;		/* active things looking at this mark */
+	struct inode *inode;		/* inode this entry is associated with */
+	struct fsnotify_group *group;	/* group this mark entry is for */
+	struct hlist_node i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+	spinlock_t lock;		/* protect group, inode, and killme */
+	struct list_head free_i_list;	/* tmp list used when freeing this mark */
+	struct list_head free_g_list;	/* tmp list used when freeing this mark */
+	void (*free_mark)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+};
+
 #ifdef CONFIG_FSNOTIFY
 
 /* called from the vfs helpers */
 
 /* main fsnotify call to send events */
 extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+extern void __fsnotify_inode_delete(struct inode *inode);
 
 
 /* called from fsnotify listeners, such as fanotify or dnotify */
@@ -153,6 +194,8 @@ extern void fsnotify_recalc_global_mask(
 extern struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num,
 						    __u32 mask,
 						    const struct fsnotify_ops *ops);
+/* run all marks associated with this group and update group->mask */
+extern void fsnotify_recalc_group_mask(struct fsnotify_group *group);
 /* drop reference on a group from fsnotify_obtain_group */
 extern void fsnotify_put_group(struct fsnotify_group *group);
 
@@ -163,6 +206,22 @@ extern void fsnotify_put_event(struct fs
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group,
 									struct fsnotify_event *event);
 
+/* functions used to manipulate the marks attached to inodes */
+
+/* run all marks associated with an inode and update inode->i_fsnotify_mask */
+extern void fsnotify_recalc_inode_mask(struct inode *inode);
+extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_mark)(struct fsnotify_mark_entry *entry));
+/* find (and take a reference) to a mark associated with group and inode */
+extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
+/* attach the mark to both the group and the inode */
+extern int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode);
+/* given a mark, flag it to be freed when all references are dropped */
+extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
+/* run all the marks in a group, and flag them to be freed */
+extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
+extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
+
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 						    void *data, int data_is);
@@ -170,6 +229,10 @@ extern struct fsnotify_event *fsnotify_c
 
 static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
 {}
+
+static inline void __fsnotify_inode_delete(struct inode *inode)
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

