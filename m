From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:02:16 -0700
Message-ID: <55ef22a8.D7KXkxcGdHBGgnvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbIHSCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: use list_for_each_entry instead of list_for_each
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: use list_for_each_entry instead of list_for_each

Use list_for_each_entry instead of list_for_each to simplify code.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1776,7 +1776,7 @@ static int dlm_process_recovery_data(str
 				     struct dlm_migratable_lockres *mres)
 {
 	struct dlm_migratable_lock *ml;
-	struct list_head *queue, *iter;
+	struct list_head *queue;
 	struct list_head *tmpq = NULL;
 	struct dlm_lock *newlock = NULL;
 	struct dlm_lockstatus *lksb = NULL;
@@ -1821,9 +1821,7 @@ static int dlm_process_recovery_data(str
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each(iter, tmpq) {
-					lock = list_entry(iter,
-						  struct dlm_lock, list);
+				list_for_each_entry(lock, tmpq, list) {
 					if (lock->ml.cookie == ml->cookie)
 						break;
 					lock = NULL;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


