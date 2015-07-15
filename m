From: akpm@linux-foundation.org
Subject: +
 fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount.patch
 added to -mm tree
Date: Wed, 15 Jul 2015 13:42:29 -0700
Message-ID: <55a6c5b5.UFP76np4rUVKxypR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbbGOUm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: make fsnotify_destroy_mark_locked() safe without refcount
has been added to the -mm tree.  Its filename is
     fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount.patch

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
Subject: fsnotify: make fsnotify_destroy_mark_locked() safe without refcount

fsnotify_destroy_mark_locked() is almost safe without holding a reference
to destroyed mark (the comment before that function is obviously stale as
fsnotify_put_mark() isn't called in that function at all).  The only thing
that may race with mark freeing is update of group mark count so do that
before queueing destruction of the mark.  Also update the comment to
better describe reality.

With this change fsnotify_clear_marks_by_group_flags() has no need to grab
reference to fsnotify mark so just remove that.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount
+++ a/fs/notify/mark.c
@@ -122,9 +122,12 @@ u32 fsnotify_recalc_mask(struct hlist_he
 }
 
 /*
- * Any time a mark is getting freed we end up here.
- * The caller had better be holding a reference to this mark so we don't actually
- * do the final put under the mark->lock
+ * Any time a mark is getting freed we end up here. We remove mark from
+ * inode / vfsmount list so that it cannot be found by new events, from the
+ * group list so that functions manipulating group cannot touch it, and queue
+ * it for further processing by notification kthread. We are still holding
+ * initial mark reference which gets dropped by the notification kthread once
+ * it's done destroying the mark.
  */
 void fsnotify_destroy_mark_locked(struct fsnotify_mark *mark,
 				  struct fsnotify_group *group)
@@ -157,11 +160,6 @@ void fsnotify_destroy_mark_locked(struct
 	if (inode && (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED))
 		iput(inode);
 
-	spin_lock(&destroy_lock);
-	list_add(&mark->g_list, &destroy_list);
-	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
-
 	/*
 	 * __fsnotify_update_child_dentry_flags(inode);
 	 *
@@ -173,8 +171,13 @@ void fsnotify_destroy_mark_locked(struct
 	 * children and will update all of these flags then.  So really this
 	 * is just a lazy update (and could be a perf win...)
 	 */
-
 	atomic_dec(&group->num_marks);
+
+	/* Queue for further destruction by kthread */
+	spin_lock(&destroy_lock);
+	list_add(&mark->g_list, &destroy_list);
+	spin_unlock(&destroy_lock);
+	wake_up(&destroy_waitq);
 }
 
 void fsnotify_destroy_mark(struct fsnotify_mark *mark,
@@ -400,11 +403,8 @@ void fsnotify_clear_marks_by_group_flags
 
 	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
-		if (mark->flags & flags) {
-			fsnotify_get_mark(mark);
+		if (mark->flags & flags)
 			fsnotify_destroy_mark_locked(mark, group);
-			fsnotify_put_mark(mark);
-		}
 	}
 	mutex_unlock(&group->mark_mutex);
 }
_

Patches currently in -mm which might be from jack@suse.com are

maintainers-switch-to-susecom-many-in-one.patch
fs-optimize-inotify-fsnotify-code-for-unwatched-files.patch
fsnotify-make-fsnotify_destroy_mark_locked-safe-without-refcount.patch
linux-next.patch

