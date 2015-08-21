From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch added to
 -mm tree
Date: Fri, 21 Aug 2015 14:06:01 -0700
Message-ID: <55d792b9.4imxpjJG2kuj0xKe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbHUVGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 17:06:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: use list_for_each_entry instead of list_for_each
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch

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

ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch
ocfs2-fix-bug-when-o2hb_register_callback-fails.patch
ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch
ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch

