From: akpm@linux-foundation.org
Subject: [patch 005/127] fsnotify: clean up spinlock assertions
Date: Fri, 07 Oct 2016 16:57:01 -0700
Message-ID: <57f8364d.jXp8gkpZR8eSMzbX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, hkallweit1@gmail.com, jlayton@redhat.com

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
