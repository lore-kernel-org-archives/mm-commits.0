From: akpm@linux-foundation.org
Subject: + fanotify-use-notification_lock-instead-of-access_lock.patch
 added to -mm tree
Date: Tue, 13 Sep 2016 14:01:50 -0700
Message-ID: <57d8693e.meR+O8qzUpqE8EuU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34499 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758600AbcIMVBv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: use notification_lock instead of access_lock
has been added to the -mm tree.  Its filename is
     fanotify-use-notification_lock-instead-of-access_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-use-notification_lock-instead-of-access_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-use-notification_lock-instead-of-access_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
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
@@ -147,7 +147,7 @@ static struct fanotify_perm_event_info *
 {
 	struct fanotify_perm_event_info *event, *return_e = NULL;
 
-	spin_lock(&group->fanotify_data.access_lock);
+	spin_lock(&group->notification_lock);
 	list_for_each_entry(event, &group->fanotify_data.access_list,
 			    fae.fse.list) {
 		if (event->fd != fd)
@@ -157,7 +157,7 @@ static struct fanotify_perm_event_info *
 		return_e = event;
 		break;
 	}
-	spin_unlock(&group->fanotify_data.access_lock);
+	spin_unlock(&group->notification_lock);
 
 	pr_debug("%s: found return_re=%p\n", __func__, return_e);
 
@@ -309,10 +309,10 @@ static ssize_t fanotify_read(struct file
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
@@ -371,7 +371,7 @@ static int fanotify_release(struct inode
 	 * Process all permission events on access_list and notification queue
 	 * and simulate reply from userspace.
 	 */
-	spin_lock(&group->fanotify_data.access_lock);
+	spin_lock(&group->notification_lock);
 	list_for_each_entry_safe(event, next, &group->fanotify_data.access_list,
 				 fae.fse.list) {
 		pr_debug("%s: found group=%p event=%p\n", __func__, group,
@@ -380,14 +380,12 @@ static int fanotify_release(struct inode
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
@@ -767,7 +765,6 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
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

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown.patch
fanotify-fix-list-corruption-in-fanotify_get_response.patch
fsnotify-drop-notification_mutex-before-destroying-event.patch
fsnotify-convert-notification_mutex-to-a-spinlock.patch
fanotify-use-notification_lock-instead-of-access_lock.patch
fanotify-fix-possible-false-warning-when-freeing-events.patch

