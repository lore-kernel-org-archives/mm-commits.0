From: akpm@linux-foundation.org
Subject: + afs-fix-file-locking.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:50:22 -0700
Message-ID: <200707180050.l6I0oM5h016289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762295AbXGRAum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AFS: fix file locking
has been added to the -mm tree.  Its filename is
     afs-fix-file-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AFS: fix file locking
From: David Howells <dhowells@redhat.com>

Fix file locking for AFS:

 (*) Start the lock manager thread under a mutex to avoid a race.

 (*) Made the locking non-fair: New readlocks will jump pending writelocks if
     there's a readlock currently granted on a file.  This makes the behaviour
     similar to Linux's VFS locking.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/flock.c |  128 +++++++++++++++++++++++++++++------------------
 1 files changed, 80 insertions(+), 48 deletions(-)

diff -puN fs/afs/flock.c~afs-fix-file-locking fs/afs/flock.c
--- a/fs/afs/flock.c~afs-fix-file-locking
+++ a/fs/afs/flock.c
@@ -19,6 +19,7 @@ static void afs_fl_copy_lock(struct file
 static void afs_fl_release_private(struct file_lock *fl);
 
 static struct workqueue_struct *afs_lock_manager;
+static DEFINE_MUTEX(afs_lock_manager_mutex);
 
 static struct file_lock_operations afs_lock_ops = {
 	.fl_copy_lock		= afs_fl_copy_lock,
@@ -30,12 +31,20 @@ static struct file_lock_operations afs_l
  */
 static int afs_init_lock_manager(void)
 {
+	int ret;
+
+	ret = 0;
 	if (!afs_lock_manager) {
-		afs_lock_manager = create_singlethread_workqueue("kafs_lockd");
-		if (!afs_lock_manager)
-			return -ENOMEM;
+		mutex_lock(&afs_lock_manager_mutex);
+		if (!afs_lock_manager) {
+			afs_lock_manager =
+				create_singlethread_workqueue("kafs_lockd");
+			if (!afs_lock_manager)
+				ret = -ENOMEM;
+		}
+		mutex_unlock(&afs_lock_manager_mutex);
 	}
-	return 0;
+	return ret;
 }
 
 /*
@@ -68,6 +77,29 @@ static void afs_schedule_lock_extension(
 }
 
 /*
+ * grant one or more locks (readlocks are allowed to jump the queue if the
+ * first lock in the queue is itself a readlock)
+ * - the caller must hold the vnode lock
+ */
+static void afs_grant_locks(struct afs_vnode *vnode, struct file_lock *fl)
+{
+	struct file_lock *p, *_p;
+
+	list_move_tail(&fl->fl_u.afs.link, &vnode->granted_locks);
+	if (fl->fl_type == F_RDLCK) {
+		list_for_each_entry_safe(p, _p, &vnode->pending_locks,
+					 fl_u.afs.link) {
+			if (p->fl_type == F_RDLCK) {
+				p->fl_u.afs.state = AFS_LOCK_GRANTED;
+				list_move_tail(&p->fl_u.afs.link,
+					       &vnode->granted_locks);
+				wake_up(&p->fl_wait);
+			}
+		}
+	}
+}
+
+/*
  * do work for a lock, including:
  * - probing for a lock we're waiting on but didn't get immediately
  * - extending a lock that's close to timing out
@@ -172,8 +204,7 @@ void afs_lock_work(struct work_struct *w
 				       struct file_lock, fl_u.afs.link) == fl) {
 				fl->fl_u.afs.state = ret;
 				if (ret == AFS_LOCK_GRANTED)
-					list_move_tail(&fl->fl_u.afs.link,
-						       &vnode->granted_locks);
+					afs_grant_locks(vnode, fl);
 				else
 					list_del_init(&fl->fl_u.afs.link);
 				wake_up(&fl->fl_wait);
@@ -258,49 +289,50 @@ static int afs_do_setlk(struct file *fil
 
 	spin_lock(&vnode->lock);
 
-	if (list_empty(&vnode->pending_locks)) {
-		/* if there's no-one else with a lock on this vnode, then we
-		 * need to ask the server for a lock */
-		if (list_empty(&vnode->granted_locks)) {
-			_debug("not locked");
-			ASSERTCMP(vnode->flags &
-				  ((1 << AFS_VNODE_LOCKING) |
-				   (1 << AFS_VNODE_READLOCKED) |
-				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
-			list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
-			set_bit(AFS_VNODE_LOCKING, &vnode->flags);
-			spin_unlock(&vnode->lock);
-
-			ret = afs_vnode_set_lock(vnode, key, type);
-			clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
-			switch (ret) {
-			case 0:
-				goto acquired_server_lock;
-			case -EWOULDBLOCK:
-				spin_lock(&vnode->lock);
-				ASSERT(list_empty(&vnode->granted_locks));
-				ASSERTCMP(vnode->pending_locks.next, ==,
-					  &fl->fl_u.afs.link);
-				goto wait;
-			default:
-				spin_lock(&vnode->lock);
-				list_del_init(&fl->fl_u.afs.link);
-				spin_unlock(&vnode->lock);
-				goto error;
-			}
-		}
+	/* if we've already got a readlock on the server then we can instantly
+	 * grant another readlock, irrespective of whether there are any
+	 * pending writelocks */
+	if (type == AFS_LOCK_READ &&
+	    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
+		_debug("instant readlock");
+		ASSERTCMP(vnode->flags &
+			  ((1 << AFS_VNODE_LOCKING) |
+			   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
+		ASSERT(!list_empty(&vnode->granted_locks));
+		goto sharing_existing_lock;
+	}
+
+	/* if there's no-one else with a lock on this vnode, then we need to
+	 * ask the server for a lock */
+	if (list_empty(&vnode->pending_locks) &&
+	    list_empty(&vnode->granted_locks)) {
+		_debug("not locked");
+		ASSERTCMP(vnode->flags &
+			  ((1 << AFS_VNODE_LOCKING) |
+			   (1 << AFS_VNODE_READLOCKED) |
+			   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
+		list_add_tail(&fl->fl_u.afs.link, &vnode->pending_locks);
+		set_bit(AFS_VNODE_LOCKING, &vnode->flags);
+		spin_unlock(&vnode->lock);
 
-		/* if we've already got a readlock on the server and no waiting
-		 * writelocks, then we might be able to instantly grant another
-		 * readlock */
-		if (type == AFS_LOCK_READ &&
-		    vnode->flags & (1 << AFS_VNODE_READLOCKED)) {
-			_debug("instant readlock");
-			ASSERTCMP(vnode->flags &
-				  ((1 << AFS_VNODE_LOCKING) |
-				   (1 << AFS_VNODE_WRITELOCKED)), ==, 0);
-			ASSERT(!list_empty(&vnode->granted_locks));
-			goto sharing_existing_lock;
+		ret = afs_vnode_set_lock(vnode, key, type);
+		clear_bit(AFS_VNODE_LOCKING, &vnode->flags);
+		switch (ret) {
+		case 0:
+			_debug("acquired");
+			goto acquired_server_lock;
+		case -EWOULDBLOCK:
+			_debug("would block");
+			spin_lock(&vnode->lock);
+			ASSERT(list_empty(&vnode->granted_locks));
+			ASSERTCMP(vnode->pending_locks.next, ==,
+				  &fl->fl_u.afs.link);
+			goto wait;
+		default:
+			spin_lock(&vnode->lock);
+			list_del_init(&fl->fl_u.afs.link);
+			spin_unlock(&vnode->lock);
+			goto error;
 		}
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
document-page_mkwrite-locking.patch
afs-fix-file-locking.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
mutex-subsystem-synchro-test-module.patch
