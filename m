From: akpm@linux-foundation.org
Subject: + nfs-fix-the-desynchronized-value-of-nfs_incommit-error.patch added to -mm tree
Date: Tue, 17 Apr 2007 19:56:40 -0700
Message-ID: <200704180256.l3I2ueg4014607@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXDRC4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 22:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com


The patch titled
     NFS: Fix the 'desynchronized value of nfs_i.ncommit' error
has been added to the -mm tree.  Its filename is
     nfs-fix-the-desynchronized-value-of-nfs_incommit-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: Fix the 'desynchronized value of nfs_i.ncommit' error
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Redirtying a request that is already marked for commit will screw up the
accounting for NR_UNSTABLE_NFS as well as nfs_i.ncommit.
Ensure that all requests on the commit queue are labelled with the
PG_NEED_COMMIT flag, and avoid moving them onto the dirty list inside
nfs_page_mark_flush().

Also inline nfs_mark_request_dirty() into nfs_page_mark_flush() for
atomicity reasons. Avoid dropping the spinlock until we're done marking the
request in the radix tree and have added it to the ->dirty list.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff -puN fs/nfs/write.c~nfs-fix-the-desynchronized-value-of-nfs_incommit-error fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-fix-the-desynchronized-value-of-nfs_incommit-error
+++ a/fs/nfs/write.c
@@ -38,7 +38,6 @@
 static struct nfs_page * nfs_update_request(struct nfs_open_context*,
 					    struct page *,
 					    unsigned int, unsigned int);
-static void nfs_mark_request_dirty(struct nfs_page *req);
 static long nfs_flush_mapping(struct address_space *mapping, struct writeback_control *wbc, int how);
 static const struct rpc_call_ops nfs_write_partial_ops;
 static const struct rpc_call_ops nfs_write_full_ops;
@@ -255,7 +254,8 @@ static void nfs_end_page_writeback(struc
 static int nfs_page_mark_flush(struct page *page)
 {
 	struct nfs_page *req;
-	spinlock_t *req_lock = &NFS_I(page->mapping->host)->req_lock;
+	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+	spinlock_t *req_lock = &nfsi->req_lock;
 	int ret;
 
 	spin_lock(req_lock);
@@ -279,11 +279,23 @@ static int nfs_page_mark_flush(struct pa
 			return ret;
 		spin_lock(req_lock);
 	}
-	spin_unlock(req_lock);
+	if (test_bit(PG_NEED_COMMIT, &req->wb_flags)) {
+		/* This request is marked for commit */
+		spin_unlock(req_lock);
+		nfs_unlock_request(req);
+		return 1;
+	}
 	if (nfs_set_page_writeback(page) == 0) {
 		nfs_list_remove_request(req);
-		nfs_mark_request_dirty(req);
-	}
+		/* add the request to the inode's dirty list. */
+		radix_tree_tag_set(&nfsi->nfs_page_tree,
+				req->wb_index, NFS_PAGE_TAG_DIRTY);
+		nfs_list_add_request(req, &nfsi->dirty);
+		nfsi->ndirty++;
+		spin_unlock(req_lock);
+		__mark_inode_dirty(page->mapping->host, I_DIRTY_PAGES);
+	} else
+		spin_unlock(req_lock);
 	ret = test_bit(PG_NEED_FLUSH, &req->wb_flags);
 	nfs_unlock_request(req);
 	return ret;
@@ -410,24 +422,6 @@ static void nfs_inode_remove_request(str
 	nfs_release_request(req);
 }
 
-/*
- * Add a request to the inode's dirty list.
- */
-static void
-nfs_mark_request_dirty(struct nfs_page *req)
-{
-	struct inode *inode = req->wb_context->dentry->d_inode;
-	struct nfs_inode *nfsi = NFS_I(inode);
-
-	spin_lock(&nfsi->req_lock);
-	radix_tree_tag_set(&nfsi->nfs_page_tree,
-			req->wb_index, NFS_PAGE_TAG_DIRTY);
-	nfs_list_add_request(req, &nfsi->dirty);
-	nfsi->ndirty++;
-	spin_unlock(&nfsi->req_lock);
-	__mark_inode_dirty(inode, I_DIRTY_PAGES);
-}
-
 static void
 nfs_redirty_request(struct nfs_page *req)
 {
@@ -442,7 +436,7 @@ nfs_dirty_request(struct nfs_page *req)
 {
 	struct page *page = req->wb_page;
 
-	if (page == NULL)
+	if (page == NULL || test_bit(PG_NEED_COMMIT, &req->wb_flags))
 		return 0;
 	return !PageWriteback(req->wb_page);
 }
@@ -460,6 +454,7 @@ nfs_mark_request_commit(struct nfs_page 
 	spin_lock(&nfsi->req_lock);
 	nfs_list_add_request(req, &nfsi->commit);
 	nfsi->ncommit++;
+	set_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 	spin_unlock(&nfsi->req_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
@@ -474,7 +469,7 @@ int nfs_write_need_commit(struct nfs_wri
 static inline
 int nfs_reschedule_unstable_write(struct nfs_page *req)
 {
-	if (test_and_clear_bit(PG_NEED_COMMIT, &req->wb_flags)) {
+	if (test_bit(PG_NEED_COMMIT, &req->wb_flags)) {
 		nfs_mark_request_commit(req);
 		return 1;
 	}
@@ -561,6 +556,7 @@ static void nfs_cancel_commit_list(struc
 		req = nfs_list_entry(head->next);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 		nfs_list_remove_request(req);
+		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 		nfs_inode_remove_request(req);
 		nfs_unlock_request(req);
 	}
@@ -1299,6 +1295,7 @@ static void nfs_commit_done(struct rpc_t
 	while (!list_empty(&data->pages)) {
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
+		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 
 		dprintk("NFS: commit (%s/%Ld %d@%Ld)",
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
nfs-clean-up-the-unstable-write-code.patch
nfs-fix-race-in-nfs_set_page_dirty.patch
nfs-fix-the-desynchronized-value-of-nfs_incommit-error.patch
nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
