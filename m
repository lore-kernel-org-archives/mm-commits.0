From: akpm@linux-foundation.org
Subject: [merged] inotify-fix-race-when-adding-a-new-watch.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:16 -0700
Message-ID: <51dc9a74.QVC8nsTkmiSMfcPM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, LinoSanfilippo@gmx.de

Subject: [merged] inotify-fix-race-when-adding-a-new-watch.patch removed from -mm tree
To: LinoSanfilippo@gmx.de,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:16 -0700


The patch titled
     Subject: inotify: fix race when adding a new watch
has been removed from the -mm tree.  Its filename was
     inotify-fix-race-when-adding-a-new-watch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: inotify: fix race when adding a new watch

In inotify_new_watch() the number of watches for a group is compared
against the max number of allowed watches and increased afterwards.  The
check and incrementation is not done atomically, so it is possible for
multiple concurrent threads to pass the check and increment the number of
marks above the allowed max.

This patch uses an inotify groups mark_lock to ensure that both check and
incrementation are done atomic.  Furthermore we dont have to worry about
the race that allows a concurrent thread to add a watch just after
inotify_update_existing_watch() returned with -ENOENT anymore, since this
is also synchronized by the groups mark mutex now.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-fix-race-when-adding-a-new-watch fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-fix-race-when-adding-a-new-watch
+++ a/fs/notify/inotify/inotify_user.c
@@ -636,7 +636,8 @@ static int inotify_new_watch(struct fsno
 		goto out_err;
 
 	/* we are on the idr, now get on the inode */
-	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, NULL, 0);
+	ret = fsnotify_add_mark_locked(&tmp_i_mark->fsn_mark, group, inode,
+				       NULL, 0);
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
@@ -660,19 +661,13 @@ static int inotify_update_watch(struct f
 {
 	int ret = 0;
 
-retry:
+	mutex_lock(&group->mark_mutex);
 	/* try to update and existing watch with the new arg */
 	ret = inotify_update_existing_watch(group, inode, arg);
 	/* no mark present, try to add a new one */
 	if (ret == -ENOENT)
 		ret = inotify_new_watch(group, inode, arg);
-	/*
-	 * inotify_new_watch could race with another thread which did an
-	 * inotify_new_watch between the update_existing and the add watch
-	 * here, go back and try to update an existing mark again.
-	 */
-	if (ret == -EEXIST)
-		goto retry;
+	mutex_unlock(&group->mark_mutex);
 
 	return ret;
 }
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch

