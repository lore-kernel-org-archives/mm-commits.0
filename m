From: akpm@linux-foundation.org
Subject: [merged] nfs-disable-data-cache-revalidation-for-swapfiles.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:25 -0700
Message-ID: <20120801201725.F40201E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab2HAUR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:27 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: disable data cache revalidation for swapfiles
has been removed from the -mm tree.  Its filename was
     nfs-disable-data-cache-revalidation-for-swapfiles.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: nfs: disable data cache revalidation for swapfiles

The VM does not like PG_private set on PG_swapcache pages.  As suggested
by Trond in http://lkml.org/lkml/2006/8/25/348, this patch disables NFS
data cache revalidation on swap files.  as it does not make sense to have
other clients change the file while it is being used as swap.  This avoids
setting PG_private on swap pages, since there ought to be no further races
with invalidate_inode_pages2() to deal with.

Since we cannot set PG_private we cannot use page->private which is
already used by PG_swapcache pages to store the nfs_page.  Thus augment
the new nfs_page_find_request logic.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/inode.c |    4 +++
 fs/nfs/write.c |   49 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff -puN fs/nfs/inode.c~nfs-disable-data-cache-revalidation-for-swapfiles fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-disable-data-cache-revalidation-for-swapfiles
+++ a/fs/nfs/inode.c
@@ -882,6 +882,10 @@ int nfs_revalidate_mapping(struct inode 
 	struct nfs_inode *nfsi = NFS_I(inode);
 	int ret = 0;
 
+	/* swapfiles are not supposed to be shared. */
+	if (IS_SWAPFILE(inode))
+		goto out;
+
 	if (nfs_mapping_need_revalidate_inode(inode)) {
 		ret = __nfs_revalidate_inode(NFS_SERVER(inode), inode);
 		if (ret < 0)
diff -puN fs/nfs/write.c~nfs-disable-data-cache-revalidation-for-swapfiles fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-disable-data-cache-revalidation-for-swapfiles
+++ a/fs/nfs/write.c
@@ -139,15 +139,28 @@ static void nfs_context_set_write_error(
 	set_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 }
 
-static struct nfs_page *nfs_page_find_request_locked(struct page *page)
+static struct nfs_page *
+nfs_page_find_request_locked(struct nfs_inode *nfsi, struct page *page)
 {
 	struct nfs_page *req = NULL;
 
-	if (PagePrivate(page)) {
+	if (PagePrivate(page))
 		req = (struct nfs_page *)page_private(page);
-		if (req != NULL)
-			kref_get(&req->wb_kref);
+	else if (unlikely(PageSwapCache(page))) {
+		struct nfs_page *freq, *t;
+
+		/* Linearly search the commit list for the correct req */
+		list_for_each_entry_safe(freq, t, &nfsi->commit_info.list, wb_list) {
+			if (freq->wb_page == page) {
+				req = freq;
+				break;
+			}
+		}
 	}
+
+	if (req)
+		kref_get(&req->wb_kref);
+
 	return req;
 }
 
@@ -157,7 +170,7 @@ static struct nfs_page *nfs_page_find_re
 	struct nfs_page *req = NULL;
 
 	spin_lock(&inode->i_lock);
-	req = nfs_page_find_request_locked(page);
+	req = nfs_page_find_request_locked(NFS_I(inode), page);
 	spin_unlock(&inode->i_lock);
 	return req;
 }
@@ -258,7 +271,7 @@ static struct nfs_page *nfs_find_and_loc
 
 	spin_lock(&inode->i_lock);
 	for (;;) {
-		req = nfs_page_find_request_locked(page);
+		req = nfs_page_find_request_locked(NFS_I(inode), page);
 		if (req == NULL)
 			break;
 		if (nfs_lock_request(req))
@@ -413,9 +426,15 @@ static void nfs_inode_add_request(struct
 	spin_lock(&inode->i_lock);
 	if (!nfsi->npages && NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
 		inode->i_version++;
-	set_bit(PG_MAPPED, &req->wb_flags);
-	SetPagePrivate(req->wb_page);
-	set_page_private(req->wb_page, (unsigned long)req);
+	/*
+	 * Swap-space should not get truncated. Hence no need to plug the race
+	 * with invalidate/truncate.
+	 */
+	if (likely(!PageSwapCache(req->wb_page))) {
+		set_bit(PG_MAPPED, &req->wb_flags);
+		SetPagePrivate(req->wb_page);
+		set_page_private(req->wb_page, (unsigned long)req);
+	}
 	nfsi->npages++;
 	kref_get(&req->wb_kref);
 	spin_unlock(&inode->i_lock);
@@ -432,9 +451,11 @@ static void nfs_inode_remove_request(str
 	BUG_ON (!NFS_WBACK_BUSY(req));
 
 	spin_lock(&inode->i_lock);
-	set_page_private(req->wb_page, 0);
-	ClearPagePrivate(req->wb_page);
-	clear_bit(PG_MAPPED, &req->wb_flags);
+	if (likely(!PageSwapCache(req->wb_page))) {
+		set_page_private(req->wb_page, 0);
+		ClearPagePrivate(req->wb_page);
+		clear_bit(PG_MAPPED, &req->wb_flags);
+	}
 	nfsi->npages--;
 	spin_unlock(&inode->i_lock);
 	nfs_release_request(req);
@@ -730,7 +751,7 @@ static struct nfs_page *nfs_try_to_updat
 	spin_lock(&inode->i_lock);
 
 	for (;;) {
-		req = nfs_page_find_request_locked(page);
+		req = nfs_page_find_request_locked(NFS_I(inode), page);
 		if (req == NULL)
 			goto out_unlock;
 
@@ -1744,7 +1765,7 @@ int nfs_wb_page_cancel(struct inode *ino
  */
 int nfs_wb_page(struct inode *inode, struct page *page)
 {
-	loff_t range_start = page_offset(page);
+	loff_t range_start = page_file_offset(page);
 	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

