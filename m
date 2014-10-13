From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch removed from -mm
 tree
Date: Mon, 13 Oct 2014 11:17:31 -0700
Message-ID: <543c173b.M4dgXMvQ9rWAHHqO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaJMSRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: refactor error handling in dlm_alloc_ctxt
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: refactor error handling in dlm_alloc_ctxt

Refactoring error handling in dlm_alloc_ctxt to simplify code.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   42 +++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1975,24 +1975,22 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 
 	dlm = kzalloc(sizeof(*dlm), GFP_KERNEL);
 	if (!dlm) {
-		mlog_errno(-ENOMEM);
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}
 
 	dlm->name = kstrdup(domain, GFP_KERNEL);
 	if (dlm->name == NULL) {
-		mlog_errno(-ENOMEM);
-		kfree(dlm);
-		dlm = NULL;
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}
 
 	dlm->lockres_hash = (struct hlist_head **)dlm_alloc_pagevec(DLM_HASH_PAGES);
 	if (!dlm->lockres_hash) {
-		mlog_errno(-ENOMEM);
-		kfree(dlm->name);
-		kfree(dlm);
-		dlm = NULL;
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}
 
@@ -2002,11 +2000,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 	dlm->master_hash = (struct hlist_head **)
 				dlm_alloc_pagevec(DLM_HASH_PAGES);
 	if (!dlm->master_hash) {
-		mlog_errno(-ENOMEM);
-		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
-		kfree(dlm->name);
-		kfree(dlm);
-		dlm = NULL;
+		ret = -ENOMEM;
+		mlog_errno(ret);
 		goto leave;
 	}
 
@@ -2017,14 +2012,8 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 	dlm->node_num = o2nm_this_node();
 
 	ret = dlm_create_debugfs_subroot(dlm);
-	if (ret < 0) {
-		dlm_free_pagevec((void **)dlm->master_hash, DLM_HASH_PAGES);
-		dlm_free_pagevec((void **)dlm->lockres_hash, DLM_HASH_PAGES);
-		kfree(dlm->name);
-		kfree(dlm);
-		dlm = NULL;
+	if (ret < 0)
 		goto leave;
-	}
 
 	spin_lock_init(&dlm->spinlock);
 	spin_lock_init(&dlm->master_lock);
@@ -2085,6 +2074,19 @@ static struct dlm_ctxt *dlm_alloc_ctxt(c
 		  atomic_read(&dlm->dlm_refs.refcount));
 
 leave:
+	if (ret < 0 && dlm) {
+		if (dlm->master_hash)
+			dlm_free_pagevec((void **)dlm->master_hash,
+					DLM_HASH_PAGES);
+
+		if (dlm->lockres_hash)
+			dlm_free_pagevec((void **)dlm->lockres_hash,
+					DLM_HASH_PAGES);
+
+		kfree(dlm->name);
+		kfree(dlm);
+		dlm = NULL;
+	}
 	return dlm;
 }
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch

