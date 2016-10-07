From: akpm@linux-foundation.org
Subject: [patch 003/127] fanotify: use notification_lock instead of
 access_lock
Date: Fri, 07 Oct 2016 16:56:55 -0700
Message-ID: <57f83647.Nac3Bx2NUD3uvpPc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX45 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk

From: Jan Kara <jack@suse.cz>
Subject: fanotify: use notification_lock instead of access_lock

Fanotify code has an own lock (access_lock) to protect a list of events
waiting for a response from userspace.  However this is somewhat awkward
as the same list_head in the event is protected by notification_lock if it
is part of the notification queue and by access_lock if it is part of the
fanotify private queue which makes it difficult for any reliable checks in
the generic code.  So make fanotify use the same lock - notification_lock
- for protecting its private event list.

Link: http://lkml.kernel.org/r/1473797711-14111-6-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   13 +++++--------
 include/linux/fsnotify_backend.h   |    1 -
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-use-notification_lock-instead-of-access_lock fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-use-notification_lock-instead-of-access_lock
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -148,7 +148,7 @@ static struct fanotify_perm_event_info *
 {
 	struct fanotify_perm_event_info *event, *return_e = NULL;
 
-	spin_lock(&group->fanotify_data.access_lock);
+	spin_lock(&group->notification_lock);
 	list_for_each_entry(event, &group->fanotify_data.access_list,
 			    fae.fse.list) {
 		if (event->fd != fd)
@@ -158,7 +158,7 @@ static struct fanotify_perm_event_info *
 		return_e = event;
 		break;
 	}
-	spin_unlock(&group->fanotify_data.access_lock);
+	spin_unlock(&group->notification_lock);
 
 	pr_debug("%s: found return_re=%p\n", __func__, return_e);
 
@@ -310,10 +310,10 @@ static ssize_t fanotify_read(struct file
 				wake_up(&group->fanotify_data.access_waitq);
 				break;
 			}
-			spin_lock(&group->fanotify_data.access_lock);
+			spin_lock(&group->notification_lock);
 			list_add_tail(&kevent->list,
 				      &group->fanotify_data.access_list);
-			spin_unlock(&group->fanotify_data.access_lock);
+			spin_unlock(&group->notification_lock);
 #endif
 		}
 		buf += ret;
@@ -372,7 +372,7 @@ static int fanotify_release(struct inode
 	 * Process all permission events on access_list and notification queue
 	 * and simulate reply from userspace.
 	 */
-	spin_lock(&group->fanotify_data.access_lock);
+	spin_lock(&group->notification_lock);
 	list_for_each_entry_safe(event, next, &group->fanotify_data.access_list,
 				 fae.fse.list) {
 		pr_debug("%s: found group=%p event=%p\n", __func__, group,
@@ -381,14 +381,12 @@ static int fanotify_release(struct inode
 		list_del_init(&event->fae.fse.list);
 		event->response = FAN_ALLOW;
 	}
-	spin_unlock(&group->fanotify_data.access_lock);
 
 	/*
 	 * Destroy all non-permission events. For permission events just
 	 * dequeue them and set the response. They will be freed once the
 	 * response is consumed and fanotify_get_response() returns.
 	 */
-	spin_lock(&group->notification_lock);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		fsn_event = fsnotify_remove_first_event(group);
 		if (!(fsn_event->mask & FAN_ALL_PERM_EVENTS)) {
@@ -768,7 +766,6 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
 		event_f_flags |= O_LARGEFILE;
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	spin_lock_init(&group->fanotify_data.access_lock);
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
 #endif
diff -puN include/linux/fsnotify_backend.h~fanotify-use-notification_lock-instead-of-access_lock include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fanotify-use-notification_lock-instead-of-access_lock
+++ a/include/linux/fsnotify_backend.h
@@ -177,7 +177,6 @@ struct fsnotify_group {
 		struct fanotify_group_private_data {
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 			/* allows a group to block waiting for a userspace response */
-			spinlock_t access_lock;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
_
