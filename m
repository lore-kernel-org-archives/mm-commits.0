Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ADDC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354311AbiCYAka (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348270AbiCYAk3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71C975E63
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D514617E3
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BF5C340EC;
        Fri, 25 Mar 2022 00:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168735;
        bh=R+v+RP0PR4o3y9P1rShUzNNiLr/KRo+A9AYuMxV0Vk8=;
        h=Date:To:From:Subject:From;
        b=UZLAx2oIGdZUz1HpglyE2X4oISjMhUBiwFX7NiEpRTo+bNWkU1e8W2J/16DIzS2n1
         oA9TxWT/rUc5375W7tzLGkaPLb9Pud7/rdE/FyPOI0w7EY++XqklYxHiRYs4IoyvkO
         lrbN1/e/uDjrn7Q2mvUMjRKGxOIIKldwL59D2nBA=
Date:   Thu, 24 Mar 2022 17:38:55 -0700
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
Subject: [folded-merged] mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch removed from -mm tree
Message-Id: <20220325003855.B1BF5C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4
has been removed from the -mm tree.  Its filename was
     mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read-v4.patch

This patch was dropped because it was folded into mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch

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
@@ -1645,16 +1645,16 @@ static bool try_to_unmap_one(struct foli
 				map_count = folio_mapcount(folio);
 
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
 				    !folio_test_dirty(folio)) {
 					/* Invalidate as we cleared the pte */
 					mmu_notifier_invalidate_range(mm,
_

Patches currently in -mm which might be from mfo@canonical.com are

mm-fix-race-between-madv_free-reclaim-and-blkdev-direct-io-read.patch

