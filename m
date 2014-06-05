From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-some-unused-codes.patch removed from -mm
 tree
Date: Thu, 05 Jun 2014 12:42:58 -0700
Message-ID: <5390c842.Nv46aQwa7LKP3Fg/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaFETm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-remove-some-unused-codes.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:58 -0700


The patch titled
     Subject: ocfs2: remove some unused code
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-some-unused-codes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
linux-next.patch

