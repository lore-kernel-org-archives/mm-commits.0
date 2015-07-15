From: akpm@linux-foundation.org
Subject: + fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
 added to -mm tree
Date: Wed, 15 Jul 2015 13:41:19 -0700
Message-ID: <55a6c56f.qWwbyVhYakY5PoAP%akpm__2217.26448876343$1436992893$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbbGOUlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 16:41:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, a.sangwan@samsung.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


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
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: fix oops in fsnotify_clear_marks_by_group_flags()

fsnotify_clear_marks_by_group_flags() can race with
fsnotify_destroy_marks() so when fsnotify_destroy_mark_locked() drops
mark_mutex, a mark from the list iterated by
fsnotify_clear_marks_by_group_flags() can be freed and we dereference free
memory in the loop there.

Fix the problem by keeping mark_mutex held in
fsnotify_destroy_mark_locked().  The reason why we drop that mutex is that
we need to call a ->freeing_mark() callback which may acquire mark_mutex
again.  To avoid this and similar lock inversion issues, we move the call
to ->freeing_mark() callback to the kthread destroying the mark.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Ashish Sangwan <a.sangwan@samsung.com>
Suggested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/mark.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff -puN fs/notify/mark.c~fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags fs/notify/mark.c
--- a/fs/notify/mark.c~fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags
+++ a/fs/notify/mark.c
@@ -152,31 +152,15 @@ void fsnotify_destroy_mark_locked(struct
 		BUG();
 
 	list_del_init(&mark->g_list);
-
 	spin_unlock(&mark->lock);
 
 	if (inode && (mark->flags & FSNOTIFY_MARK_FLAG_OBJECT_PINNED))
 		iput(inode);
-	/* release lock temporarily */
-	mutex_unlock(&group->mark_mutex);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->g_list, &destroy_list);
 	spin_unlock(&destroy_lock);
 	wake_up(&destroy_waitq);
-	/*
-	 * We don't necessarily have a ref on mark from caller so the above destroy
-	 * may have actually freed it, unless this group provides a 'freeing_mark'
-	 * function which must be holding a reference.
-	 */
-
-	/*
-	 * Some groups like to know that marks are being freed.  This is a
-	 * callback to the group function to let it know that this mark
-	 * is being freed.
-	 */
-	if (group->ops->freeing_mark)
-		group->ops->freeing_mark(mark, group);
 
 	/*
 	 * __fsnotify_update_child_dentry_flags(inode);
@@ -191,8 +175,6 @@ void fsnotify_destroy_mark_locked(struct
 	 */
 
 	atomic_dec(&group->num_marks);
-
-	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
 }
 
 void fsnotify_destroy_mark(struct fsnotify_mark *mark,
@@ -205,7 +187,10 @@ void fsnotify_destroy_mark(struct fsnoti
 
 /*
  * Destroy all marks in the given list. The marks must be already detached from
- * the original inode / vfsmount.
+ * the original inode / vfsmount. Note that we can race with
+ * fsnotify_clear_marks_by_group_flags(). However we hold a reference to each
+ * mark so they won't get freed from under us and nobody else touches our
+ * free_list list_head.
  */
 void fsnotify_destroy_marks(struct list_head *to_free)
 {
@@ -406,7 +391,7 @@ struct fsnotify_mark *fsnotify_find_mark
 }
 
 /*
- * clear any marks in a group in which mark->flags & flags is true
+ * Clear any marks in a group in which mark->flags & flags is true.
  */
 void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
 					 unsigned int flags)
@@ -460,6 +445,7 @@ static int fsnotify_mark_destroy(void *i
 {
 	struct fsnotify_mark *mark, *next;
 	struct list_head private_destroy_list;
+	struct fsnotify_group *group;
 
 	for (;;) {
 		spin_lock(&destroy_lock);
@@ -471,6 +457,14 @@ static int fsnotify_mark_destroy(void *i
 
 		list_for_each_entry_safe(mark, next, &private_destroy_list, g_list) {
 			list_del_init(&mark->g_list);
+			group = mark->group;
+			/*
+			 * Some groups like to know that marks are being freed.
+			 * This is a callback to the group function to let it
+			 * know that this mark is being freed.
+			 */
+			if (group && group->ops->freeing_mark)
+				group->ops->freeing_mark(mark, group);
 			fsnotify_put_mark(mark);
 		}
 
_

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-fix-oops-in-fsnotify_clear_marks_by_group_flags.patch
fsnotify-fix-check-in-inotify-fdinfo-printing.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse_integer-convert-ext2-ext3-ext4.patch
mm-add-strictlimit-knob-v2.patch

