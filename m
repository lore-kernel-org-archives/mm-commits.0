Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E38C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 03:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiD0DLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242711AbiD0DLh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 23:11:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9B5106DDC
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FF4EB81FE0
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 03:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E97AC385A4;
        Wed, 27 Apr 2022 03:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651028905;
        bh=Nr9zETDZrropQ6fPePgMECNv7trlpiZzHp6PZNUUkXE=;
        h=Date:To:From:Subject:From;
        b=LkUUrvq8sh/AQHOe4p9oDbz+lkwHHIsuMOF5uJjbkA2IVAm7YxuwZ7lrLfKKn8tGR
         sZTJDFXPTykH7agFANqUrq41Mo869x1D1GW5KO3ZL+3XHALmCQtbHtMW6/9mxQlOOt
         7A6AlDzyrpMvhaLLXbqwSmOm5F5Aiyhg4JZkCXCc=
Date:   Tue, 26 Apr 2022 20:08:24 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mgorman@techsingularity.net,
        linmiaohe@huawei.com, david@redhat.com, richard.weiyang@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch removed from -mm tree
Message-Id: <20220427030825.2E97AC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2
has been removed from the -mm tree.  Its filename was
     mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch

This patch was dropped because it was folded into mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

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
@@ -1981,7 +1981,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * Returns true if this is a safe migration target node for misplaced NUMA
- * pages. Currently it only checks the watermarks which crude
+ * pages. Currently it only checks the watermarks which is crude.
  */
 static bool migrate_balanced_pgdat(struct pglist_data *pgdat,
 				   unsigned long nr_migrate_pages)
@@ -1991,7 +1991,7 @@ static bool migrate_balanced_pgdat(struc
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
mm-memcg-non-hierarchical-mode-is-deprecated.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

