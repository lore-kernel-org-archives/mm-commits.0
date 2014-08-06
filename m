From: akpm@linux-foundation.org
Subject: + fsnotify-rename-event-handling-functions.patch added to -mm
 tree
Date: Wed, 06 Aug 2014 12:23:28 -0700
Message-ID: <53e280b0.JxziUOYdPJulvbuD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:65048 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaHFTXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 15:23:30 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so397214qgd.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 12:23:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: Rename event handling functions
has been added to the -mm tree.  Its filename is
     fsnotify-rename-event-handling-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-rename-event-handling-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-rename-event-handling-functions.patch

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
Subject: fsnotify: Rename event handling functions

Rename fsnotify_add_notify_event() to fsnotify_add_event() since the
"notify" part is duplicit.  Rename fsnotify_remove_notify_event() and
fsnotify_peek_notify_event() to fsnotify_remove_first_event() and
fsnotify_peek_first_event() respectively since "notify" part is duplicit
and they really look at the first event in the queue.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c        |    2 +-
 fs/notify/fanotify/fanotify_user.c   |    2 +-
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 fs/notify/inotify/inotify_user.c     |    4 ++--
 fs/notify/notification.c             |   18 +++++++++---------
 include/linux/fsnotify_backend.h     |   12 ++++++------
 6 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fsnotify-rename-event-handling-functions fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fsnotify-rename-event-handling-functions
+++ a/fs/notify/fanotify/fanotify.c
@@ -210,7 +210,7 @@ static int fanotify_handle_event(struct
 		return -ENOMEM;
 
 	fsn_event = &event->fse;
-	ret = fsnotify_add_notify_event(group, fsn_event, fanotify_merge);
+	ret = fsnotify_add_event(group, fsn_event, fanotify_merge);
 	if (ret) {
 		/* Permission events shouldn't be merged */
 		BUG_ON(ret == 1 && mask & FAN_ALL_PERM_EVENTS);
diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-rename-event-handling-functions fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-rename-event-handling-functions
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -66,7 +66,7 @@ static struct fsnotify_event *get_one_ev
 
 	/* held the notification_mutex the whole time, so this is the
 	 * same event we peeked above */
-	return fsnotify_remove_notify_event(group);
+	return fsnotify_remove_first_event(group);
 }
 
 static int create_fd(struct fsnotify_group *group,
diff -puN fs/notify/inotify/inotify_fsnotify.c~fsnotify-rename-event-handling-functions fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~fsnotify-rename-event-handling-functions
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -108,7 +108,7 @@ int inotify_handle_event(struct fsnotify
 	if (len)
 		strcpy(event->name, file_name);
 
-	ret = fsnotify_add_notify_event(group, fsn_event, inotify_merge);
+	ret = fsnotify_add_event(group, fsn_event, inotify_merge);
 	if (ret) {
 		/* Our event wasn't used in the end. Free it. */
 		fsnotify_destroy_event(group, fsn_event);
diff -puN fs/notify/inotify/inotify_user.c~fsnotify-rename-event-handling-functions fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fsnotify-rename-event-handling-functions
+++ a/fs/notify/inotify/inotify_user.c
@@ -149,7 +149,7 @@ static struct fsnotify_event *get_one_ev
 	if (fsnotify_notify_queue_is_empty(group))
 		return NULL;
 
-	event = fsnotify_peek_notify_event(group);
+	event = fsnotify_peek_first_event(group);
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -159,7 +159,7 @@ static struct fsnotify_event *get_one_ev
 
 	/* held the notification_mutex the whole time, so this is the
 	 * same event we peeked above */
-	fsnotify_remove_notify_event(group);
+	fsnotify_remove_first_event(group);
 
 	return event;
 }
diff -puN fs/notify/notification.c~fsnotify-rename-event-handling-functions fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-rename-event-handling-functions
+++ a/fs/notify/notification.c
@@ -83,10 +83,10 @@ void fsnotify_destroy_event(struct fsnot
  * added to the queue, 1 if the event was merged with some other queued event,
  * 2 if the queue of events has overflown.
  */
-int fsnotify_add_notify_event(struct fsnotify_group *group,
-			      struct fsnotify_event *event,
-			      int (*merge)(struct list_head *,
-					   struct fsnotify_event *))
+int fsnotify_add_event(struct fsnotify_group *group,
+		       struct fsnotify_event *event,
+		       int (*merge)(struct list_head *,
+				    struct fsnotify_event *))
 {
 	int ret = 0;
 	struct list_head *list = &group->notification_list;
@@ -128,7 +128,7 @@ queue:
  * Remove and return the first event from the notification list.  It is the
  * responsibility of the caller to destroy the obtained event
  */
-struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group)
+struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
 
@@ -140,7 +140,7 @@ struct fsnotify_event *fsnotify_remove_n
 				 struct fsnotify_event, list);
 	/*
 	 * We need to init list head for the case of overflow event so that
-	 * check in fsnotify_add_notify_events() works
+	 * check in fsnotify_add_event() works
 	 */
 	list_del_init(&event->list);
 	group->q_len--;
@@ -149,9 +149,9 @@ struct fsnotify_event *fsnotify_remove_n
 }
 
 /*
- * This will not remove the event, that must be done with fsnotify_remove_notify_event()
+ * This will not remove the event, that must be done with fsnotify_remove_first_event()
  */
-struct fsnotify_event *fsnotify_peek_notify_event(struct fsnotify_group *group)
+struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
 	BUG_ON(!mutex_is_locked(&group->notification_mutex));
 
@@ -169,7 +169,7 @@ void fsnotify_flush_notify(struct fsnoti
 
 	mutex_lock(&group->notification_mutex);
 	while (!fsnotify_notify_queue_is_empty(group)) {
-		event = fsnotify_remove_notify_event(group);
+		event = fsnotify_remove_first_event(group);
 		fsnotify_destroy_event(group, event);
 	}
 	mutex_unlock(&group->notification_mutex);
diff -puN include/linux/fsnotify_backend.h~fsnotify-rename-event-handling-functions include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-rename-event-handling-functions
+++ a/include/linux/fsnotify_backend.h
@@ -322,16 +322,16 @@ extern int fsnotify_fasync(int fd, struc
 extern void fsnotify_destroy_event(struct fsnotify_group *group,
 				   struct fsnotify_event *event);
 /* attach the event to the group notification queue */
-extern int fsnotify_add_notify_event(struct fsnotify_group *group,
-				     struct fsnotify_event *event,
-				     int (*merge)(struct list_head *,
-						  struct fsnotify_event *));
+extern int fsnotify_add_event(struct fsnotify_group *group,
+			      struct fsnotify_event *event,
+			      int (*merge)(struct list_head *,
+					   struct fsnotify_event *));
 /* true if the group notification queue is empty */
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */
-extern struct fsnotify_event *fsnotify_peek_notify_event(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group);
 /* return AND dequeue the first event on the notification queue */
-extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_remove_first_event(struct fsnotify_group *group);
 
 /* functions used to manipulate the marks attached to inodes */
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fsnotify-rename-event-handling-functions.patch
fanotify-fix-double-free-of-pending-permission-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
printk-rename-default_message_loglevel.patch
printk-fix-some-comments.patch
printk-use-a-clever-macro.patch
printk-miscellaneous-cleanups.patch
printk-enable-interrupts-before-calling-console_trylock_for_printk.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

