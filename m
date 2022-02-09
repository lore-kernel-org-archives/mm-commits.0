Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA46C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  9 Feb 2022 20:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiBIUja (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:39:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiBIUj3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2022 15:39:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05AE018E42
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 12:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60C9861AD5
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 20:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B3FC340E7;
        Wed,  9 Feb 2022 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644439168;
        bh=UXgIpYYsVku5dYLLu2vJZg0MTlYM6KfjG85cI55cmYI=;
        h=Date:To:From:Subject:From;
        b=b2utqSliMmvQFBhlN0AEfTLJjCViZeZAEGXhJzlzxDgdjrSicGjvQr/mwAwI390dd
         bjlaVZyjgY2ap2AatnMxTf/qCU4KnXue++c5gb/j66SsN6QmxkKPxwvK3d6u2+gjjL
         90LzqsjZwRibvdI0iPuO+sY9M3b7+lSD53qKJoN8=
Date:   Wed, 09 Feb 2022 12:39:27 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        shy828301@gmail.com, ponnuvel.palaniyappan@canonical.com,
        minchan@kernel.org, matthew.ruffell@canonical.com,
        linmiaohe@huawei.com, jay.vosburgh@canonical.com,
        ioanna-maria.alifieraki@canonical.com, halves@canonical.com,
        gerald.yang@canonical.com, gavin.guo@canonical.com,
        dongdong.tao@canonical.com, dan.streetman@canonical.com,
        daniel.hill@canonical.com, mfo@canonical.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch added to -mm tree
Message-Id: <20220209203928.99B3FC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4
has been added to the -mm tree.  Its filename is
     mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4

v4: - fixed Fixes: tag to first support, after tests on v4.5;
      updated commit message/reproducer section with results.
    - tested on v5.17-rc3 and v4.5.
    - shorten comment line; remove inner braces in the check.
      (Thanks: Christoph Hellwig <hch@infradead.org>)
    - clarify comment about __remove_mapping()
      (Thanks: Yu Zhao <yuzhao@google.com>)

Link: https://lkml.kernel.org/r/20220209202659.183418-1-mfo@canonical.com
Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dan Hill <daniel.hill@canonical.com>
Cc: Dan Streetman <dan.streetman@canonical.com>
Cc: Dongdong Tao <dongdong.tao@canonical.com>
Cc: Gavin Guo <gavin.guo@canonical.com>
Cc: Gerald Yang <gerald.yang@canonical.com>
Cc: Heitor Alves de Siqueira <halves@canonical.com>
Cc: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Cc: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ponnuvel Palaniyappan <ponnuvel.palaniyappan@canonical.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4
+++ a/mm/rmap.c
@@ -1614,16 +1614,16 @@ static bool try_to_unmap_one(struct page
 				map_count = page_mapcount(page);
 
 				/*
-				 * Order reads for page refcount and dirty flag;
-				 * see __remove_mapping().
+				 * Order reads for page refcount and dirty flag
+				 * (see comments in __remove_mapping()).
 				 */
 				smp_rmb();
 
 				/*
-				 * The only page refs must be from the isolation
-				 * plus one or more rmap's (dropped by discard:).
+				 * The only page refs must be one from isolation
+				 * plus the rmap(s) (dropped by discard:).
 				 */
-				if ((ref_count == 1 + map_count) &&
+				if (ref_count == 1 + map_count &&
 				    !PageDirty(page)) {
 					/* Invalidate as we cleared the pte */
 					mmu_notifier_invalidate_range(mm,
_

Patches currently in -mm which might be from mfo@canonical.com are

mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch
mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch

