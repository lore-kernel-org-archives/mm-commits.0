From: akpm@linux-foundation.org
Subject: + fsnotify-cleanup-spinlock-assertions.patch added to -mm tree
Date: Tue, 27 Sep 2016 14:51:42 -0700
Message-ID: <57eae9ee.GZvry7/GhfQPmozp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46791 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753219AbcI0Vvo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 17:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hkallweit1@gmail.com, jlayton@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: clean up spinlock assertions
has been added to the -mm tree.  Its filename is
     fsnotify-cleanup-spinlock-assertions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-cleanup-spinlock-assertions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-cleanup-spinlock-assertions.patch

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
Subject: fsnotify: clean up spinlock assertions

Use assert_spin_locked() macro instead of hand-made BUG_ON statements.

Link: http://lkml.kernel.org/r/1474537439-18919-1-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    3 +--
 fs/notify/notification.c           |    9 +++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-cleanup-spinlock-assertions fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-cleanup-spinlock-assertions
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -54,8 +54,7 @@ struct kmem_cache *fanotify_perm_event_c
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
 {
-	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
-	       !spin_is_locked(&group->notification_lock));
+	assert_spin_locked(&group->notification_lock);
 
 	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
 
diff -puN fs/notify/notification.c~fsnotify-cleanup-spinlock-assertions fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-cleanup-spinlock-assertions
+++ a/fs/notify/notification.c
@@ -63,8 +63,7 @@ EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
 {
-	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
-	       !spin_is_locked(&group->notification_lock));
+	assert_spin_locked(&group->notification_lock);
 	return list_empty(&group->notification_list) ? true : false;
 }
 
@@ -149,8 +148,7 @@ struct fsnotify_event *fsnotify_remove_f
 {
 	struct fsnotify_event *event;
 
-	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
-	       !spin_is_locked(&group->notification_lock));
+	assert_spin_locked(&group->notification_lock);
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
@@ -172,8 +170,7 @@ struct fsnotify_event *fsnotify_remove_f
  */
 struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
-	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
-	       !spin_is_locked(&group->notification_lock));
+	assert_spin_locked(&group->notification_lock);
 
 	return list_first_entry(&group->notification_list,
 				struct fsnotify_event, list);
_

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-drop-notification_mutex-before-destroying-event.patch
fsnotify-convert-notification_mutex-to-a-spinlock.patch
fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch
fanotify-use-notification_lock-instead-of-access_lock.patch
fanotify-fix-possible-false-warning-when-freeing-events.patch
fsnotify-cleanup-spinlock-assertions.patch

