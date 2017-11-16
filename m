From: akpm@linux-foundation.org
Subject: [patch 004/131] ocfs2: no need flush workqueue before
 destroying it
Date: Wed, 15 Nov 2017 17:31:25 -0800
Message-ID: <20171116013125.1mErWFMz1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754571AbdKPBb1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:31:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: piaojun <piaojun@huawei.com>
Subject: ocfs2: no need flush workqueue before destroying it

destroy_workqueue() will do flushing work for us.

Link: http://lkml.kernel.org/r/59E06476.3090502@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    1 -
 fs/ocfs2/dlmfs/dlmfs.c   |    1 -
 fs/ocfs2/super.c         |    4 +---
 3 files changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-no-need-flush-workqueue-before-destroying-it fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-no-need-flush-workqueue-before-destroying-it
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -394,7 +394,6 @@ int dlm_domain_fully_joined(struct dlm_c
 static void dlm_destroy_dlm_worker(struct dlm_ctxt *dlm)
 {
 	if (dlm->dlm_worker) {
-		flush_workqueue(dlm->dlm_worker);
 		destroy_workqueue(dlm->dlm_worker);
 		dlm->dlm_worker = NULL;
 	}
diff -puN fs/ocfs2/dlmfs/dlmfs.c~ocfs2-no-need-flush-workqueue-before-destroying-it fs/ocfs2/dlmfs/dlmfs.c
--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-no-need-flush-workqueue-before-destroying-it
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -670,7 +670,6 @@ static void __exit exit_dlmfs_fs(void)
 {
 	unregister_filesystem(&dlmfs_fs_type);
 
-	flush_workqueue(user_dlm_worker);
 	destroy_workqueue(user_dlm_worker);
 
 	/*
diff -puN fs/ocfs2/super.c~ocfs2-no-need-flush-workqueue-before-destroying-it fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-no-need-flush-workqueue-before-destroying-it
+++ a/fs/ocfs2/super.c
@@ -2521,10 +2521,8 @@ static void ocfs2_delete_osb(struct ocfs
 	/* This function assumes that the caller has the main osb resource */
 
 	/* ocfs2_initializer_super have already created this workqueue */
-	if (osb->ocfs2_wq) {
-		flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq)
 		destroy_workqueue(osb->ocfs2_wq);
-	}
 
 	ocfs2_free_slot_info(osb);
 
_
