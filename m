From: akpm@linux-foundation.org
Subject: + ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
 added to -mm tree
Date: Wed, 13 May 2015 15:07:07 -0700
Message-ID: <5553cb0b.W1YkxWg2EMO4ndES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbbEMWHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 May 2015 18:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2
has been added to the -mm tree.  Its filename is
     ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2

Changes since v1:
As Mark suggested, we can only add it to loop condition and explain the
case with comments instead of BUG.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   18 ++++++++++++------
 fs/ocfs2/ocfs2.h   |    1 -
 fs/ocfs2/super.c   |    1 -
 3 files changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2 fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2
+++ a/fs/ocfs2/dlmglue.c
@@ -3198,7 +3198,6 @@ void ocfs2_mark_lockres_freeing(struct o
 		spin_lock_irqsave(&osb->dc_task_lock, flags2);
 		list_del_init(&lockres->l_blocked_list);
 		osb->blocked_lock_count--;
-		osb->blocked_lock_processed--;
 		spin_unlock_irqrestore(&osb->dc_task_lock, flags2);
 		/*
 		 * Warn if we recurse into another post_unlock call.  Strictly
@@ -4016,6 +4015,7 @@ static void ocfs2_schedule_blocked_lock(
 
 static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
 {
+	unsigned long processed;
 	unsigned long flags;
 	struct ocfs2_lock_res *lockres;
 
@@ -4024,17 +4024,23 @@ static void ocfs2_downconvert_thread_do_
 	 * wake happens part-way through our work  */
 	osb->dc_work_sequence = osb->dc_wake_sequence;
 
-	osb->blocked_lock_processed = osb->blocked_lock_count;
-	while (osb->blocked_lock_processed) {
-		BUG_ON(list_empty(&osb->blocked_lock_list));
-
+	processed = osb->blocked_lock_count;
+	/*
+	 * blocked lock processing in this loop might call iput which can
+	 * remove items off osb->blocked_lock_list. Downconvert up to
+	 * 'processed' number of locks, but stop short if we had some
+	 * removed in ocfs2_mark_lockres_freeing when downconverting.
+	 */
+	while (processed && !list_empty(&osb->blocked_lock_list)) {
 		lockres = list_entry(osb->blocked_lock_list.next,
 				     struct ocfs2_lock_res, l_blocked_list);
 		list_del_init(&lockres->l_blocked_list);
 		osb->blocked_lock_count--;
-		osb->blocked_lock_processed--;
 		spin_unlock_irqrestore(&osb->dc_task_lock, flags);
 
+		BUG_ON(!processed);
+		processed--;
+
 		ocfs2_process_blocked_lock(osb, lockres);
 
 		spin_lock_irqsave(&osb->dc_task_lock, flags);
diff -puN fs/ocfs2/ocfs2.h~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2 fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2
+++ a/fs/ocfs2/ocfs2.h
@@ -424,7 +424,6 @@ struct ocfs2_super
 	 */
 	struct list_head blocked_lock_list;
 	unsigned long blocked_lock_count;
-	unsigned long blocked_lock_processed;
 
 	/* List of dquot structures to drop last reference to */
 	struct llist_head dquot_drop_list;
diff -puN fs/ocfs2/super.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2 fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2
+++ a/fs/ocfs2/super.c
@@ -2089,7 +2089,6 @@ static int ocfs2_initialize_super(struct
 	osb->dc_wake_sequence = 0;
 	INIT_LIST_HEAD(&osb->blocked_lock_list);
 	osb->blocked_lock_count = 0;
-	osb->blocked_lock_processed = 0;
 	spin_lock_init(&osb->osb_lock);
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

