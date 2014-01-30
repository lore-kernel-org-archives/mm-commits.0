From: akpm@linux-foundation.org
Subject: + fanotify-reorganize-loop-in-fanotify_read.patch added to -mm
 tree
Date: Thu, 30 Jan 2014 14:01:34 -0800
Message-ID: <52eacbbe.BU+PzYPbh3aaoF4x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaA3WBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 17:01:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: + fanotify-reorganize-loop-in-fanotify_read.patch added to -mm tree
To: jack@suse.cz,eparis@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 14:01:34 -0800


The patch titled
     Subject: fanotify: reorganize loop in fanotify_read()
has been added to the -mm tree.  Its filename is
     fanotify-reorganize-loop-in-fanotify_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-reorganize-loop-in-fanotify_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-reorganize-loop-in-fanotify_read.patch

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
Subject: fanotify: reorganize loop in fanotify_read()

Swap the error / "read ok" branches in the main loop of fanotify_read(). 
We will grow the "read ok" part in the next patch and this makes the
indentation easier.  Also it is more common to have error conditions
inside an 'if' instead of the fast path.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   46 ++++++++++++++-------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-reorganize-loop-in-fanotify_read fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-reorganize-loop-in-fanotify_read
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -272,35 +272,37 @@ static ssize_t fanotify_read(struct file
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
