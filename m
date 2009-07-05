From: akpm@linux-foundation.org
Subject: [merged] fs-notify-inotify-decrement-user-inotify-count-on-close.patch removed from -mm tree
Date: Sun, 05 Jul 2009 11:36:07 -0700
Message-ID: <200907051836.n65Ia7n7005074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbZGESgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 5 Jul 2009 14:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keithp@keithp.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/notify/inotify: decrement user inotify count on close
has been removed from the -mm tree.  Its filename was
     fs-notify-inotify-decrement-user-inotify-count-on-close.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/notify/inotify: decrement user inotify count on close
From: Keith Packard <keithp@keithp.com>

The per-user inotify_devs value is incremented each time a new file is
allocated, but never decremented. This led to inotify_init failing after a
limited number of calls.

Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/notify/inotify/inotify_user.c~fs-notify-inotify-decrement-user-inotify-count-on-close fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fs-notify-inotify-decrement-user-inotify-count-on-close
+++ a/fs/notify/inotify/inotify_user.c
@@ -296,12 +296,15 @@ static int inotify_fasync(int fd, struct
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
+	struct user_struct *user = group->inotify_data.user;
 
 	fsnotify_clear_marks_by_group(group);
 
 	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
 	fsnotify_put_group(group);
 
+	atomic_dec(&user->inotify_devs);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from keithp@keithp.com are


