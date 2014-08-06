From: akpm@linux-foundation.org
Subject: + fanotify-fix-double-free-of-pending-permission-events.patch
 added to -mm tree
Date: Wed, 06 Aug 2014 12:23:29 -0700
Message-ID: <53e280b1.1XwtX9dv+DWSy4Nm%akpm__41714.8274406374$1407353022$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:48297 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955AbaHFTXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 15:23:30 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so399257qgd.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 12:23:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, douglas.leeder@sophos.com, stable@vger.kernel.org, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: fix double free of pending permission events
has been added to the -mm tree.  Its filename is
     fanotify-fix-double-free-of-pending-permission-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-fix-double-free-of-pending-permission-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-fix-double-free-of-pending-permission-events.patch

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
Subject: fanotify: fix double free of pending permission events

Commit 85816794240b ("fanotify: Fix use after free for permission events")
introduced a double free issue for permission events which are pending in
group's notification queue while group is being destroyed.  These events
are freed from fanotify_handle_event() but they are not removed from
groups notification queue and thus they get freed again from
fsnotify_flush_notify().

Fix the problem by removing permission events from notification queue
before freeing them if we skip processing access response.  Also expand
comments in fanotify_release() to explain group shutdown in detail.

Fixes: 85816794240b9659e66e4d9b0df7c6e814e5f603
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Douglas Leeder <douglas.leeder@sophos.com>
Tested-by: Douglas Leeder <douglas.leeder@sophos.com>
Reported-by: Heinrich Schuchard <xypron.glpk@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c      |    9 ++++++++-
 fs/notify/fanotify/fanotify_user.c |   12 ++++++++++++
 fs/notify/notification.c           |   18 +++++++++++++++++-
 include/linux/fsnotify_backend.h   |    2 ++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-fix-double-free-of-pending-permission-events fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-fix-double-free-of-pending-permission-events
+++ a/fs/notify/fanotify/fanotify.c
@@ -70,8 +70,15 @@ static int fanotify_get_response(struct
 	wait_event(group->fanotify_data.access_waitq, event->response ||
 				atomic_read(&group->fanotify_data.bypass_perm));
 
-	if (!event->response) /* bypass_perm set */
+	if (!event->response) {	/* bypass_perm set */
+		/*
+		 * Event was canceled because group is being destroyed. Remove
+		 * it from group's event list because we are responsible for
+		 * freeing the permission event.
+		 */
+		fsnotify_remove_event(group, &event->fae.fse);
 		return 0;
+	}
 
 	/* userspace responded, convert to something usable */
 	switch (event->response) {
diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-fix-double-free-of-pending-permission-events fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-fix-double-free-of-pending-permission-events
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -359,6 +359,11 @@ static int fanotify_release(struct inode
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_perm_event_info *event, *next;
 
+	/*
+	 * There may be still new events arriving in the notification queue
+	 * but since userspace cannot use fanotify fd anymore, no event can
+	 * enter or leave access_list by now.
+	 */
 	spin_lock(&group->fanotify_data.access_lock);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
@@ -373,6 +378,13 @@ static int fanotify_release(struct inode
 	}
 	spin_unlock(&group->fanotify_data.access_lock);
 
+	/*
+	 * Since bypass_perm is set, newly queued events will not wait for
+	 * access response. Wake up the already sleeping ones now.
+	 * synchronize_srcu() in fsnotify_destroy_group() will wait for all
+	 * processes sleeping in fanotify_handle_event() waiting for access
+	 * response and thus also for all permission events to be freed.
+	 */
 	wake_up(&group->fanotify_data.access_waitq);
 #endif
 
diff -puN fs/notify/notification.c~fanotify-fix-double-free-of-pending-permission-events fs/notify/notification.c
--- a/fs/notify/notification.c~fanotify-fix-double-free-of-pending-permission-events
+++ a/fs/notify/notification.c
@@ -73,7 +73,8 @@ void fsnotify_destroy_event(struct fsnot
 	/* Overflow events are per-group and we don't want to free them */
 	if (!event || event->mask == FS_Q_OVERFLOW)
 		return;
-
+	/* If the event is still queued, we have a problem... */
+	WARN_ON(!list_empty(&event->list));
 	group->ops->free_event(event);
 }
 
@@ -125,6 +126,21 @@ queue:
 }
 
 /*
+ * Remove @event from group's notification queue. It is the responsibility of
+ * the caller to destroy the event.
+ */
+void fsnotify_remove_event(struct fsnotify_group *group,
+			   struct fsnotify_event *event)
+{
+	mutex_lock(&group->notification_mutex);
+	if (!list_empty(&event->list)) {
+		list_del_init(&event->list);
+		group->q_len--;
+	}
+	mutex_unlock(&group->notification_mutex);
+}
+
+/*
  * Remove and return the first event from the notification list.  It is the
  * responsibility of the caller to destroy the obtained event
  */
diff -puN include/linux/fsnotify_backend.h~fanotify-fix-double-free-of-pending-permission-events include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fanotify-fix-double-free-of-pending-permission-events
+++ a/include/linux/fsnotify_backend.h
@@ -326,6 +326,8 @@ extern int fsnotify_add_event(struct fsn
 			      struct fsnotify_event *event,
 			      int (*merge)(struct list_head *,
 					   struct fsnotify_event *));
+/* Remove passed event from groups notification queue */
+extern void fsnotify_remove_event(struct fsnotify_group *group, struct fsnotify_event *event);
 /* true if the group notification queue is empty */
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */
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

