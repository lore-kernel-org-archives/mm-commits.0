Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA74AC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbjFIXeL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjFIXc6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A070A49DF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E8F163EA3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CA4C433D2;
        Fri,  9 Jun 2023 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353408;
        bh=9K+G1PKzlRx8xsArwl6gJNQUN+BFPQQHiZrfYtaIstc=;
        h=Date:To:From:Subject:From;
        b=SQEURDYOXOl3INLcXoxDGpJ9W2uX9Rd2SRey+18/0DZuzvkB+r3zxqEgwEYupWsX5
         Bb8ctMhSrFWdv88UV471tpYuDkU1YQ/bXoYy1yU4JohBJ3cPwbcPoY2K4mKEuLBnlg
         lin1hw8d9zraGujjh2Id1ca48X7FLsdgBKHZh8Ck=
Date:   Fri, 09 Jun 2023 16:30:08 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-update-ki_pos-in-generic_perform_write.patch removed from -mm tree
Message-Id: <20230609233008.92CA4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: update ki_pos in generic_perform_write
has been removed from the -mm tree.  Its filename was
     filemap-update-ki_pos-in-generic_perform_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: filemap: update ki_pos in generic_perform_write
Date: Thu, 1 Jun 2023 16:58:55 +0200

All callers of generic_perform_write need to updated ki_pos, move it into
common code.

Link: https://lkml.kernel.org/r/20230601145904.1385409-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Theodore Ts'o <tytso@mit.edu>
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
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/file.c |    2 --
 fs/ext4/file.c |    9 +++------
 fs/f2fs/file.c |    1 -
 fs/nfs/file.c  |    1 -
 mm/filemap.c   |    8 ++++----
 5 files changed, 7 insertions(+), 14 deletions(-)

--- a/fs/ceph/file.c~filemap-update-ki_pos-in-generic_perform_write
+++ a/fs/ceph/file.c
@@ -1891,8 +1891,6 @@ retry_snap:
 		 * can not run at the same time
 		 */
 		written = generic_perform_write(iocb, from);
-		if (likely(written >= 0))
-			iocb->ki_pos = pos + written;
 		ceph_end_io_write(inode);
 	}
 
--- a/fs/ext4/file.c~filemap-update-ki_pos-in-generic_perform_write
+++ a/fs/ext4/file.c
@@ -289,12 +289,9 @@ static ssize_t ext4_buffered_write_iter(
 
 out:
 	inode_unlock(inode);
-	if (likely(ret > 0)) {
-		iocb->ki_pos += ret;
-		ret = generic_write_sync(iocb, ret);
-	}
-
-	return ret;
+	if (unlikely(ret <= 0))
+		return ret;
+	return generic_write_sync(iocb, ret);
 }
 
 static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
--- a/fs/f2fs/file.c~filemap-update-ki_pos-in-generic_perform_write
+++ a/fs/f2fs/file.c
@@ -4520,7 +4520,6 @@ static ssize_t f2fs_buffered_write_iter(
 	ret = generic_perform_write(iocb, from);
 
 	if (ret > 0) {
-		iocb->ki_pos += ret;
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 						APP_BUFFERED_IO, ret);
 	}
--- a/fs/nfs/file.c~filemap-update-ki_pos-in-generic_perform_write
+++ a/fs/nfs/file.c
@@ -655,7 +655,6 @@ ssize_t nfs_file_write(struct kiocb *ioc
 		goto out;
 
 	written = result;
-	iocb->ki_pos += written;
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
 
 	if (mntflags & NFS_MOUNT_WRITE_EAGER) {
--- a/mm/filemap.c~filemap-update-ki_pos-in-generic_perform_write
+++ a/mm/filemap.c
@@ -3930,7 +3930,10 @@ again:
 		balance_dirty_pages_ratelimited(mapping);
 	} while (iov_iter_count(i));
 
-	return written ? written : status;
+	if (!written)
+		return status;
+	iocb->ki_pos += written;
+	return written;
 }
 EXPORT_SYMBOL(generic_perform_write);
 
@@ -4007,7 +4010,6 @@ ssize_t __generic_file_write_iter(struct
 		endbyte = pos + status - 1;
 		err = filemap_write_and_wait_range(mapping, pos, endbyte);
 		if (err == 0) {
-			iocb->ki_pos = endbyte + 1;
 			written += status;
 			invalidate_mapping_pages(mapping,
 						 pos >> PAGE_SHIFT,
@@ -4020,8 +4022,6 @@ ssize_t __generic_file_write_iter(struct
 		}
 	} else {
 		written = generic_perform_write(iocb, from);
-		if (likely(written > 0))
-			iocb->ki_pos += written;
 	}
 out:
 	return written ? written : err;
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

