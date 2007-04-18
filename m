From: akpm@linux-foundation.org
Subject: + nfs-clean-up-the-unstable-write-code.patch added to -mm tree
Date: Tue, 17 Apr 2007 19:56:32 -0700
Message-ID: <200704180256.l3I2uWOE014601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345AbXDRC4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 22:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com


The patch titled
     NFS: clean up the unstable write code
has been added to the -mm tree.  Its filename is
     nfs-clean-up-the-unstable-write-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: clean up the unstable write code
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Get rid of the inlined #ifdefs.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c           |  117 ++++++++++++++++++++++---------------
 include/linux/nfs_page.h |   30 ---------
 2 files changed, 71 insertions(+), 76 deletions(-)

diff -puN fs/nfs/write.c~nfs-clean-up-the-unstable-write-code fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-clean-up-the-unstable-write-code
+++ a/fs/nfs/write.c
@@ -460,6 +460,43 @@ nfs_mark_request_commit(struct nfs_page 
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
+
+static inline
+int nfs_write_need_commit(struct nfs_write_data *data)
+{
+	return data->verf.committed != NFS_FILE_SYNC;
+}
+
+static inline
+int nfs_reschedule_unstable_write(struct nfs_page *req)
+{
+	if (test_and_clear_bit(PG_NEED_COMMIT, &req->wb_flags)) {
+		nfs_mark_request_commit(req);
+		return 1;
+	}
+	if (test_and_clear_bit(PG_NEED_RESCHED, &req->wb_flags)) {
+		nfs_redirty_request(req);
+		return 1;
+	}
+	return 0;
+}
+#else
+static inline void
+nfs_mark_request_commit(struct nfs_page *req)
+{
+}
+
+static inline
+int nfs_write_need_commit(struct nfs_write_data *data)
+{
+	return 0;
+}
+
+static inline
+int nfs_reschedule_unstable_write(struct nfs_page *req)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -746,26 +783,12 @@ int nfs_updatepage(struct file *file, st
 
 static void nfs_writepage_release(struct nfs_page *req)
 {
-	nfs_end_page_writeback(req->wb_page);
-
-#if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
-	if (!PageError(req->wb_page)) {
-		if (NFS_NEED_RESCHED(req)) {
-			nfs_redirty_request(req);
-			goto out;
-		} else if (NFS_NEED_COMMIT(req)) {
-			nfs_mark_request_commit(req);
-			goto out;
-		}
-	}
-	nfs_inode_remove_request(req);
 
-out:
-	nfs_clear_commit(req);
-	nfs_clear_reschedule(req);
-#else
-	nfs_inode_remove_request(req);
-#endif
+	if (PageError(req->wb_page) || !nfs_reschedule_unstable_write(req)) {
+		nfs_end_page_writeback(req->wb_page);
+		nfs_inode_remove_request(req);
+	} else
+		nfs_end_page_writeback(req->wb_page);
 	nfs_clear_page_writeback(req);
 }
 
@@ -1008,22 +1031,28 @@ static void nfs_writeback_done_partial(s
 		nfs_set_pageerror(page);
 		req->wb_context->error = task->tk_status;
 		dprintk(", error = %d\n", task->tk_status);
-	} else {
-#if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
-		if (data->verf.committed < NFS_FILE_SYNC) {
-			if (!NFS_NEED_COMMIT(req)) {
-				nfs_defer_commit(req);
-				memcpy(&req->wb_verf, &data->verf, sizeof(req->wb_verf));
-				dprintk(" defer commit\n");
-			} else if (memcmp(&req->wb_verf, &data->verf, sizeof(req->wb_verf))) {
-				nfs_defer_reschedule(req);
-				dprintk(" server reboot detected\n");
-			}
-		} else
-#endif
-			dprintk(" OK\n");
+		goto out;
 	}
 
+	if (nfs_write_need_commit(data)) {
+		spinlock_t *req_lock = &NFS_I(page->mapping->host)->req_lock;
+
+		spin_lock(req_lock);
+		if (test_bit(PG_NEED_RESCHED, &req->wb_flags)) {
+			/* Do nothing we need to resend the writes */
+		} else if (!test_and_set_bit(PG_NEED_COMMIT, &req->wb_flags)) {
+			memcpy(&req->wb_verf, &data->verf, sizeof(req->wb_verf));
+			dprintk(" defer commit\n");
+		} else if (memcmp(&req->wb_verf, &data->verf, sizeof(req->wb_verf))) {
+			set_bit(PG_NEED_RESCHED, &req->wb_flags);
+			clear_bit(PG_NEED_COMMIT, &req->wb_flags);
+			dprintk(" server reboot detected\n");
+		}
+		spin_unlock(req_lock);
+	} else
+		dprintk(" OK\n");
+
+out:
 	if (atomic_dec_and_test(&req->wb_complete))
 		nfs_writepage_release(req);
 }
@@ -1064,25 +1093,21 @@ static void nfs_writeback_done_full(stru
 		if (task->tk_status < 0) {
 			nfs_set_pageerror(page);
 			req->wb_context->error = task->tk_status;
-			nfs_end_page_writeback(page);
-			nfs_inode_remove_request(req);
 			dprintk(", error = %d\n", task->tk_status);
-			goto next;
+			goto remove_request;
 		}
-		nfs_end_page_writeback(page);
 
-#if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
-		if (data->args.stable != NFS_UNSTABLE || data->verf.committed == NFS_FILE_SYNC) {
-			nfs_inode_remove_request(req);
-			dprintk(" OK\n");
+		if (nfs_write_need_commit(data)) {
+			memcpy(&req->wb_verf, &data->verf, sizeof(req->wb_verf));
+			nfs_mark_request_commit(req);
+			nfs_end_page_writeback(page);
+			dprintk(" marked for commit\n");
 			goto next;
 		}
-		memcpy(&req->wb_verf, &data->verf, sizeof(req->wb_verf));
-		nfs_mark_request_commit(req);
-		dprintk(" marked for commit\n");
-#else
+		dprintk(" OK\n");
+remove_request:
+		nfs_end_page_writeback(page);
 		nfs_inode_remove_request(req);
-#endif
 	next:
 		nfs_clear_page_writeback(req);
 	}
diff -puN include/linux/nfs_page.h~nfs-clean-up-the-unstable-write-code include/linux/nfs_page.h
--- a/include/linux/nfs_page.h~nfs-clean-up-the-unstable-write-code
+++ a/include/linux/nfs_page.h
@@ -49,8 +49,6 @@ struct nfs_page {
 };
 
 #define NFS_WBACK_BUSY(req)	(test_bit(PG_BUSY,&(req)->wb_flags))
-#define NFS_NEED_COMMIT(req)	(test_bit(PG_NEED_COMMIT,&(req)->wb_flags))
-#define NFS_NEED_RESCHED(req)	(test_bit(PG_NEED_RESCHED,&(req)->wb_flags))
 
 extern	struct nfs_page *nfs_create_request(struct nfs_open_context *ctx,
 					    struct inode *inode,
@@ -121,34 +119,6 @@ nfs_list_remove_request(struct nfs_page 
 	req->wb_list_head = NULL;
 }
 
-static inline int
-nfs_defer_commit(struct nfs_page *req)
-{
-	return !test_and_set_bit(PG_NEED_COMMIT, &req->wb_flags);
-}
-
-static inline void
-nfs_clear_commit(struct nfs_page *req)
-{
-	smp_mb__before_clear_bit();
-	clear_bit(PG_NEED_COMMIT, &req->wb_flags);
-	smp_mb__after_clear_bit();
-}
-
-static inline int
-nfs_defer_reschedule(struct nfs_page *req)
-{
-	return !test_and_set_bit(PG_NEED_RESCHED, &req->wb_flags);
-}
-
-static inline void
-nfs_clear_reschedule(struct nfs_page *req)
-{
-	smp_mb__before_clear_bit();
-	clear_bit(PG_NEED_RESCHED, &req->wb_flags);
-	smp_mb__after_clear_bit();
-}
-
 static inline struct nfs_page *
 nfs_list_entry(struct list_head *head)
 {
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
nfs-clean-up-the-unstable-write-code.patch
nfs-fix-race-in-nfs_set_page_dirty.patch
nfs-fix-the-desynchronized-value-of-nfs_incommit-error.patch
nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
