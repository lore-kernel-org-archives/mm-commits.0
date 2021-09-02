Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B5BC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE1C610F7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347733AbhIBWCF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347666AbhIBWCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DB1D610A2;
        Thu,  2 Sep 2021 22:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620066;
        bh=Px6p1VEHn6MGZZ4Ar1Smc+Cee11OKc630leQeMa4Gzc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C+C0zcBS3kbn0I2nniY9j3X/t7zbVIXrLNJSN8d1rqYhiG0MW5yju9+b8tg54f0ic
         d3oLUy2rrsaZP4zExVejvXYrYa7xOceGf4MGa6Ud4aZD2C+hqjptq6wQ9re448loBp
         YLB0xkxFj44a7N4CgBcp5NCNnOLBTH53W0SiSVc4=
Date:   Thu, 02 Sep 2021 15:01:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 210/212] mm/vmstat: simplify the array size
 calculation
Message-ID: <20210902220105.GLslDVsS1%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
