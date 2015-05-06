From: akpm@linux-foundation.org
Subject: + ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch added
 to -mm tree
Date: Wed, 06 May 2015 15:25:33 -0700
Message-ID: <554a94dd.yePWWUPCDXrmOQrB%akpm__47747.0056656331$1430951148$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbbEFWZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 18:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG in ocfs2_downconvert_thread_do_work()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch

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
Subject: ocfs2: fix BUG in ocfs2_downconvert_thread_do_work()

BUG_ON(list_empty(&osb->blocked_lock_list)) in
ocfs2_downconvert_thread_do_work can be triggered in the following case:

ocfs2dc has firstly saved osb->blocked_lock_count to local varibale
processed, and then processes the dentry lockres.  During the dentry put,
it calls iput and then deletes rw, inode and open lockres from blocked
list in ocfs2_mark_lockres_freeing.  And this causes the variable
`processed' to not reflect the number of blocked lockres to be processed,
which triggers the BUG.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   10 ++++------
 fs/ocfs2/ocfs2.h   |    1 +
 fs/ocfs2/super.c   |    1 +
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work
+++ a/fs/ocfs2/dlmglue.c
@@ -3198,6 +3198,7 @@ void ocfs2_mark_lockres_freeing(struct o
 		spin_lock_irqsave(&osb->dc_task_lock, flags2);
 		list_del_init(&lockres->l_blocked_list);
 		osb->blocked_lock_count--;
+		osb->blocked_lock_processed--;
 		spin_unlock_irqrestore(&osb->dc_task_lock, flags2);
 		/*
 		 * Warn if we recurse into another post_unlock call.  Strictly
@@ -4015,7 +4016,6 @@ static void ocfs2_schedule_blocked_lock(
 
 static void ocfs2_downconvert_thread_do_work(struct ocfs2_super *osb)
 {
-	unsigned long processed;
 	unsigned long flags;
 	struct ocfs2_lock_res *lockres;
 
@@ -4024,19 +4024,17 @@ static void ocfs2_downconvert_thread_do_
 	 * wake happens part-way through our work  */
 	osb->dc_work_sequence = osb->dc_wake_sequence;
 
-	processed = osb->blocked_lock_count;
-	while (processed) {
+	osb->blocked_lock_processed = osb->blocked_lock_count;
+	while (osb->blocked_lock_processed) {
 		BUG_ON(list_empty(&osb->blocked_lock_list));
 
 		lockres = list_entry(osb->blocked_lock_list.next,
 				     struct ocfs2_lock_res, l_blocked_list);
 		list_del_init(&lockres->l_blocked_list);
 		osb->blocked_lock_count--;
+		osb->blocked_lock_processed--;
 		spin_unlock_irqrestore(&osb->dc_task_lock, flags);
 
-		BUG_ON(!processed);
-		processed--;
-
 		ocfs2_process_blocked_lock(osb, lockres);
 
 		spin_lock_irqsave(&osb->dc_task_lock, flags);
diff -puN fs/ocfs2/ocfs2.h~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work
+++ a/fs/ocfs2/ocfs2.h
@@ -424,6 +424,7 @@ struct ocfs2_super
 	 */
 	struct list_head blocked_lock_list;
 	unsigned long blocked_lock_count;
+	unsigned long blocked_lock_processed;
 
 	/* List of dquot structures to drop last reference to */
 	struct llist_head dquot_drop_list;
diff -puN fs/ocfs2/super.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work
+++ a/fs/ocfs2/super.c
@@ -2089,6 +2089,7 @@ static int ocfs2_initialize_super(struct
 	osb->dc_wake_sequence = 0;
 	INIT_LIST_HEAD(&osb->blocked_lock_list);
 	osb->blocked_lock_count = 0;
+	osb->blocked_lock_processed = 0;
 	spin_lock_init(&osb->osb_lock);
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

