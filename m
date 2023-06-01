Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356EDC7EE29
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbjFAW3N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbjFAW3L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ECA194
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16BFD64A88
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0D2C433D2;
        Thu,  1 Jun 2023 22:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685658549;
        bh=bJ7gR/1xQ+nnNtpG6Bf27z+viReHQmVTLUVdtpzEoNc=;
        h=Date:To:From:Subject:From;
        b=0H6OqKpq/x+gOEgsmT5IDsbZmtnM6GYbEyWd7JWDLR5bKN9b35pcQpoTKA0uf+MYB
         Ryp9Eoynp3p49EmAZL43R62O8eybkVuuQet6rgbb7ph50/SkVKSj6zYxmxZChJmTKw
         qasEWnvMI77IT3UG+62WhEWEZInNCp2+REdIiSLQ=
Date:   Thu, 01 Jun 2023 15:29:08 -0700
To:     mm-commits@vger.kernel.org, xiubli@redhat.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        trond.myklebust@hammerspace.com, mszeredi@redhat.com,
        miklos@szeredi.hu, johannes.thumshirn@wdc.com, jaegeuk@kernel.org,
        idryomov@gmail.com, hare@suse.de, dlemoal@kernel.org,
        djwong@kernel.org, chao@kernel.org, brauner@kernel.org,
        axboe@kernel.dk, anna@kernel.org, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-update-ki_pos-in-generic_perform_write.patch added to mm-unstable branch
Message-Id: <20230601222909.6D0D2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: update ki_pos in generic_perform_write
has been added to the -mm mm-unstable branch.  Its filename is
     filemap-update-ki_pos-in-generic_perform_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-update-ki_pos-in-generic_perform_write.patch

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

backing_dev-remove-current-backing_dev_info.patch
iomap-update-ki_pos-a-little-later-in-iomap_dio_complete.patch
filemap-update-ki_pos-in-generic_perform_write.patch
filemap-add-a-kiocb_write_and_wait-helper.patch
filemap-add-a-kiocb_invalidate_pages-helper.patch
filemap-add-a-kiocb_invalidate_post_direct_write-helper.patch
iomap-update-ki_pos-in-iomap_file_buffered_write.patch
iomap-use-kiocb_write_and_wait-and-kiocb_invalidate_pages.patch
fs-factor-out-a-direct_write_fallback-helper.patch
fuse-update-ki_pos-in-fuse_perform_write.patch
fuse-drop-redundant-arguments-to-fuse_perform_write.patch
fuse-use-direct_write_fallback.patch
squashfs-dont-include-buffer_headh.patch

