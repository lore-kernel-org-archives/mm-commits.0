Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA277C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 00:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbiBZAcn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 19:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBZAcn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 19:32:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BC6517D7
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 16:32:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FA64B833BF
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 00:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287F5C340E7;
        Sat, 26 Feb 2022 00:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645835527;
        bh=UXgIpYYsVku5dYLLu2vJZg0MTlYM6KfjG85cI55cmYI=;
        h=Date:To:From:Subject:From;
        b=CuZuSsGa8UweEdMw/gc+bEbWfzAppmNoIALLwefDISotPxW7pskynWUxfB2pTfnkb
         SsVBLEAvkEkcM93XxMgVekPbQl0jrqebm3aKJo3lk/d+GbRHWaLOanh3S9d2RCJUeO
         zs5ZZX+4qOP5Z+SsrfrGtFHH+rPWDN8TdOBKf6dY=
Date:   Fri, 25 Feb 2022 16:32:06 -0800
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
Message-Id: <20220226003207.287F5C340E7@smtp.kernel.org>
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

