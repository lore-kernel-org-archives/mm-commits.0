Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59070C8300C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjFIXeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjFIXdF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1D33AAF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A6C060FCA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA63EC433D2;
        Fri,  9 Jun 2023 23:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353411;
        bh=BxUzZ0QNzlUMOBywcI6jyLXHRzHg7BH2fo1k9JAbhGc=;
        h=Date:To:From:Subject:From;
        b=eQWamysCgTgCdwagjms24w7co7wNiaVCos1Uw5vdjlERwGS716MlOTiRSgflFzdrS
         rjOeD8mkxkLiE1Mlgyxcpq3dTWhHLBVrajkusKD4ZuMr/bovlaTt0rG8/DggOnS5i+
         ST4MvUa9mZTYM51x4XbmHEIKmGTUp6m6yv6+dTRQ=
Date:   Fri, 09 Jun 2023 16:30:11 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-add-a-kiocb_invalidate_pages-helper.patch removed from -mm tree
Message-Id: <20230609233011.CA63EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: add a kiocb_invalidate_pages helper
has been removed from the -mm tree.  Its filename was
     filemap-add-a-kiocb_invalidate_pages-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: filemap: add a kiocb_invalidate_pages helper
Date: Thu, 1 Jun 2023 16:58:57 +0200

Factor out a helper that calls filemap_write_and_wait_range and
invalidate_inode_pages2_range for the range covered by a write kiocb or
returns -EAGAIN if the kiocb is marked as nowait and there would be pages
to write or invalidate.

Link: https://lkml.kernel.org/r/20230601145904.1385409-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

 include/linux/pagemap.h |    1 
 mm/filemap.c            |   48 ++++++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 20 deletions(-)

--- a/include/linux/pagemap.h~filemap-add-a-kiocb_invalidate_pages-helper
+++ a/include/linux/pagemap.h
@@ -30,6 +30,7 @@ static inline void invalidate_remote_ino
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
--- a/mm/filemap.c~filemap-add-a-kiocb_invalidate_pages-helper
+++ a/mm/filemap.c
@@ -2750,6 +2750,33 @@ int kiocb_write_and_wait(struct kiocb *i
 	return filemap_write_and_wait_range(mapping, pos, end);
 }
 
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+	int ret;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* we could block if there are any pages in the range */
+		if (filemap_range_has_page(mapping, pos, end))
+			return -EAGAIN;
+	} else {
+		ret = filemap_write_and_wait_range(mapping, pos, end);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
+					     end >> PAGE_SHIFT);
+}
+
 /**
  * generic_file_read_iter - generic filesystem read routine
  * @iocb:	kernel I/O control block
@@ -3793,30 +3820,11 @@ generic_file_direct_write(struct kiocb *
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		/* If there are pages to writeback, return */
-		if (filemap_range_has_page(file->f_mapping, pos,
-					   pos + write_len - 1))
-			return -EAGAIN;
-	} else {
-		written = filemap_write_and_wait_range(mapping, pos,
-							pos + write_len - 1);
-		if (written)
-			goto out;
-	}
-
-	/*
-	 * After a write we want buffered reads to be sure to go to disk to get
-	 * the new data.  We invalidate clean cached page from the region we're
-	 * about to write.  We do this *before* the write so that we can return
-	 * without clobbering -EIOCBQUEUED from ->direct_IO().
-	 */
-	written = invalidate_inode_pages2_range(mapping,
-					pos >> PAGE_SHIFT, end);
 	/*
 	 * If a page can not be invalidated, return 0 to fall back
 	 * to buffered write.
 	 */
+	written = kiocb_invalidate_pages(iocb, write_len);
 	if (written) {
 		if (written == -EBUSY)
 			return 0;
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

