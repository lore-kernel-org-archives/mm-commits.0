From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 025/128] mm: move end_index check out of readahead
 loop
Date: Tue, 02 Jun 2020 13:11:24 -0700
Message-ID: <20200602201124.JBsJVakQh%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBUL1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:11:27 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, torvalds@linux-foundation.org, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move end_index check out of readahead loop

By reducing nr_to_read, we can eliminate this check from inside the loop.

Link: http://lkml.kernel.org/r/20200414150233.24495-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/readahead.c~mm-move-end_index-check-out-of-readahead-loop
+++ a/mm/readahead.c
@@ -167,8 +167,6 @@ void __do_page_cache_readahead(struct ad
 		unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
-	struct page *page;
-	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
@@ -178,22 +176,26 @@ void __do_page_cache_readahead(struct ad
 		._index = index,
 	};
 	unsigned long i;
+	pgoff_t end_index;	/* The last page we want to read */
 
 	if (isize == 0)
 		return;
 
-	end_index = ((isize - 1) >> PAGE_SHIFT);
+	end_index = (isize - 1) >> PAGE_SHIFT;
+	if (index > end_index)
+		return;
+	/* Don't read past the page containing the last byte of the file */
+	if (nr_to_read > end_index - index)
+		nr_to_read = end_index - index + 1;
 
 	/*
 	 * Preallocate as many pages as we will need.
 	 */
 	for (i = 0; i < nr_to_read; i++) {
-		if (index + i > end_index)
-			break;
+		struct page *page = xa_load(&mapping->i_pages, index + i);
 
 		BUG_ON(index + i != rac._index + rac._nr_pages);
 
-		page = xa_load(&mapping->i_pages, index + i);
 		if (page && !xa_is_value(page)) {
 			/*
 			 * Page already present?  Kick off the current batch of
_
