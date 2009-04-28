From: akpm@linux-foundation.org
Subject: + fsnotify-unified-filesystem-notification-backend.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:27:56 -0700
Message-ID: <200904282027.n3SKRvBQ020942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427AbZD1Ucs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: unified filesystem notification backend
has been added to the -mm tree.  Its filename is
     fsnotify-unified-filesystem-notification-backend.patch

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
Subject: fsnotify: unified filesystem notification backend
From: Eric Paris <eparis@redhat.com>

fsnotify is a backend for filesystem notification.  fsnotify does not
provide any userspace interface but does provide the basis needed for
other notification schemes such as dnotify.  fsnotify can be extended to
be the backend for inotify or the upcoming fanotify.  fsnotify provides a
mechanism for "groups" to register for some set of filesystem events and
to then deliver those events to those groups for processing.

fsnotify has a number of benefits, the first being actually shrinking the
size of an inode.  Before fsnotify to support both dnotify and inotify an
inode had

        unsigned long           i_dnotify_mask; /* Directory notify events */
        struct dnotify_struct   *i_dnotify; /* for directory notifications */
        struct list_head        inotify_watches; /* watches on this inode */
        struct mutex            inotify_mutex;  /* protects the watches list

But with fsnotify this same functionallity (and more) is done with just

        __u32                   i_fsnotify_mask; /* all events for this inode */
        struct hlist_head       i_fsnotify_mark_entries; /* marks on this inode */

That's right, inotify, dnotify, and fanotify all in 64 bits.  We used that
much space just in inotify_watches alone, before this patch set.

fsnotify object lifetime and locking is MUCH better than what we have
today.  inotify locking is incredibly complex.  See 8f7b0ba1c8539 as an
example of what's been busted since inception.  inotify needs to know
internal semantics of superblock destruction and unmounting to function. 
The inode pinning and vfs contortions are horrible.

No fsnotify implementers do allocation under locks.  This means things
like f04b30de3 which (due to an overabundance of caution) changes
GFP_KERNEL to GFP_NOFS can be reverted.  There are no longer any
allocation rules when using or implementing your own fsnotify listener.

fsnotify paves the way for fanotify.  In brief fanotify is a notification
mechanism that delivers the lisener both an 'event' and an open file
descriptor to the object in question.  This means that fanotify is
pathname agnostic.  Some on lkml may not care for the original companies
or users that pushed for TALPA, but fanotify was designed with flexibility
and input for other users in mind.  The readahead group expressed interest
in fanotify as it could be used to profile disk access on boot without
breaking the audit system.  The desktop search groups have also expressed
interest in fanotify as it solves a number of the race conditions and
problems present with managing inotify when more than a limited number of
specific files are of interest.  fanotify can provide for a userspace
access control system which makes it a clean interface for AV vendors to
hook without trying to do binary patching on the syscall table, LSM, and
everywhere else they do their things today.  With this patch series
fanotify can be implemented in less than 1200 lines of easy to review
code.  Almost all of which is the socket based user interface.

This patch series builds fsnotify to the point that it can implement
dnotify and inotify_user.  Patches exist and will be sent soon after
acceptance to finish the in kernel inotify conversion (audit) and
implement fanotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/Kconfig                |   13 +
 fs/notify/Makefile               |    2 
 fs/notify/fsnotify.c             |   79 +++++++++++
 fs/notify/fsnotify.h             |   15 ++
 fs/notify/group.c                |  198 +++++++++++++++++++++++++++++
 fs/notify/inotify/inotify.c      |   20 ++
 fs/notify/notification.c         |  121 +++++++++++++++++
 include/linux/fsnotify.h         |  115 +++++++++++-----
 include/linux/fsnotify_backend.h |  177 +++++++++++++++++++++++++
 9 files changed, 705 insertions(+), 35 deletions(-)

diff -puN fs/notify/Kconfig~fsnotify-unified-filesystem-notification-backend fs/notify/Kconfig
--- a/fs/notify/Kconfig~fsnotify-unified-filesystem-notification-backend
+++ a/fs/notify/Kconfig
@@ -1,2 +1,15 @@
+config FSNOTIFY
+	bool "Filesystem notification backend"
+	default y
+	---help---
+	   fsnotify is a backend for filesystem notification.  fsnotify does
+	   not provide any userspace interface but does provide the basis
+	   needed for other notification schemes such as dnotify, inotify,
+	   and fanotify.
+
+	   Say Y here to enable fsnotify suport.
+
+	   If unsure, say Y.
+
 source "fs/notify/dnotify/Kconfig"
 source "fs/notify/inotify/Kconfig"
diff -puN fs/notify/Makefile~fsnotify-unified-filesystem-notification-backend fs/notify/Makefile
--- a/fs/notify/Makefile~fsnotify-unified-filesystem-notification-backend
+++ a/fs/notify/Makefile
@@ -1,2 +1,4 @@
+obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o
+
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff -puN /dev/null fs/notify/fsnotify.c
--- /dev/null
+++ a/fs/notify/fsnotify.c
@@ -0,0 +1,79 @@
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
+#include <linux/dcache.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/srcu.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+/*
+ * This is the main call to fsnotify.  The VFS calls into hook specific functions
+ * in linux/fsnotify.h.  Those functions then in turn call here.  Here will call
+ * out to all of the registered fsnotify_group.  Those groups can then use the
+ * notification event in whatever means they feel necessary.
+ */
+void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
+{
+	struct fsnotify_group *group;
+	struct fsnotify_event *event = NULL;
+	int idx;
+
+	if (list_empty(&fsnotify_groups))
+		return;
+
+	if (!(mask & fsnotify_mask))
+		return;
+
+	/*
+	 * SRCU!!  the groups list is very very much read only and the path is
+	 * very hot.  The VAST majority of events are not going to need to do
+	 * anything other than walk the list so it's crazy to pre-allocate.
+	 */
+	idx = srcu_read_lock(&fsnotify_grp_srcu);
+	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
+		if (mask & group->mask) {
+			if (!event) {
+				event = fsnotify_create_event(to_tell, mask, data, data_is);
+				/* shit, we OOM'd and now we can't tell, maybe
+				 * someday someone else will want to do something
+				 * here */
+				if (!event)
+					break;
+			}
+			group->ops->handle_event(group, event);
+		}
+	}
+	srcu_read_unlock(&fsnotify_grp_srcu, idx);
+	/*
+	 * fsnotify_create_event() took a reference so the event can't be cleaned
+	 * up while we are still trying to add it to lists, drop that one.
+	 */
+	if (event)
+		fsnotify_put_event(event);
+}
+EXPORT_SYMBOL_GPL(fsnotify);
+
+static __init int fsnotify_init(void)
+{
+	return init_srcu_struct(&fsnotify_grp_srcu);
+}
+subsys_initcall(fsnotify_init);
diff -puN /dev/null fs/notify/fsnotify.h
--- /dev/null
+++ a/fs/notify/fsnotify.h
@@ -0,0 +1,15 @@
+#ifndef __FS_NOTIFY_FSNOTIFY_H_
+#define __FS_NOTIFY_FSNOTIFY_H_
+
+#include <linux/list.h>
+#include <linux/fsnotify.h>
+#include <linux/srcu.h>
+#include <linux/types.h>
+
+/* protects reads of fsnotify_groups */
+extern struct srcu_struct fsnotify_grp_srcu;
+/* all groups which receive fsnotify events */
+extern struct list_head fsnotify_groups;
+/* all bitwise OR of all event types (FS_*) for all fsnotify_groups */
+extern __u32 fsnotify_mask;
+#endif	/* __FS_NOTIFY_FSNOTIFY_H_ */
diff -puN /dev/null fs/notify/group.c
--- /dev/null
+++ a/fs/notify/group.c
@@ -0,0 +1,198 @@
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
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/rculist.h>
+#include <linux/wait.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+#include <asm/atomic.h>
+
+/* protects writes to fsnotify_groups and fsnotify_mask */
+static DEFINE_MUTEX(fsnotify_grp_mutex);
+/* protects reads while running the fsnotify_groups list */
+struct srcu_struct fsnotify_grp_srcu;
+/* all groups registered to receive filesystem notifications */
+LIST_HEAD(fsnotify_groups);
+/* bitwise OR of all events (FS_*) interesting to some group on this system */
+__u32 fsnotify_mask;
+
+/*
+ * When a new group registers or changes it's set of interesting events
+ * this function updates the fsnotify_mask to contain all interesting events
+ */
+void fsnotify_recalc_global_mask(void)
+{
+	struct fsnotify_group *group;
+	__u32 mask = 0;
+	int idx;
+
+	idx = srcu_read_lock(&fsnotify_grp_srcu);
+	list_for_each_entry_rcu(group, &fsnotify_groups, group_list)
+		mask |= group->mask;
+	srcu_read_unlock(&fsnotify_grp_srcu, idx);
+	fsnotify_mask = mask;
+}
+
+/*
+ * Take a reference to a group so things found under the fsnotify_grp_mutex
+ * can't get freed under us
+ */
+static void fsnotify_get_group(struct fsnotify_group *group)
+{
+	atomic_inc(&group->refcnt);
+}
+
+/*
+ * Final freeing of a group
+ */
+static void fsnotify_destroy_group(struct fsnotify_group *group)
+{
+	if (group->ops->free_group_priv)
+		group->ops->free_group_priv(group);
+
+	kfree(group);
+}
+
+/*
+ * Remove this group from the global list of groups that will get events
+ * this can be done even if there are still references and things still using
+ * this group.  This just stops the group from getting new events.
+ */
+static void __fsnotify_evict_group(struct fsnotify_group *group)
+{
+	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
+
+	if (group->on_group_list)
+		list_del_rcu(&group->group_list);
+	group->on_group_list = 0;
+}
+
+/*
+ * Called when a group is no longer interested in getting events.  This can be
+ * used if a group is misbehaving or if for some reason a group should no longer
+ * get any filesystem events.
+ */
+void fsnotify_evict_group(struct fsnotify_group *group)
+{
+	mutex_lock(&fsnotify_grp_mutex);
+	__fsnotify_evict_group(group);
+	mutex_unlock(&fsnotify_grp_mutex);
+}
+
+/*
+ * Drop a reference to a group.  Free it if it's through.
+ */
+void fsnotify_put_group(struct fsnotify_group *group)
+{
+	if (!atomic_dec_and_mutex_lock(&group->refcnt, &fsnotify_grp_mutex))
+		return;
+
+	/*
+	 * OK, now we know that there's no other users *and* we hold mutex,
+	 * so no new references will appear
+	 */
+	__fsnotify_evict_group(group);
+
+	/*
+	 * now it's off the list, so the only thing we might care about is
+	 * srcu access....
+	 */
+	mutex_unlock(&fsnotify_grp_mutex);
+	synchronize_srcu(&fsnotify_grp_srcu);
+
+	/* and now it is really dead. _Nothing_ could be seeing it */
+	fsnotify_recalc_global_mask();
+	fsnotify_destroy_group(group);
+}
+
+/*
+ * Simply run the fsnotify_groups list and find a group which matches
+ * the given parameters.  If a group is found we take a reference to that
+ * group.
+ */
+static struct fsnotify_group *fsnotify_find_group(unsigned int group_num, __u32 mask,
+						  const struct fsnotify_ops *ops)
+{
+	struct fsnotify_group *group_iter;
+	struct fsnotify_group *group = NULL;
+
+	BUG_ON(!mutex_is_locked(&fsnotify_grp_mutex));
+
+	list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
+		if (group_iter->group_num == group_num) {
+			if ((group_iter->mask == mask) &&
+			    (group_iter->ops == ops)) {
+				fsnotify_get_group(group_iter);
+				group = group_iter;
+			} else
+				group = ERR_PTR(-EEXIST);
+		}
+	}
+	return group;
+}
+
+/*
+ * Either finds an existing group which matches the group_num, mask, and ops or
+ * creates a new group and adds it to the global group list.  In either case we
+ * take a reference for the group returned.
+ */
+struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask,
+					     const struct fsnotify_ops *ops)
+{
+	struct fsnotify_group *group, *tgroup;
+
+	/* very low use, simpler locking if we just always alloc */
+	group = kmalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	atomic_set(&group->refcnt, 1);
+
+	group->on_group_list = 0;
+	group->group_num = group_num;
+	group->mask = mask;
+
+	group->ops = ops;
+
+	mutex_lock(&fsnotify_grp_mutex);
+	tgroup = fsnotify_find_group(group_num, mask, ops);
+	if (tgroup) {
+		/* group already exists */
+		mutex_unlock(&fsnotify_grp_mutex);
+		/* destroy the new one we made */
+		fsnotify_put_group(group);
+		return tgroup;
+	}
+
+	/* group not found, add a new one */
+	list_add_rcu(&group->group_list, &fsnotify_groups);
+	group->on_group_list = 1;
+
+	mutex_unlock(&fsnotify_grp_mutex);
+
+	if (mask)
+		fsnotify_recalc_global_mask();
+
+	return group;
+}
diff -puN fs/notify/inotify/inotify.c~fsnotify-unified-filesystem-notification-backend fs/notify/inotify/inotify.c
--- a/fs/notify/inotify/inotify.c~fsnotify-unified-filesystem-notification-backend
+++ a/fs/notify/inotify/inotify.c
@@ -32,6 +32,7 @@
 #include <linux/list.h>
 #include <linux/writeback.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify_backend.h>
 
 static atomic_t inotify_cookie;
 
@@ -905,6 +906,25 @@ EXPORT_SYMBOL_GPL(inotify_rm_watch);
  */
 static int __init inotify_setup(void)
 {
+	BUILD_BUG_ON(IN_ACCESS != FS_ACCESS);
+	BUILD_BUG_ON(IN_MODIFY != FS_MODIFY);
+	BUILD_BUG_ON(IN_ATTRIB != FS_ATTRIB);
+	BUILD_BUG_ON(IN_CLOSE_WRITE != FS_CLOSE_WRITE);
+	BUILD_BUG_ON(IN_CLOSE_NOWRITE != FS_CLOSE_NOWRITE);
+	BUILD_BUG_ON(IN_OPEN != FS_OPEN);
+	BUILD_BUG_ON(IN_MOVED_FROM != FS_MOVED_FROM);
+	BUILD_BUG_ON(IN_MOVED_TO != FS_MOVED_TO);
+	BUILD_BUG_ON(IN_CREATE != FS_CREATE);
+	BUILD_BUG_ON(IN_DELETE != FS_DELETE);
+	BUILD_BUG_ON(IN_DELETE_SELF != FS_DELETE_SELF);
+	BUILD_BUG_ON(IN_MOVE_SELF != FS_MOVE_SELF);
+	BUILD_BUG_ON(IN_Q_OVERFLOW != FS_Q_OVERFLOW);
+
+	BUILD_BUG_ON(IN_UNMOUNT != FS_UNMOUNT);
+	BUILD_BUG_ON(IN_ISDIR != FS_IN_ISDIR);
+	BUILD_BUG_ON(IN_IGNORED != FS_IN_IGNORED);
+	BUILD_BUG_ON(IN_ONESHOT != FS_IN_ONESHOT);
+
 	atomic_set(&inotify_cookie, 0);
 
 	return 0;
diff -puN /dev/null fs/notify/notification.c
--- /dev/null
+++ a/fs/notify/notification.c
@@ -0,0 +1,121 @@
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
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mount.h>
+#include <linux/mutex.h>
+#include <linux/namei.h>
+#include <linux/path.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/atomic.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+static struct kmem_cache *fsnotify_event_cachep;
+
+void fsnotify_get_event(struct fsnotify_event *event)
+{
+	atomic_inc(&event->refcnt);
+}
+
+void fsnotify_put_event(struct fsnotify_event *event)
+{
+	if (!event)
+		return;
+
+	if (atomic_dec_and_test(&event->refcnt)) {
+		if (event->data_type == FSNOTIFY_EVENT_PATH)
+			path_put(&event->path);
+
+		kmem_cache_free(fsnotify_event_cachep, event);
+	}
+}
+
+/*
+ * Allocate a new event which will be sent to each group's handle_event function
+ * if the group was interested in this particular event.
+ */
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
+					     void *data, int data_type)
+{
+	struct fsnotify_event *event;
+
+	event = kmem_cache_alloc(fsnotify_event_cachep, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	atomic_set(&event->refcnt, 1);
+
+	spin_lock_init(&event->lock);
+
+	event->path.dentry = NULL;
+	event->path.mnt = NULL;
+	event->inode = NULL;
+
+	event->to_tell = to_tell;
+
+	switch (data_type) {
+	case FSNOTIFY_EVENT_FILE: {
+		struct file *file = data;
+		struct path *path = &file->f_path;
+		event->path.dentry = path->dentry;
+		event->path.mnt = path->mnt;
+		path_get(&event->path);
+		event->data_type = FSNOTIFY_EVENT_PATH;
+		break;
+	}
+	case FSNOTIFY_EVENT_PATH: {
+		struct path *path = data;
+		event->path.dentry = path->dentry;
+		event->path.mnt = path->mnt;
+		path_get(&event->path);
+		event->data_type = FSNOTIFY_EVENT_PATH;
+		break;
+	}
+	case FSNOTIFY_EVENT_INODE:
+		event->inode = data;
+		event->data_type = FSNOTIFY_EVENT_INODE;
+		break;
+	case FSNOTIFY_EVENT_NONE:
+		event->inode = NULL;
+		event->path.dentry = NULL;
+		event->path.mnt = NULL;
+		break;
+	default:
+		BUG();
+	}
+
+	event->mask = mask;
+
+	return event;
+}
+
+__init int fsnotify_notification_init(void)
+{
+	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
+
+	return 0;
+}
+subsys_initcall(fsnotify_notification_init);
+
diff -puN include/linux/fsnotify.h~fsnotify-unified-filesystem-notification-backend include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~fsnotify-unified-filesystem-notification-backend
+++ a/include/linux/fsnotify.h
@@ -13,6 +13,7 @@
 
 #include <linux/dnotify.h>
 #include <linux/inotify.h>
+#include <linux/fsnotify_backend.h>
 #include <linux/audit.h>
 
 /*
@@ -35,6 +36,16 @@ static inline void fsnotify_d_move(struc
 }
 
 /*
+ * fsnotify_link_count - inode's link count changed
+ */
+static inline void fsnotify_link_count(struct inode *inode)
+{
+	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+
+	fsnotify(inode, FS_ATTRIB, inode, FSNOTIFY_EVENT_INODE);
+}
+
+/*
  * fsnotify_move - file old_name at old_dir was moved to new_name at new_dir
  */
 static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
@@ -43,28 +54,47 @@ static inline void fsnotify_move(struct 
 {
 	struct inode *source = moved->d_inode;
 	u32 cookie = inotify_get_cookie();
+	__u32 old_dir_mask = 0;
+	__u32 new_dir_mask = 0;
 
-	if (old_dir == new_dir)
+	if (old_dir == new_dir) {
 		inode_dir_notify(old_dir, DN_RENAME);
-	else {
+		old_dir_mask = FS_DN_RENAME;
+	} else {
 		inode_dir_notify(old_dir, DN_DELETE);
+		old_dir_mask = FS_DELETE;
 		inode_dir_notify(new_dir, DN_CREATE);
+		new_dir_mask = FS_CREATE;
 	}
 
-	if (isdir)
+	if (isdir) {
 		isdir = IN_ISDIR;
+		old_dir_mask |= FS_IN_ISDIR;
+		new_dir_mask |= FS_IN_ISDIR;
+	}
+
+	old_dir_mask |= FS_MOVED_FROM;
+	new_dir_mask |= FS_MOVED_TO;
+
 	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir,cookie,old_name,
 				  source);
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, cookie, new_name,
 				  source);
 
+	fsnotify(old_dir, old_dir_mask, old_dir, FSNOTIFY_EVENT_INODE);
+	fsnotify(new_dir, new_dir_mask, new_dir, FSNOTIFY_EVENT_INODE);
+
 	if (target) {
 		inotify_inode_queue_event(target, IN_DELETE_SELF, 0, NULL, NULL);
 		inotify_inode_is_dead(target);
+
+		/* this is really a link_count change not a removal */
+		fsnotify_link_count(target);
 	}
 
 	if (source) {
 		inotify_inode_queue_event(source, IN_MOVE_SELF, 0, NULL, NULL);
+		fsnotify(source, FS_MOVE_SELF, moved->d_inode, FSNOTIFY_EVENT_INODE);
 	}
 	audit_inode_child(new_name, moved, new_dir);
 }
@@ -74,10 +104,12 @@ static inline void fsnotify_move(struct 
  */
 static inline void fsnotify_nameremove(struct dentry *dentry, int isdir)
 {
+	__u32 mask = FS_DELETE;
+
 	if (isdir)
-		isdir = IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 	dnotify_parent(dentry, DN_DELETE);
-	inotify_dentry_parent_queue_event(dentry, IN_DELETE|isdir, 0, dentry->d_name.name);
+	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 }
 
 /*
@@ -87,14 +119,8 @@ static inline void fsnotify_inoderemove(
 {
 	inotify_inode_queue_event(inode, IN_DELETE_SELF, 0, NULL, NULL);
 	inotify_inode_is_dead(inode);
-}
 
-/*
- * fsnotify_link_count - inode's link count changed
- */
-static inline void fsnotify_link_count(struct inode *inode)
-{
-	inotify_inode_queue_event(inode, IN_ATTRIB, 0, NULL, NULL);
+	fsnotify(inode, FS_DELETE_SELF, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -106,6 +132,8 @@ static inline void fsnotify_create(struc
 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
+
+	fsnotify(inode, FS_CREATE, dentry->d_inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -120,6 +148,8 @@ static inline void fsnotify_link(struct 
 				  inode);
 	fsnotify_link_count(inode);
 	audit_inode_child(new_dentry->d_name.name, new_dentry, dir);
+
+	fsnotify(dir, FS_CREATE, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -127,10 +157,14 @@ static inline void fsnotify_link(struct 
  */
 static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 {
+	__u32 mask = (FS_CREATE | FS_IN_ISDIR);
+	struct inode *d_inode = dentry->d_inode;
+
 	inode_dir_notify(inode, DN_CREATE);
-	inotify_inode_queue_event(inode, IN_CREATE | IN_ISDIR, 0, 
-				  dentry->d_name.name, dentry->d_inode);
+	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
+
+	fsnotify(inode, mask, d_inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -139,14 +173,16 @@ static inline void fsnotify_mkdir(struct
 static inline void fsnotify_access(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_ACCESS;
+	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	dnotify_parent(dentry, DN_ACCESS);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -155,14 +191,16 @@ static inline void fsnotify_access(struc
 static inline void fsnotify_modify(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_MODIFY;
+	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	dnotify_parent(dentry, DN_MODIFY);
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -171,13 +209,15 @@ static inline void fsnotify_modify(struc
 static inline void fsnotify_open(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_OPEN;
+	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -189,13 +229,15 @@ static inline void fsnotify_close(struct
 	struct inode *inode = dentry->d_inode;
 	const char *name = dentry->d_name.name;
 	fmode_t mode = file->f_mode;
-	u32 mask = (mode & FMODE_WRITE) ? IN_CLOSE_WRITE : IN_CLOSE_NOWRITE;
+	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, file, FSNOTIFY_EVENT_FILE);
 }
 
 /*
@@ -204,13 +246,15 @@ static inline void fsnotify_close(struct
 static inline void fsnotify_xattr(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	u32 mask = IN_ATTRIB;
+	__u32 mask = FS_ATTRIB;
 
 	if (S_ISDIR(inode->i_mode))
-		mask |= IN_ISDIR;
+		mask |= FS_IN_ISDIR;
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
+
+	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 }
 
 /*
@@ -221,34 +265,34 @@ static inline void fsnotify_change(struc
 {
 	struct inode *inode = dentry->d_inode;
 	int dn_mask = 0;
-	u32 in_mask = 0;
+	__u32 in_mask = 0;
 
 	if (ia_valid & ATTR_UID) {
-		in_mask |= IN_ATTRIB;
+		in_mask |= FS_ATTRIB;
 		dn_mask |= DN_ATTRIB;
 	}
 	if (ia_valid & ATTR_GID) {
-		in_mask |= IN_ATTRIB;
+		in_mask |= FS_ATTRIB;
 		dn_mask |= DN_ATTRIB;
 	}
 	if (ia_valid & ATTR_SIZE) {
-		in_mask |= IN_MODIFY;
+		in_mask |= FS_MODIFY;
 		dn_mask |= DN_MODIFY;
 	}
 	/* both times implies a utime(s) call */
 	if ((ia_valid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME))
 	{
-		in_mask |= IN_ATTRIB;
+		in_mask |= FS_ATTRIB;
 		dn_mask |= DN_ATTRIB;
 	} else if (ia_valid & ATTR_ATIME) {
-		in_mask |= IN_ACCESS;
+		in_mask |= FS_ACCESS;
 		dn_mask |= DN_ACCESS;
 	} else if (ia_valid & ATTR_MTIME) {
-		in_mask |= IN_MODIFY;
+		in_mask |= FS_MODIFY;
 		dn_mask |= DN_MODIFY;
 	}
 	if (ia_valid & ATTR_MODE) {
-		in_mask |= IN_ATTRIB;
+		in_mask |= FS_ATTRIB;
 		dn_mask |= DN_ATTRIB;
 	}
 
@@ -256,14 +300,15 @@ static inline void fsnotify_change(struc
 		dnotify_parent(dentry, dn_mask);
 	if (in_mask) {
 		if (S_ISDIR(inode->i_mode))
-			in_mask |= IN_ISDIR;
+			in_mask |= FS_IN_ISDIR;
 		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
 		inotify_dentry_parent_queue_event(dentry, in_mask, 0,
 						  dentry->d_name.name);
+		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
 
-#ifdef CONFIG_INOTIFY	/* inotify helpers */
+#if defined(CONFIG_INOTIFY) || defined(CONFIG_FSNOTIFY)	/* notify helpers */
 
 /*
  * fsnotify_oldname_init - save off the old filename before we change it
@@ -281,7 +326,7 @@ static inline void fsnotify_oldname_free
 	kfree(old_name);
 }
 
-#else	/* CONFIG_INOTIFY */
+#else	/* CONFIG_INOTIFY || CONFIG_FSNOTIFY */
 
 static inline const char *fsnotify_oldname_init(const char *name)
 {
diff -puN /dev/null include/linux/fsnotify_backend.h
--- /dev/null
+++ a/include/linux/fsnotify_backend.h
@@ -0,0 +1,177 @@
+/*
+ * Filesystem access notification for Linux
+ *
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ */
+
+#ifndef __LINUX_FSNOTIFY_BACKEND_H
+#define __LINUX_FSNOTIFY_BACKEND_H
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h> /* struct inode */
+#include <linux/list.h>
+#include <linux/path.h> /* struct path */
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#include <asm/atomic.h>
+
+/*
+ * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
+ * convert between them.  dnotify only needs conversion at watch creation
+ * so no perf loss there.  fanotify isn't defined yet, so it can use the
+ * wholes if it needs more events.
+ */
+#define FS_ACCESS		0x00000001	/* File was accessed */
+#define FS_MODIFY		0x00000002	/* File was modified */
+#define FS_ATTRIB		0x00000004	/* Metadata changed */
+#define FS_CLOSE_WRITE		0x00000008	/* Writtable file was closed */
+#define FS_CLOSE_NOWRITE	0x00000010	/* Unwrittable file closed */
+#define FS_OPEN			0x00000020	/* File was opened */
+#define FS_MOVED_FROM		0x00000040	/* File was moved from X */
+#define FS_MOVED_TO		0x00000080	/* File was moved to Y */
+#define FS_CREATE		0x00000100	/* Subfile was created */
+#define FS_DELETE		0x00000200	/* Subfile was deleted */
+#define FS_DELETE_SELF		0x00000400	/* Self was deleted */
+#define FS_MOVE_SELF		0x00000800	/* Self was moved */
+
+#define FS_UNMOUNT		0x00002000	/* inode on umount fs */
+#define FS_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
+#define FS_IN_IGNORED		0x00008000	/* last inotify event here */
+
+#define FS_IN_ISDIR		0x40000000	/* event occurred against dir */
+#define FS_IN_ONESHOT		0x80000000	/* only send event once */
+
+#define FS_DN_RENAME		0x10000000	/* file renamed */
+#define FS_DN_MULTISHOT		0x20000000	/* dnotify multishot */
+
+struct fsnotify_group;
+struct fsnotify_event;
+
+/*
+ * Each group much define these ops.  The fsnotify infrastructure will call
+ * these operations for each relevant group.
+ *
+ * handle_event - main call for a group to handle an fs event
+ * free_group_priv - called when a group refcnt hits 0 to clean up the private union
+ */
+struct fsnotify_ops {
+	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
+	void (*free_group_priv)(struct fsnotify_group *group);
+};
+
+/*
+ * A group is a "thing" that wants to receive notification about filesystem
+ * events.  The mask holds the subset of event types this group cares about.
+ * refcnt on a group is up to the implementor and at any moment if it goes 0
+ * everything will be cleaned up.
+ */
+struct fsnotify_group {
+	/*
+	 * global list of all groups receiving events from fsnotify.
+	 * anchored by fsnotify_groups and protected by either fsnotify_grp_mutex
+	 * or fsnotify_grp_srcu depending on write vs read.
+	 */
+	struct list_head group_list;
+
+	/*
+	 * Defines all of the event types in which this group is interested.
+	 * This mask is a bitwise OR of the FS_* events from above.  Each time
+	 * this mask changes for a group (if it changes) the correct functions
+	 * must be called to update the global structures which indicate global
+	 * interest in event types.
+	 */
+	__u32 mask;
+
+	/*
+	 * How the refcnt is used is up to each group.  When the refcnt hits 0
+	 * fsnotify will clean up all of the resources associated with this group.
+	 * As an example, the dnotify group will always have a refcnt=1 and that
+	 * will never change.  Inotify, on the other hand, has a group per
+	 * inotify_init() and the refcnt will hit 0 only when that fd has been
+	 * closed.
+	 */
+	atomic_t refcnt;		/* things with interest in this group */
+	unsigned int group_num;		/* simply prevents accidental group collision */
+
+	const struct fsnotify_ops *ops;	/* how this group handles things */
+
+	/* prevents double list_del of group_list.  protected by global fsnotify_gr_mutex */
+	bool on_group_list;
+
+	/* groups can define private fields here or use the void *private */
+	union {
+		void *private;
+	};
+};
+
+/*
+ * all of the information about the original object we want to now send to
+ * a group.  If you want to carry more info from the accessing task to the
+ * listener this structure is where you need to be adding fields.
+ */
+struct fsnotify_event {
+	spinlock_t lock;	/* protection for the associated event_holder and private_list */
+	/* to_tell may ONLY be dereferenced during handle_event(). */
+	struct inode *to_tell;	/* either the inode the event happened to or its parent */
+	/*
+	 * depending on the event type we should have either a path or inode
+	 * We hold a reference on path, but NOT on inode.  Since we have the ref on
+	 * the path, it may be dereferenced at any point during this object's
+	 * lifetime.  That reference is dropped when this object's refcnt hits
+	 * 0.  If this event contains an inode instead of a path, the inode may
+	 * ONLY be used during handle_event().
+	 */
+	union {
+		struct path path;
+		struct inode *inode;
+	};
+/* when calling fsnotify tell it if the data is a path or inode */
+#define FSNOTIFY_EVENT_NONE	0
+#define FSNOTIFY_EVENT_PATH	1
+#define FSNOTIFY_EVENT_INODE	2
+#define FSNOTIFY_EVENT_FILE	3
+	int data_type;		/* which of the above union we have */
+	atomic_t refcnt;	/* how many groups still are using/need to send this event */
+	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
+};
+
+#ifdef CONFIG_FSNOTIFY
+
+/* called from the vfs helpers */
+
+/* main fsnotify call to send events */
+extern void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is);
+
+
+/* called from fsnotify listeners, such as fanotify or dnotify */
+
+/* must call when a group changes its ->mask */
+extern void fsnotify_recalc_global_mask(void);
+/* get a reference to an existing or create a new group */
+extern struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num,
+						    __u32 mask,
+						    const struct fsnotify_ops *ops);
+/* drop reference on a group from fsnotify_obtain_group */
+extern void fsnotify_put_group(struct fsnotify_group *group);
+
+/* take a reference to an event */
+extern void fsnotify_get_event(struct fsnotify_event *event);
+extern void fsnotify_put_event(struct fsnotify_event *event);
+/* find private data previously attached to an event */
+extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group,
+									struct fsnotify_event *event);
+
+/* put here because inotify does some weird stuff when destroying watches */
+extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
+						    void *data, int data_is);
+#else
+
+static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is)
+{}
+#endif	/* CONFIG_FSNOTIFY */
+
+#endif	/* __KERNEL __ */
+
+#endif	/* __LINUX_FSNOTIFY_BACKEND_H */
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

