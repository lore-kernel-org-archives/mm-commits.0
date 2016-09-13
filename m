From: akpm@linux-foundation.org
Subject: + fanotify-fix-possible-false-warning-when-freeing-events.patch
 added to -mm tree
Date: Tue, 13 Sep 2016 14:01:52 -0700
Message-ID: <57d86940.YhxkTWjWMeS9Xayi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34499 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758640AbcIMVBx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: fix possible false warning when freeing events
has been added to the -mm tree.  Its filename is
     fanotify-fix-possible-false-warning-when-freeing-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-fix-possible-false-warning-when-freeing-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-fix-possible-false-warning-when-freeing-events.patch

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
Subject: fanotify: fix possible false warning when freeing events

When freeing permission events by fsnotify_destroy_event(), the warning
WARN_ON(!list_empty(&event->list)); may falsely hit.  This is because
although fanotify_get_response() saw event->response set, there is nothing
to make sure the current CPU also sees the removal of the event from the
list.  Add proper locking around the WARN_ON() to avoid the false warning.

Link: http://lkml.kernel.org/r/1473797711-14111-7-git-send-email-jack@suse.cz
Reported-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/notification.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/notify/notification.c~fanotify-fix-possible-false-warning-when-freeing-events fs/notify/notification.c
--- a/fs/notify/notification.c~fanotify-fix-possible-false-warning-when-freeing-events
+++ a/fs/notify/notification.c
@@ -73,8 +73,17 @@ void fsnotify_destroy_event(struct fsnot
 	/* Overflow events are per-group and we don't want to free them */
 	if (!event || event->mask == FS_Q_OVERFLOW)
 		return;
-	/* If the event is still queued, we have a problem... */
-	WARN_ON(!list_empty(&event->list));
+	/*
+	 * If the event is still queued, we have a problem... Do an unreliable
+	 * lockless check first to avoid locking in the common case. The
+	 * locking may be necessary for permission events which got removed
+	 * from the list by a different CPU than the one freeing the event.
+	 */
+	if (!list_empty(&event->list)) {
+		spin_lock(&group->notification_lock);
+		WARN_ON(!list_empty(&event->list));
+		spin_unlock(&group->notification_lock);
+	}
 	group->ops->free_event(event);
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown.patch
fanotify-fix-list-corruption-in-fanotify_get_response.patch
fsnotify-drop-notification_mutex-before-destroying-event.patch
fsnotify-convert-notification_mutex-to-a-spinlock.patch
fanotify-use-notification_lock-instead-of-access_lock.patch
fanotify-fix-possible-false-warning-when-freeing-events.patch

