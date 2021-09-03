Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8767EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7512A610CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350002AbhICVCp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235821AbhICVCo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81E9E60EE3;
        Fri,  3 Sep 2021 21:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702904;
        bh=Qi8NsuL4RPV4lEs616EOt1bOUbo8A0ygheu03Fbar4E=;
        h=Date:From:To:Subject:From;
        b=XmqV+ZvQwDow5740SRBpKpon6IG4uJuv+0jK91wxl4HyyEM1A7BiTjDPL7A1jYupe
         rFAZu6PFyLLQidEkVDnP861Bq0xW2hC5Na2Fn2IAi7cX2ZUwUIiKc1bneni8ADDTpO
         g79QXgxQgcJTUfjJWcTa5zNtH+OhOtjo6ugFikHY=
Date:   Fri, 03 Sep 2021 14:01:44 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-vmstat-simplify-the-array-size-calculation.patch removed from -mm tree
Message-ID: <20210903210144.7Rao40OQj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: simplify the array size calculation
has been removed from the -mm tree.  Its filename was
     mm-vmstat-simplify-the-array-size-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmstat: simplify the array size calculation

We can replace the array_num * sizeof(array[0]) with sizeof(array) to
simplify the code.

Link: https://lkml.kernel.org/r/20210715122911.15700-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-simplify-the-array-size-calculation
+++ a/mm/vmstat.c
@@ -1891,17 +1891,15 @@ static bool need_update(int cpu)
 		/*
 		 * The fast way of checking if there are any vmstat diffs.
 		 */
-		if (memchr_inv(pzstats->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS *
-			       sizeof(pzstats->vm_stat_diff[0])))
+		if (memchr_inv(pzstats->vm_stat_diff, 0, sizeof(pzstats->vm_stat_diff)))
 			return true;
 
 		if (last_pgdat == zone->zone_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
 		n = per_cpu_ptr(zone->zone_pgdat->per_cpu_nodestats, cpu);
-		if (memchr_inv(n->vm_node_stat_diff, 0, NR_VM_NODE_STAT_ITEMS *
-			       sizeof(n->vm_node_stat_diff[0])))
-		    return true;
+		if (memchr_inv(n->vm_node_stat_diff, 0, sizeof(n->vm_node_stat_diff)))
+			return true;
 	}
 	return false;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

