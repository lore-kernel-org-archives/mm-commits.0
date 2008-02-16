From: akpm@linux-foundation.org
Subject: - nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch removed from -mm tree
Date: Fri, 15 Feb 2008 16:10:22 -0800
Message-ID: <200802160010.m1G0AMir031459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762664AbYBPAKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 19:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: use GFP_NOFS preloads for radix-tree insertion
has been removed from the -mm tree.  Its filename was
     nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: use GFP_NOFS preloads for radix-tree insertion
From: Nick Piggin <npiggin@suse.de>

NFS should use GFP_NOFS mode radix tree preloads rather than GFP_ATOMIC
allocations at radix-tree insertion-time.  This is important to reduce the
atomic memory requirement.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -puN fs/nfs/write.c~nfs-use-gfp_nofs-preloads-for-radix-tree-insertion fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-use-gfp_nofs-preloads-for-radix-tree-insertion
+++ a/fs/nfs/write.c
@@ -360,15 +360,13 @@ int nfs_writepages(struct address_space 
 /*
  * Insert a write request into an inode
  */
-static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
+static void nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int error;
 
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
-	BUG_ON(error == -EEXIST);
-	if (error)
-		return error;
+	BUG_ON(error);
 	if (!nfsi->npages) {
 		igrab(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
@@ -378,8 +376,8 @@ static int nfs_inode_add_request(struct 
 	set_page_private(req->wb_page, (unsigned long)req);
 	nfsi->npages++;
 	kref_get(&req->wb_kref);
-	radix_tree_tag_set(&nfsi->nfs_page_tree, req->wb_index, NFS_PAGE_TAG_LOCKED);
-	return 0;
+	radix_tree_tag_set(&nfsi->nfs_page_tree, req->wb_index,
+				NFS_PAGE_TAG_LOCKED);
 }
 
 /*
@@ -591,6 +589,13 @@ static struct nfs_page * nfs_update_requ
 		/* Loop over all inode entries and see if we find
 		 * A request for the page we wish to update
 		 */
+		if (new) {
+			if (radix_tree_preload(GFP_NOFS)) {
+				nfs_release_request(new);
+				return ERR_PTR(-ENOMEM);
+			}
+		}
+
 		spin_lock(&inode->i_lock);
 		req = nfs_page_find_request_locked(page);
 		if (req) {
@@ -601,28 +606,27 @@ static struct nfs_page * nfs_update_requ
 				error = nfs_wait_on_request(req);
 				nfs_release_request(req);
 				if (error < 0) {
-					if (new)
+					if (new) {
+						radix_tree_preload_end();
 						nfs_release_request(new);
+					}
 					return ERR_PTR(error);
 				}
 				continue;
 			}
 			spin_unlock(&inode->i_lock);
-			if (new)
+			if (new) {
+				radix_tree_preload_end();
 				nfs_release_request(new);
+			}
 			break;
 		}
 
 		if (new) {
-			int error;
 			nfs_lock_request_dontget(new);
-			error = nfs_inode_add_request(inode, new);
-			if (error) {
-				spin_unlock(&inode->i_lock);
-				nfs_unlock_request(new);
-				return ERR_PTR(error);
-			}
+			nfs_inode_add_request(inode, new);
 			spin_unlock(&inode->i_lock);
+			radix_tree_preload_end();
 			req = new;
 			goto zero_page;
 		}
_

Patches currently in -mm which might be from npiggin@suse.de are

git-drm.patch
git-kvm.patch
git-nfsd.patch
mm-remove-nopage.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
