Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 441FEC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjFIXeQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjFIXdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608D93C3A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE5263E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE44C433EF;
        Fri,  9 Jun 2023 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353416;
        bh=93Ym6M7F7+UmPMsqjDYIL3P6TAiOixU0z15aWWB7PBU=;
        h=Date:To:From:Subject:From;
        b=wrVV72X5zA9UldLKsywiTPPnVNv2Fbb0mhAFDrC0Ko5YJoHhm+N2O6K+9EfCqVP8X
         Blcx0HZEh5HFBGnETPijAdkb4nqeo+16v0AZ56dN5+sl7ke1EA2L72e76KsCg288Rh
         xLpmjML+Z3S/BwYIgU4zvPzDQM4uYQqgy0V45Qtk=
Date:   Fri, 09 Jun 2023 16:30:15 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages.patch removed from -mm tree
Message-Id: <20230609233016.4DE44C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iomap: use kiocb_write_and_wait and kiocb_invalidate_pages
has been removed from the -mm tree.  Its filename was
     iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: iomap: use kiocb_write_and_wait and kiocb_invalidate_pages
Date: Thu, 1 Jun 2023 16:59:00 +0200

Use the common helpers for direct I/O page invalidation instead of open
coding the logic.  This leads to a slight reordering of checks in
__iomap_dio_rw to keep the logic straight.

Link: https://lkml.kernel.org/r/20230601145904.1385409-9-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/direct-io.c |   55 ++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 35 deletions(-)

--- a/fs/iomap/direct-io.c~iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages
+++ a/fs/iomap/direct-io.c
@@ -472,7 +472,6 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before)
 {
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct iomap_iter iomi = {
 		.inode		= inode,
@@ -481,11 +480,11 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 		.flags		= IOMAP_DIRECT,
 		.private	= private,
 	};
-	loff_t end = iomi.pos + iomi.len - 1, ret = 0;
 	bool wait_for_completion =
 		is_sync_kiocb(iocb) || (dio_flags & IOMAP_DIO_FORCE_WAIT);
 	struct blk_plug plug;
 	struct iomap_dio *dio;
+	loff_t ret = 0;
 
 	trace_iomap_dio_rw_begin(iocb, iter, dio_flags, done_before);
 
@@ -509,31 +508,29 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 	dio->submit.waiter = current;
 	dio->submit.poll_bio = NULL;
 
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iomi.flags |= IOMAP_NOWAIT;
+
 	if (iov_iter_rw(iter) == READ) {
 		if (iomi.pos >= dio->i_size)
 			goto out_free_dio;
 
-		if (iocb->ki_flags & IOCB_NOWAIT) {
-			if (filemap_range_needs_writeback(mapping, iomi.pos,
-					end)) {
-				ret = -EAGAIN;
-				goto out_free_dio;
-			}
-			iomi.flags |= IOMAP_NOWAIT;
-		}
-
 		if (user_backed_iter(iter))
 			dio->flags |= IOMAP_DIO_DIRTY;
+
+		ret = kiocb_write_and_wait(iocb, iomi.len);
+		if (ret)
+			goto out_free_dio;
 	} else {
 		iomi.flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
-		if (iocb->ki_flags & IOCB_NOWAIT) {
-			if (filemap_range_has_page(mapping, iomi.pos, end)) {
-				ret = -EAGAIN;
+		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
+			ret = -EAGAIN;
+			if (iomi.pos >= dio->i_size ||
+			    iomi.pos + iomi.len > dio->i_size)
 				goto out_free_dio;
-			}
-			iomi.flags |= IOMAP_NOWAIT;
+			iomi.flags |= IOMAP_OVERWRITE_ONLY;
 		}
 
 		/* for data sync or sync, we need sync completion processing */
@@ -549,31 +546,19 @@ __iomap_dio_rw(struct kiocb *iocb, struc
 			if (!(iocb->ki_flags & IOCB_SYNC))
 				dio->flags |= IOMAP_DIO_WRITE_FUA;
 		}
-	}
-
-	if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
-		ret = -EAGAIN;
-		if (iomi.pos >= dio->i_size ||
-		    iomi.pos + iomi.len > dio->i_size)
-			goto out_free_dio;
-		iomi.flags |= IOMAP_OVERWRITE_ONLY;
-	}
-
-	ret = filemap_write_and_wait_range(mapping, iomi.pos, end);
-	if (ret)
-		goto out_free_dio;
 
-	if (iov_iter_rw(iter) == WRITE) {
 		/*
 		 * Try to invalidate cache pages for the range we are writing.
 		 * If this invalidation fails, let the caller fall back to
 		 * buffered I/O.
 		 */
-		if (invalidate_inode_pages2_range(mapping,
-				iomi.pos >> PAGE_SHIFT, end >> PAGE_SHIFT)) {
-			trace_iomap_dio_invalidate_fail(inode, iomi.pos,
-							iomi.len);
-			ret = -ENOTBLK;
+		ret = kiocb_invalidate_pages(iocb, iomi.len);
+		if (ret) {
+			if (ret != -EAGAIN) {
+				trace_iomap_dio_invalidate_fail(inode, iomi.pos,
+								iomi.len);
+				ret = -ENOTBLK;
+			}
 			goto out_free_dio;
 		}
 
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

