From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-fix-possible-false-warning-when-freeing-events.patch removed from
 -mm tree
Date: Mon, 10 Oct 2016 15:42:22 -0700
Message-ID: <57fc194e./qNXeVPcX5xNe067%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37356 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbcJJWuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: fix possible false warning when freeing events
has been removed from the -mm tree.  Its filename was
     fanotify-fix-possible-false-warning-when-freeing-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from jack@suse.cz are


