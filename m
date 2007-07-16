From: akpm@linux-foundation.org
Subject: - afs-implement-file-locking.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:39 -0700
Message-ID: <200707162054.l6GKsdvM001842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751AbXGPV0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: implement file locking
has been removed from the -mm tree.  Its filename was
     afs-implement-file-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: implement file locking
From: David Howells <dhowells@redhat.com>

Implement file locking for AFS.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/Makefile    |    1 
 fs/afs/afs.h       |    8 
 fs/afs/afs_fs.h    |    3 
 fs/afs/callback.c  |    3 
 fs/afs/dir.c       |    1 
 fs/afs/file.c      |    2 
 fs/afs/flock.c     |  558 +++++++++++++++++++++++++++++++++++++++++++
 fs/afs/fsclient.c  |  155 +++++++++++
 fs/afs/internal.h  |   30 ++
 fs/afs/main.c      |    1 
 fs/afs/misc.c      |    1 
 fs/afs/super.c     |    3 
 fs/afs/vnode.c     |  130 ++++++++--
 include/linux/fs.h |    4 
 14 files changed, 885 insertions(+), 15 deletions(-)

diff -puN fs/afs/Makefile~afs-implement-file-locking fs/afs/Makefile
--- a/fs/afs/Makefile~afs-implement-file-locking
+++ a/fs/afs/Makefile
@@ -8,6 +8,7 @@ kafs-objs := \
 	cmservice.o \
 	dir.o \
 	file.o \
+	flock.o \
 	fsclient.o \
 	inode.o \
 	main.o \
diff -puN fs/afs/afs.h~afs-implement-file-locking fs/afs/afs.h
--- a/fs/afs/afs.h~afs-implement-file-locking
+++ a/fs/afs/afs.h
@@ -37,6 +37,13 @@ typedef enum {
 	AFS_FTYPE_SYMLINK	= 3,
 } afs_file_type_t;
 
+typedef enum {
+	AFS_LOCK_READ		= 0,	/* read lock request */
+	AFS_LOCK_WRITE		= 1,	/* write lock request */
+} afs_lock_type_t;
+
+#define AFS_LOCKWAIT		(5 * 60) /* time until a lock times out (seconds) */
+
 /*
  * AFS file identifier
  */
@@ -120,6 +127,7 @@ struct afs_file_status {
 	struct afs_fid		parent;		/* parent dir ID for non-dirs only */
 	time_t			mtime_client;	/* last time client changed data */
 	time_t			mtime_server;	/* last time server changed data */
+	s32			lock_count;	/* file lock count (0=UNLK -1=WRLCK +ve=#RDLCK */
 };
 
 /*
diff -puN fs/afs/afs_fs.h~afs-implement-file-locking fs/afs/afs_fs.h
--- a/fs/afs/afs_fs.h~afs-implement-file-locking
+++ a/fs/afs/afs_fs.h
@@ -31,6 +31,9 @@ enum AFS_FS_Operations {
 	FSGETVOLUMEINFO		= 148,	/* AFS Get information about a volume */
 	FSGETVOLUMESTATUS	= 149,	/* AFS Get volume status information */
 	FSGETROOTVOLUME		= 151,	/* AFS Get root volume name */
+	FSSETLOCK		= 156,	/* AFS Request a file lock */
+	FSEXTENDLOCK		= 157,	/* AFS Extend a file lock */
+	FSRELEASELOCK		= 158,	/* AFS Release a file lock */
 	FSLOOKUP		= 161,	/* AFS lookup file in directory */
 	FSFETCHDATA64		= 65537, /* AFS Fetch file data */
 	FSSTOREDATA64		= 65538, /* AFS Store file data */
diff -puN fs/afs/callback.c~afs-implement-file-locking fs/afs/callback.c
--- a/fs/afs/callback.c~afs-implement-file-locking
+++ a/fs/afs/callback.c
@@ -125,6 +125,9 @@ static void afs_break_callback(struct af
 		spin_unlock(&server->cb_lock);
 
 		queue_work(afs_callback_update_worker, &vnode->cb_broken_work);
+		if (list_empty(&vnode->granted_locks) &&
+		    !list_empty(&vnode->pending_locks))
+			afs_lock_may_be_available(vnode);
 		spin_unlock(&vnode->lock);
 	}
 }
diff -puN fs/afs/dir.c~afs-implement-file-locking fs/afs/dir.c
--- a/fs/afs/dir.c~afs-implement-file-locking
+++ a/fs/afs/dir.c
@@ -44,6 +44,7 @@ const struct file_operations afs_dir_fil
 	.open		= afs_dir_open,
 	.release	= afs_release,
 	.readdir	= afs_readdir,
+	.lock		= afs_lock,
 };
 
 const struct inode_operations afs_dir_inode_operations = {
diff -puN fs/afs/file.c~afs-implement-file-locking fs/afs/file.c
--- a/fs/afs/file.c~afs-implement-file-locking
+++ a/fs/afs/file.c
@@ -34,6 +34,8 @@ const struct file_operations afs_file_op
 	.mmap		= generic_file_readonly_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= afs_fsync,
+	.lock		= afs_lock,
+	.flock		= afs_flock,
 };
 
 const struct inode_operations afs_file_inode_operations = {
diff -puN /dev/null fs/afs/flock.c
--- /dev/null
+++ a/fs/afs/flock.c
@@ -0,0 +1,558 @@
+/* AFS file locking support
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/smp_lock.h>
+#include "internal.h"
+
+#define AFS_LOCK_GRANTED	0
+#define AFS_LOCK_PENDING	1
+
+static void afs_fl_copy_lock(struct file_lock *new, struct file_lock *fl);
+static void afs_fl_release_private(struct file_lock *fl);
+
+static struct workqueue_struct *afs_lock_manager;
+
+static struct file_lock_operations afs_lock_ops = {
+	.fl_copy_lock		= afs_fl_copy_lock,
+	.fl_release_private	= afs_fl_release_private,
+};
+
+/*
+ * initialise the lock manager thread if it isn't already running
+ */
+static int afs_init_lock_manager(void)
+{
+	if (!afs_lock_manager) {
+		afs_lock_manager = create_singlethread_workqueue("kafs_lockd");
+		if (!afs_lock_manager)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+/*
+ * destroy the lock manager thread if it's running
+ */
+void __exit afs_kill_lock_manager(void)
+{
+	if (afs_lock_manager)
+		destroy_workqueue(afs_lock_manager);
+}
+
+/*
+ * if the callback is broken on this vnode, then the lock may now be available
+ */
+void afs_lock_may_be_available(struct afs_vnode *vnode)
+{
+	_enter("{%x:%u}", vnode->fid.vid, vnode->fid.vnode);
+
+	queue_delayed_work(afs_lock_manager, &vnode->lock_work, 0);
+}
+
+/*
+ * the lock will time out in 5 minutes unless we extend it, so schedule
+ * extension in a bit less than that time
+ */
+static void afs_schedule_lock_extension(struct afs_vnode *vnode)
+{
+	queue_delayed_work(afs_lock_manager, &vnode->lock_work,
+			   AFS_LOCKWAIT * HZ / 2);
+}
+
+/*
+ * do work for a lock, including:
+ * - probing for a lock we're waiting on but didn't get immediately
+ * - extending a lock that's close to timing out
+ */
+void afs_lock_work(struct work_struct *work)
+{
+	struct afs_vnode *vnode =
+		container_of(work, struct afs_vnode, lock_work.work);
+	struct file_lock *fl;
+	afs_lock_type_t type;
+	struct key *key;
+	int ret;
+
+	_enter("{%x:%u}", vnode->fid.vid, vnode->fid.vnode);
+
+	spin_lock(&vnode->lock);
+
+	if (test_bit(AFS_VNODE_UNLOCKING, &vnode->flags)) {
+		_debug("unlock");
+		spin_unlock(&vnode->lock);
+
+		/* attempt to release the server lock; if it fails, we just
+		 * wait 5 minutes and it'll time out anyway */
+		ret = afs_vnode_release_lock(vnode, vnode->unlock_key);
+		if (ret < 0)
+			printk(KERN_WARNING "AFS:"
+			       " Failed to release lock on {%x:%x} error %d\n",
+			       vnode->fid.vid, vnode->fid.vnode, ret);
+
+		spin_lock(&vnode->lock);
+		key_put(vnode->unlock_key);
+		vnode->unlock_key = NULL;
+		clear_bit(AFS_VNODE_UNLOCKING, &vnode->flags);
+	}
+
+	/* if we've got a lock, then it must be time to extend that lock as AFS
+	 * locks time out after 5 minutes */
+	if (!list_empty(&vnode->granted_locks)) {
+		_debug("extend");
+
+		if (test_and_set_bit(AFS_VNODE_LOCKING, &vnode->flags))
+			BUG();
+		fl = list_entry(vnode->granted_locks.next,
+				struct file_lock, fl_u.afs.link);
+		key = key_get(fl->fl_file->private_data);
+		spin_unlock(&vnode->lock);
+
+		ret = afs_vnode_extend_lock(vnode, key);
+		clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
+		key_put(key);
+		switch (ret) {
+		case 0:
+			afs_schedule_lock_extension(vnode);
+			break;
+		default:
+			/* ummm... we failed to extend the lock - retry
+			 * extension shortly */
+			printk(KERN_WARNING "AFS:"
+			       " Failed to extend lock on {%x:%x} error %d\n",
+			       vnode->fid.vid, vnode->fid.vnode, ret);
+			queue_delayed_work(afs_lock_manager, &vnode->lock_work,
+					   HZ * 10);
+			break;
+		}
+		_leave(" [extend]");
+		return;
+	}
+
+	/* if we don't have a granted lock, then we must've been called back by
+	 * the server, and so if might be possible to get a lock we're
+	 * currently waiting for */
+	if (!list_empty(&vnode->pending_locks)) {
+		_debug("get");
+
+		if (test_and_set_bit(AFS_VNODE_LOCKING, &vnode->flags))
+			BUG();
+		fl = list_entry(vnode->pending_locks.next,
+				struct file_lock, fl_u.afs.link);
+		key = key_get(fl->fl_file->private_data);
+		type = (fl->fl_type == F_RDLCK) ?
+			AFS_LOCK_READ : AFS_LOCK_WRITE;
+		spin_unlock(&vnode->lock);
+
+		ret = afs_vnode_set_lock(vnode, key, type);
+		clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
+		switch (ret) {
+		case -EWOULDBLOCK:
+			_debug("blocked");
+			break;
+		case 0:
+			_debug("acquired");
+			if (type == AFS_LOCK_READ)
+				set_bit(AFS_VNODE_READLOCKED, &vnode->flags);
+			else
+				set_bit(AFS_VNODE_WRITELOCKED, &vnode->flags);
+			ret = AFS_LOCK_GRANTED;
+		default:
+			spin_lock(&vnode->lock);
+			/* the pending lock may have been withdrawn due to a
+			 * signal */
+			if (list_entry(vnode->pending_locks.next,
+				       struct file_lock, fl_u.afs.link) == fl) {
+				fl->fl_u.afs.state = ret;
+				if (ret == AFS_LOCK_GRANTED)
+					list_move_tail(&fl->fl_u.afs.link,
+						       &vnode->granted_locks);
+				else
+					list_del_init(&fl->fl_u.afs.link);
+				wake_up(&fl->fl_wait);
+				spin_unlock(&vnode->lock);
+			} else {
+				_debug("withdrawn");
+				clear_bit(AFS_VNODE_READLOCKED, &vnode->flags);
+				clear_bit(AFS_VNODE_WRITELOCKED, &vnode->flags);
+				spin_unlock(&vnode->lock);
+				afs_vnode_release_lock(vnode, key);
+				if (!list_empty(&vnode->pending_locks))
+					afs_lock_may_be_available(vnode);
+			}
+			break;
+		}
+		key_put(key);
+		_leave(" [pend]");
+		return;
+	}
+
+	/* looks like the lock request was withdrawn on a signal */
+	spin_unlock(&vnode->lock);
+	_leave(" [no locks]");
+}
+
+/*
+ * pass responsibility for the unlocking of a vnode on the server to the
+ * manager thread, lest a pending signal in the calling thread interrupt
+ * AF_RXRPC
+ * - the caller must hold the vnode lock
+ */
+static void afs_defer_unlock(struct afs_vnode *vnode, struct key *key)
+{
+	cancel_delayed_work(&vnode->lock_work);
+	if (!test_and_clear_bit(AFS_VNODE_READLOCKED, &vnode->flags) &&
+	    !test_and_clear_bit(AFS_VNODE_WRITELOCKED, &vnode->flags))
+		BUG();
+	if (test_and_set_bit(AFS_VNODE_UNLOCKING, &vnode->flags))
+		BUG();
+	vnode->unlock_key = key_get(key);
+	afs_lock_may_be_available(vnode);
+}
+
+/*
+ * request a lock on a file on the server
+ */
+static int afs_do_setlk(struct file *file, struct file_lock *fl)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file->f_mapping->host);
+	afs_lock_type_t type;
+	struct key *key = file->private_data;
+	int ret;
+
+	_enter("{%x:%u},%u", vnode->fid.vid, vnode->fid.vnode, fl->fl_type);
+
+	/* only whole-file locks are supported */
+	if (fl->fl_start != 0 || fl->fl_end != OFFSET_MAX)
+		return -EINVAL;
+
+	ret = afs_init_lock_manager();
+	if (ret < 0)
+		return ret;
+
+	fl->fl_ops = &afs_lock_ops;
+	INIT_LIST_HEAD(&fl->fl_u.afs.link);
+	fl->fl_u.afs.state = AFS_LOCK_PENDING;
+
+	type = (fl->fl_type == F_RDLCK) ? AFS_LOCK_READ : AFS_LOCK_WRITE;
+
+	lock_kernel();
+
+	/* make sure we've got a callback on this file and that our view of the
+	 * data version is up to date */
+	ret = afs_vnode_fetch_status(vnode, NULL, key);
+	if (ret < 0)
+		goto error;
+
+	if (vnode->status.lock_count != 0 && !(fl->fl_flags & FL_SLEEP)) {
+		ret = -EAGAIN;
+		goto error;
+	}
+
+	spin_lock(&vnode->lock);
+
+	if (list_empty(&vnode->pending_locks)) {
+		/* if there's no-one else with a lock on this vnode, then we
+		 * need to ask the server for a lock */
+		if (list_empty(&vnode->granted_locks)) {
+			_debug("not locked");
+			ASSERTCMP(vnode->flags &
+				  ((1 << AFS_VNODE_LOCKING) |
+				   (1 << AFS_VNODE_READLOCKED) |
+				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
+			list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
+			set_bit(AFS_VNODE_LOCKING, &vnode->flags);
+			spin_unlock(&vnode->lock);
+
+			ret = afs_vnode_set_lock(vnode, key, type);
+			clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
+			switch (ret) {
+			case 0:
+				goto acquired_server_lock;
+			case -EWOULDBLOCK:
+				spin_lock(&vnode->lock);
+				ASSERT(list_empty(&vnode->granted_locks));
+				ASSERTCMP(vnode->pending_locks.next, ==,
+					  &fl->fl_u.afs.link);
+				goto wait;
+			default:
+				spin_lock(&vnode->lock);
+				list_del_init(&fl->fl_u.afs.link);
+				spin_unlock(&vnode->lock);
+				goto error;
+			}
+		}
+
+		/* if we've already got a readlock on the server and no waiting
+		 * writelocks, then we might be able to instantly grant another
+		 * readlock */
+		if (type == AFS_LOCK_READ &&
+		    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
+			_debug("instant readlock");
+			ASSERTCMP(vnode->flags &
+				  ((1 << AFS_VNODE_LOCKING) |
+				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
+			ASSERT(!list_empty(&vnode->granted_locks));
+			goto sharing_existing_lock;
+		}
+	}
+
+	/* otherwise, we need to wait for a local lock to become available */
+	_debug("wait local");
+	list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
+wait:
+	if (!(fl->fl_flags & FL_SLEEP)) {
+		_debug("noblock");
+		ret = -EAGAIN;
+		goto abort_attempt;
+	}
+	spin_unlock(&vnode->lock);
+
+	/* now we need to sleep and wait for the lock manager thread to get the
+	 * lock from the server */
+	_debug("sleep");
+	ret = wait_event_interruptible(fl->fl_wait,
+				       fl->fl_u.afs.state <= AFS_LOCK_GRANTED);
+	if (fl->fl_u.afs.state <= AFS_LOCK_GRANTED) {
+		ret = fl->fl_u.afs.state;
+		if (ret < 0)
+			goto error;
+		spin_lock(&vnode->lock);
+		goto given_lock;
+	}
+
+	/* we were interrupted, but someone may still be in the throes of
+	 * giving us the lock */
+	_debug("intr");
+	ASSERTCMP(ret, ==, -ERESTARTSYS);
+
+	spin_lock(&vnode->lock);
+	if (fl->fl_u.afs.state <= AFS_LOCK_GRANTED) {
+		ret = fl->fl_u.afs.state;
+		if (ret < 0) {
+			spin_unlock(&vnode->lock);
+			goto error;
+		}
+		goto given_lock;
+	}
+
+abort_attempt:
+	/* we aren't going to get the lock, either because we're unwilling to
+	 * wait, or because some signal happened */
+	_debug("abort");
+	if (list_empty(&vnode->granted_locks) &&
+	    vnode->pending_locks.next == &fl->fl_u.afs.link) {
+		if (vnode->pending_locks.prev != &fl->fl_u.afs.link) {
+			/* kick the next pending lock into having a go */
+			list_del_init(&fl->fl_u.afs.link);
+			afs_lock_may_be_available(vnode);
+		}
+	} else {
+		list_del_init(&fl->fl_u.afs.link);
+	}
+	spin_unlock(&vnode->lock);
+	goto error;
+
+acquired_server_lock:
+	/* we've acquired a server lock, but it needs to be renewed after 5
+	 * mins */
+	spin_lock(&vnode->lock);
+	afs_schedule_lock_extension(vnode);
+	if (type == AFS_LOCK_READ)
+		set_bit(AFS_VNODE_READLOCKED, &vnode->flags);
+	else
+		set_bit(AFS_VNODE_WRITELOCKED, &vnode->flags);
+sharing_existing_lock:
+	/* the lock has been granted as far as we're concerned... */
+	fl->fl_u.afs.state = AFS_LOCK_GRANTED;
+	list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
+given_lock:
+	/* ... but we do still need to get the VFS's blessing */
+	ASSERT(!(vnode->flags & (1 << AFS_VNODE_LOCKING)));
+	ASSERT((vnode->flags & ((1 << AFS_VNODE_READLOCKED) |
+				(1 << AFS_VNODE_WRITELOCKED))) != 0);
+	ret = posix_lock_file(file, fl, NULL);
+	if (ret < 0)
+		goto vfs_rejected_lock;
+	spin_unlock(&vnode->lock);
+
+	/* again, make sure we've got a callback on this file and, again, make
+	 * sure that our view of the data version is up to date (we ignore
+	 * errors incurred here and deal with the consequences elsewhere) */
+	afs_vnode_fetch_status(vnode, NULL, key);
+
+error:
+	unlock_kernel();
+	_leave(" = %d", ret);
+	return ret;
+
+vfs_rejected_lock:
+	/* the VFS rejected the lock we just obtained, so we have to discard
+	 * what we just got */
+	_debug("vfs refused %d", ret);
+	list_del_init(&fl->fl_u.afs.link);
+	if (list_empty(&vnode->granted_locks))
+		afs_defer_unlock(vnode, key);
+	spin_unlock(&vnode->lock);
+	goto abort_attempt;
+}
+
+/*
+ * unlock on a file on the server
+ */
+static int afs_do_unlk(struct file *file, struct file_lock *fl)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file->f_mapping->host);
+	struct key *key = file->private_data;
+	int ret;
+
+	_enter("{%x:%u},%u", vnode->fid.vid, vnode->fid.vnode, fl->fl_type);
+
+	/* only whole-file unlocks are supported */
+	if (fl->fl_start != 0 || fl->fl_end != OFFSET_MAX)
+		return -EINVAL;
+
+	fl->fl_ops = &afs_lock_ops;
+	INIT_LIST_HEAD(&fl->fl_u.afs.link);
+	fl->fl_u.afs.state = AFS_LOCK_PENDING;
+
+	spin_lock(&vnode->lock);
+	ret = posix_lock_file(file, fl, NULL);
+	if (ret < 0) {
+		spin_unlock(&vnode->lock);
+		_leave(" = %d [vfs]", ret);
+		return ret;
+	}
+
+	/* discard the server lock only if all granted locks are gone */
+	if (list_empty(&vnode->granted_locks))
+		afs_defer_unlock(vnode, key);
+	spin_unlock(&vnode->lock);
+	_leave(" = 0");
+	return 0;
+}
+
+/*
+ * return information about a lock we currently hold, if indeed we hold one
+ */
+static int afs_do_getlk(struct file *file, struct file_lock *fl)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file->f_mapping->host);
+	struct key *key = file->private_data;
+	int ret, lock_count;
+
+	_enter("");
+
+	fl->fl_type = F_UNLCK;
+
+	mutex_lock(&vnode->vfs_inode.i_mutex);
+
+	/* check local lock records first */
+	ret = 0;
+	if (posix_test_lock(file, fl) == 0) {
+		/* no local locks; consult the server */
+		ret = afs_vnode_fetch_status(vnode, NULL, key);
+		if (ret < 0)
+			goto error;
+		lock_count = vnode->status.lock_count;
+		if (lock_count) {
+			if (lock_count > 0)
+				fl->fl_type = F_RDLCK;
+			else
+				fl->fl_type = F_WRLCK;
+			fl->fl_start = 0;
+			fl->fl_end = OFFSET_MAX;
+		}
+	}
+
+error:
+	mutex_unlock(&vnode->vfs_inode.i_mutex);
+	_leave(" = %d [%hd]", ret, fl->fl_type);
+	return ret;
+}
+
+/*
+ * manage POSIX locks on a file
+ */
+int afs_lock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file->f_dentry->d_inode);
+
+	_enter("{%x:%u},%d,{t=%x,fl=%x,r=%Ld:%Ld}",
+	       vnode->fid.vid, vnode->fid.vnode, cmd,
+	       fl->fl_type, fl->fl_flags,
+	       (long long) fl->fl_start, (long long) fl->fl_end);
+
+	/* AFS doesn't support mandatory locks */
+	if ((vnode->vfs_inode.i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
+	    fl->fl_type != F_UNLCK)
+		return -ENOLCK;
+
+	if (IS_GETLK(cmd))
+		return afs_do_getlk(file, fl);
+	if (fl->fl_type == F_UNLCK)
+		return afs_do_unlk(file, fl);
+	return afs_do_setlk(file, fl);
+}
+
+/*
+ * manage FLOCK locks on a file
+ */
+int afs_flock(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file->f_dentry->d_inode);
+
+	_enter("{%x:%u},%d,{t=%x,fl=%x}",
+	       vnode->fid.vid, vnode->fid.vnode, cmd,
+	       fl->fl_type, fl->fl_flags);
+
+	/*
+	 * No BSD flocks over NFS allowed.
+	 * Note: we could try to fake a POSIX lock request here by
+	 * using ((u32) filp | 0x80000000) or some such as the pid.
+	 * Not sure whether that would be unique, though, or whether
+	 * that would break in other places.
+	 */
+	if (!(fl->fl_flags & FL_FLOCK))
+		return -ENOLCK;
+
+	/* we're simulating flock() locks using posix locks on the server */
+	fl->fl_owner = (fl_owner_t) file;
+	fl->fl_start = 0;
+	fl->fl_end = OFFSET_MAX;
+
+	if (fl->fl_type == F_UNLCK)
+		return afs_do_unlk(file, fl);
+	return afs_do_setlk(file, fl);
+}
+
+/*
+ * the POSIX lock management core VFS code copies the lock record and adds the
+ * copy into its own list, so we need to add that copy to the vnode's lock
+ * queue in the same place as the original (which will be deleted shortly
+ * after)
+ */
+static void afs_fl_copy_lock(struct file_lock *new, struct file_lock *fl)
+{
+	_enter("");
+
+	list_add(&new->fl_u.afs.link, &fl->fl_u.afs.link);
+}
+
+/*
+ * need to remove this lock from the vnode queue when it's removed from the
+ * VFS's list
+ */
+static void afs_fl_release_private(struct file_lock *fl)
+{
+	_enter("");
+
+	list_del_init(&fl->fl_u.afs.link);
+}
diff -puN fs/afs/fsclient.c~afs-implement-file-locking fs/afs/fsclient.c
--- a/fs/afs/fsclient.c~afs-implement-file-locking
+++ a/fs/afs/fsclient.c
@@ -67,7 +67,7 @@ static void xdr_decode_AFSFetchStatus(co
 	EXTRACT(status->group);
 	bp++; /* sync counter */
 	data_version |= (u64) ntohl(*bp++) << 32;
-	bp++; /* lock count */
+	EXTRACT(status->lock_count);
 	size |= (u64) ntohl(*bp++) << 32;
 	bp++; /* spare 4 */
 	*_bp = bp;
@@ -1748,3 +1748,156 @@ int afs_fs_get_volume_status(struct afs_
 
 	return afs_make_call(&server->addr, call, GFP_NOFS, wait_mode);
 }
+
+/*
+ * deliver reply data to an FS.SetLock, FS.ExtendLock or FS.ReleaseLock
+ */
+static int afs_deliver_fs_xxxx_lock(struct afs_call *call,
+				    struct sk_buff *skb, bool last)
+{
+	const __be32 *bp;
+
+	_enter("{%u},{%u},%d", call->unmarshall, skb->len, last);
+
+	afs_transfer_reply(call, skb);
+	if (!last)
+		return 0;
+
+	if (call->reply_size != call->reply_max)
+		return -EBADMSG;
+
+	/* unmarshall the reply once we've received all of it */
+	bp = call->buffer;
+	/* xdr_decode_AFSVolSync(&bp, call->replyX); */
+
+	_leave(" = 0 [done]");
+	return 0;
+}
+
+/*
+ * FS.SetLock operation type
+ */
+static const struct afs_call_type afs_RXFSSetLock = {
+	.name		= "FS.SetLock",
+	.deliver	= afs_deliver_fs_xxxx_lock,
+	.abort_to_error	= afs_abort_to_error,
+	.destructor	= afs_flat_call_destructor,
+};
+
+/*
+ * FS.ExtendLock operation type
+ */
+static const struct afs_call_type afs_RXFSExtendLock = {
+	.name		= "FS.ExtendLock",
+	.deliver	= afs_deliver_fs_xxxx_lock,
+	.abort_to_error	= afs_abort_to_error,
+	.destructor	= afs_flat_call_destructor,
+};
+
+/*
+ * FS.ReleaseLock operation type
+ */
+static const struct afs_call_type afs_RXFSReleaseLock = {
+	.name		= "FS.ReleaseLock",
+	.deliver	= afs_deliver_fs_xxxx_lock,
+	.abort_to_error	= afs_abort_to_error,
+	.destructor	= afs_flat_call_destructor,
+};
+
+/*
+ * get a lock on a file
+ */
+int afs_fs_set_lock(struct afs_server *server,
+		    struct key *key,
+		    struct afs_vnode *vnode,
+		    afs_lock_type_t type,
+		    const struct afs_wait_mode *wait_mode)
+{
+	struct afs_call *call;
+	__be32 *bp;
+
+	_enter("");
+
+	call = afs_alloc_flat_call(&afs_RXFSSetLock, 5 * 4, 6 * 4);
+	if (!call)
+		return -ENOMEM;
+
+	call->key = key;
+	call->reply = vnode;
+	call->service_id = FS_SERVICE;
+	call->port = htons(AFS_FS_PORT);
+
+	/* marshall the parameters */
+	bp = call->request;
+	*bp++ = htonl(FSSETLOCK);
+	*bp++ = htonl(vnode->fid.vid);
+	*bp++ = htonl(vnode->fid.vnode);
+	*bp++ = htonl(vnode->fid.unique);
+	*bp++ = htonl(type);
+
+	return afs_make_call(&server->addr, call, GFP_NOFS, wait_mode);
+}
+
+/*
+ * extend a lock on a file
+ */
+int afs_fs_extend_lock(struct afs_server *server,
+		       struct key *key,
+		       struct afs_vnode *vnode,
+		       const struct afs_wait_mode *wait_mode)
+{
+	struct afs_call *call;
+	__be32 *bp;
+
+	_enter("");
+
+	call = afs_alloc_flat_call(&afs_RXFSExtendLock, 4 * 4, 6 * 4);
+	if (!call)
+		return -ENOMEM;
+
+	call->key = key;
+	call->reply = vnode;
+	call->service_id = FS_SERVICE;
+	call->port = htons(AFS_FS_PORT);
+
+	/* marshall the parameters */
+	bp = call->request;
+	*bp++ = htonl(FSEXTENDLOCK);
+	*bp++ = htonl(vnode->fid.vid);
+	*bp++ = htonl(vnode->fid.vnode);
+	*bp++ = htonl(vnode->fid.unique);
+
+	return afs_make_call(&server->addr, call, GFP_NOFS, wait_mode);
+}
+
+/*
+ * release a lock on a file
+ */
+int afs_fs_release_lock(struct afs_server *server,
+			struct key *key,
+			struct afs_vnode *vnode,
+			const struct afs_wait_mode *wait_mode)
+{
+	struct afs_call *call;
+	__be32 *bp;
+
+	_enter("");
+
+	call = afs_alloc_flat_call(&afs_RXFSReleaseLock, 4 * 4, 6 * 4);
+	if (!call)
+		return -ENOMEM;
+
+	call->key = key;
+	call->reply = vnode;
+	call->service_id = FS_SERVICE;
+	call->port = htons(AFS_FS_PORT);
+
+	/* marshall the parameters */
+	bp = call->request;
+	*bp++ = htonl(FSRELEASELOCK);
+	*bp++ = htonl(vnode->fid.vid);
+	*bp++ = htonl(vnode->fid.vnode);
+	*bp++ = htonl(vnode->fid.unique);
+
+	return afs_make_call(&server->addr, call, GFP_NOFS, wait_mode);
+}
diff -puN fs/afs/internal.h~afs-implement-file-locking fs/afs/internal.h
--- a/fs/afs/internal.h~afs-implement-file-locking
+++ a/fs/afs/internal.h
@@ -351,10 +351,18 @@ struct afs_vnode {
 #define AFS_VNODE_ZAP_DATA	3		/* set if vnode's data should be invalidated */
 #define AFS_VNODE_DELETED	4		/* set if vnode deleted on server */
 #define AFS_VNODE_MOUNTPOINT	5		/* set if vnode is a mountpoint symlink */
+#define AFS_VNODE_LOCKING	6		/* set if waiting for lock on vnode */
+#define AFS_VNODE_READLOCKED	7		/* set if vnode is read-locked on the server */
+#define AFS_VNODE_WRITELOCKED	8		/* set if vnode is write-locked on the server */
+#define AFS_VNODE_UNLOCKING	9		/* set if vnode is being unlocked on the server */
 
 	long			acl_order;	/* ACL check count (callback break count) */
 
 	struct list_head	writebacks;	/* alterations in pagecache that need writing */
+	struct list_head	pending_locks;	/* locks waiting to be granted */
+	struct list_head	granted_locks;	/* locks granted on this file */
+	struct delayed_work	lock_work;	/* work to be done in locking */
+	struct key		*unlock_key;	/* key to be used in unlocking */
 
 	/* outstanding callback notification on this file */
 	struct rb_node		server_rb;	/* link in server->fs_vnodes */
@@ -474,6 +482,15 @@ extern int afs_open(struct inode *, stru
 extern int afs_release(struct inode *, struct file *);
 
 /*
+ * flock.c
+ */
+extern void __exit afs_kill_lock_manager(void);
+extern void afs_lock_work(struct work_struct *);
+extern void afs_lock_may_be_available(struct afs_vnode *);
+extern int afs_lock(struct file *, int, struct file_lock *);
+extern int afs_flock(struct file *, int, struct file_lock *);
+
+/*
  * fsclient.c
  */
 extern int afs_fs_fetch_file_status(struct afs_server *, struct key *,
@@ -513,6 +530,15 @@ extern int afs_fs_get_volume_status(stru
 				    struct afs_vnode *,
 				    struct afs_volume_status *,
 				    const struct afs_wait_mode *);
+extern int afs_fs_set_lock(struct afs_server *, struct key *,
+			   struct afs_vnode *, afs_lock_type_t,
+			   const struct afs_wait_mode *);
+extern int afs_fs_extend_lock(struct afs_server *, struct key *,
+			      struct afs_vnode *,
+			      const struct afs_wait_mode *);
+extern int afs_fs_release_lock(struct afs_server *, struct key *,
+			       struct afs_vnode *,
+			       const struct afs_wait_mode *);
 
 /*
  * inode.c
@@ -681,6 +707,10 @@ extern int afs_vnode_store_data(struct a
 extern int afs_vnode_setattr(struct afs_vnode *, struct key *, struct iattr *);
 extern int afs_vnode_get_volume_status(struct afs_vnode *, struct key *,
 				       struct afs_volume_status *);
+extern int afs_vnode_set_lock(struct afs_vnode *, struct key *,
+			      afs_lock_type_t);
+extern int afs_vnode_extend_lock(struct afs_vnode *, struct key *);
+extern int afs_vnode_release_lock(struct afs_vnode *, struct key *);
 
 /*
  * volume.c
diff -puN fs/afs/main.c~afs-implement-file-locking fs/afs/main.c
--- a/fs/afs/main.c~afs-implement-file-locking
+++ a/fs/afs/main.c
@@ -168,6 +168,7 @@ static void __exit afs_exit(void)
 	printk(KERN_INFO "kAFS: Red Hat AFS client v0.1 unregistering.\n");
 
 	afs_fs_exit();
+	afs_kill_lock_manager();
 	afs_close_socket();
 	afs_purge_servers();
 	afs_callback_update_kill();
diff -puN fs/afs/misc.c~afs-implement-file-locking fs/afs/misc.c
--- a/fs/afs/misc.c~afs-implement-file-locking
+++ a/fs/afs/misc.c
@@ -35,6 +35,7 @@ int afs_abort_to_error(u32 abort_code)
 	case VOVERQUOTA:	return -EDQUOT;
 	case VBUSY:		return -EBUSY;
 	case VMOVED:		return -ENXIO;
+	case 0x2f6df0a:		return -EWOULDBLOCK;
 	case 0x2f6df0c:		return -EACCES;
 	case 0x2f6df0f:		return -EBUSY;
 	case 0x2f6df10:		return -EEXIST;
diff -puN fs/afs/super.c~afs-implement-file-locking fs/afs/super.c
--- a/fs/afs/super.c~afs-implement-file-locking
+++ a/fs/afs/super.c
@@ -460,6 +460,9 @@ static void afs_i_init_once(void *_vnode
 	spin_lock_init(&vnode->writeback_lock);
 	spin_lock_init(&vnode->lock);
 	INIT_LIST_HEAD(&vnode->writebacks);
+	INIT_LIST_HEAD(&vnode->pending_locks);
+	INIT_LIST_HEAD(&vnode->granted_locks);
+	INIT_DELAYED_WORK(&vnode->lock_work, afs_lock_work);
 	INIT_WORK(&vnode->cb_broken_work, afs_broken_callback_work);
 }
 
diff -puN fs/afs/vnode.c~afs-implement-file-locking fs/afs/vnode.c
--- a/fs/afs/vnode.c~afs-implement-file-locking
+++ a/fs/afs/vnode.c
@@ -887,11 +887,6 @@ int afs_vnode_get_volume_status(struct a
 	       vnode->fid.unique,
 	       key_serial(key));
 
-	/* this op will fetch the status */
-	spin_lock(&vnode->lock);
-	vnode->update_cnt++;
-	spin_unlock(&vnode->lock);
-
 	do {
 		/* pick a server to query */
 		server = afs_volume_pick_fileserver(vnode);
@@ -905,20 +900,127 @@ int afs_vnode_get_volume_status(struct a
 	} while (!afs_volume_release_fileserver(vnode, server, ret));
 
 	/* adjust the flags */
-	if (ret == 0) {
-		afs_vnode_finalise_status_update(vnode, server);
+	if (ret == 0)
+		afs_put_server(server);
+
+	_leave(" = %d", ret);
+	return ret;
+
+no_server:
+	return PTR_ERR(server);
+}
+
+/*
+ * get a lock on a file
+ */
+int afs_vnode_set_lock(struct afs_vnode *vnode, struct key *key,
+		       afs_lock_type_t type)
+{
+	struct afs_server *server;
+	int ret;
+
+	_enter("%s{%x:%u.%u},%x,%u",
+	       vnode->volume->vlocation->vldb.name,
+	       vnode->fid.vid,
+	       vnode->fid.vnode,
+	       vnode->fid.unique,
+	       key_serial(key), type);
+
+	do {
+		/* pick a server to query */
+		server = afs_volume_pick_fileserver(vnode);
+		if (IS_ERR(server))
+			goto no_server;
+
+		_debug("USING SERVER: %08x\n", ntohl(server->addr.s_addr));
+
+		ret = afs_fs_set_lock(server, key, vnode, type, &afs_sync_call);
+
+	} while (!afs_volume_release_fileserver(vnode, server, ret));
+
+	/* adjust the flags */
+	if (ret == 0)
+		afs_put_server(server);
+
+	_leave(" = %d", ret);
+	return ret;
+
+no_server:
+	return PTR_ERR(server);
+}
+
+/*
+ * extend a lock on a file
+ */
+int afs_vnode_extend_lock(struct afs_vnode *vnode, struct key *key)
+{
+	struct afs_server *server;
+	int ret;
+
+	_enter("%s{%x:%u.%u},%x",
+	       vnode->volume->vlocation->vldb.name,
+	       vnode->fid.vid,
+	       vnode->fid.vnode,
+	       vnode->fid.unique,
+	       key_serial(key));
+
+	do {
+		/* pick a server to query */
+		server = afs_volume_pick_fileserver(vnode);
+		if (IS_ERR(server))
+			goto no_server;
+
+		_debug("USING SERVER: %08x\n", ntohl(server->addr.s_addr));
+
+		ret = afs_fs_extend_lock(server, key, vnode, &afs_sync_call);
+
+	} while (!afs_volume_release_fileserver(vnode, server, ret));
+
+	/* adjust the flags */
+	if (ret == 0)
+		afs_put_server(server);
+
+	_leave(" = %d", ret);
+	return ret;
+
+no_server:
+	return PTR_ERR(server);
+}
+
+/*
+ * release a lock on a file
+ */
+int afs_vnode_release_lock(struct afs_vnode *vnode, struct key *key)
+{
+	struct afs_server *server;
+	int ret;
+
+	_enter("%s{%x:%u.%u},%x",
+	       vnode->volume->vlocation->vldb.name,
+	       vnode->fid.vid,
+	       vnode->fid.vnode,
+	       vnode->fid.unique,
+	       key_serial(key));
+
+	do {
+		/* pick a server to query */
+		server = afs_volume_pick_fileserver(vnode);
+		if (IS_ERR(server))
+			goto no_server;
+
+		_debug("USING SERVER: %08x\n", ntohl(server->addr.s_addr));
+
+		ret = afs_fs_release_lock(server, key, vnode, &afs_sync_call);
+
+	} while (!afs_volume_release_fileserver(vnode, server, ret));
+
+	/* adjust the flags */
+	if (ret == 0)
 		afs_put_server(server);
-	} else {
-		afs_vnode_status_update_failed(vnode, ret);
-	}
 
 	_leave(" = %d", ret);
 	return ret;
 
 no_server:
-	spin_lock(&vnode->lock);
-	vnode->update_cnt--;
-	ASSERTCMP(vnode->update_cnt, >=, 0);
-	spin_unlock(&vnode->lock);
 	return PTR_ERR(server);
 }
diff -puN include/linux/fs.h~afs-implement-file-locking include/linux/fs.h
--- a/include/linux/fs.h~afs-implement-file-locking
+++ a/include/linux/fs.h
@@ -820,6 +820,10 @@ struct file_lock {
 	union {
 		struct nfs_lock_info	nfs_fl;
 		struct nfs4_lock_info	nfs4_fl;
+		struct {
+			struct list_head link;	/* link in AFS vnode's pending_locks list */
+			int state;		/* state of grant or error if -ve */
+		} afs;
 	} fl_u;
 };
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
document-page_mkwrite-locking.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
mutex-subsystem-synchro-test-module.patch
