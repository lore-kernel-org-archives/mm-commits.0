From: akpm@linux-foundation.org
Subject: - a-potential-bug-in-inotify_userc.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:29 -0800
Message-ID: <200802070020.m170KAN7006097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933854AbYBGAUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:20:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanzheng@21cn.com, rlove@rlove.org, ttb@tentacle.dhs.org, mm-commits@vger.kernel.org


The patch titled
     A potential bug in inotify_user.c
has been removed from the -mm tree.  Its filename was
     a-potential-bug-in-inotify_userc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: A potential bug in inotify_user.c
From: "Yan Zheng" <yanzheng@21cn.com>

Following comment is at fs/inotify_user.c:287
/* coalescing: drop this event if it is a dupe of the previous */

I think the previous event in the comment should be the last event in the
link list.  But inotify_dev_get_event return the first event in the list. 
In addition, it doesn't check whether the list is empty

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
Acked-by: Robert Love <rlove@rlove.org>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/inotify_user.c~a-potential-bug-in-inotify_userc fs/inotify_user.c
--- a/fs/inotify_user.c~a-potential-bug-in-inotify_userc
+++ a/fs/inotify_user.c
@@ -248,6 +248,19 @@ inotify_dev_get_event(struct inotify_dev
 }
 
 /*
+ * inotify_dev_get_last_event - return the last event in the given dev's queue
+ *
+ * Caller must hold dev->ev_mutex.
+ */
+static inline struct inotify_kernel_event *
+inotify_dev_get_last_event(struct inotify_device *dev)
+{
+	if (list_empty(&dev->events))
+		return NULL;
+	return list_entry(dev->events.prev, struct inotify_kernel_event, list);
+}
+
+/*
  * inotify_dev_queue_event - event handler registered with core inotify, adds
  * a new event to the given device
  *
@@ -273,7 +286,7 @@ static void inotify_dev_queue_event(stru
 		put_inotify_watch(w); /* final put */
 
 	/* coalescing: drop this event if it is a dupe of the previous */
-	last = inotify_dev_get_event(dev);
+	last = inotify_dev_get_last_event(dev);
 	if (last && last->event.mask == mask && last->event.wd == wd &&
 			last->event.cookie == cookie) {
 		const char *lastname = last->name;
_

Patches currently in -mm which might be from yanzheng@21cn.com are

origin.patch
