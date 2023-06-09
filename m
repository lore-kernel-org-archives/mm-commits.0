Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539E2C7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFIXeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXcy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762ED49D8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5684F60D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB38C433EF;
        Fri,  9 Jun 2023 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353405;
        bh=JNt/2MsoI64uDkxeNcGP1Mo7KnQF+jLLWDGj+2NjY60=;
        h=Date:To:From:Subject:From;
        b=DvOVl7zyPLu3kcAEt3nzE1EgLl+PBDLxGxY2BsYEj2yQAO5JUpf5Bzx+Aeq+5j+C/
         fM+DG44UsGfPNZ0lXOBuweLJRYEmXX/jSItFixs/qZwT57281C22W+blSJInaUVU9a
         Z+5NeaACYK5GsE2mdL9+hVf5B+fk6te7WeZyQIow=
Date:   Fri, 09 Jun 2023 16:30:05 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] backing_dev-remove-current-backing_dev_info.patch removed from -mm tree
Message-Id: <20230609233005.AFB38C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: backing_dev: remove current->backing_dev_info
has been removed from the -mm tree.  Its filename was
     backing_dev-remove-current-backing_dev_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: backing_dev: remove current->backing_dev_info
Date: Thu, 1 Jun 2023 16:58:53 +0200

Patch series "cleanup the filemap / direct I/O interaction", v4.

This series cleans up some of the generic write helper calling conventions
and the page cache writeback / invalidation for direct I/O.  This is a
spinoff from the no-bufferhead kernel project, for which we'll want to an
use iomap based buffered write path in the block layer.


This patch (of 12):

The last user of current->backing_dev_info disappeared in commit
b9b1335e6403 ("remove bdi_congested() and wb_congested() and related
functions").  Remove the field and all assignments to it.

Link: https://lkml.kernel.org/r/20230601145904.1385409-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230601145904.1385409-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/file.c       |    6 +-----
 fs/ceph/file.c        |    4 ----
 fs/ext4/file.c        |    2 --
 fs/f2fs/file.c        |    2 --
 fs/fuse/file.c        |    4 ----
 fs/gfs2/file.c        |    2 --
 fs/nfs/file.c         |    5 +----
 fs/ntfs/file.c        |    2 --
 fs/ntfs3/file.c       |    3 ---
 fs/xfs/xfs_file.c     |    4 ----
 include/linux/sched.h |    3 ---
 mm/filemap.c          |    3 ---
 12 files changed, 2 insertions(+), 38 deletions(-)

--- a/fs/btrfs/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/btrfs/file.c
@@ -1145,7 +1145,6 @@ static int btrfs_write_check(struct kioc
 	    !(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW | BTRFS_INODE_PREALLOC)))
 		return -EAGAIN;
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	ret = file_remove_privs(file);
 	if (ret)
 		return ret;
@@ -1165,10 +1164,8 @@ static int btrfs_write_check(struct kioc
 		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
 
 		ret = btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
-		if (ret) {
-			current->backing_dev_info = NULL;
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
@@ -1689,7 +1686,6 @@ ssize_t btrfs_do_write_iter(struct kiocb
 	if (sync)
 		atomic_dec(&inode->sync_writers);
 
-	current->backing_dev_info = NULL;
 	return num_written;
 }
 
--- a/fs/ceph/file.c~backing_dev-remove-current-backing_dev_info
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
@@ -1940,7 +1937,6 @@ out:
 		ceph_end_io_write(inode);
 out_unlocked:
 	ceph_free_cap_flush(prealloc_cf);
-	current->backing_dev_info = NULL;
 	return written ? written : err;
 }
 
--- a/fs/ext4/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/ext4/file.c
@@ -285,9 +285,7 @@ static ssize_t ext4_buffered_write_iter(
 	if (ret <= 0)
 		goto out;
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	ret = generic_perform_write(iocb, from);
-	current->backing_dev_info = NULL;
 
 out:
 	inode_unlock(inode);
--- a/fs/f2fs/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/f2fs/file.c
@@ -4517,9 +4517,7 @@ static ssize_t f2fs_buffered_write_iter(
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EOPNOTSUPP;
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	ret = generic_perform_write(iocb, from);
-	current->backing_dev_info = NULL;
 
 	if (ret > 0) {
 		iocb->ki_pos += ret;
--- a/fs/fuse/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/fuse/file.c
@@ -1362,9 +1362,6 @@ static ssize_t fuse_cache_write_iter(str
 writethrough:
 	inode_lock(inode);
 
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
-
 	err = generic_write_checks(iocb, from);
 	if (err <= 0)
 		goto out;
@@ -1409,7 +1406,6 @@ writethrough:
 			iocb->ki_pos += written;
 	}
 out:
-	current->backing_dev_info = NULL;
 	inode_unlock(inode);
 	if (written > 0)
 		written = generic_write_sync(iocb, written);
--- a/fs/gfs2/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/gfs2/file.c
@@ -1041,11 +1041,9 @@ retry:
 			goto out_unlock;
 	}
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	pagefault_enable();
-	current->backing_dev_info = NULL;
 	if (ret > 0) {
 		iocb->ki_pos += ret;
 		written += ret;
--- a/fs/nfs/file.c~backing_dev-remove-current-backing_dev_info
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
--- a/fs/ntfs3/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/ntfs3/file.c
@@ -820,7 +820,6 @@ static ssize_t ntfs_compress_write(struc
 	if (!pages)
 		return -ENOMEM;
 
-	current->backing_dev_info = inode_to_bdi(inode);
 	err = file_remove_privs(file);
 	if (err)
 		goto out;
@@ -993,8 +992,6 @@ static ssize_t ntfs_compress_write(struc
 out:
 	kfree(pages);
 
-	current->backing_dev_info = NULL;
-
 	if (err < 0)
 		return err;
 
--- a/fs/ntfs/file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/ntfs/file.c
@@ -1911,11 +1911,9 @@ static ssize_t ntfs_file_write_iter(stru
 
 	inode_lock(vi);
 	/* We can write back this queue in page reclaim. */
-	current->backing_dev_info = inode_to_bdi(vi);
 	err = ntfs_prepare_file_for_write(iocb, from);
 	if (iov_iter_count(from) && !err)
 		written = ntfs_perform_write(file, from, iocb->ki_pos);
-	current->backing_dev_info = NULL;
 	inode_unlock(vi);
 	iocb->ki_pos += written;
 	if (likely(written > 0))
--- a/fs/xfs/xfs_file.c~backing_dev-remove-current-backing_dev_info
+++ a/fs/xfs/xfs_file.c
@@ -717,9 +717,6 @@ write_retry:
 	if (ret)
 		goto out;
 
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
-
 	trace_xfs_file_buffered_write(iocb, from);
 	ret = iomap_file_buffered_write(iocb, from,
 			&xfs_buffered_write_iomap_ops);
@@ -753,7 +750,6 @@ write_retry:
 		goto write_retry;
 	}
 
-	current->backing_dev_info = NULL;
 out:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
--- a/include/linux/sched.h~backing_dev-remove-current-backing_dev_info
+++ a/include/linux/sched.h
@@ -41,7 +41,6 @@
 
 /* task_struct member predeclarations (sorted alphabetically): */
 struct audit_context;
-struct backing_dev_info;
 struct bio_list;
 struct blk_plug;
 struct bpf_local_storage;
@@ -1186,8 +1185,6 @@ struct task_struct {
 	/* VM state: */
 	struct reclaim_state		*reclaim_state;
 
-	struct backing_dev_info		*backing_dev_info;
-
 	struct io_context		*io_context;
 
 #ifdef CONFIG_COMPACTION
--- a/mm/filemap.c~backing_dev-remove-current-backing_dev_info
+++ a/mm/filemap.c
@@ -3964,8 +3964,6 @@ ssize_t __generic_file_write_iter(struct
 	ssize_t		err;
 	ssize_t		status;
 
-	/* We can write back this queue in page reclaim */
-	current->backing_dev_info = inode_to_bdi(inode);
 	err = file_remove_privs(file);
 	if (err)
 		goto out;
@@ -4026,7 +4024,6 @@ ssize_t __generic_file_write_iter(struct
 			iocb->ki_pos += written;
 	}
 out:
-	current->backing_dev_info = NULL;
 	return written ? written : err;
 }
 EXPORT_SYMBOL(__generic_file_write_iter);
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

