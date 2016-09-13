From: akpm@linux-foundation.org
Subject: + fsnotify-drop-notification_mutex-before-destroying-event.patch
 added to -mm tree
Date: Tue, 13 Sep 2016 14:01:46 -0700
Message-ID: <57d8693a.KckAtKtFL9Iw+9wT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758600AbcIMVBx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, mszeredi@redhat.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: drop notification_mutex before destroying event
has been added to the -mm tree.  Its filename is
     fsnotify-drop-notification_mutex-before-destroying-event.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-drop-notification_mutex-before-destroying-event.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-drop-notification_mutex-before-destroying-event.patch

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

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown.patch
fanotify-fix-list-corruption-in-fanotify_get_response.patch
fsnotify-drop-notification_mutex-before-destroying-event.patch
fsnotify-convert-notification_mutex-to-a-spinlock.patch
fanotify-use-notification_lock-instead-of-access_lock.patch
fanotify-fix-possible-false-warning-when-freeing-events.patch

