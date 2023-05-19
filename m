Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B711EC7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjESVxp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjESVxn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370FE110
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E52A65B7F
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F64C4339B;
        Fri, 19 May 2023 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684533221;
        bh=S9Xt+ntYXNtV8oYWsIUKxk6igR7Fc+e4JjnOhYoMDyY=;
        h=Date:To:From:Subject:From;
        b=xdtxLXGibTsQkmsKNF66ZCCkWcvlrR/vddCrY3KHZs2sRX3siZ+huxumyQLm+kVff
         IVyGBlKKSxBiPdUni/I6OsUKxzUKAzPQaoZYPZhh5JtERz5muF7bX1vzz9U21mHPom
         t0leZ7iw4qmAftjK05OszqxvZpigPfXg3jeEhx/U=
Date:   Fri, 19 May 2023 14:53:40 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        jaegeuk@kernel.org, idryomov@gmail.com, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-a-kiocb_invalidate_post_write-helper.patch added to mm-unstable branch
Message-Id: <20230519215340.F1F64C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: add a kiocb_invalidate_post_write helper
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-add-a-kiocb_invalidate_post_write-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-a-kiocb_invalidate_post_write-helper.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: filemap: add a kiocb_invalidate_post_write helper
Date: Fri, 19 May 2023 11:35:14 +0200

Add a helper to invalidate page cache after a dio write.

Link: https://lkml.kernel.org/r/20230519093521.133226-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c          |   10 ++--------
 fs/iomap/direct-io.c    |   12 ++----------
 include/linux/fs.h      |    5 -----
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   37 ++++++++++++++++++++-----------------
 5 files changed, 25 insertions(+), 40 deletions(-)

--- a/fs/direct-io.c~filemap-add-a-kiocb_invalidate_post_write-helper
+++ a/fs/direct-io.c
@@ -285,14 +285,8 @@ static ssize_t dio_complete(struct dio *
 	 * zeros from unwritten extents.
 	 */
 	if (flags & DIO_COMPLETE_INVALIDATE &&
-	    ret > 0 && dio_op == REQ_OP_WRITE &&
-	    dio->inode->i_mapping->nrpages) {
-		err = invalidate_inode_pages2_range(dio->inode->i_mapping,
-					offset >> PAGE_SHIFT,
-					(offset + ret - 1) >> PAGE_SHIFT);
-		if (err)
-			dio_warn_stale_pagecache(dio->iocb->ki_filp);
-	}
+	    ret > 0 && dio_op == REQ_OP_WRITE)
+		kiocb_invalidate_post_write(dio->iocb, ret);
 
 	inode_dio_end(dio->inode);
 
--- a/fs/iomap/direct-io.c~filemap-add-a-kiocb_invalidate_post_write-helper
+++ a/fs/iomap/direct-io.c
@@ -81,7 +81,6 @@ ssize_t iomap_dio_complete(struct iomap_
 {
 	const struct iomap_dio_ops *dops = dio->dops;
 	struct kiocb *iocb = dio->iocb;
-	struct inode *inode = file_inode(iocb->ki_filp);
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret = dio->error;
 
@@ -108,15 +107,8 @@ ssize_t iomap_dio_complete(struct iomap_
 	 * ->end_io() when necessary, otherwise a racing buffer read would cache
 	 * zeros from unwritten extents.
 	 */
-	if (!dio->error && dio->size &&
-	    (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
-		int err;
-		err = invalidate_inode_pages2_range(inode->i_mapping,
-				offset >> PAGE_SHIFT,
-				(offset + dio->size - 1) >> PAGE_SHIFT);
-		if (err)
-			dio_warn_stale_pagecache(iocb->ki_filp);
-	}
+	if (!dio->error && dio->size && (dio->flags & IOMAP_DIO_WRITE))
+		kiocb_invalidate_post_write(iocb, dio->size);
 
 	inode_dio_end(file_inode(iocb->ki_filp));
 
--- a/include/linux/fs.h~filemap-add-a-kiocb_invalidate_post_write-helper
+++ a/include/linux/fs.h
@@ -2837,11 +2837,6 @@ static inline void inode_dio_end(struct
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
 
-/*
- * Warn about a page cache invalidation failure diring a direct I/O write.
- */
-void dio_warn_stale_pagecache(struct file *filp);
-
 extern void inode_set_flags(struct inode *inode, unsigned int flags,
 			    unsigned int mask);
 
--- a/include/linux/pagemap.h~filemap-add-a-kiocb_invalidate_post_write-helper
+++ a/include/linux/pagemap.h
@@ -31,6 +31,7 @@ int invalidate_inode_pages2(struct addre
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
+void kiocb_invalidate_post_write(struct kiocb *iocb, size_t count);
 
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
--- a/mm/filemap.c~filemap-add-a-kiocb_invalidate_post_write-helper
+++ a/mm/filemap.c
@@ -3789,7 +3789,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
-void dio_warn_stale_pagecache(struct file *filp)
+static void dio_warn_stale_pagecache(struct file *filp)
 {
 	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
 	char pathname[128];
@@ -3806,19 +3806,23 @@ void dio_warn_stale_pagecache(struct fil
 	}
 }
 
+void kiocb_invalidate_post_write(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	if (mapping->nrpages &&
+	    invalidate_inode_pages2_range(mapping,
+			iocb->ki_pos >> PAGE_SHIFT,
+			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
+		dio_warn_stale_pagecache(iocb->ki_filp);
+}
+
 ssize_t
 generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file	*file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode	*inode = mapping->host;
-	loff_t		pos = iocb->ki_pos;
-	ssize_t		written;
-	size_t		write_len;
-	pgoff_t		end;
-
-	write_len = iov_iter_count(from);
-	end = (pos + write_len - 1) >> PAGE_SHIFT;
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	size_t write_len = iov_iter_count(from);
+	ssize_t written;
 
 	/*
 	 * If a page can not be invalidated, return 0 to fall back
@@ -3828,7 +3832,7 @@ generic_file_direct_write(struct kiocb *
 	if (written) {
 		if (written == -EBUSY)
 			return 0;
-		goto out;
+		return written;
 	}
 
 	written = mapping->a_ops->direct_IO(iocb, from);
@@ -3850,11 +3854,11 @@ generic_file_direct_write(struct kiocb *
 	 *
 	 * Skip invalidation for async writes or if mapping has no pages.
 	 */
-	if (written > 0 && mapping->nrpages &&
-	    invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT, end))
-		dio_warn_stale_pagecache(file);
-
 	if (written > 0) {
+		struct inode *inode = mapping->host;
+		loff_t pos = iocb->ki_pos;
+
+		kiocb_invalidate_post_write(iocb, written);
 		pos += written;
 		write_len -= written;
 		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
@@ -3865,7 +3869,6 @@ generic_file_direct_write(struct kiocb *
 	}
 	if (written != -EIOCBQUEUED)
 		iov_iter_revert(from, write_len - iov_iter_count(from));
-out:
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);
_

Patches currently in -mm which might be from hch@lst.de are

iomap-update-ki_pos-a-little-later-in-iomap_dio_complete.patch
filemap-update-ki_pos-in-generic_perform_write.patch
filemap-assign-current-backing_dev_info-in-generic_perform_write.patch
filemap-add-a-kiocb_write_and_wait-helper.patch
filemap-add-a-kiocb_invalidate_pages-helper.patch
filemap-add-a-kiocb_invalidate_post_write-helper.patch
iomap-update-ki_pos-in-iomap_file_buffered_write.patch
iomap-assign-current-backing_dev_info-in-iomap_file_buffered_write.patch
iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages.patch
fs-factor-out-a-direct_write_fallback-helper.patch
fuse-update-ki_pos-in-fuse_perform_write.patch
fuse-drop-redundant-arguments-to-fuse_perform_write.patch
fuse-use-direct_write_fallback.patch
squashfs-dont-include-buffer_headh.patch

