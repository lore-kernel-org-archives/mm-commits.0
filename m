From: akpm@linux-foundation.org
Subject: + fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
 added to -mm tree
Date: Thu, 23 Jul 2015 11:13:50 -0700
Message-ID: <55b12ede.skl1RQianoFgi89f%akpm__13071.7895845466$1437675242$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbbGWSNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 14:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, LinoSanfilippo@gmx.de, a.sangwan@samsung.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: fix oops in fsnotify_clear_marks_by_group_flags()
has been added to the -mm tree.  Its filename is
     fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.com>
Subject: fsnotify: fix oops in fsnotify_clear_marks_by_group_flags()

fsnotify_clear_marks_by_group_flags() can race with
fsnotify_destroy_marks() so when fsnotify_destroy_mark_locked() drops
mark_mutex, a mark from the list iterated by
fsnotify_clear_marks_by_group_flags() can be freed and thus the next entry
pointer we have cached may become stale and we dereference free memory.

Fix the problem by first moving marks to free to a special private list
and then always free the first entry in the special list.  This method is
safe even when entries from the list can disappear once we drop the lock.

Signed-off-by: Jan Kara <jack@suse.com>
Reported-by: Ashish Sangwan <a.sangwan@samsung.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags
+++ a/fs/notify/mark.c
@@ -412,16 +412,36 @@ void fsnotify_clear_marks_by_group_flags
 					 unsigned int flags)
 {
 	struct fsnotify_mark *lmark, *mark;
+	LIST_HEAD(to_free);
 
+	/*
+	 * We have to be really careful here. Anytime we drop mark_mutex, e.g.
+	 * fsnotify_clear_marks_by_inode() can come and free marks. Even in our
+	 * to_free list so we have to use mark_mutex even when accessing that
+	 * list. And freeing mark requires us to drop mark_mutex. So we can
+	 * reliably free only the first mark in the list. That's why we first
+	 * move marks to free to to_free list in one go and then free marks in
+	 * to_free list one by one.
+	 */
 	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
-		if (mark->flags & flags) {
-			fsnotify_get_mark(mark);
-			fsnotify_destroy_mark_locked(mark, group);
-			fsnotify_put_mark(mark);
-		}
+		if (mark->flags & flags)
+			list_move(&mark->g_list, &to_free);
 	}
 	mutex_unlock(&group->mark_mutex);
+
+	while (1) {
+		mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+		if (list_empty(&to_free)) {
+			mutex_unlock(&group->mark_mutex);
+			break;
+		}
+		mark = list_first_entry(&to_free, struct fsnotify_mark, g_list);
+		fsnotify_get_mark(mark);
+		fsnotify_destroy_mark_locked(mark, group);
+		mutex_unlock(&group->mark_mutex);
+		fsnotify_put_mark(mark);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from jack@suse.com are

origin.patch
fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
linux-next.patch

