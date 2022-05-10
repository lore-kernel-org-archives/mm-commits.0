Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5C0C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiEJEVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiEJEUe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B6D2B032B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9016FB81B0A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FBEC385C2;
        Tue, 10 May 2022 04:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156121;
        bh=SkbGpcSl8hhdIt8K9MFYWD+1j804CNbXRhogjBVFBSM=;
        h=Date:To:From:Subject:From;
        b=UpG0rOGKxWjnZKb5iSoklgsLiVGzUeOyEilqtsrPI4mOfJaAeOwIFlaoSmdsQwozy
         kcxGISY1P9TJdcVmvPHOAQd1MeqCiCaI8jJUrHEHg0RSGmQm0VPSOOtbtxklEUK7Zj
         3PxMoBvMytrCUm00xstqKdndUsJRr2xRiGu/BP3I=
Date:   Mon, 09 May 2022 21:15:20 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vfs-add-fmode_can_odirect-file-flag.patch removed from -mm tree
Message-Id: <20220510041521.47FBEC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: VFS: add FMODE_CAN_ODIRECT file flag
has been removed from the -mm tree.  Its filename was
     vfs-add-fmode_can_odirect-file-flag.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: VFS: add FMODE_CAN_ODIRECT file flag

Currently various places test if direct IO is possible on a file by
checking for the existence of the direct_IO address space operation.
This is a poor choice, as the direct_IO operation may not be used - it is
only used if the generic_file_*_iter functions are called for direct IO
and some filesystems - particularly NFS - don't do this.

Instead, introduce a new f_mode flag: FMODE_CAN_ODIRECT and change the
various places to check this (avoiding pointer dereferences).
do_dentry_open() will set this flag if ->direct_IO is present, so
filesystems do not need to be changed.

NFS *is* changed, to set the flag explicitly and discard the direct_IO
entry in the address_space_operations for files.

Other filesystems which currently use noop_direct_IO could usefully be
changed to set this flag instead.

Link: https://lkml.kernel.org/r/164859778128.29473.15189737957277399416.stgit@noble.brown
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: NeilBrown <neilb@suse.de>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    4 ++--
 fs/fcntl.c           |    9 ++++-----
 fs/nfs/file.c        |    3 ++-
 fs/open.c            |    9 ++++-----
 fs/overlayfs/file.c  |   13 ++++---------
 include/linux/fs.h   |    3 +++
 6 files changed, 19 insertions(+), 22 deletions(-)

--- a/drivers/block/loop.c~vfs-add-fmode_can_odirect-file-flag
+++ a/drivers/block/loop.c
@@ -186,8 +186,8 @@ static void __loop_update_dio(struct loo
 	 */
 	if (dio) {
 		if (queue_logical_block_size(lo->lo_queue) >= sb_bsize &&
-				!(lo->lo_offset & dio_align) &&
-				mapping->a_ops->direct_IO)
+		    !(lo->lo_offset & dio_align) &&
+		    (file->f_mode & FMODE_CAN_ODIRECT))
 			use_dio = true;
 		else
 			use_dio = false;
--- a/fs/fcntl.c~vfs-add-fmode_can_odirect-file-flag
+++ a/fs/fcntl.c
@@ -56,11 +56,10 @@ static int setfl(int fd, struct file * f
 		   arg |= O_NONBLOCK;
 
 	/* Pipe packetized mode is controlled by O_DIRECT flag */
-	if (!S_ISFIFO(inode->i_mode) && (arg & O_DIRECT)) {
-		if (!filp->f_mapping || !filp->f_mapping->a_ops ||
-			!filp->f_mapping->a_ops->direct_IO)
-				return -EINVAL;
-	}
+	if (!S_ISFIFO(inode->i_mode) &&
+	    (arg & O_DIRECT) &&
+	    !(filp->f_mode & FMODE_CAN_ODIRECT))
+		return -EINVAL;
 
 	if (filp->f_op->check_flags)
 		error = filp->f_op->check_flags(arg);
--- a/fs/nfs/file.c~vfs-add-fmode_can_odirect-file-flag
+++ a/fs/nfs/file.c
@@ -69,6 +69,8 @@ nfs_file_open(struct inode *inode, struc
 		return res;
 
 	res = nfs_open(inode, filp);
+	if (res == 0)
+		filp->f_mode |= FMODE_CAN_ODIRECT;
 	return res;
 }
 
@@ -536,7 +538,6 @@ const struct address_space_operations nf
 	.write_end = nfs_write_end,
 	.invalidate_folio = nfs_invalidate_folio,
 	.releasepage = nfs_release_page,
-	.direct_IO = nfs_direct_IO,
 #ifdef CONFIG_MIGRATION
 	.migratepage = nfs_migrate_page,
 #endif
--- a/fs/open.c~vfs-add-fmode_can_odirect-file-flag
+++ a/fs/open.c
@@ -834,16 +834,15 @@ static int do_dentry_open(struct file *f
 	if ((f->f_mode & FMODE_WRITE) &&
 	     likely(f->f_op->write || f->f_op->write_iter))
 		f->f_mode |= FMODE_CAN_WRITE;
+	if (f->f_mapping->a_ops && f->f_mapping->a_ops->direct_IO)
+		f->f_mode |= FMODE_CAN_ODIRECT;
 
 	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
 	file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);
 
-	/* NB: we're sure to have correct a_ops only after f_op->open */
-	if (f->f_flags & O_DIRECT) {
-		if (!f->f_mapping->a_ops || !f->f_mapping->a_ops->direct_IO)
-			return -EINVAL;
-	}
+	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
+		return -EINVAL;
 
 	/*
 	 * XXX: Huge page cache doesn't support writing yet. Drop all page
--- a/fs/overlayfs/file.c~vfs-add-fmode_can_odirect-file-flag
+++ a/fs/overlayfs/file.c
@@ -82,11 +82,8 @@ static int ovl_change_flags(struct file
 	if (((flags ^ file->f_flags) & O_APPEND) && IS_APPEND(inode))
 		return -EPERM;
 
-	if (flags & O_DIRECT) {
-		if (!file->f_mapping->a_ops ||
-		    !file->f_mapping->a_ops->direct_IO)
-			return -EINVAL;
-	}
+	if ((flags & O_DIRECT) && !(file->f_mode & FMODE_CAN_ODIRECT))
+		return -EINVAL;
 
 	if (file->f_op->check_flags) {
 		err = file->f_op->check_flags(flags);
@@ -306,8 +303,7 @@ static ssize_t ovl_read_iter(struct kioc
 
 	ret = -EINVAL;
 	if (iocb->ki_flags & IOCB_DIRECT &&
-	    (!real.file->f_mapping->a_ops ||
-	     !real.file->f_mapping->a_ops->direct_IO))
+	    !(real.file->f_mode & FMODE_CAN_ODIRECT))
 		goto out_fdput;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
@@ -367,8 +363,7 @@ static ssize_t ovl_write_iter(struct kio
 
 	ret = -EINVAL;
 	if (iocb->ki_flags & IOCB_DIRECT &&
-	    (!real.file->f_mapping->a_ops ||
-	     !real.file->f_mapping->a_ops->direct_IO))
+	    !(real.file->f_mode & FMODE_CAN_ODIRECT))
 		goto out_fdput;
 
 	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
--- a/include/linux/fs.h~vfs-add-fmode_can_odirect-file-flag
+++ a/include/linux/fs.h
@@ -162,6 +162,9 @@ typedef int (dio_iodone_t)(struct kiocb
 /* File is stream-like */
 #define FMODE_STREAM		((__force fmode_t)0x200000)
 
+/* File supports DIRECT IO */
+#define	FMODE_CAN_ODIRECT	((__force fmode_t)0x400000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

