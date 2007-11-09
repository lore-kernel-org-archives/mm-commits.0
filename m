From: akpm@linux-foundation.org
Subject: + nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch added to -mm tree
Date: Fri, 09 Nov 2007 14:17:13 -0800
Message-ID: <200711092217.lA9MHDrc002018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbXKIWRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 17:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     nfs: use GFP_NOFS preloads for radix-tree insertion
has been added to the -mm tree.  Its filename is
     nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/nfs/write.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN fs/nfs/write.c~nfs-use-gfp_nofs-preloads-for-radix-tree-insertion fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-use-gfp_nofs-preloads-for-radix-tree-insertion
+++ a/fs/nfs/write.c
@@ -363,15 +363,13 @@ int nfs_writepages(struct address_space 
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
@@ -381,7 +379,6 @@ static int nfs_inode_add_request(struct 
 	set_page_private(req->wb_page, (unsigned long)req);
 	nfsi->npages++;
 	kref_get(&req->wb_kref);
-	return 0;
 }
 
 /*
@@ -593,6 +590,13 @@ static struct nfs_page * nfs_update_requ
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
@@ -603,28 +607,27 @@ static struct nfs_page * nfs_update_requ
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

nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
rd-fix-data-corruption-on-memory-pressure.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4.patch
