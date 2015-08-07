From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
 removed from -mm tree
Date: Fri, 07 Aug 2015 12:03:02 -0700
Message-ID: <55c500e6.WCa/+ExUkAisGXTt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946066AbbHGTDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 15:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix BUG in ocfs2_downconvert_thread_do_work()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/ocfs2/dlmglue.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work
+++ a/fs/ocfs2/dlmglue.c
@@ -4025,9 +4025,13 @@ static void ocfs2_downconvert_thread_do_
 	osb->dc_work_sequence = osb->dc_wake_sequence;
 
 	processed = osb->blocked_lock_count;
-	while (processed) {
-		BUG_ON(list_empty(&osb->blocked_lock_list));
-
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
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

