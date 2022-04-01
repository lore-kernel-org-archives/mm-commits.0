Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFA1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 02:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiDACol (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiDACok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 22:44:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1EE217967
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 19:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72EEDB82346
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 02:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01CBC340ED;
        Fri,  1 Apr 2022 02:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648780969;
        bh=s/b96ghJosoMpUOQHEt17xL4WdZFpLIY1ldS82ZE44g=;
        h=Date:To:From:Subject:From;
        b=tzqFB9A15ILqt3l+WKzQo0oWiVsn7NuDkJpbESXjY4Jr3xsUg5wSycKuPUFtmhqdO
         BfvXelXwS2AcBHJPiikg1lGHlgeB9tI5Yc+yxvokd+t4FxCnb4DBXLi0RL8KncE3nn
         9LxaRoSzmtCvT2fvTHRZpjqkxU46sxCI7MCWB/dM=
Date:   Thu, 31 Mar 2022 19:42:48 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mgorman@techsingularity.net,
        linmiaohe@huawei.com, david@redhat.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch added to -mm tree
Message-Id: <20220401024248.F01CBC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2
has been added to the -mm tree.  Its filename is
     mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2

adjust the usage in migrate_balanced_pgdat()

Link: https://lkml.kernel.org/r/20220329010901.1654-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2
+++ a/mm/migrate.c
@@ -1983,7 +1983,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * Returns true if this is a safe migration target node for misplaced NUMA
- * pages. Currently it only checks the watermarks which crude
+ * pages. Currently it only checks the watermarks which is crude.
  */
 static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
 				   unsigned long nr_migrate_pages)
@@ -1993,7 +1993,7 @@ static bool migrate_balanced_pgdat(struc
 	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 		struct zone *zone = pgdat->node_zones + z;
 
-		if (!populated_zone(zone))
+		if (!managed_zone(zone))
 			continue;
 
 		/* Avoid waking kswapd by allocating pages_to_migrate pages. */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mz-already-removed-from-rb_tree-if-not-null.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-explicitly-for-reclaim-and-reclaim.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

