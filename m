Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B555FC77B75
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjESVxk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjESVxi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:53:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2420A10F
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1BE564405
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10856C433EF;
        Fri, 19 May 2023 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684533216;
        bh=nT5BSvHiZMMlOcXlqeT9xKSqQls65V2T5kQokfG8Tss=;
        h=Date:To:From:Subject:From;
        b=lc32f21Ihgx8Mi1bpklsobeotxDEZMtucjIfmp9snIR8adxBlTWVnMkM4XytgQMwK
         BedujBKhTI3pn6k8bWYyuPu+JUdLf7f8AYoCvj9x2UzOMgcUJC2nfKNzjf1NUsFt/g
         EIXNmVCYL4JtTVPgJGuw85ikYR9GNzryNwuTUid0=
Date:   Fri, 19 May 2023 14:53:35 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        jaegeuk@kernel.org, idryomov@gmail.com, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-add-a-kiocb_write_and_wait-helper.patch added to mm-unstable branch
Message-Id: <20230519215336.10856C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: add a kiocb_write_and_wait helper
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-add-a-kiocb_write_and_wait-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-add-a-kiocb_write_and_wait-helper.patch

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
Subject: filemap: add a kiocb_write_and_wait helper
Date: Fri, 19 May 2023 11:35:12 +0200

Factor out a helper that does filemap_write_and_wait_range for a the range
covered by a read kiocb, or returns -EAGAIN if the kiocb is marked as
nowait and there would be pages to write.

Link: https://lkml.kernel.org/r/20230519093521.133226-5-hch@lst.de
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

 block/fops.c            |   18 +++---------------
 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |   30 ++++++++++++++++++------------
 3 files changed, 23 insertions(+), 27 deletions(-)

--- a/block/fops.c~filemap-add-a-kiocb_write_and_wait-helper
+++ a/block/fops.c
@@ -576,21 +576,9 @@ static ssize_t blkdev_read_iter(struct k
 		goto reexpand; /* skip atime */
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		struct address_space *mapping = iocb->ki_filp->f_mapping;
-
-		if (iocb->ki_flags & IOCB_NOWAIT) {
-			if (filemap_range_needs_writeback(mapping, pos,
-							  pos + count - 1)) {
-				ret = -EAGAIN;
-				goto reexpand;
-			}
-		} else {
-			ret = filemap_write_and_wait_range(mapping, pos,
-							   pos + count - 1);
-			if (ret < 0)
-				goto reexpand;
-		}
-
+		ret = kiocb_write_and_wait(iocb, count);
+		if (ret < 0)
+			goto reexpand;
 		file_accessed(iocb->ki_filp);
 
 		ret = blkdev_direct_IO(iocb, to);
--- a/include/linux/pagemap.h~filemap-add-a-kiocb_write_and_wait-helper
+++ a/include/linux/pagemap.h
@@ -30,6 +30,7 @@ static inline void invalidate_remote_ino
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
+
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
@@ -54,6 +55,7 @@ int filemap_check_errors(struct address_
 void __filemap_set_wb_err(struct address_space *mapping, int err);
 int filemap_fdatawrite_wbc(struct address_space *mapping,
 			   struct writeback_control *wbc);
+int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
 
 static inline int filemap_write_and_wait(struct address_space *mapping)
 {
--- a/mm/filemap.c~filemap-add-a-kiocb_write_and_wait-helper
+++ a/mm/filemap.c
@@ -2735,6 +2735,21 @@ put_folios:
 }
 EXPORT_SYMBOL_GPL(filemap_read);
 
+int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (filemap_range_needs_writeback(mapping, pos, end))
+			return -EAGAIN;
+		return 0;
+	}
+
+	return filemap_write_and_wait_range(mapping, pos, end);
+}
+
 /**
  * generic_file_read_iter - generic filesystem read routine
  * @iocb:	kernel I/O control block
@@ -2770,18 +2785,9 @@ generic_file_read_iter(struct kiocb *ioc
 		struct address_space *mapping = file->f_mapping;
 		struct inode *inode = mapping->host;
 
-		if (iocb->ki_flags & IOCB_NOWAIT) {
-			if (filemap_range_needs_writeback(mapping, iocb->ki_pos,
-						iocb->ki_pos + count - 1))
-				return -EAGAIN;
-		} else {
-			retval = filemap_write_and_wait_range(mapping,
-						iocb->ki_pos,
-					        iocb->ki_pos + count - 1);
-			if (retval < 0)
-				return retval;
-		}
-
+		retval = kiocb_write_and_wait(iocb, count);
+		if (retval < 0)
+			return retval;
 		file_accessed(file);
 
 		retval = mapping->a_ops->direct_IO(iocb, iter);
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

