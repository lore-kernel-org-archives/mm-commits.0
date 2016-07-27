From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 11:59:00 -0700
Message-ID: <57990474.pdmmGHBwX+uzh/X/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbcG0S7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix memory leak of dlm_debug_ctxt
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix memory leak of dlm_debug_ctxt

dlm_debug_ctxt->debug_refcnt is initialized to 1 and then increased to 2
by dlm_debug_get in dlm_debug_init. But dlm_debug_put is called only
once in dlm_debug_shutdown during unregister dlm, which leads to
dlm_debug_ctxt leaked.

Link: http://lkml.kernel.org/r/577BB755.4030900@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdebug.c |   26 ++------------------------
 fs/ocfs2/dlm/dlmdebug.h |    1 -
 2 files changed, 2 insertions(+), 25 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdebug.c~ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -347,26 +347,6 @@ static struct dentry *dlm_debugfs_root;
 #define DLM_DEBUGFS_PURGE_LIST			"purge_list"
 
 /* begin - utils funcs */
-static void dlm_debug_free(struct kref *kref)
-{
-	struct dlm_debug_ctxt *dc;
-
-	dc = container_of(kref, struct dlm_debug_ctxt, debug_refcnt);
-
-	kfree(dc);
-}
-
-static void dlm_debug_put(struct dlm_debug_ctxt *dc)
-{
-	if (dc)
-		kref_put(&dc->debug_refcnt, dlm_debug_free);
-}
-
-static void dlm_debug_get(struct dlm_debug_ctxt *dc)
-{
-	kref_get(&dc->debug_refcnt);
-}
-
 static int debug_release(struct inode *inode, struct file *file)
 {
 	free_page((unsigned long)file->private_data);
@@ -932,11 +912,9 @@ int dlm_debug_init(struct dlm_ctxt *dlm)
 		goto bail;
 	}
 
-	dlm_debug_get(dc);
 	return 0;
 
 bail:
-	dlm_debug_shutdown(dlm);
 	return -ENOMEM;
 }
 
@@ -949,7 +927,8 @@ void dlm_debug_shutdown(struct dlm_ctxt
 		debugfs_remove(dc->debug_mle_dentry);
 		debugfs_remove(dc->debug_lockres_dentry);
 		debugfs_remove(dc->debug_state_dentry);
-		dlm_debug_put(dc);
+		kfree(dc);
+		dc = NULL;
 	}
 }
 
@@ -969,7 +948,6 @@ int dlm_create_debugfs_subroot(struct dl
 		mlog_errno(-ENOMEM);
 		goto bail;
 	}
-	kref_init(&dlm->dlm_debug_ctxt->debug_refcnt);
 
 	return 0;
 bail:
diff -puN fs/ocfs2/dlm/dlmdebug.h~ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt fs/ocfs2/dlm/dlmdebug.h
--- a/fs/ocfs2/dlm/dlmdebug.h~ocfs2-dlm-fix-memory-leak-of-dlm_debug_ctxt
+++ a/fs/ocfs2/dlm/dlmdebug.h
@@ -30,7 +30,6 @@ void dlm_print_one_mle(struct dlm_master
 #ifdef CONFIG_DEBUG_FS
 
 struct dlm_debug_ctxt {
-	struct kref debug_refcnt;
 	struct dentry *debug_state_dentry;
 	struct dentry *debug_lockres_dentry;
 	struct dentry *debug_mle_dentry;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


