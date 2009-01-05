From: akpm@linux-foundation.org
Subject: - fs-reorder-struct-inotify_device-on-64bits-to-remove-padding.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:27 -0800
Message-ID: <200901050641.n056fRcv005497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbZAEGlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: reorder struct inotify_device on 64bits to remove padding
has been removed from the -mm tree.  Its filename was
     fs-reorder-struct-inotify_device-on-64bits-to-remove-padding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: reorder struct inotify_device on 64bits to remove padding
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reorder struct inotify_device to remove 8 bytes of padding on 64bit
builds, reducing size to 128 bytes.  Therefore allocating from a smaller
slab & using one fewer cachelines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inotify_user.c~fs-reorder-struct-inotify_device-on-64bits-to-remove-padding fs/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fs-reorder-struct-inotify_device-on-64bits-to-remove-padding
+++ a/fs/notify/inotify/inotify_user.c
@@ -76,10 +76,10 @@ struct inotify_device {
 	struct mutex		ev_mutex;	/* protects event queue */
 	struct mutex		up_mutex;	/* synchronizes watch updates */
 	struct list_head 	events;		/* list of queued events */
-	atomic_t		count;		/* reference count */
 	struct user_struct	*user;		/* user who opened this dev */
 	struct inotify_handle	*ih;		/* inotify handle */
 	struct fasync_struct    *fa;            /* async notification */
+	atomic_t		count;		/* reference count */
 	unsigned int		queue_size;	/* size of the queue (bytes) */
 	unsigned int		event_count;	/* number of pending events */
 	unsigned int		max_events;	/* maximum number of events */
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch

