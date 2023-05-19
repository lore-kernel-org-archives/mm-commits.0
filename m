Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB71C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjESVxu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjESVxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:53:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA5B110
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:53:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8445265B7A
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D6EC433D2;
        Fri, 19 May 2023 21:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684533223;
        bh=pONig7G6KrIbj6J+DPNaGBoMMva9TlwL8dfBObSntKE=;
        h=Date:To:From:Subject:From;
        b=KKhA7S7UBCuMxTb8LyGposM04Lk/hHISw54myI8tyXCRlFv0ilu3VXZJDXMWSvMlz
         cGZpaqh3iVKZhnG6IsqtBJHe3nbYwNfnps9ekYCt/pcSt4yO5W4Lx0RcPoo+2Txh/N
         NAQKeo/5GRWvWGEnjIA+Cn4NFHQEsvBMQWy4/Jtc=
Date:   Fri, 19 May 2023 14:53:43 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        jaegeuk@kernel.org, idryomov@gmail.com, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + iomap-update-ki_pos-in-iomap_file_buffered_write.patch added to mm-unstable branch
Message-Id: <20230519215343.D2D6EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: update ki_pos in iomap_file_buffered_write
has been added to the -mm mm-unstable branch.  Its filename is
     iomap-update-ki_pos-in-iomap_file_buffered_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iomap-update-ki_pos-in-iomap_file_buffered_write.patch

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
Subject: iomap: update ki_pos in iomap_file_buffered_write
Date: Fri, 19 May 2023 11:35:15 +0200

All callers of iomap_file_buffered_write need to updated ki_pos, move it
into common code.

Link: https://lkml.kernel.org/r/20230519093521.133226-8-hch@lst.de
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

 fs/gfs2/file.c         |    4 +---
 fs/iomap/buffered-io.c |    9 ++++++---
 fs/xfs/xfs_file.c      |    2 --
 fs/zonefs/file.c       |    4 +---
 4 files changed, 8 insertions(+), 11 deletions(-)

--- a/fs/gfs2/file.c~iomap-update-ki_pos-in-iomap_file_buffered_write
+++ a/fs/gfs2/file.c
@@ -1046,10 +1046,8 @@ retry:
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	pagefault_enable();
 	current->backing_dev_info = NULL;
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
@@ -723,8 +723,6 @@ write_retry:
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

