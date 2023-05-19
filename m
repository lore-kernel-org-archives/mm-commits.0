Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493D5C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjESVxj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjESVxf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EFF10D
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:53:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC6C64405
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33037C433EF;
        Fri, 19 May 2023 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684533213;
        bh=28c7EPoIaBBWUMJ8/i5COq+/CEDyax9HehXSINybHqw=;
        h=Date:To:From:Subject:From;
        b=hcVhtqC5yuQ6k795nwN5Zho5B2FGmfL1ii2OI3K35Uo7udiQi+y/riCgV8W6wScS4
         0rr/vkB4TkVQ0s0KZti63Ku8KxA1Heu1pcVp5Vy/XtNj5rcVQaclSw9v5FBx4yz21R
         abk/WuFrYdaXB9mMoKavJFAI2B5zgxZUo+fIQe9s=
Date:   Fri, 19 May 2023 14:53:32 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        jaegeuk@kernel.org, idryomov@gmail.com, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-assign-current-backing_dev_info-in-generic_perform_write.patch added to mm-unstable branch
Message-Id: <20230519215333.33037C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: assign current->backing_dev_info in generic_perform_write
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-assign-current-backing_dev_info-in-generic_perform_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-assign-current-backing_dev_info-in-generic_perform_write.patch

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
Subject: filemap: assign current->backing_dev_info in generic_perform_write
Date: Fri, 19 May 2023 11:35:11 +0200

Move the assignment to current->backing_dev_info from the callers into
generic_perform_write to reduce boiler plate code and reduce the scope to
just around the page dirtying loop.

Link: https://lkml.kernel.org/r/20230519093521.133226-4-hch@lst.de
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

 fs/ceph/file.c |    4 ----
 fs/ext4/file.c |    3 ---
 fs/f2fs/file.c |    2 --
 fs/nfs/file.c  |    5 +----
 mm/filemap.c   |    2 ++
 5 files changed, 3 insertions(+), 13 deletions(-)

--- a/fs/ceph/file.c~filemap-assign-current-backing_dev_info-in-generic_perform_write
+++ a/fs/ceph/file.c
@@ -1791,9 +1791,6 @@ retry_snap:
 	else
 		ceph_start_io_write(inode);
 
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
-
 	if (iocb->ki_flags & IOCB_APPEND) {
 		err = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
 		if (err < 0)
@@ -1938,7 +1935,6 @@ out:
 		ceph_end_io_write(inode);
 out_unlocked:
 	ceph_free_cap_flush(prealloc_cf);
-	current->backing_dev_info = NULL;
 	return written ? written : err;
 }
 
--- a/fs/ext4/file.c~filemap-assign-current-backing_dev_info-in-generic_perform_write
+++ a/fs/ext4/file.c
@@ -29,7 +29,6 @@
 #include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/mman.h>
-#include <linux/backing-dev.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -285,9 +284,7 @@ static ssize_t ext4_buffered_write_iter(
 	if (ret <= 0)
 		goto out;
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	ret = generic_perform_write(iocb, from);
-	current->backing_dev_info = NULL;
 
 out:
 	inode_unlock(inode);
--- a/fs/f2fs/file.c~filemap-assign-current-backing_dev_info-in-generic_perform_write
+++ a/fs/f2fs/file.c
@@ -4517,9 +4517,7 @@ static ssize_t f2fs_buffered_write_iter(
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	ret = generic_perform_write(iocb, from);
-	current->backing_dev_info = NULL;
 
 	if (ret > 0) {
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
--- a/fs/nfs/file.c~filemap-assign-current-backing_dev_info-in-generic_perform_write
+++ a/fs/nfs/file.c
@@ -648,11 +648,8 @@ ssize_t nfs_file_write(struct kiocb *ioc
 	since = filemap_sample_wb_err(file->f_mapping);
 	nfs_start_io_write(inode);
 	result = generic_write_checks(iocb, from);
-	if (result > 0) {
-		current->backing_dev_info = inode_to_bdi(inode);
+	if (result > 0)
 		result = generic_perform_write(iocb, from);
-		current->backing_dev_info = NULL;
-	}
 	nfs_end_io_write(inode);
 	if (result <= 0)
 		goto out;
--- a/mm/filemap.c~filemap-assign-current-backing_dev_info-in-generic_perform_write
+++ a/mm/filemap.c
@@ -3865,6 +3865,7 @@ ssize_t generic_perform_write(struct kio
 	long status = 0;
 	ssize_t written = 0;
 
+	current->backing_dev_info = inode_to_bdi(mapping->host);
 	do {
 		struct page *page;
 		unsigned long offset;	/* Offset into pagecache page */
@@ -3929,6 +3930,7 @@ again:
 
 		balance_dirty_pages_ratelimited(mapping);
 	} while (iov_iter_count(i));
+	current->backing_dev_info = NULL;
 
 	if (!written)
 		return status;
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

