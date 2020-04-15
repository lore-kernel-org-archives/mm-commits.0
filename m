From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-put-readahead-pages-in-cache-earlier.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 18:17:50 -0700
Message-ID: <20200415011750.yd5zynPcu%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392439AbgDOBRw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 21:17:52 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm: put readahead pages in cache earlier
has been added to the -mm tree.  Its filename is
     mm-put-readahead-pages-in-cache-earlier.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-put-readahead-pages-in-cache-earlier.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-put-readahead-pages-in-cache-earlier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: put readahead pages in cache earlier

When populating the page cache for readahead, mappings that use
->readpages must populate the page cache themselves as the pages are
passed on a linked list which would normally be used for the page cache's
LRU.  For mappings that use ->readpage or the upcoming ->readahead method,
we can put the pages into the page cache as soon as they're allocated,
which solves a race between readahead and direct IO.  It also lets us
remove the gfp argument from read_pages().

Use the new readahead_page() API to implement the repeated calls to
->readpage(), just like most filesystems will.

Link: http://lkml.kernel.org/r/20200414150233.24495-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/mm/readahead.c~mm-put-readahead-pages-in-cache-earlier
+++ a/mm/readahead.c
@@ -114,14 +114,14 @@ int read_cache_pages(struct address_spac
 EXPORT_SYMBOL(read_cache_pages);
 
 static void read_pages(struct readahead_control *rac, struct list_head *pages,
-		gfp_t gfp)
+		bool skip_page)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;
+	struct page *page;
 	struct blk_plug plug;
-	unsigned page_idx;
 
 	if (!readahead_count(rac))
-		return;
+		goto out;
 
 	blk_start_plug(&plug);
 
@@ -130,23 +130,23 @@ static void read_pages(struct readahead_
 				readahead_count(rac));
 		/* Clean up the remaining pages */
 		put_pages_list(pages);
-		goto out;
-	}
-
-	for (page_idx = 0; page_idx < readahead_count(rac); page_idx++) {
-		struct page *page = lru_to_page(pages);
-		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, rac->mapping, page->index,
-				gfp))
+		rac->_index += rac->_nr_pages;
+		rac->_nr_pages = 0;
+	} else {
+		while ((page = readahead_page(rac))) {
 			aops->readpage(rac->file, page);
-		put_page(page);
+			put_page(page);
+		}
 	}
 
-out:
 	blk_finish_plug(&plug);
 
 	BUG_ON(!list_empty(pages));
-	rac->_nr_pages = 0;
+	BUG_ON(readahead_count(rac));
+
+out:
+	if (skip_page)
+		rac->_index++;
 }
 
 /*
@@ -168,6 +168,7 @@ void __do_page_cache_readahead(struct ad
 	struct readahead_control rac = {
 		.mapping = mapping,
 		.file = filp,
+		._index = index,
 	};
 	unsigned long i;
 
@@ -183,6 +184,8 @@ void __do_page_cache_readahead(struct ad
 		if (index + i > end_index)
 			break;
 
+		BUG_ON(index + i != rac._index + rac._nr_pages);
+
 		page = xa_load(&mapping->i_pages, index + i);
 		if (page && !xa_is_value(page)) {
 			/*
@@ -190,15 +193,22 @@ void __do_page_cache_readahead(struct ad
 			 * contiguous pages before continuing with the next
 			 * batch.
 			 */
-			read_pages(&rac, &page_pool, gfp_mask);
+			read_pages(&rac, &page_pool, true);
 			continue;
 		}
 
 		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			break;
-		page->index = index + i;
-		list_add(&page->lru, &page_pool);
+		if (mapping->a_ops->readpages) {
+			page->index = index + i;
+			list_add(&page->lru, &page_pool);
+		} else if (add_to_page_cache_lru(page, mapping, index + i,
+					gfp_mask) < 0) {
+			put_page(page);
+			read_pages(&rac, &page_pool, true);
+			continue;
+		}
 		if (i == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
 		rac._nr_pages++;
@@ -209,7 +219,7 @@ void __do_page_cache_readahead(struct ad
 	 * uptodate then the caller will launch readpage again, and
 	 * will then handle the error.
 	 */
-	read_pages(&rac, &page_pool, gfp_mask);
+	read_pages(&rac, &page_pool, false);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-readahead-prototypes-from-mmh.patch
mm-return-void-from-various-readahead-functions.patch
mm-ignore-return-value-of-readpages.patch
mm-move-readahead-nr_pages-check-into-read_pages.patch
mm-add-new-readahead_control-api.patch
mm-use-readahead_control-to-pass-arguments.patch
mm-rename-various-offset-parameters-to-index.patch
mm-rename-readahead-loop-variable-to-i.patch
mm-remove-page_offset-from-readahead-loop.patch
mm-put-readahead-pages-in-cache-earlier.patch
mm-add-readahead-address-space-operation.patch
mm-move-end_index-check-out-of-readahead-loop.patch
mm-add-page_cache_readahead_unbounded.patch
mm-document-why-we-dont-set-pagereadahead.patch
mm-use-memalloc_nofs_save-in-readahead-path.patch
fs-convert-mpage_readpages-to-mpage_readahead.patch
btrfs-convert-from-readpages-to-readahead.patch
erofs-convert-uncompressed-files-from-readpages-to-readahead.patch
erofs-convert-compressed-files-from-readpages-to-readahead.patch
ext4-convert-from-readpages-to-readahead.patch
ext4-pass-the-inode-to-ext4_mpage_readpages.patch
f2fs-convert-from-readpages-to-readahead.patch
f2fs-pass-the-inode-to-f2fs_mpage_readpages.patch
fuse-convert-from-readpages-to-readahead.patch
iomap-convert-from-readpages-to-readahead.patch
