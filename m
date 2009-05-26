From: akpm@linux-foundation.org
Subject: [wrecked] dnotify-reimplement-dnotify-using-fsnotify.patch removed from -mm tree
Date: Tue, 26 May 2009 12:34:19 -0700
Message-ID: <200905261934.n4QJYJmr005522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbZEZTer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     dnotify: reimplement dnotify using fsnotify
has been removed from the -mm tree.  Its filename was
     dnotify-reimplement-dnotify-using-fsnotify.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dnotify: reimplement dnotify using fsnotify
From: Eric Paris <eparis@redhat.com>

Reimplement dnotify using fsnotify.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                      |    2 
 fs/notify/dnotify/Kconfig        |    1 
 fs/notify/dnotify/dnotify.c      |  469 ++++++++++++++++++++++-------
 include/linux/dnotify.h          |   29 -
 include/linux/fs.h               |    5 
 include/linux/fsnotify.h         |   68 +---
 include/linux/fsnotify_backend.h |    3 
 7 files changed, 397 insertions(+), 180 deletions(-)

diff -puN MAINTAINERS~dnotify-reimplement-dnotify-using-fsnotify MAINTAINERS
--- a/MAINTAINERS~dnotify-reimplement-dnotify-using-fsnotify
+++ a/MAINTAINERS
@@ -1792,6 +1792,8 @@ F:	drivers/char/digi*
 DIRECTORY NOTIFICATION (DNOTIFY)
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
+P:	Eric Paris
+M:	eparis@parisplace.org
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	Documentation/filesystems/dnotify.txt
diff -puN fs/notify/dnotify/Kconfig~dnotify-reimplement-dnotify-using-fsnotify fs/notify/dnotify/Kconfig
--- a/fs/notify/dnotify/Kconfig~dnotify-reimplement-dnotify-using-fsnotify
+++ a/fs/notify/dnotify/Kconfig
@@ -1,5 +1,6 @@
 config DNOTIFY
 	bool "Dnotify support"
+	depends on FSNOTIFY
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
diff -puN fs/notify/dnotify/dnotify.c~dnotify-reimplement-dnotify-using-fsnotify fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~dnotify-reimplement-dnotify-using-fsnotify
+++ a/fs/notify/dnotify/dnotify.c
@@ -3,6 +3,9 @@
  *
  * Copyright (C) 2000,2001,2002 Stephen Rothwell
  *
+ * Copyright (C) 2009 Eric Paris <Red Hat Inc>
+ * dnotify was largly rewritten to use the new fsnotify infrastructure
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -21,24 +24,178 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/fdtable.h>
+#include <linux/fsnotify_backend.h>
 
 int dir_notify_enable __read_mostly = 1;
 
-static struct kmem_cache *dn_cache __read_mostly;
+static struct kmem_cache *dnotify_struct_cache __read_mostly;
+static struct kmem_cache *dnotify_mark_entry_cache __read_mostly;
+static struct fsnotify_group *dnotify_group __read_mostly;
+static DEFINE_MUTEX(dnotify_mark_mutex);
+
+/*
+ * dnotify will attach one of these to each inode (i_fsnotify_mark_entries) which
+ * is being watched by dnotify.  If multiple userspace applications are watching
+ * the same directory with dnotify their information is chained in dn
+ */
+struct dnotify_mark_entry {
+	struct fsnotify_mark_entry fsn_entry;
+	struct dnotify_struct *dn;
+};
 
-static void redo_inode_mask(struct inode *inode)
+/*
+ * When a process starts or stops watching an inode the set of events which
+ * dnotify cares about for that inode may change.  This function runs the
+ * list of everything receiving dnotify events about this directory and calculates
+ * the set of all those events.  After it updates what dnotify is interested in
+ * it calls the fsnotify function so it can update the set of all events relevant
+ * to this inode.
+ */
+static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
 {
-	unsigned long new_mask;
+	__u32 new_mask, old_mask;
 	struct dnotify_struct *dn;
+	struct dnotify_mark_entry *dnentry  = container_of(entry,
+							   struct dnotify_mark_entry,
+							   fsn_entry);
+
+	assert_spin_locked(&entry->lock);
 
+	old_mask = entry->mask;
 	new_mask = 0;
-	for (dn = inode->i_dnotify; dn != NULL; dn = dn->dn_next)
-		new_mask |= dn->dn_mask & ~DN_MULTISHOT;
-	inode->i_dnotify_mask = new_mask;
+	for (dn = dnentry->dn; dn != NULL; dn = dn->dn_next)
+		new_mask |= (dn->dn_mask & ~FS_DN_MULTISHOT);
+	entry->mask = new_mask;
+
+	if (old_mask == new_mask)
+		return;
+
+	if (entry->inode)
+		fsnotify_recalc_inode_mask(entry->inode);
+}
+
+/*
+ * Mains fsnotify call where events are delivered to dnotify.
+ * Find the dnotify mark on the relevant inode, run the list of dnotify structs
+ * on that mark and determine which of them has expressed interest in receiving
+ * events of this type.  When found send the correct process and signal and
+ * destroy the dnotify struct if it was not registered to receive multiple
+ * events.
+ */
+static int dnotify_handle_event(struct fsnotify_group *group,
+				struct fsnotify_event *event)
+{
+	struct fsnotify_mark_entry *entry = NULL;
+	struct dnotify_mark_entry *dnentry;
+	struct inode *to_tell;
+	struct dnotify_struct *dn;
+	struct dnotify_struct **prev;
+	struct fown_struct *fown;
+
+	to_tell = event->to_tell;
+
+	spin_lock(&to_tell->i_lock);
+	entry = fsnotify_find_mark_entry(group, to_tell);
+	spin_unlock(&to_tell->i_lock);
+
+	/* unlikely since we alreay passed dnotify_should_send_event() */
+	if (unlikely(!entry))
+		return 0;
+	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+
+	spin_lock(&entry->lock);
+	prev = &dnentry->dn;
+	while ((dn = *prev) != NULL) {
+		if ((dn->dn_mask & event->mask) == 0) {
+			prev = &dn->dn_next;
+			continue;
+		}
+		fown = &dn->dn_filp->f_owner;
+		send_sigio(fown, dn->dn_fd, POLL_MSG);
+		if (dn->dn_mask & FS_DN_MULTISHOT)
+			prev = &dn->dn_next;
+		else {
+			*prev = dn->dn_next;
+			kmem_cache_free(dnotify_struct_cache, dn);
+			dnotify_recalc_inode_mask(entry);
+		}
+	}
+
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry);
+
+	return 0;
+}
+
+/*
+ * Given an inode and mask determine if dnotify would be interested in sending
+ * userspace notification for that pair.
+ */
+static bool dnotify_should_send_event(struct fsnotify_group *group,
+				      struct inode *inode, __u32 mask)
+{
+	struct fsnotify_mark_entry *entry;
+	bool send;
+
+	/* !dir_notify_enable should never get here, don't waste time checking
+	if (!dir_notify_enable)
+		return 0; */
+
+	/* not a dir, dnotify doesn't care */
+	if (!S_ISDIR(inode->i_mode))
+		return false;
+
+	spin_lock(&inode->i_lock);
+	entry = fsnotify_find_mark_entry(group, inode);
+	spin_unlock(&inode->i_lock);
+
+	/* no mark means no dnotify watch */
+	if (!entry)
+		return false;
+
+	spin_lock(&entry->lock);
+	send = (mask & entry->mask) ? true : false;
+	spin_unlock(&entry->lock);
+	fsnotify_put_mark(entry); /* matches fsnotify_find_mark_entry */
+
+	return send;
+}
+
+static void dnotify_freeing_mark(struct fsnotify_mark_entry *entry,
+				 struct fsnotify_group *group)
+{
+	/* dnotify doesn't care than an inode is on the way out */
+}
+
+static void dnotify_free_mark(struct fsnotify_mark_entry *entry)
+{
+	struct dnotify_mark_entry *dnentry = container_of(entry,
+							  struct dnotify_mark_entry,
+							  fsn_entry);
+
+	BUG_ON(dnentry->dn);
+
+	kmem_cache_free(dnotify_mark_entry_cache, dnentry);
 }
 
+static struct fsnotify_ops dnotify_fsnotify_ops = {
+	.handle_event = dnotify_handle_event,
+	.should_send_event = dnotify_should_send_event,
+	.free_group_priv = NULL,
+	.freeing_mark = dnotify_freeing_mark,
+};
+
+/*
+ * Called every time a file is closed.  Looks first for a dnotify mark on the
+ * inode.  If one is found run all of the ->dn entries attached to that
+ * mark for one relevant to this process closing the file and remove that
+ * dnotify_struct.  If that was the last dnotify_struct also remove the
+ * fsnotify_mark_entry.
+ */
 void dnotify_flush(struct file *filp, fl_owner_t id)
 {
+	struct fsnotify_mark_entry *entry;
+	struct dnotify_mark_entry *dnentry;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct inode *inode;
@@ -46,145 +203,243 @@ void dnotify_flush(struct file *filp, fl
 	inode = filp->f_path.dentry->d_inode;
 	if (!S_ISDIR(inode->i_mode))
 		return;
+
 	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
+	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	spin_unlock(&inode->i_lock);
+	if (!entry)
+		return;
+	dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+
+	mutex_lock(&dnotify_mark_mutex);
+
+	spin_lock(&entry->lock);
+	prev = &dnentry->dn;
 	while ((dn = *prev) != NULL) {
 		if ((dn->dn_owner == id) && (dn->dn_filp == filp)) {
 			*prev = dn->dn_next;
-			redo_inode_mask(inode);
-			kmem_cache_free(dn_cache, dn);
+			kmem_cache_free(dnotify_struct_cache, dn);
+			dnotify_recalc_inode_mask(entry);
 			break;
 		}
 		prev = &dn->dn_next;
 	}
-	spin_unlock(&inode->i_lock);
+
+	spin_unlock(&entry->lock);
+
+	/* nothing else could have found us thanks to the dnotify_mark_mutex */
+	if (dnentry->dn == NULL)
+		fsnotify_destroy_mark_by_entry(entry);
+
+	fsnotify_recalc_group_mask(dnotify_group);
+
+	mutex_unlock(&dnotify_mark_mutex);
+
+	fsnotify_put_mark(entry);
+}
+
+/* this conversion is done only at watch creation */
+static __u32 convert_arg(unsigned long arg)
+{
+	__u32 new_mask = FS_EVENT_ON_CHILD;
+
+	if (arg & DN_MULTISHOT)
+		new_mask |= FS_DN_MULTISHOT;
+	if (arg & DN_DELETE)
+		new_mask |= (FS_DELETE | FS_MOVED_FROM);
+	if (arg & DN_MODIFY)
+		new_mask |= FS_MODIFY;
+	if (arg & DN_ACCESS)
+		new_mask |= FS_ACCESS;
+	if (arg & DN_ATTRIB)
+		new_mask |= FS_ATTRIB;
+	if (arg & DN_RENAME)
+		new_mask |= FS_DN_RENAME;
+	if (arg & DN_CREATE)
+		new_mask |= (FS_CREATE | FS_MOVED_TO);
+
+	return new_mask;
 }
 
+/*
+ * If multiple processes watch the same inode with dnotify there is only one
+ * dnotify mark in inode->i_fsnotify_mark_entries but we chain a dnotify_struct
+ * onto that mark.  This function either attaches the new dnotify_struct onto
+ * that list, or it |= the mask onto an existing dnofiy_struct.
+ */
+static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnentry,
+		     fl_owner_t id, int fd, struct file *filp, __u32 mask)
+{
+	struct dnotify_struct *odn;
+
+	odn = dnentry->dn;
+	while (odn != NULL) {
+		/* adding more events to existing dnofiy_struct? */
+		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
+			odn->dn_fd = fd;
+			odn->dn_mask |= mask;
+			return -EEXIST;
+		}
+		odn = odn->dn_next;
+	}
+
+	dn->dn_mask = mask;
+	dn->dn_fd = fd;
+	dn->dn_filp = filp;
+	dn->dn_owner = id;
+	dn->dn_next = dnentry->dn;
+	dnentry->dn = dn;
+
+	return 0;
+}
+
+/*
+ * When a process calls fcntl to attach a dnotify watch to a directory it ends
+ * up here.  Allocate both a mark for fsnotify to add and a dnotify_struct to be
+ * attached to the fsnotify_mark.
+ */
 int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
+	struct dnotify_mark_entry *new_dnentry, *dnentry;
+	struct fsnotify_mark_entry *new_entry, *entry;
 	struct dnotify_struct *dn;
-	struct dnotify_struct *odn;
-	struct dnotify_struct **prev;
 	struct inode *inode;
 	fl_owner_t id = current->files;
 	struct file *f;
-	int error = 0;
+	int destroy = 0, error = 0;
+	__u32 mask;
+
+	/* we use these to tell if we need to kfree */
+	new_entry = NULL;
+	dn = NULL;
+
+	if (!dir_notify_enable) {
+		error = -EINVAL;
+		goto out_err;
+	}
 
+	/* a 0 mask means we are explicitly removing the watch */
 	if ((arg & ~DN_MULTISHOT) == 0) {
 		dnotify_flush(filp, id);
-		return 0;
+		error = 0;
+		goto out_err;
 	}
-	if (!dir_notify_enable)
-		return -EINVAL;
+
+	/* dnotify only works on directories */
 	inode = filp->f_path.dentry->d_inode;
-	if (!S_ISDIR(inode->i_mode))
-		return -ENOTDIR;
-	dn = kmem_cache_alloc(dn_cache, GFP_KERNEL);
-	if (dn == NULL)
-		return -ENOMEM;
-	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
-	while ((odn = *prev) != NULL) {
-		if ((odn->dn_owner == id) && (odn->dn_filp == filp)) {
-			odn->dn_fd = fd;
-			odn->dn_mask |= arg;
-			inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-			goto out_free;
-		}
-		prev = &odn->dn_next;
+	if (!S_ISDIR(inode->i_mode)) {
+		error = -ENOTDIR;
+		goto out_err;
 	}
 
-	rcu_read_lock();
-	f = fcheck(fd);
-	rcu_read_unlock();
-	/* we'd lost the race with close(), sod off silently */
-	/* note that inode->i_lock prevents reordering problems
-	 * between accesses to descriptor table and ->i_dnotify */
-	if (f != filp)
-		goto out_free;
+	/* expect most fcntl to add new rather than augment old */
+	dn = kmem_cache_alloc(dnotify_struct_cache, GFP_KERNEL);
+	if (!dn) {
+		error = -ENOMEM;
+		goto out_err;
+	}
 
-	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
-	if (error)
-		goto out_free;
+	/* new fsnotify mark, we expect most fcntl calls to add a new mark */
+	new_dnentry = kmem_cache_alloc(dnotify_mark_entry_cache, GFP_KERNEL);
+	if (!new_dnentry) {
+		error = -ENOMEM;
+		goto out_err;
+	}
 
-	dn->dn_mask = arg;
-	dn->dn_fd = fd;
-	dn->dn_filp = filp;
-	dn->dn_owner = id;
-	inode->i_dnotify_mask |= arg & ~DN_MULTISHOT;
-	dn->dn_next = inode->i_dnotify;
-	inode->i_dnotify = dn;
-	spin_unlock(&inode->i_lock);
-	return 0;
+	/* convert the userspace DN_* "arg" to the internal FS_* defines in fsnotify */
+	mask = convert_arg(arg);
 
-out_free:
-	spin_unlock(&inode->i_lock);
-	kmem_cache_free(dn_cache, dn);
-	return error;
-}
+	/* set up the new_entry and new_dnentry */
+	new_entry = &new_dnentry->fsn_entry;
+	fsnotify_init_mark(new_entry, dnotify_free_mark);
+	new_entry->mask = mask;
+	new_dnentry->dn = NULL;
 
-void __inode_dir_notify(struct inode *inode, unsigned long event)
-{
-	struct dnotify_struct *	dn;
-	struct dnotify_struct **prev;
-	struct fown_struct *	fown;
-	int			changed = 0;
+	/* this is needed to prevent the fcntl/close race described below */
+	mutex_lock(&dnotify_mark_mutex);
 
+	/* add the new_entry or find an old one. */
 	spin_lock(&inode->i_lock);
-	prev = &inode->i_dnotify;
-	while ((dn = *prev) != NULL) {
-		if ((dn->dn_mask & event) == 0) {
-			prev = &dn->dn_next;
-			continue;
-		}
-		fown = &dn->dn_filp->f_owner;
-		send_sigio(fown, dn->dn_fd, POLL_MSG);
-		if (dn->dn_mask & DN_MULTISHOT)
-			prev = &dn->dn_next;
-		else {
-			*prev = dn->dn_next;
-			changed = 1;
-			kmem_cache_free(dn_cache, dn);
-		}
-	}
-	if (changed)
-		redo_inode_mask(inode);
+	entry = fsnotify_find_mark_entry(dnotify_group, inode);
 	spin_unlock(&inode->i_lock);
-}
-
-EXPORT_SYMBOL(__inode_dir_notify);
+	if (entry) {
+		dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
+		spin_lock(&entry->lock);
+	} else {
+		fsnotify_add_mark(new_entry, dnotify_group, inode);
+		spin_lock(&new_entry->lock);
+		entry = new_entry;
+		dnentry = new_dnentry;
+		/* we used new_entry, so don't free it */
+		new_entry = NULL;
+	}
 
-/*
- * This is hopelessly wrong, but unfixable without API changes.  At
- * least it doesn't oops the kernel...
- *
- * To safely access ->d_parent we need to keep d_move away from it.  Use the
- * dentry's d_lock for this.
- */
-void dnotify_parent(struct dentry *dentry, unsigned long event)
-{
-	struct dentry *parent;
+	rcu_read_lock();
+	f = fcheck(fd);
+	rcu_read_unlock();
 
-	if (!dir_notify_enable)
-		return;
+	/* if (f != filp) means that we lost a race and another task/thread
+	 * actually closed the fd we are still playing with before we grabbed
+	 * the dnotify_mark_mutex and entry->lock.  Since closing the fd is the
+	 * only time we clean up the mark entries we need to get our mark off
+	 * the list. */
+	if (f != filp) {
+		/* if we added ourselves, shoot ourselves, it's possible that
+		 * the flush actually did shoot this entry.  That's fine too
+		 * since multiple calls to destroy_mark is perfectly safe, if
+		 * we found a dnentry already attached to the inode, just sod
+		 * off silently as the flush at close time dealt with it.
+		 */
+		if (dnentry == new_dnentry)
+			destroy = 1;
+		goto out;
+	}
 
-	spin_lock(&dentry->d_lock);
-	parent = dentry->d_parent;
-	if (parent->d_inode->i_dnotify_mask & event) {
-		dget(parent);
-		spin_unlock(&dentry->d_lock);
-		__inode_dir_notify(parent->d_inode, event);
-		dput(parent);
-	} else {
-		spin_unlock(&dentry->d_lock);
+	error = __f_setown(filp, task_pid(current), PIDTYPE_PID, 0);
+	if (error) {
+		/* if we added, we must shoot */
+		if (dnentry == new_dnentry)
+			destroy = 1;
+		goto out;
 	}
+
+	error = attach_dn(dn, dnentry, id, fd, filp, mask);
+	/* !error means that we attached the dn to the dnentry, so don't free it */
+	if (!error)
+		dn = NULL;
+	/* -EEXIST means that we didn't add this new dn and used an old one.
+	 * that isn't an error (and the unused dn should be freed) */
+	else if (error == -EEXIST)
+		error = 0;
+
+	dnotify_recalc_inode_mask(entry);
+out:
+	spin_unlock(&entry->lock);
+
+	if (destroy)
+		fsnotify_destroy_mark_by_entry(entry);
+
+	fsnotify_recalc_group_mask(dnotify_group);
+
+	mutex_unlock(&dnotify_mark_mutex);
+	fsnotify_put_mark(entry);
+out_err:
+	if (new_entry)
+		fsnotify_put_mark(new_entry);
+	if (dn)
+		kmem_cache_free(dnotify_struct_cache, dn);
+	return error;
 }
-EXPORT_SYMBOL_GPL(dnotify_parent);
 
 static int __init dnotify_init(void)
 {
-	dn_cache = kmem_cache_create("dnotify_cache",
-		sizeof(struct dnotify_struct), 0, SLAB_PANIC, NULL);
+	dnotify_struct_cache = KMEM_CACHE(dnotify_struct, SLAB_PANIC);
+	dnotify_mark_entry_cache = KMEM_CACHE(dnotify_mark_entry, SLAB_PANIC);
+
+	dnotify_group = fsnotify_obtain_group(DNOTIFY_GROUP_NUM,
+					      0, &dnotify_fsnotify_ops);
+	if (IS_ERR(dnotify_group))
+		panic("unable to allocate fsnotify group for dnotify\n");
 	return 0;
 }
 
diff -puN include/linux/dnotify.h~dnotify-reimplement-dnotify-using-fsnotify include/linux/dnotify.h
--- a/include/linux/dnotify.h~dnotify-reimplement-dnotify-using-fsnotify
+++ a/include/linux/dnotify.h
@@ -10,7 +10,7 @@
 
 struct dnotify_struct {
 	struct dnotify_struct *	dn_next;
-	unsigned long		dn_mask;
+	__u32			dn_mask;
 	int			dn_fd;
 	struct file *		dn_filp;
 	fl_owner_t		dn_owner;
@@ -21,23 +21,18 @@ struct dnotify_struct {
 
 #ifdef CONFIG_DNOTIFY
 
-extern void __inode_dir_notify(struct inode *, unsigned long);
+#define DNOTIFY_ALL_EVENTS (FS_DELETE | FS_DELETE_CHILD |\
+			    FS_MODIFY | FS_MODIFY_CHILD |\
+			    FS_ACCESS | FS_ACCESS_CHILD |\
+			    FS_ATTRIB | FS_ATTRIB_CHILD |\
+			    FS_CREATE | FS_DN_RENAME |\
+			    FS_MOVED_FROM | FS_MOVED_TO)
+
 extern void dnotify_flush(struct file *, fl_owner_t);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
-extern void dnotify_parent(struct dentry *, unsigned long);
-
-static inline void inode_dir_notify(struct inode *inode, unsigned long event)
-{
-	if (inode->i_dnotify_mask & (event))
-		__inode_dir_notify(inode, event);
-}
 
 #else
 
-static inline void __inode_dir_notify(struct inode *inode, unsigned long event)
-{
-}
-
 static inline void dnotify_flush(struct file *filp, fl_owner_t id)
 {
 }
@@ -47,14 +42,6 @@ static inline int fcntl_dirnotify(int fd
 	return -EINVAL;
 }
 
-static inline void dnotify_parent(struct dentry *dentry, unsigned long event)
-{
-}
-
-static inline void inode_dir_notify(struct inode *inode, unsigned long event)
-{
-}
-
 #endif /* CONFIG_DNOTIFY */
 
 #endif /* __KERNEL __ */
diff -puN include/linux/fs.h~dnotify-reimplement-dnotify-using-fsnotify include/linux/fs.h
--- a/include/linux/fs.h~dnotify-reimplement-dnotify-using-fsnotify
+++ a/include/linux/fs.h
@@ -760,11 +760,6 @@ struct inode {
 	struct hlist_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
 #endif
 
-#ifdef CONFIG_DNOTIFY
-	unsigned long		i_dnotify_mask; /* Directory notify events */
-	struct dnotify_struct	*i_dnotify; /* for directory notifications */
-#endif
-
 #ifdef CONFIG_INOTIFY
 	struct list_head	inotify_watches; /* watches on this inode */
 	struct mutex		inotify_mutex;	/* protects the watches list */
diff -puN include/linux/fsnotify.h~dnotify-reimplement-dnotify-using-fsnotify include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~dnotify-reimplement-dnotify-using-fsnotify
+++ a/include/linux/fsnotify.h
@@ -74,13 +74,7 @@ static inline void fsnotify_move(struct 
 	__u32 new_dir_mask = 0;
 
 	if (old_dir == new_dir) {
-		inode_dir_notify(old_dir, DN_RENAME);
 		old_dir_mask = FS_DN_RENAME;
-	} else {
-		inode_dir_notify(old_dir, DN_DELETE);
-		old_dir_mask = FS_DELETE;
-		inode_dir_notify(new_dir, DN_CREATE);
-		new_dir_mask = FS_CREATE;
 	}
 
 	if (isdir) {
@@ -132,7 +126,6 @@ static inline void fsnotify_nameremove(s
 
 	if (isdir)
 		mask |= FS_IN_ISDIR;
-	dnotify_parent(dentry, DN_DELETE);
 
 	fsnotify_parent(dentry, mask);
 }
@@ -153,7 +146,6 @@ static inline void fsnotify_inoderemove(
  */
 static inline void fsnotify_create(struct inode *inode, struct dentry *dentry)
 {
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, IN_CREATE, 0, dentry->d_name.name,
 				  dentry->d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
@@ -168,7 +160,6 @@ static inline void fsnotify_create(struc
  */
 static inline void fsnotify_link(struct inode *dir, struct inode *inode, struct dentry *new_dentry)
 {
-	inode_dir_notify(dir, DN_CREATE);
 	inotify_inode_queue_event(dir, IN_CREATE, 0, new_dentry->d_name.name,
 				  inode);
 	fsnotify_link_count(inode);
@@ -185,7 +176,6 @@ static inline void fsnotify_mkdir(struct
 	__u32 mask = (FS_CREATE | FS_IN_ISDIR);
 	struct inode *d_inode = dentry->d_inode;
 
-	inode_dir_notify(inode, DN_CREATE);
 	inotify_inode_queue_event(inode, mask, 0, dentry->d_name.name, d_inode);
 	audit_inode_child(dentry->d_name.name, dentry, inode);
 
@@ -203,7 +193,6 @@ static inline void fsnotify_access(struc
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	dnotify_parent(dentry, DN_ACCESS);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
@@ -221,7 +210,6 @@ static inline void fsnotify_modify(struc
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_IN_ISDIR;
 
-	dnotify_parent(dentry, DN_MODIFY);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
 	fsnotify_parent(dentry, mask);
@@ -288,47 +276,33 @@ static inline void fsnotify_xattr(struct
 static inline void fsnotify_change(struct dentry *dentry, unsigned int ia_valid)
 {
 	struct inode *inode = dentry->d_inode;
-	int dn_mask = 0;
-	__u32 in_mask = 0;
+	__u32 mask = 0;
+
+	if (ia_valid & ATTR_UID)
+		mask |= FS_ATTRIB;
+	if (ia_valid & ATTR_GID)
+		mask |= FS_ATTRIB;
+	if (ia_valid & ATTR_SIZE)
+		mask |= FS_MODIFY;
 
-	if (ia_valid & ATTR_UID) {
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
-	if (ia_valid & ATTR_GID) {
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
-	if (ia_valid & ATTR_SIZE) {
-		in_mask |= FS_MODIFY;
-		dn_mask |= DN_MODIFY;
-	}
 	/* both times implies a utime(s) call */
 	if ((ia_valid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME))
-	{
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	} else if (ia_valid & ATTR_ATIME) {
-		in_mask |= FS_ACCESS;
-		dn_mask |= DN_ACCESS;
-	} else if (ia_valid & ATTR_MTIME) {
-		in_mask |= FS_MODIFY;
-		dn_mask |= DN_MODIFY;
-	}
-	if (ia_valid & ATTR_MODE) {
-		in_mask |= FS_ATTRIB;
-		dn_mask |= DN_ATTRIB;
-	}
+		mask |= FS_ATTRIB;
+	else if (ia_valid & ATTR_ATIME)
+		mask |= FS_ACCESS;
+	else if (ia_valid & ATTR_MTIME)
+		mask |= FS_MODIFY;
+
+	if (ia_valid & ATTR_MODE)
+		mask |= FS_ATTRIB;
 
-	if (dn_mask)
-		dnotify_parent(dentry, dn_mask);
-	if (in_mask) {
+	if (mask) {
 		if (S_ISDIR(inode->i_mode))
-			in_mask |= FS_IN_ISDIR;
-		inotify_inode_queue_event(inode, in_mask, 0, NULL, NULL);
+			mask |= FS_IN_ISDIR;
+		inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-		fsnotify_parent(dentry, in_mask);
-		fsnotify(inode, in_mask, inode, FSNOTIFY_EVENT_INODE);
+		fsnotify_parent(dentry, mask);
+		fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE);
 	}
 }
 
diff -puN include/linux/fsnotify_backend.h~dnotify-reimplement-dnotify-using-fsnotify include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~dnotify-reimplement-dnotify-using-fsnotify
+++ a/include/linux/fsnotify_backend.h
@@ -57,6 +57,9 @@
 				   FS_MOVED_FROM | FS_MOVED_TO | FS_CREATE |\
 				   FS_DELETE)
 
+/* listeners that hard code group numbers near the top */
+#define DNOTIFY_GROUP_NUM	UINT_MAX
+
 struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark_entry;
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

