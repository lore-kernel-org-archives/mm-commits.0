From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-move-unrelated-handling-from-copy_event_to_user.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:40 -0700
Message-ID: <533f0824./St5L5/eCyGVgQXe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaDDT3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, jack@suse.cz

Subject: [merged] fanotify-move-unrelated-handling-from-copy_event_to_user.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:40 -0700


The patch titled
     Subject: fanotify: move unrelated handling from copy_event_to_user()
has been removed from the -mm tree.  Its filename was
     fanotify-move-unrelated-handling-from-copy_event_to_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: move unrelated handling from copy_event_to_user()

Move code moving event structure to access_list from copy_event_to_user()
to fanotify_read() where it is more logical (so that we can immediately
see in the main loop that we either move the event to a different list or
free it).  Also move special error handling for permission events from
copy_event_to_user() to the main loop to have it in one place with error
handling for normal events.  This makes copy_event_to_user() really only
copy the event to user without any side effects.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   40 ++++++++++++---------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-move-unrelated-handling-from-copy_event_to_user fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-move-unrelated-handling-from-copy_event_to_user
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -199,7 +199,7 @@ static ssize_t copy_event_to_user(struct
 
 	ret = fill_event_metadata(group, &fanotify_event_metadata, event, &f);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	fd = fanotify_event_metadata.fd;
 	ret = -EFAULT;
@@ -208,16 +208,8 @@ static ssize_t copy_event_to_user(struct
 		goto out_close_fd;
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		struct fanotify_perm_event_info *pevent;
-
-		pevent = FANOTIFY_PE(event);
-		pevent->fd = fd;
-		spin_lock(&group->fanotify_data.access_lock);
-		list_add_tail(&pevent->fae.fse.list,
-			      &group->fanotify_data.access_list);
-		spin_unlock(&group->fanotify_data.access_lock);
-	}
+	if (event->mask & FAN_ALL_PERM_EVENTS)
+		FANOTIFY_PE(event)->fd = fd;
 #endif
 
 	if (fd != FAN_NOFD)
@@ -229,13 +221,6 @@ out_close_fd:
 		put_unused_fd(fd);
 		fput(f);
 	}
-out:
-#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		FANOTIFY_PE(event)->response = FAN_DENY;
-		wake_up(&group->fanotify_data.access_waitq);
-	}
-#endif
 	return ret;
 }
 
@@ -300,10 +285,23 @@ static ssize_t fanotify_read(struct file
 		 * Permission events get queued to wait for response.  Other
 		 * events can be destroyed now.
 		 */
-		if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+		if (!(kevent->mask & FAN_ALL_PERM_EVENTS)) {
 			fsnotify_destroy_event(group, kevent);
-		if (ret < 0)
-			break;
+			if (ret < 0)
+				break;
+		} else {
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+			if (ret < 0) {
+				FANOTIFY_PE(kevent)->response = FAN_DENY;
+				wake_up(&group->fanotify_data.access_waitq);
+				break;
+			}
+			spin_lock(&group->fanotify_data.access_lock);
+			list_add_tail(&kevent->list,
+				      &group->fanotify_data.access_list);
+			spin_unlock(&group->fanotify_data.access_lock);
+#endif
+		}
 		buf += ret;
 		count -= ret;
 	}
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

