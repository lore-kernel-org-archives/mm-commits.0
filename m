Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACA7C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjESVyG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjESVyF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C3B125
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609B365B82
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA361C433EF;
        Fri, 19 May 2023 21:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684533237;
        bh=qMDomNzddBiFPLSJR/t8hSebCScddpEKygT5TAYVjEE=;
        h=Date:To:From:Subject:From;
        b=krUmr2IgmrRfzfIQoSv0Lio4RZQ1LuqXfR/xLR7RW5m5emLpU7KoHb9a3QsxWK4yF
         kOmg3gORsYVmps6ZURwawu7H7k2Wwf3KMxBJxB46XWa03PmKGJXFxcDqL9P99SXIjh
         owrWjelHSTK4Gfv5lwy9mjikJSu5OYnu+qMa1+Hw=
Date:   Fri, 19 May 2023 14:53:57 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        jaegeuk@kernel.org, idryomov@gmail.com, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-use-direct_write_fallback.patch added to mm-unstable branch
Message-Id: <20230519215357.BA361C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fuse: use direct_write_fallback
has been added to the -mm mm-unstable branch.  Its filename is
     fuse-use-direct_write_fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fuse-use-direct_write_fallback.patch

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
Subject: fuse: use direct_write_fallback
Date: Fri, 19 May 2023 11:35:21 +0200

Use the generic direct_write_fallback helper instead of duplicating the
logic.

Link: https://lkml.kernel.org/r/20230519093521.133226-14-hch@lst.de
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

 fs/fuse/file.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

--- a/fs/fuse/file.c~fuse-use-direct_write_fallback
+++ a/fs/fuse/file.c
@@ -1340,11 +1340,9 @@ static ssize_t fuse_cache_write_iter(str
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	ssize_t written = 0;
-	ssize_t written_buffered = 0;
 	struct inode *inode = mapping->host;
 	ssize_t err;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	loff_t endbyte = 0;
 
 	if (fc->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
@@ -1382,28 +1380,9 @@ writethrough:
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		written = generic_file_direct_write(iocb, from);
-		if (written < 0 || !iov_iter_count(from))
-			goto out;
-
-		written_buffered = fuse_perform_write(iocb, from);
-		if (written_buffered < 0) {
-			err = written_buffered;
-			goto out;
-		}
-		endbyte = iocb->ki_pos + written_buffered - 1;
-
-		err = filemap_write_and_wait_range(file->f_mapping,
-						   iocb->ki_pos,
-						   endbyte);
-		if (err)
-			goto out;
-
-		invalidate_mapping_pages(file->f_mapping,
-					 iocb->ki_pos >> PAGE_SHIFT,
-					 endbyte >> PAGE_SHIFT);
-
-		written += written_buffered;
-		iocb->ki_pos += written_buffered;
+		if (written >= 0 && iov_iter_count(from))
+			written = direct_write_fallback(iocb, from, written,
+					fuse_perform_write(iocb, from));
 	} else {
 		written = fuse_perform_write(iocb, from);
 	}
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

