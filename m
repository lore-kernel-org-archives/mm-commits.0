From: akpm@linux-foundation.org
Subject: [merged] nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:19 -0700
Message-ID: <20120801201720.69DD820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:43913 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755785Ab2HAURY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:24 -0400
Received: by lagr15 with SMTP id r15so343898lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: teach the NFS client how to treat PG_swapcache pages
has been removed from the -mm tree.  Its filename was
     nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: nfs: teach the NFS client how to treat PG_swapcache pages

Replace all relevant occurences of page->index and page->mapping in the
NFS client with the new page_file_index() and page_file_mapping()
functions.

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

 fs/nfs/file.c     |    6 +++---
 fs/nfs/internal.h |    7 ++++---
 fs/nfs/pagelist.c |    2 +-
 fs/nfs/read.c     |    6 +++---
 fs/nfs/write.c    |   36 ++++++++++++++++++------------------
 5 files changed, 29 insertions(+), 28 deletions(-)

diff -puN fs/nfs/file.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages
+++ a/fs/nfs/file.c
@@ -430,7 +430,7 @@ static void nfs_invalidate_page(struct p
 	if (offset != 0)
 		return;
 	/* Cancel any unstarted writes on this page */
-	nfs_wb_page_cancel(page->mapping->host, page);
+	nfs_wb_page_cancel(page_file_mapping(page)->host, page);
 
 	nfs_fscache_invalidate_page(page, page->mapping->host);
 }
@@ -472,7 +472,7 @@ static int nfs_release_page(struct page 
  */
 static int nfs_launder_page(struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct nfs_inode *nfsi = NFS_I(inode);
 
 	dfprintk(PAGECACHE, "NFS: launder_page(%ld, %llu)\n",
@@ -521,7 +521,7 @@ static int nfs_vm_page_mkwrite(struct vm
 	nfs_fscache_wait_on_page_write(NFS_I(dentry->d_inode), page);
 
 	lock_page(page);
-	mapping = page->mapping;
+	mapping = page_file_mapping(page);
 	if (mapping != dentry->d_inode->i_mapping)
 		goto out_unlock;
 
diff -puN fs/nfs/internal.h~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages fs/nfs/internal.h
--- a/fs/nfs/internal.h~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages
+++ a/fs/nfs/internal.h
@@ -546,13 +546,14 @@ void nfs_super_set_maxbytes(struct super
 static inline
 unsigned int nfs_page_length(struct page *page)
 {
-	loff_t i_size = i_size_read(page->mapping->host);
+	loff_t i_size = i_size_read(page_file_mapping(page)->host);
 
 	if (i_size > 0) {
+		pgoff_t page_index = page_file_index(page);
 		pgoff_t end_index = (i_size - 1) >> PAGE_CACHE_SHIFT;
-		if (page->index < end_index)
+		if (page_index < end_index)
 			return PAGE_CACHE_SIZE;
-		if (page->index == end_index)
+		if (page_index == end_index)
 			return ((i_size - 1) & ~PAGE_CACHE_MASK) + 1;
 	}
 	return 0;
diff -puN fs/nfs/pagelist.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages
+++ a/fs/nfs/pagelist.c
@@ -117,7 +117,7 @@ nfs_create_request(struct nfs_open_conte
 	 * long write-back delay. This will be adjusted in
 	 * update_nfs_request below if the region is not locked. */
 	req->wb_page    = page;
-	req->wb_index	= page->index;
+	req->wb_index	= page_file_index(page);
 	page_cache_get(page);
 	req->wb_offset  = offset;
 	req->wb_pgbase	= offset;
diff -puN fs/nfs/read.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages fs/nfs/read.c
--- a/fs/nfs/read.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages
+++ a/fs/nfs/read.c
@@ -522,11 +522,11 @@ static const struct rpc_call_ops nfs_rea
 int nfs_readpage(struct file *file, struct page *page)
 {
 	struct nfs_open_context *ctx;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	int		error;
 
 	dprintk("NFS: nfs_readpage (%p %ld@%lu)\n",
-		page, PAGE_CACHE_SIZE, page->index);
+		page, PAGE_CACHE_SIZE, page_file_index(page));
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGE);
 	nfs_add_stats(inode, NFSIOS_READPAGES, 1);
 
@@ -580,7 +580,7 @@ static int
 readpage_async_filler(void *data, struct page *page)
 {
 	struct nfs_readdesc *desc = (struct nfs_readdesc *)data;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct nfs_page *new;
 	unsigned int len;
 	int error;
diff -puN fs/nfs/write.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages
+++ a/fs/nfs/write.c
@@ -153,7 +153,7 @@ static struct nfs_page *nfs_page_find_re
 
 static struct nfs_page *nfs_page_find_request(struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct nfs_page *req = NULL;
 
 	spin_lock(&inode->i_lock);
@@ -165,16 +165,16 @@ static struct nfs_page *nfs_page_find_re
 /* Adjust the file length if we're writing beyond the end */
 static void nfs_grow_file(struct page *page, unsigned int offset, unsigned int count)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	loff_t end, i_size;
 	pgoff_t end_index;
 
 	spin_lock(&inode->i_lock);
 	i_size = i_size_read(inode);
 	end_index = (i_size - 1) >> PAGE_CACHE_SHIFT;
-	if (i_size > 0 && page->index < end_index)
+	if (i_size > 0 && page_file_index(page) < end_index)
 		goto out;
-	end = ((loff_t)page->index << PAGE_CACHE_SHIFT) + ((loff_t)offset+count);
+	end = page_file_offset(page) + ((loff_t)offset+count);
 	if (i_size >= end)
 		goto out;
 	i_size_write(inode, end);
@@ -187,7 +187,7 @@ out:
 static void nfs_set_pageerror(struct page *page)
 {
 	SetPageError(page);
-	nfs_zap_mapping(page->mapping->host, page->mapping);
+	nfs_zap_mapping(page_file_mapping(page)->host, page_file_mapping(page));
 }
 
 /* We can set the PG_uptodate flag if we see that a write request
@@ -228,7 +228,7 @@ static int nfs_set_page_writeback(struct
 	int ret = test_set_page_writeback(page);
 
 	if (!ret) {
-		struct inode *inode = page->mapping->host;
+		struct inode *inode = page_file_mapping(page)->host;
 		struct nfs_server *nfss = NFS_SERVER(inode);
 
 		if (atomic_long_inc_return(&nfss->writeback) >
@@ -242,7 +242,7 @@ static int nfs_set_page_writeback(struct
 
 static void nfs_end_page_writeback(struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct nfs_server *nfss = NFS_SERVER(inode);
 
 	end_page_writeback(page);
@@ -252,7 +252,7 @@ static void nfs_end_page_writeback(struc
 
 static struct nfs_page *nfs_find_and_lock_request(struct page *page, bool nonblock)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct nfs_page *req;
 	int ret;
 
@@ -313,13 +313,13 @@ out:
 
 static int nfs_do_writepage(struct page *page, struct writeback_control *wbc, struct nfs_pageio_descriptor *pgio)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	int ret;
 
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
 	nfs_add_stats(inode, NFSIOS_WRITEPAGES, 1);
 
-	nfs_pageio_cond_complete(pgio, page->index);
+	nfs_pageio_cond_complete(pgio, page_file_index(page));
 	ret = nfs_page_async_flush(pgio, page, wbc->sync_mode == WB_SYNC_NONE);
 	if (ret == -EAGAIN) {
 		redirty_page_for_writepage(wbc, page);
@@ -336,7 +336,7 @@ static int nfs_writepage_locked(struct p
 	struct nfs_pageio_descriptor pgio;
 	int err;
 
-	NFS_PROTO(page->mapping->host)->write_pageio_init(&pgio,
+	NFS_PROTO(page_file_mapping(page)->host)->write_pageio_init(&pgio,
 							  page->mapping->host,
 							  wb_priority(wbc),
 							  &nfs_async_write_completion_ops);
@@ -471,7 +471,7 @@ nfs_request_add_commit_list(struct nfs_p
 	spin_unlock(cinfo->lock);
 	if (!cinfo->dreq) {
 		inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
-		inc_bdi_stat(req->wb_page->mapping->backing_dev_info,
+		inc_bdi_stat(page_file_mapping(req->wb_page)->backing_dev_info,
 			     BDI_RECLAIMABLE);
 		__mark_inode_dirty(req->wb_context->dentry->d_inode,
 				   I_DIRTY_DATASYNC);
@@ -538,7 +538,7 @@ static void
 nfs_clear_page_commit(struct page *page)
 {
 	dec_zone_page_state(page, NR_UNSTABLE_NFS);
-	dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
+	dec_bdi_stat(page_file_mapping(page)->backing_dev_info, BDI_RECLAIMABLE);
 }
 
 static void
@@ -789,7 +789,7 @@ out_err:
 static struct nfs_page * nfs_setup_write_request(struct nfs_open_context* ctx,
 		struct page *page, unsigned int offset, unsigned int bytes)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_file_mapping(page)->host;
 	struct nfs_page	*req;
 
 	req = nfs_try_to_update_request(inode, page, offset, bytes);
@@ -842,7 +842,7 @@ int nfs_flush_incompatible(struct file *
 		nfs_release_request(req);
 		if (!do_flush)
 			return 0;
-		status = nfs_wb_page(page->mapping->host, page);
+		status = nfs_wb_page(page_file_mapping(page)->host, page);
 	} while (status == 0);
 	return status;
 }
@@ -872,7 +872,7 @@ int nfs_updatepage(struct file *file, st
 		unsigned int offset, unsigned int count)
 {
 	struct nfs_open_context *ctx = nfs_file_open_context(file);
-	struct inode	*inode = page->mapping->host;
+	struct inode	*inode = page_file_mapping(page)->host;
 	int		status = 0;
 
 	nfs_inc_stats(inode, NFSIOS_VFSUPDATEPAGE);
@@ -880,7 +880,7 @@ int nfs_updatepage(struct file *file, st
 	dprintk("NFS:       nfs_updatepage(%s/%s %d@%lld)\n",
 		file->f_path.dentry->d_parent->d_name.name,
 		file->f_path.dentry->d_name.name, count,
-		(long long)(page_offset(page) + offset));
+		(long long)(page_file_offset(page) + offset));
 
 	/* If we're not using byte range locks, and we know the page
 	 * is up to date, it may be more efficient to extend the write
@@ -1469,7 +1469,7 @@ void nfs_retry_commit(struct list_head *
 		nfs_mark_request_commit(req, lseg, cinfo);
 		if (!cinfo->dreq) {
 			dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
-			dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+			dec_bdi_stat(page_file_mapping(req->wb_page)->backing_dev_info,
 				     BDI_RECLAIMABLE);
 		}
 		nfs_unlock_and_release_request(req);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

