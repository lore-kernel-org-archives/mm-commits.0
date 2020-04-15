From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-readahead-loop-variable-to-i.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 18:17:44 -0700
Message-ID: <20200415011744.SMw3hY-7z%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392437AbgDOBRq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 21:17:46 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm: rename readahead loop variable to 'i'
has been added to the -mm tree.  Its filename is
     mm-rename-readahead-loop-variable-to-i.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-readahead-loop-variable-to-i.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-readahead-loop-variable-to-i.patch

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
Subject: mm: rename readahead loop variable to 'i'

Change the type of page_idx to unsigned long, and rename it -- it's just a
loop counter, not a page index.

Link: http://lkml.kernel.org/r/20200414150233.24495-9-willy@infradead.org
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/readahead.c~mm-rename-readahead-loop-variable-to-i
+++ a/mm/readahead.c
@@ -163,13 +163,13 @@ void __do_page_cache_readahead(struct ad
 	struct page *page;
 	unsigned long end_index;	/* The last page we want to read */
 	LIST_HEAD(page_pool);
-	int page_idx;
 	loff_t isize = i_size_read(inode);
 	gfp_t gfp_mask = readahead_gfp_mask(mapping);
 	struct readahead_control rac = {
 		.mapping = mapping,
 		.file = filp,
 	};
+	unsigned long i;
 
 	if (isize == 0)
 		return;
@@ -179,8 +179,8 @@ void __do_page_cache_readahead(struct ad
 	/*
 	 * Preallocate as many pages as we will need.
 	 */
-	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
-		pgoff_t page_offset = index + page_idx;
+	for (i = 0; i < nr_to_read; i++) {
+		pgoff_t page_offset = index + i;
 
 		if (page_offset > end_index)
 			break;
@@ -201,7 +201,7 @@ void __do_page_cache_readahead(struct ad
 			break;
 		page->index = page_offset;
 		list_add(&page->lru, &page_pool);
-		if (page_idx == nr_to_read - lookahead_size)
+		if (i == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
 		rac._nr_pages++;
 	}
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
