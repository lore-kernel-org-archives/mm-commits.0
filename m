From: akpm@linux-foundation.org
Subject: [merged] mm-remove-page_file_index.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:18 -0700
Message-ID: <57fc19fe.zLouMcf/9RbnI3tL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37099 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbcJJWpT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, anna.schumaker@netapp.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, edumazet@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, ross.zwisler@linux.intel.com, trond.myklebust@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove page_file_index
has been removed from the -mm tree.  Its filename was
     mm-remove-page_file_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: remove page_file_index

After using the offset of the swap entry as the key of the swap cache, the
page_index() becomes exactly same as page_file_index().  So the
page_file_index() is removed and the callers are changed to use
page_index() instead.

Link: http://lkml.kernel.org/r/1473270649-27229-2-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/internal.h       |    6 +++---
 fs/nfs/pagelist.c       |    2 +-
 fs/nfs/read.c           |    2 +-
 fs/nfs/write.c          |    4 ++--
 include/linux/mm.h      |   12 ------------
 include/linux/pagemap.h |    2 +-
 6 files changed, 8 insertions(+), 20 deletions(-)

diff -puN fs/nfs/internal.h~mm-remove-page_file_index fs/nfs/internal.h
--- a/fs/nfs/internal.h~mm-remove-page_file_index
+++ a/fs/nfs/internal.h
@@ -681,11 +681,11 @@ unsigned int nfs_page_length(struct page
 	loff_t i_size = i_size_read(page_file_mapping(page)->host);
 
 	if (i_size > 0) {
-		pgoff_t page_index = page_file_index(page);
+		pgoff_t index = page_index(page);
 		pgoff_t end_index = (i_size - 1) >> PAGE_SHIFT;
-		if (page_index < end_index)
+		if (index < end_index)
 			return PAGE_SIZE;
-		if (page_index == end_index)
+		if (index == end_index)
 			return ((i_size - 1) & ~PAGE_MASK) + 1;
 	}
 	return 0;
diff -puN fs/nfs/pagelist.c~mm-remove-page_file_index fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~mm-remove-page_file_index
+++ a/fs/nfs/pagelist.c
@@ -342,7 +342,7 @@ nfs_create_request(struct nfs_open_conte
 	 * update_nfs_request below if the region is not locked. */
 	req->wb_page    = page;
 	if (page) {
-		req->wb_index = page_file_index(page);
+		req->wb_index = page_index(page);
 		get_page(page);
 	}
 	req->wb_offset  = offset;
diff -puN fs/nfs/read.c~mm-remove-page_file_index fs/nfs/read.c
--- a/fs/nfs/read.c~mm-remove-page_file_index
+++ a/fs/nfs/read.c
@@ -295,7 +295,7 @@ int nfs_readpage(struct file *file, stru
 	int		error;
 
 	dprintk("NFS: nfs_readpage (%p %ld@%lu)\n",
-		page, PAGE_SIZE, page_file_index(page));
+		page, PAGE_SIZE, page_index(page));
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGE);
 	nfs_add_stats(inode, NFSIOS_READPAGES, 1);
 
diff -puN fs/nfs/write.c~mm-remove-page_file_index fs/nfs/write.c
--- a/fs/nfs/write.c~mm-remove-page_file_index
+++ a/fs/nfs/write.c
@@ -151,7 +151,7 @@ static void nfs_grow_file(struct page *p
 	spin_lock(&inode->i_lock);
 	i_size = i_size_read(inode);
 	end_index = (i_size - 1) >> PAGE_SHIFT;
-	if (i_size > 0 && page_file_index(page) < end_index)
+	if (i_size > 0 && page_index(page) < end_index)
 		goto out;
 	end = page_file_offset(page) + ((loff_t)offset+count);
 	if (i_size >= end)
@@ -603,7 +603,7 @@ static int nfs_do_writepage(struct page
 {
 	int ret;
 
-	nfs_pageio_cond_complete(pgio, page_file_index(page));
+	nfs_pageio_cond_complete(pgio, page_index(page));
 	ret = nfs_page_async_flush(pgio, page, wbc->sync_mode == WB_SYNC_NONE,
 				   launder);
 	if (ret == -EAGAIN) {
diff -puN include/linux/mm.h~mm-remove-page_file_index include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-page_file_index
+++ a/include/linux/mm.h
@@ -1061,18 +1061,6 @@ static inline pgoff_t page_index(struct
 	return page->index;
 }
 
-/*
- * Return the file index of the page. Regular pagecache pages use ->index
- * whereas swapcache pages use swp_offset(->private)
- */
-static inline pgoff_t page_file_index(struct page *page)
-{
-	if (unlikely(PageSwapCache(page)))
-		return __page_file_index(page);
-
-	return page->index;
-}
