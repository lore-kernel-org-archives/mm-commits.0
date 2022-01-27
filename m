Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46AEC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbiA0WnH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:43:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50902 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244140AbiA0WnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:43:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B7CD61C04
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D89C340E4;
        Thu, 27 Jan 2022 22:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323385;
        bh=z3FmZNVdjA+jwPS/0trr5fusAPlw7dlXFA/FNXWyekI=;
        h=Date:From:To:Subject:From;
        b=dTZdOj6i7mGltOCnowl0epLy1bdap+VmYLTPDvlCKZQ1Rl4R7dikgPnOvMBxvRJGn
         trIhctRtAVQIjnesyNJk8XcrW+VV/nCHPrUKq5aCrdsbQzGiy/D09NY1EXq8/UCo7d
         XAyChxmXb2oW69Ynb+mws9dR9SyEeHW7/CqIlTtU=
Date:   Thu, 27 Jan 2022 14:43:04 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  +
 block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch added to -mm
 tree
Message-ID: <20220127224304.NOlAPf65f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"
has been added to the -mm tree.  Its filename is
     block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch

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
Subject: block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

bfq_get_queue() expects a "bool" for the third arg, so pass "false" rather
than "BLK_RW_ASYNC" which will soon be removed.

Link: https://lkml.kernel.org/r/164325158959.29787.11286416793279041497.stgit@noble.brown
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

 block/bfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bfq-iosched.c~block-bfq-ioschedc-use-false-rather-than-blk_rw_async
+++ a/block/bfq-iosched.c
@@ -5448,7 +5448,7 @@ static void bfq_check_ioprio_change(stru
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
 		bfq_release_process_ref(bfqd, bfqq);
-		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic, true);
+		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
 		bic_set_bfqq(bic, bfqq, false);
 	}
 
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

