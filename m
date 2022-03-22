Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C773EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiCVVkn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiCVVka (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82301E7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70A3D61733
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18FBC340EC;
        Tue, 22 Mar 2022 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985141;
        bh=uWkJGJ2N+nvR3L+pGd9iSgDBQla/4Y6wR2/ld2flBDU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=hQHwlLGVUU4B9VtwY0U3wE0dRXtmMQM8+ojPEz1gpwGGqqJZ9/04xbsiUiRKDdVJx
         JPj8x6NznFF4VVpQ8D/uOGg8oehPnOOIu+oDOOnbpOJ40FMm3ZSjHW07I79EjU8ERJ
         YmuNWH2hQhP+Zh1NlJ2mem87a8iA+QfrD0/4URrU=
Date:   Tue, 22 Mar 2022 14:39:01 -0700
To:     trond.myklebust@hammerspace.com, philipp.reisner@linbit.com,
        paolo.valente@linaro.org, miklos@szeredi.hu,
        lars.ellenberg@linbit.com, konishi.ryusuke@gmail.com,
        jlayton@kernel.org, jaegeuk@kernel.org, jack@suse.cz,
        idryomov@gmail.com, fengguang.wu@intel.com, djwong@kernel.org,
        chao@kernel.org, axboe@kernel.dk, Anna.Schumaker@Netapp.com,
        neilb@suse.de, akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 010/227] nfs: remove reliance on bdi congestion
Message-Id: <20220322213901.C18FBC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: NeilBrown <neilb@suse.de>
Subject: nfs: remove reliance on bdi congestion

The bdi congestion tracking in not widely used and will be removed.

NFS is one of a small number of filesystems that uses it, setting just the
async (write) congestion flag at what it determines are appropriate times.

The only remaining effect of the async flag is to cause (some)
WB_SYNC_NONE writes to be skipped.

So instead of setting the flag, set an internal flag and change:
 - .writepages to do nothing if WB_SYNC_NONE and the flag is set
 - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
    and the flag is set.

The writepages change causes a behavioural change in that pageout() can
now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will be
called on the page which (I think) wil further delay the next attempt at
writeout.  This might be a good thing.

Link: https://lkml.kernel.org/r/164549983738.9187.3972219847989393182.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c            |   14 +++++++++++---
 include/linux/nfs_fs_sb.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/fs/nfs/write.c~nfs-remove-reliance-on-bdi-congestion
+++ a/fs/nfs/write.c
@@ -417,7 +417,7 @@ static void nfs_set_page_writeback(struc
 
 	if (atomic_long_inc_return(&nfss->writeback) >
 			NFS_CONGESTION_ON_THRESH)
-		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
+		nfss->write_congested = 1;
 }
 
 static void nfs_end_page_writeback(struct nfs_page *req)
@@ -433,7 +433,7 @@ static void nfs_end_page_writeback(struc
 
 	end_page_writeback(req->wb_page);
 	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
-		clear_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
+		nfss->write_congested = 0;
 }
 
 /*
@@ -672,6 +672,10 @@ static int nfs_writepage_locked(struct p
 	struct inode *inode = page_file_mapping(page)->host;
 	int err;
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    NFS_SERVER(inode)->write_congested)
+		return AOP_WRITEPAGE_ACTIVATE;
+
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGE);
 	nfs_pageio_init_write(&pgio, inode, 0,
 				false, &nfs_async_write_completion_ops);
@@ -719,6 +723,10 @@ int nfs_writepages(struct address_space
 	int priority = 0;
 	int err;
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    NFS_SERVER(inode)->write_congested)
+		return 0;
+
 	nfs_inc_stats(inode, NFSIOS_VFSWRITEPAGES);
 
 	if (!(mntflags & NFS_MOUNT_WRITE_EAGER) || wbc->for_kupdate ||
@@ -1893,7 +1901,7 @@ static void nfs_commit_release_pages(str
 	}
 	nfss = NFS_SERVER(data->inode);
 	if (atomic_long_read(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
-		clear_bdi_congested(inode_to_bdi(data->inode), BLK_RW_ASYNC);
+		nfss->write_congested = 0;
 
 	nfs_init_cinfo(&cinfo, data->inode, data->dreq);
 	nfs_commit_end(cinfo.mds);
--- a/include/linux/nfs_fs_sb.h~nfs-remove-reliance-on-bdi-congestion
+++ a/include/linux/nfs_fs_sb.h
@@ -138,6 +138,7 @@ struct nfs_server {
 	struct nlm_host		*nlm_host;	/* NLM client handle */
 	struct nfs_iostats __percpu *io_stats;	/* I/O statistics */
 	atomic_long_t		writeback;	/* number of writeback pages */
+	unsigned int		write_congested;/* flag set when writeback gets too high */
 	unsigned int		flags;		/* various flags */
 
 /* The following are for internal use only. Also see uapi/linux/nfs_mount.h */
_
