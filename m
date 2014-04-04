From: akpm@linux-foundation.org
Subject: [merged] fanotify-reorganize-loop-in-fanotify_read.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:29:39 -0700
Message-ID: <533f0823.ykmO8AJPAVu0MiS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaDDT3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, jack@suse.cz

Subject: [merged] fanotify-reorganize-loop-in-fanotify_read.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:39 -0700


The patch titled
     Subject: fanotify: reorganize loop in fanotify_read()
has been removed from the -mm tree.  Its filename was
     fanotify-reorganize-loop-in-fanotify_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: reorganize loop in fanotify_read()

Swap the error / "read ok" branches in the main loop of fanotify_read(). 
We will grow the "read ok" part in the next patch and this makes the
indentation easier.  Also it is more common to have error conditions
inside an 'if' instead of the fast path.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   46 ++++++++++++++-------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-reorganize-loop-in-fanotify_read fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-reorganize-loop-in-fanotify_read
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -275,35 +275,37 @@ static ssize_t fanotify_read(struct file
 		kevent = get_one_event(group, count);
 		mutex_unlock(&group->notification_mutex);
 
-		if (kevent) {
+		if (IS_ERR(kevent)) {
 			ret = PTR_ERR(kevent);
-			if (IS_ERR(kevent))
+			break;
+		}
+
+		if (!kevent) {
+			ret = -EAGAIN;
+			if (file->f_flags & O_NONBLOCK)
+				break;
+
+			ret = -ERESTARTSYS;
+			if (signal_pending(current))
 				break;
-			ret = copy_event_to_user(group, kevent, buf);
-			/*
-			 * Permission events get queued to wait for response.
-			 * Other events can be destroyed now.
-			 */
-			if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
-				fsnotify_destroy_event(group, kevent);
-			if (ret < 0)
+
+			if (start != buf)
 				break;
-			buf += ret;
-			count -= ret;
+			schedule();
 			continue;
 		}
 
-		ret = -EAGAIN;
-		if (file->f_flags & O_NONBLOCK)
-			break;
-		ret = -ERESTARTSYS;
-		if (signal_pending(current))
+		ret = copy_event_to_user(group, kevent, buf);
+		/*
+		 * Permission events get queued to wait for response.  Other
+		 * events can be destroyed now.
+		 */
+		if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+			fsnotify_destroy_event(group, kevent);
+		if (ret < 0)
 			break;
-
-		if (start != buf)
-			break;
