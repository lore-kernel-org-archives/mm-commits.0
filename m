From: akpm@linux-foundation.org
Subject: + fanotify-move-unrelated-handling-from-copy_event_to_user.patch
 added to -mm tree
Date: Thu, 30 Jan 2014 14:01:35 -0800
Message-ID: <52eacbbf.cTIR3NGn7rw/GCIQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3WBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 17:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: + fanotify-move-unrelated-handling-from-copy_event_to_user.patch added to -mm tree
To: jack@suse.cz,eparis@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 14:01:35 -0800


The patch titled
     Subject: fanotify: move unrelated handling from copy_event_to_user()
has been added to the -mm tree.  Its filename is
     fanotify-move-unrelated-handling-from-copy_event_to_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-move-unrelated-handling-from-copy_event_to_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-move-unrelated-handling-from-copy_event_to_user.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   35 +++++++++++++--------------
 1 file changed, 18 insertions(+), 17 deletions(-)

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
@@ -208,13 +208,8 @@ static ssize_t copy_event_to_user(struct
 		goto out_close_fd;
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
+	if (event->mask & FAN_ALL_PERM_EVENTS)
 		FANOTIFY_PE(event)->fd = fd;
-		spin_lock(&group->fanotify_data.access_lock);
-		list_add_tail(&event->fae.fse.list,
-			      &group->fanotify_data.access_list);
-		spin_unlock(&group->fanotify_data.access_lock);
-	}
 #endif
 
 	if (fd != FAN_NOFD)
@@ -226,13 +221,6 @@ out_close_fd:
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
 
@@ -297,10 +285,23 @@ static ssize_t fanotify_read(struct file
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
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-remove-useless-test-from-event-initialization.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
linux-next.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
mm-add-strictlimit-knob-v2.patch

