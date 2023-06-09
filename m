Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B52CC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjFIXeT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjFIXdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620973A9D
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC5E063E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4EAC433EF;
        Fri,  9 Jun 2023 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353419;
        bh=CtHngDT/WNhfJkDXWyAi0XVIr4an1yQZEiI6IaYK8AE=;
        h=Date:To:From:Subject:From;
        b=XinoDvs969zkb15at+QJQzFauYE8KLhycLBz0BJQOcJWAQoUFIXfCL0RvHE7uNX9N
         qHkr3cOotCvhq4cYmjPRU3bqQ70HkyDM0cZC/9E7r1PT/0AVTtXW3EIOuwBvC6FndN
         Y6q148oO8ep5UvVbhmF8lXSwPcv8kgHldB9kxl/w=
Date:   Fri, 09 Jun 2023 16:30:18 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fuse-update-ki_pos-in-fuse_perform_write.patch removed from -mm tree
Message-Id: <20230609233019.4D4EAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fuse: update ki_pos in fuse_perform_write
has been removed from the -mm tree.  Its filename was
     fuse-update-ki_pos-in-fuse_perform_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: fuse: update ki_pos in fuse_perform_write
Date: Thu, 1 Jun 2023 16:59:02 +0200

Both callers of fuse_perform_write need to updated ki_pos, move it into
common code.

Link: https://lkml.kernel.org/r/20230601145904.1385409-11-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
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

 fs/fuse/file.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/fuse/file.c~fuse-update-ki_pos-in-fuse_perform_write
+++ a/fs/fuse/file.c
@@ -1329,7 +1329,10 @@ static ssize_t fuse_perform_write(struct
 	fuse_write_update_attr(inode, pos, res);
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
-	return res > 0 ? res : err;
+	if (!res)
+		return err;
+	iocb->ki_pos += res;
+	return res;
 }
 
 static ssize_t fuse_cache_write_iter(struct kiocb *iocb, struct iov_iter *from)
@@ -1341,7 +1344,6 @@ static ssize_t fuse_cache_write_iter(str
 	struct inode *inode = mapping->host;
 	ssize_t err;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	loff_t endbyte = 0;
 
 	if (fc->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
@@ -1375,19 +1377,20 @@ writethrough:
 		goto out;
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		loff_t pos = iocb->ki_pos;
+		loff_t pos, endbyte;
+
 		written = generic_file_direct_write(iocb, from);
 		if (written < 0 || !iov_iter_count(from))
 			goto out;
 
-		pos += written;
-
-		written_buffered = fuse_perform_write(iocb, mapping, from, pos);
+		written_buffered = fuse_perform_write(iocb, mapping, from,
+						      iocb->ki_pos);
 		if (written_buffered < 0) {
 			err = written_buffered;
 			goto out;
 		}
-		endbyte = pos + written_buffered - 1;
+		pos = iocb->ki_pos - written_buffered;
+		endbyte = iocb->ki_pos - 1;
 
 		err = filemap_write_and_wait_range(file->f_mapping, pos,
 						   endbyte);
@@ -1399,11 +1402,8 @@ writethrough:
 					 endbyte >> PAGE_SHIFT);
 
 		written += written_buffered;
-		iocb->ki_pos = pos + written_buffered;
 	} else {
 		written = fuse_perform_write(iocb, mapping, from, iocb->ki_pos);
-		if (written >= 0)
-			iocb->ki_pos += written;
 	}
 out:
 	inode_unlock(inode);
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

