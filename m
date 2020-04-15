From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-convert-from-readpages-to-readahead.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 18:18:37 -0700
Message-ID: <20200415011837._F8QgJFmq%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392448AbgDOBSj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 21:18:39 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: fuse: convert from readpages to readahead
has been added to the -mm tree.  Its filename is
     fuse-convert-from-readpages-to-readahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fuse-convert-from-readpages-to-readahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fuse-convert-from-readpages-to-readahead.patch

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
Subject: fuse: convert from readpages to readahead

Implement the new readahead operation in fuse by using __readahead_batch()
to fill the array of pages in fuse_args_pages directly.  This lets us
inline fuse_readpages_fill() into fuse_readahead().

Link: http://lkml.kernel.org/r/20200414150233.24495-25-willy@infradead.org
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
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   99 ++++++++++++-----------------------------------
 1 file changed, 27 insertions(+), 72 deletions(-)

--- a/fs/fuse/file.c~fuse-convert-from-readpages-to-readahead
+++ a/fs/fuse/file.c
@@ -915,84 +915,39 @@ static void fuse_send_readpages(struct f
 	fuse_readpages_end(fc, &ap->args, err);
 }
 
-struct fuse_fill_data {
-	struct fuse_io_args *ia;
-	struct file *file;
-	struct inode *inode;
-	unsigned int nr_pages;
-	unsigned int max_pages;
-};
-
-static int fuse_readpages_fill(void *_data, struct page *page)
+static void fuse_readahead(struct readahead_control *rac)
 {
-	struct fuse_fill_data *data = _data;
-	struct fuse_io_args *ia = data->ia;
-	struct fuse_args_pages *ap = &ia->ap;
-	struct inode *inode = data->inode;
+	struct inode *inode = rac->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	unsigned int i, max_pages, nr_pages = 0;
 
-	fuse_wait_on_page_writeback(inode, page->index);
-
-	if (ap->num_pages &&
-	    (ap->num_pages == fc->max_pages ||
-	     (ap->num_pages + 1) * PAGE_SIZE > fc->max_read ||
-	     ap->pages[ap->num_pages - 1]->index + 1 != page->index)) {
-		data->max_pages = min_t(unsigned int, data->nr_pages,
-					fc->max_pages);
-		fuse_send_readpages(ia, data->file);
-		data->ia = ia = fuse_io_alloc(NULL, data->max_pages);
-		if (!ia) {
-			unlock_page(page);
-			return -ENOMEM;
-		}
-		ap = &ia->ap;
-	}
-
-	if (WARN_ON(ap->num_pages >= data->max_pages)) {
-		unlock_page(page);
-		fuse_io_free(ia);
-		return -EIO;
-	}
-
-	get_page(page);
-	ap->pages[ap->num_pages] = page;
-	ap->descs[ap->num_pages].length = PAGE_SIZE;
-	ap->num_pages++;
-	data->nr_pages--;
-	return 0;
-}
-
-static int fuse_readpages(struct file *file, struct address_space *mapping,
-			  struct list_head *pages, unsigned nr_pages)
-{
-	struct inode *inode = mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_fill_data data;
-	int err;
-
-	err = -EIO;
 	if (is_bad_inode(inode))
-		goto out;
+		return;
 
-	data.file = file;
-	data.inode = inode;
-	data.nr_pages = nr_pages;
-	data.max_pages = min_t(unsigned int, nr_pages, fc->max_pages);
-;
-	data.ia = fuse_io_alloc(NULL, data.max_pages);
-	err = -ENOMEM;
-	if (!data.ia)
-		goto out;
+	max_pages = min(fc->max_pages, fc->max_read / PAGE_SIZE);
 
-	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
-	if (!err) {
-		if (data.ia->ap.num_pages)
-			fuse_send_readpages(data.ia, file);
-		else
-			fuse_io_free(data.ia);
+	for (;;) {
+		struct fuse_io_args *ia;
+		struct fuse_args_pages *ap;
+
+		nr_pages = readahead_count(rac) - nr_pages;
+		if (nr_pages > max_pages)
+			nr_pages = max_pages;
+		if (nr_pages == 0)
+			break;
+		ia = fuse_io_alloc(NULL, nr_pages);
+		if (!ia)
+			return;
+		ap = &ia->ap;
+		nr_pages = __readahead_batch(rac, ap->pages, nr_pages);
+		for (i = 0; i < nr_pages; i++) {
+			fuse_wait_on_page_writeback(inode,
+						    readahead_index(rac) + i);
+			ap->descs[i].length = PAGE_SIZE;
+		}
+		ap->num_pages = nr_pages;
+		fuse_send_readpages(ia, rac->file);
 	}
-out:
-	return err;
 }
 
 static ssize_t fuse_cache_read_iter(struct kiocb *iocb, struct iov_iter *to)
@@ -3373,10 +3328,10 @@ static const struct file_operations fuse
 
 static const struct address_space_operations fuse_file_aops  = {
 	.readpage	= fuse_readpage,
+	.readahead	= fuse_readahead,
 	.writepage	= fuse_writepage,
 	.writepages	= fuse_writepages,
 	.launder_page	= fuse_launder_page,
-	.readpages	= fuse_readpages,
 	.set_page_dirty	= __set_page_dirty_nobuffers,
 	.bmap		= fuse_bmap,
 	.direct_IO	= fuse_direct_IO,
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
