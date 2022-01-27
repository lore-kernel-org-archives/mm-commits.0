Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D112DC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242549AbiA0Wm5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:42:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50806 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiA0Wm4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:42:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50E3761C04
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE28C340E4;
        Thu, 27 Jan 2022 22:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323375;
        bh=O0JDlijaI36FMJLxMBKQCf+IoV2ccf0v7ZE4/1AG+qY=;
        h=Date:From:To:Subject:From;
        b=JVIdZq37elybqyXNzUQ0Ezj4mn/PSNEC501MvmOP0gR/Npfa7xvhe5sHFrlPtE65S
         UMlnPWiHyK+B6XTIo3ewUV6Zn2bR6hrsyL5CQpg6ngjpMKYpZLWNvL5cMkdWib6MUj
         zDCz4Jj8rjmhydwJRMVoNEMU3QnOxbwU+kNfh/2Y=
Date:   Thu, 27 Jan 2022 14:42:54 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  + cephfs-dont-set-clear-bdi_congestion.patch added to -mm
 tree
Message-ID: <20220127224254.JOYAM9eDg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cephfs: don't set/clear bdi_congestion
has been added to the -mm tree.  Its filename is
     cephfs-dont-set-clear-bdi_congestion.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/cephfs-dont-set-clear-bdi_congestion.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/cephfs-dont-set-clear-bdi_congestion.patch

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
Subject: cephfs: don't set/clear bdi_congestion

The bdi congestion framework is no-longer used - writeback uses other
mechanisms to manage throughput.

So remove calls to set_bdi_congested() and clear_bdi_congested(), and
remove the writeback_count which is used only to guide the setting and
clearing.

The congestion_kb mount option is no longer meaningful, but as it is
visible to user-space, removing it needs more consideration.

Link: https://lkml.kernel.org/r/164325158958.29787.8840004338500709466.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/addr.c  |   27 ---------------------------
 fs/ceph/super.c |    2 --
 fs/ceph/super.h |    2 --
 3 files changed, 31 deletions(-)

--- a/fs/ceph/addr.c~cephfs-dont-set-clear-bdi_congestion
+++ a/fs/ceph/addr.c
@@ -57,11 +57,6 @@
  * accounting is preserved.
  */
 
-#define CONGESTION_ON_THRESH(congestion_kb) (congestion_kb >> (PAGE_SHIFT-10))
-#define CONGESTION_OFF_THRESH(congestion_kb)				\
-	(CONGESTION_ON_THRESH(congestion_kb) -				\
-	 (CONGESTION_ON_THRESH(congestion_kb) >> 2))
-
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
 					struct folio *folio, void **_fsdata);
 
@@ -561,10 +556,6 @@ static int writepage_nounlock(struct pag
 	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
 	     inode, page, page->index, page_off, len, snapc, snapc->seq);
 
-	if (atomic_long_inc_return(&fsc->writeback_count) >
-	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
-		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
-
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
 				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
@@ -621,10 +612,6 @@ static int writepage_nounlock(struct pag
 	ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
 	ceph_put_snap_context(snapc);  /* page's reference */
 
-	if (atomic_long_dec_return(&fsc->writeback_count) <
-	    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
-		clear_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
-
 	return err;
 }
 
@@ -704,12 +691,6 @@ static void writepages_finish(struct cep
 			BUG_ON(!page);
 			WARN_ON(!PageUptodate(page));
 
-			if (atomic_long_dec_return(&fsc->writeback_count) <
-			     CONGESTION_OFF_THRESH(
-					fsc->mount_options->congestion_kb))
-				clear_bdi_congested(inode_to_bdi(inode),
-						    BLK_RW_ASYNC);
-
 			ceph_put_snap_context(detach_page_private(page));
 			end_page_writeback(page);
 			dout("unlocking %p\n", page);
@@ -952,14 +933,6 @@ get_more_pages:
 			dout("%p will write page %p idx %lu\n",
 			     inode, page, page->index);
 
-			if (atomic_long_inc_return(&fsc->writeback_count) >
-			    CONGESTION_ON_THRESH(
-				    fsc->mount_options->congestion_kb)) {
-				set_bdi_congested(inode_to_bdi(inode),
-						  BLK_RW_ASYNC);
-			}
-
-
 			pages[locked_pages++] = page;
 			pvec.pages[i] = NULL;
 
--- a/fs/ceph/super.c~cephfs-dont-set-clear-bdi_congestion
+++ a/fs/ceph/super.c
@@ -801,8 +801,6 @@ static struct ceph_fs_client *create_fs_
 	fsc->filp_gen = 1;
 	fsc->have_copy_from2 = true;
 
-	atomic_long_set(&fsc->writeback_count, 0);
-
 	err = -ENOMEM;
 	/*
 	 * The number of concurrent works can be high but they don't need
--- a/fs/ceph/super.h~cephfs-dont-set-clear-bdi_congestion
+++ a/fs/ceph/super.h
@@ -120,8 +120,6 @@ struct ceph_fs_client {
 
 	struct ceph_mds_client *mdsc;
 
-	atomic_long_t writeback_count;
-
 	struct workqueue_struct *inode_wq;
 	struct workqueue_struct *cap_wq;
 
_

Patches currently in -mm which might be from neilb@suse.de are

remove-inode_congested.patch
remove-bdi_congested-and-wb_congested-and-related-functions.patch
f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch
f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch
cephfs-dont-set-clear-bdi_congestion.patch
fuse-dont-set-clear-bdi_congested.patch
nfs-remove-congestion-control.patch
block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
remove-congestion-tracking-framework.patch
mm-discard-__gfp_atomic.patch

