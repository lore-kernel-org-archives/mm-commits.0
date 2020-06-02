From: akpm@linux-foundation.org
Subject: [merged]
 ext4-pass-the-inode-to-ext4_mpage_readpages.patch removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:05 -0700
Message-ID: <20200602213905.koo4BSe2k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVjG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: ext4: pass the inode to ext4_mpage_readpages
has been removed from the -mm tree.  Its filename was
     ext4-pass-the-inode-to-ext4_mpage_readpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ext4: pass the inode to ext4_mpage_readpages

This function now only uses the mapping argument to look up the inode, and
both callers already have the inode, so just pass the inode instead of the
mapping.

Link: http://lkml.kernel.org/r/20200414150233.24495-22-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h     |    2 +-
 fs/ext4/inode.c    |    4 ++--
 fs/ext4/readpage.c |    3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ext4/ext4.h~ext4-pass-the-inode-to-ext4_mpage_readpages
+++ a/fs/ext4/ext4.h
@@ -3317,7 +3317,7 @@ static inline void ext4_set_de_type(stru
 }
 
 /* readpages.c */
-extern int ext4_mpage_readpages(struct address_space *mapping,
+extern int ext4_mpage_readpages(struct inode *inode,
 		struct readahead_control *rac, struct page *page);
 extern int __init ext4_init_post_read_processing(void);
 extern void ext4_exit_post_read_processing(void);
--- a/fs/ext4/inode.c~ext4-pass-the-inode-to-ext4_mpage_readpages
+++ a/fs/ext4/inode.c
@@ -3224,7 +3224,7 @@ static int ext4_readpage(struct file *fi
 		ret = ext4_readpage_inline(inode, page);
 
 	if (ret == -EAGAIN)
-		return ext4_mpage_readpages(page->mapping, NULL, page);
+		return ext4_mpage_readpages(inode, NULL, page);
 
 	return ret;
 }
@@ -3237,7 +3237,7 @@ static void ext4_readahead(struct readah
 	if (ext4_has_inline_data(inode))
 		return;
 
-	ext4_mpage_readpages(rac->mapping, rac, NULL);
+	ext4_mpage_readpages(inode, rac, NULL);
 }
 
 static void ext4_invalidatepage(struct page *page, unsigned int offset,
--- a/fs/ext4/readpage.c~ext4-pass-the-inode-to-ext4_mpage_readpages
+++ a/fs/ext4/readpage.c
@@ -221,13 +221,12 @@ static inline loff_t ext4_readpage_limit
 	return i_size_read(inode);
 }
 
-int ext4_mpage_readpages(struct address_space *mapping,
+int ext4_mpage_readpages(struct inode *inode,
 		struct readahead_control *rac, struct page *page)
 {
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
 
-	struct inode *inode = mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
 	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
 	const unsigned blocksize = 1 << blkbits;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
