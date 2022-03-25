Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8112C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357317AbiCYBbe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357315AbiCYBbW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881142BB28
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2441761947
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C191C340ED;
        Fri, 25 Mar 2022 01:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171788;
        bh=1udz+ftFYJVtopHcw9nDoP/lDpqfao318jsie86Dhog=;
        h=Date:To:From:Subject:From;
        b=rAy7kmHPL3kXCygUkqKda+JPKTaho5crSAqAHJYyds5DhVokee+QP8Vj0XXlEHLRG
         Ff9iv+9tBtjzGHp3Ihuim8kEvOkawfMxranmbkjDq42vu8FBrnWWKazgMSVxp7cQi0
         Zp/MuHj6CnCm8TMJZn2yF/EFJOZ9GMGnJopz9xJ8=
Date:   Thu, 24 Mar 2022 18:29:47 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ceph-remove-reliance-on-bdi-congestion.patch removed from -mm tree
Message-Id: <20220325012948.7C191C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ceph: remove reliance on bdi congestion
has been removed from the -mm tree.  Its filename was
     ceph-remove-reliance-on-bdi-congestion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: ceph: remove reliance on bdi congestion

The bdi congestion tracking in not widely used and will be removed.

CEPHfs is one of a small number of filesystems that uses it, setting just
the async (write) congestion flags at what it determines are appropriate
times.

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

Link: https://lkml.kernel.org/r/164549983739.9187.14895675781408171186.stgit@noble.brown
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

 fs/ceph/addr.c  |   22 +++++++++++++---------
 fs/ceph/super.c |    1 +
 fs/ceph/super.h |    1 +
 3 files changed, 15 insertions(+), 9 deletions(-)

--- a/fs/ceph/addr.c~ceph-remove-reliance-on-bdi-congestion
+++ a/fs/ceph/addr.c
@@ -563,7 +563,7 @@ static int writepage_nounlock(struct pag
 
 	if (atomic_long_inc_return(&fsc->writeback_count) >
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
-		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
+		fsc->write_congested = true;
 
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
@@ -623,7 +623,7 @@ static int writepage_nounlock(struct pag
 
 	if (atomic_long_dec_return(&fsc->writeback_count) <
 	    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
-		clear_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
+		fsc->write_congested = false;
 
 	return err;
 }
@@ -635,6 +635,10 @@ static int ceph_writepage(struct page *p
 	BUG_ON(!inode);
 	ihold(inode);
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    ceph_inode_to_client(inode)->write_congested)
+		return AOP_WRITEPAGE_ACTIVATE;
+
 	wait_on_page_fscache(page);
 
 	err = writepage_nounlock(page, wbc);
@@ -707,8 +711,7 @@ static void writepages_finish(struct cep
 			if (atomic_long_dec_return(&fsc->writeback_count) <
 			     CONGESTION_OFF_THRESH(
 					fsc->mount_options->congestion_kb))
-				clear_bdi_congested(inode_to_bdi(inode),
-						    BLK_RW_ASYNC);
+				fsc->write_congested = false;
 
 			ceph_put_snap_context(detach_page_private(page));
 			end_page_writeback(page);
@@ -760,6 +763,10 @@ static int ceph_writepages_start(struct
 	bool done = false;
 	bool caching = ceph_is_cache_enabled(inode);
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    fsc->write_congested)
+		return 0;
+
 	dout("writepages_start %p (mode=%s)\n", inode,
 	     wbc->sync_mode == WB_SYNC_NONE ? "NONE" :
 	     (wbc->sync_mode == WB_SYNC_ALL ? "ALL" : "HOLD"));
@@ -954,11 +961,8 @@ get_more_pages:
 
 			if (atomic_long_inc_return(&fsc->writeback_count) >
 			    CONGESTION_ON_THRESH(
-				    fsc->mount_options->congestion_kb)) {
-				set_bdi_congested(inode_to_bdi(inode),
-						  BLK_RW_ASYNC);
-			}
-
+				    fsc->mount_options->congestion_kb))
+				fsc->write_congested = true;
 
 			pages[locked_pages++] = page;
 			pvec.pages[i] = NULL;
--- a/fs/ceph/super.c~ceph-remove-reliance-on-bdi-congestion
+++ a/fs/ceph/super.c
@@ -802,6 +802,7 @@ static struct ceph_fs_client *create_fs_
 	fsc->have_copy_from2 = true;
 
 	atomic_long_set(&fsc->writeback_count, 0);
+	fsc->write_congested = false;
 
 	err = -ENOMEM;
 	/*
--- a/fs/ceph/super.h~ceph-remove-reliance-on-bdi-congestion
+++ a/fs/ceph/super.h
@@ -121,6 +121,7 @@ struct ceph_fs_client {
 	struct ceph_mds_client *mdsc;
 
 	atomic_long_t writeback_count;
+	bool write_congested;
 
 	struct workqueue_struct *inode_wq;
 	struct workqueue_struct *cap_wq;
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

