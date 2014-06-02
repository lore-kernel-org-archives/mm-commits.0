From: akpm@linux-foundation.org
Subject: + ocfs2-remove-some-unused-codes.patch added to -mm tree
Date: Mon, 02 Jun 2014 16:21:46 -0700
Message-ID: <538d070a.H7POJD6HC9FDEEPI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaFBXVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 19:21:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-remove-some-unused-codes.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 16:21:46 -0700


The patch titled
     Subject: ocfs2: remove some unused code
has been added to the -mm tree.  Its filename is
     ocfs2-remove-some-unused-codes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-some-unused-codes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-some-unused-codes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: remove some unused code

dlm_recovery_ctxt.received is unused.

ocfs2_should_refresh_lock_res() can only return 0 or 1, so the error
handling code in ocfs2_super_lock() is unneeded.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    1 -
 fs/ocfs2/dlm/dlmdomain.c |    1 -
 fs/ocfs2/dlmglue.c       |    5 -----
 3 files changed, 7 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-remove-some-unused-codes fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-remove-some-unused-codes
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -108,7 +108,6 @@ static inline int dlm_is_recovery_lock(c
 struct dlm_recovery_ctxt
 {
 	struct list_head resources;
-	struct list_head received;
 	struct list_head node_data;
 	u8  new_master;
 	u8  dead_node;
diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-some-unused-codes fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-some-unused-codes
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -2034,7 +2034,6 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 	INIT_LIST_HEAD(&dlm->list);
 	INIT_LIST_HEAD(&dlm->dirty_list);
 	INIT_LIST_HEAD(&dlm->reco.resources);
-	INIT_LIST_HEAD(&dlm->reco.received);
 	INIT_LIST_HEAD(&dlm->reco.node_data);
 	INIT_LIST_HEAD(&dlm->purge_list);
 	INIT_LIST_HEAD(&dlm->dlm_domain_handlers);
diff -puN fs/ocfs2/dlmglue.c~ocfs2-remove-some-unused-codes fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-remove-some-unused-codes
+++ a/fs/ocfs2/dlmglue.c
@@ -2544,11 +2544,6 @@ int ocfs2_super_lock(struct ocfs2_super
 	 * refreshed, so we do it here. Of course, making sense of
 	 * everything is up to the caller :) */
 	status = ocfs2_should_refresh_lock_res(lockres);
-	if (status < 0) {
-		ocfs2_cluster_unlock(osb, lockres, level);
-		mlog_errno(status);
-		goto bail;
-	}
 	if (status) {
 		status = ocfs2_refresh_slot_info(osb);
 
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-fix-possible-convertion-deadlock.patch
ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch
ocfs2-dlm-disallow-node-joining-when-recovery-is-on-going.patch
ocfs2-cleanup-unused-paramters-in-ocfs2_calc_new_backup_super.patch
ocfs2-remove-some-unused-codes.patch
ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

