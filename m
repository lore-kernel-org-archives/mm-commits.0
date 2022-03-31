Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5F6C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiCaEXo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiCaEXe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:23:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BFA4F445
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B553CB81E9C
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5DFC340EC;
        Thu, 31 Mar 2022 02:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695391;
        bh=46fpRwSaqKRk7lyYI1WoJuKt/G+Vu9Yi0WkYCFvURPs=;
        h=Date:To:From:Subject:From;
        b=dvXs677iwQN9BuAjbHl+5+N2GaTHLBbAsYfFhZYFhoHwLnks1A3TIdRpijR6s54U+
         2T1TWTpxb7k1aUBrm/iIw9xKOwE4Ar/GC9CtMQhKsopf5Nf9BsA1NFdjeJFVNW+/on
         QB83uE/cheDwMLaf6+JKqSxTeNl875IJjX5wk47s=
Date:   Wed, 30 Mar 2022 19:56:30 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vfs-add-fmode_can_odirect-file-flag.patch added to -mm tree
Message-Id: <20220331025631.6D5DFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: VFS: Add FMODE_CAN_ODIRECT file flag
has been added to the -mm tree.  Its filename is
     vfs-add-fmode_can_odirect-file-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vfs-add-fmode_can_odirect-file-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vfs-add-fmode_can_odirect-file-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: VFS: Add FMODE_CAN_ODIRECT file flag

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
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
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
 
@@ -540,7 +542,6 @@ const struct address_space_operations nf
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

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

