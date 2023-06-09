Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9347FC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjFIXeh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbjFIXdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07424208
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 566AA65D08
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA06CC4339B;
        Fri,  9 Jun 2023 23:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353420;
        bh=DGdtpWNKlX51ZhUwXMpDC9V5rlNLxKy3Tup+Kivmh7I=;
        h=Date:To:From:Subject:From;
        b=eloDLJfr9KzE/aBlNp4lJpV3fDR3JU6M4xRX9JwReWw//MNuvgXEOKMQiEVfxfOyX
         5yHKiBk7I/TrO4PeGo6sWAEEoHmInXNtWk6O3nPI7fTWdX/Hp9cLuxz75/gKya33f2
         ZieJ6M40AKWsaweGqdJIGtUYvkjh1Y4VYWgyOnuw=
Date:   Fri, 09 Jun 2023 16:30:20 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fuse-drop-redundant-arguments-to-fuse_perform_write.patch removed from -mm tree
Message-Id: <20230609233020.AA06CC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fuse: drop redundant arguments to fuse_perform_write
has been removed from the -mm tree.  Its filename was
     fuse-drop-redundant-arguments-to-fuse_perform_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: fuse: drop redundant arguments to fuse_perform_write
Date: Thu, 1 Jun 2023 16:59:03 +0200

pos is always equal to iocb->ki_pos, and mapping is always equal to
iocb->ki_filp->f_mapping.

Link: https://lkml.kernel.org/r/20230601145904.1385409-12-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/fuse/file.c~fuse-drop-redundant-arguments-to-fuse_perform_write
+++ a/fs/fuse/file.c
@@ -1280,13 +1280,13 @@ static inline unsigned int fuse_wr_pages
 		     max_pages);
 }
 
-static ssize_t fuse_perform_write(struct kiocb *iocb,
-				  struct address_space *mapping,
-				  struct iov_iter *ii, loff_t pos)
+static ssize_t fuse_perform_write(struct kiocb *iocb, struct iov_iter *ii)
 {
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	loff_t pos = iocb->ki_pos;
 	int err = 0;
 	ssize_t res = 0;
 
@@ -1383,8 +1383,7 @@ writethrough:
 		if (written < 0 || !iov_iter_count(from))
 			goto out;
 
-		written_buffered = fuse_perform_write(iocb, mapping, from,
-						      iocb->ki_pos);
+		written_buffered = fuse_perform_write(iocb, from);
 		if (written_buffered < 0) {
 			err = written_buffered;
 			goto out;
@@ -1403,7 +1402,7 @@ writethrough:
 
 		written += written_buffered;
 	} else {
-		written = fuse_perform_write(iocb, mapping, from, iocb->ki_pos);
+		written = fuse_perform_write(iocb, from);
 	}
 out:
 	inode_unlock(inode);
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

