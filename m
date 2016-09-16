From: akpm@linux-foundation.org
Subject: + fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch
 added to -mm tree
Date: Fri, 16 Sep 2016 15:04:05 -0700
Message-ID: <57dc6c55.3KZnChIyTw6kj8+I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbcIPWEH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 18:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify-convert-notification_mutex-to-a-spinlock-fix
has been added to the -mm tree.  Its filename is
     fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch

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
Subject: fsnotify-convert-notification_mutex-to-a-spinlock-fix

This is a fixed version of the patch that fixes the BUG_ON hitting on UP
kernels.

Link: http://lkml.kernel.org/r/1474031567-1831-1-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    3 ++-
 fs/notify/notification.c           |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-convert-notification_mutex-to-a-spinlock-fix fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-convert-notification_mutex-to-a-spinlock-fix
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -54,7 +54,8 @@ struct kmem_cache *fanotify_perm_event_c
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
 {
-	BUG_ON(!spin_is_locked(&group->notification_lock));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 
 	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
 
diff -puN fs/notify/notification.c~fsnotify-convert-notification_mutex-to-a-spinlock-fix fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-convert-notification_mutex-to-a-spinlock-fix
+++ a/fs/notify/notification.c
@@ -63,7 +63,8 @@ EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
 {
-	BUG_ON(!spin_is_locked(&group->notification_lock));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 	return list_empty(&group->notification_list) ? true : false;
 }
 
@@ -139,7 +140,8 @@ struct fsnotify_event *fsnotify_remove_f
 {
 	struct fsnotify_event *event;
 
-	BUG_ON(!spin_is_locked(&group->notification_lock));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
@@ -161,7 +163,8 @@ struct fsnotify_event *fsnotify_remove_f
  */
 struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
-	BUG_ON(!spin_is_locked(&group->notification_lock));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 
 	return list_first_entry(&group->notification_list,
 				struct fsnotify_event, list);
_

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown.patch
fanotify-fix-list-corruption-in-fanotify_get_response.patch
fsnotify-drop-notification_mutex-before-destroying-event.patch
fsnotify-convert-notification_mutex-to-a-spinlock.patch
fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch
fanotify-use-notification_lock-instead-of-access_lock.patch
fanotify-fix-possible-false-warning-when-freeing-events.patch

