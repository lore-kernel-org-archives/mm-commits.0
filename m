From: akpm@linux-foundation.org
Subject: [patch 001/127] fsnotify: drop notification_mutex before
 destroying event
Date: Fri, 07 Oct 2016 16:56:49 -0700
Message-ID: <57f83641.tY7ANSgxHzbxRRct%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38753 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk

From: Jan Kara <jack@suse.cz>
Subject: fsnotify: drop notification_mutex before destroying event

fsnotify_flush_notify() and fanotify_release() destroy notification event
while holding notification_mutex.  Destruction of fanotify event includes
a path_put() call which may end up calling into a filesystem to delete an
inode if we happen to be the last holders of dentry reference which
happens to be the last holder of inode reference.  That may violate lock
ordering for some filesystems since notification_mutex is also acquired e.
g.  during write when generating fanotify event.  Also this is the only
thing that forces notification_mutex to be a sleeping lock.  So drop
notification_mutex before destroying a notification event.

Link: http://lkml.kernel.org/r/1473797711-14111-4-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    6 ++++--
 fs/notify/notification.c           |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-drop-notification_mutex-before-destroying-event fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-drop-notification_mutex-before-destroying-event
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -390,9 +390,11 @@ static int fanotify_release(struct inode
 	mutex_lock(&group->notification_mutex);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		fsn_event = fsnotify_remove_first_event(group);
-		if (!(fsn_event->mask & FAN_ALL_PERM_EVENTS))
+		if (!(fsn_event->mask & FAN_ALL_PERM_EVENTS)) {
+			mutex_unlock(&group->notification_mutex);
 			fsnotify_destroy_event(group, fsn_event);
-		else
+			mutex_lock(&group->notification_mutex);
+		} else
 			FANOTIFY_PE(fsn_event)->response = FAN_ALLOW;
 	}
 	mutex_unlock(&group->notification_mutex);
diff -puN fs/notify/notification.c~fsnotify-drop-notification_mutex-before-destroying-event fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-drop-notification_mutex-before-destroying-event
+++ a/fs/notify/notification.c
@@ -178,7 +178,9 @@ void fsnotify_flush_notify(struct fsnoti
 	mutex_lock(&group->notification_mutex);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		event = fsnotify_remove_first_event(group);
+		mutex_unlock(&group->notification_mutex);
 		fsnotify_destroy_event(group, event);
+		mutex_lock(&group->notification_mutex);
 	}
 	mutex_unlock(&group->notification_mutex);
 }
_
