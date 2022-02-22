Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83AAC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiBVEDv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:03:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiBVEDk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:03:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7235C365
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:03:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50C29B81853
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F275EC340E8;
        Tue, 22 Feb 2022 04:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502586;
        bh=3e69gYiU9VKJJeDzyCjVdg7rYH+iYujwYHUvMfI9WzE=;
        h=Date:To:From:Subject:From;
        b=al3iD7ZjOkm02AER9T3ahhBw0Ov+Uo2hkoFQWiD7MDB0UUwgCzEzplp0PgxjNRRnS
         +8VMGiaeOSMfQHWLG576VgQnEvTBMxDr1z5GWiavah2Z+9hJ8Ldl0lTGYyOe2m1c9+
         jvLT5YaHa61qIhGqm//cZR3H+7wgOfiYiQHbqZeI=
Date:   Mon, 21 Feb 2022 20:03:05 -0800
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch added to -mm tree
Message-Id: <20220222040305.F275EC340E8@smtp.kernel.org>
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

Link: https://lkml.kernel.org/r/164549983746.9187.7949730109246767909.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
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

doc-convert-subsection-to-section-in-gfph.patch
mm-document-and-polish-read-ahead-code.patch
mm-improve-cleanup-when-readpages-doesnt-process-all-pages.patch
fuse-remove-reliance-on-bdi-congestion.patch
nfs-remove-reliance-on-bdi-congestion.patch
ceph-remove-reliance-on-bdi-congestion.patch
remove-inode_congested.patch
remove-bdi_congested-and-wb_congested-and-related-functions.patch
f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch
block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
remove-congestion-tracking-framework.patch
mm-discard-__gfp_atomic.patch

