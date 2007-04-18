From: akpm@linux-foundation.org
Subject: + nfs-fix-race-in-nfs_set_page_dirty.patch added to -mm tree
Date: Tue, 17 Apr 2007 19:56:35 -0700
Message-ID: <200704180256.l3I2uZef014604@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030840AbXDRC4l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 22:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com


The patch titled
     NFS: Fix race in nfs_set_page_dirty
has been added to the -mm tree.  Its filename is
     nfs-fix-race-in-nfs_set_page_dirty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: Fix race in nfs_set_page_dirty
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Protect nfs_set_page_dirty() against races with nfs_inode_add_request.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/nfs/write.c~nfs-fix-race-in-nfs_set_page_dirty fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-fix-race-in-nfs_set_page_dirty
+++ a/fs/nfs/write.c
@@ -376,6 +376,8 @@ static int nfs_inode_add_request(struct 
 	}
 	SetPagePrivate(req->wb_page);
 	set_page_private(req->wb_page, (unsigned long)req);
+	if (PageDirty(req->wb_page))
+		set_bit(PG_NEED_FLUSH, &req->wb_flags);
 	nfsi->npages++;
 	atomic_inc(&req->wb_count);
 	return 0;
@@ -395,6 +397,8 @@ static void nfs_inode_remove_request(str
 	set_page_private(req->wb_page, 0);
 	ClearPagePrivate(req->wb_page);
 	radix_tree_delete(&nfsi->nfs_page_tree, req->wb_index);
+	if (test_and_clear_bit(PG_NEED_FLUSH, &req->wb_flags))
+		__set_page_dirty_nobuffers(req->wb_page);
 	nfsi->npages--;
 	if (!nfsi->npages) {
 		spin_unlock(&nfsi->req_lock);
@@ -1530,15 +1534,22 @@ int nfs_wb_page(struct inode *inode, str
 
 int nfs_set_page_dirty(struct page *page)
 {
+	spinlock_t *req_lock = &NFS_I(page->mapping->host)->req_lock;
 	struct nfs_page *req;
+	int ret;
 
-	req = nfs_page_find_request(page);
+	spin_lock(req_lock);
+	req = nfs_page_find_request_locked(page);
 	if (req != NULL) {
 		/* Mark any existing write requests for flushing */
-		set_bit(PG_NEED_FLUSH, &req->wb_flags);
+		ret = !test_and_set_bit(PG_NEED_FLUSH, &req->wb_flags);
+		spin_unlock(req_lock);
 		nfs_release_request(req);
+		return ret;
 	}
-	return __set_page_dirty_nobuffers(page);
+	ret = __set_page_dirty_nobuffers(page);
+	spin_unlock(req_lock);
+	return ret;
 }
 
 
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

origin.patch
nfs-clean-up-the-unstable-write-code.patch
nfs-fix-race-in-nfs_set_page_dirty.patch
nfs-fix-the-desynchronized-value-of-nfs_incommit-error.patch
nfs-dont-clear-pg_writeback-until-after-weve-processed-unstable-writes.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
