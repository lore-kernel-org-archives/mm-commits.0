From: akpm@linux-foundation.org
Subject: [merged] fanotify-convert-access_mutex-to-spinlock.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:29:38 -0700
Message-ID: <533f0822.rhJsofcU9EWbHCCt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaDDT3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, jack@suse.cz

Subject: [merged] fanotify-convert-access_mutex-to-spinlock.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:38 -0700


The patch titled
     Subject: fanotify: convert access_mutex to spinlock
has been removed from the -mm tree.  Its filename was
     fanotify-convert-access_mutex-to-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: convert access_mutex to spinlock

access_mutex is used only to guard operations on access_list.  There's no
need for sleeping within this lock so just make a spinlock out of it.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   14 +++++++-------
 include/linux/fsnotify_backend.h   |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-convert-access_mutex-to-spinlock fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-convert-access_mutex-to-spinlock
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -134,7 +134,7 @@ static struct fanotify_perm_event_info *
 {
 	struct fanotify_perm_event_info *event, *return_e = NULL;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
+	spin_lock(&group->fanotify_data.access_lock);
 	list_for_each_entry(event, &group->fanotify_data.access_list,
 			    fae.fse.list) {
 		if (event->fd != fd)
@@ -144,7 +144,7 @@ static struct fanotify_perm_event_info *
 		return_e = event;
 		break;
 	}
-	mutex_unlock(&group->fanotify_data.access_mutex);
+	spin_unlock(&group->fanotify_data.access_lock);
 
 	pr_debug("%s: found return_re=%p\n", __func__, return_e);
 
@@ -213,10 +213,10 @@ static ssize_t copy_event_to_user(struct
 
 		pevent = FANOTIFY_PE(event);
 		pevent->fd = fd;
-		mutex_lock(&group->fanotify_data.access_mutex);
+		spin_lock(&group->fanotify_data.access_lock);
 		list_add_tail(&pevent->fae.fse.list,
 			      &group->fanotify_data.access_list);
-		mutex_unlock(&group->fanotify_data.access_mutex);
+		spin_unlock(&group->fanotify_data.access_lock);
 	}
 #endif
 
@@ -346,7 +346,7 @@ static int fanotify_release(struct inode
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_perm_event_info *event, *next;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
+	spin_lock(&group->fanotify_data.access_lock);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
 
@@ -358,7 +358,7 @@ static int fanotify_release(struct inode
 		list_del_init(&event->fae.fse.list);
 		event->response = FAN_ALLOW;
 	}
-	mutex_unlock(&group->fanotify_data.access_mutex);
+	spin_unlock(&group->fanotify_data.access_lock);
 
 	wake_up(&group->fanotify_data.access_waitq);
 #endif
@@ -700,7 +700,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
 
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	mutex_init(&group->fanotify_data.access_mutex);
+	spin_lock_init(&group->fanotify_data.access_lock);
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
 	atomic_set(&group->fanotify_data.bypass_perm, 0);
diff -puN include/linux/fsnotify_backend.h~fanotify-convert-access_mutex-to-spinlock include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fanotify-convert-access_mutex-to-spinlock
+++ a/include/linux/fsnotify_backend.h
@@ -178,7 +178,7 @@ struct fsnotify_group {
 		struct fanotify_group_private_data {
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 			/* allows a group to block waiting for a userspace response */
-			struct mutex access_mutex;
+			spinlock_t access_lock;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
 			atomic_t bypass_perm;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

