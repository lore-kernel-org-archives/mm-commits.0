From: akpm@linux-foundation.org
Subject: [patch 004/127] fanotify: fix possible false warning when freeing events
Date: Fri, 07 Oct 2016 16:56:58 -0700
Message-ID: <57f8364a.42Eh7UEcPR3nOJ6O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk

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
Reviewed-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/notification.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/notify/notification.c~fanotify-fix-possible-false-warning-when-freeing-events fs/notify/notification.c
--- a/fs/notify/notification.c~fanotify-fix-possible-false-warning-when-freeing-events
+++ a/fs/notify/notification.c
@@ -74,8 +74,17 @@ void fsnotify_destroy_event(struct fsnot
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
