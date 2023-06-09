Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51477C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjFIXeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbjFIXdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99D33AB4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8800963EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E017BC433D2;
        Fri,  9 Jun 2023 23:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353415;
        bh=RuBXqSMNC6xe5BI62rtZBKiBj58da8b986u0XxhPdnI=;
        h=Date:To:From:Subject:From;
        b=UdP7tfay5Y/wOv1rr3m2EcEPjq840BAabv/pQQHBF4J7eCg/P1mW1uQlgLS9LKzBo
         qvk/n1nrLFfWHzSziR0tozztmc0GGUurP5WC4vyVDW9xKaktA3vC4/4hUZfJTgipoc
         yfjs62JjTN1wXOmp84+MX3E2RFY/T0f8JxEHJu5c=
Date:   Fri, 09 Jun 2023 16:30:14 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] iomap-update-ki_pos-in-iomap_file_buffered_write.patch removed from -mm tree
Message-Id: <20230609233014.E017BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iomap: update ki_pos in iomap_file_buffered_write
has been removed from the -mm tree.  Its filename was
     iomap-update-ki_pos-in-iomap_file_buffered_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: iomap: update ki_pos in iomap_file_buffered_write
Date: Thu, 1 Jun 2023 16:58:59 +0200

All callers of iomap_file_buffered_write need to updated ki_pos, move it
into common code.

Link: https://lkml.kernel.org/r/20230601145904.1385409-8-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

 fs/gfs2/file.c         |    4 +---
 fs/iomap/buffered-io.c |    9 ++++++---
 fs/xfs/xfs_file.c      |    2 --
 fs/zonefs/file.c       |    4 +---
 4 files changed, 8 insertions(+), 11 deletions(-)

--- a/fs/gfs2/file.c~iomap-update-ki_pos-in-iomap_file_buffered_write
+++ a/fs/gfs2/file.c
@@ -1044,10 +1044,8 @@ retry:
 	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	pagefault_enable();
-	if (ret > 0) {
-		iocb->ki_pos += ret;
+	if (ret > 0)
 		written += ret;
-	}
 
 	if (inode == sdp->sd_rindex)
 		gfs2_glock_dq_uninit(statfs_gh);
--- a/fs/iomap/buffered-io.c~iomap-update-ki_pos-in-iomap_file_buffered_write
+++ a/fs/iomap/buffered-io.c
@@ -864,16 +864,19 @@ iomap_file_buffered_write(struct kiocb *
 		.len		= iov_iter_count(i),
 		.flags		= IOMAP_WRITE,
 	};
-	int ret;
+	ssize_t ret;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iter.flags |= IOMAP_NOWAIT;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_write_iter(&iter, i);
-	if (iter.pos == iocb->ki_pos)
+
+	if (unlikely(ret < 0))
 		return ret;
-	return iter.pos - iocb->ki_pos;
+	ret = iter.pos - iocb->ki_pos;
+	iocb->ki_pos += ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
--- a/fs/xfs/xfs_file.c~iomap-update-ki_pos-in-iomap_file_buffered_write
+++ a/fs/xfs/xfs_file.c
@@ -720,8 +720,6 @@ write_retry:
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
 			&xfs_buffered_write_iomap_ops);
-	if (likely(ret >= 0))
-		iocb->ki_pos += ret;
 
 	/*
 	 * If we hit a space limit, try to free up some lingering preallocated
--- a/fs/zonefs/file.c~iomap-update-ki_pos-in-iomap_file_buffered_write
+++ a/fs/zonefs/file.c
@@ -643,9 +643,7 @@ static ssize_t zonefs_file_buffered_writ
 		goto inode_unlock;
 
 	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
-	if (ret > 0)
-		iocb->ki_pos += ret;
-	else if (ret == -EIO)
+	if (ret == -EIO)
 		zonefs_io_error(inode, true);
 
 inode_unlock:
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

