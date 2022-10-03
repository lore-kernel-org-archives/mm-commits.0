Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD37FC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJCVPk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiJCVOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39A2183
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498AC611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C8BC433D7;
        Mon,  3 Oct 2022 21:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831372;
        bh=PNZ1wO5r6UpNw+ZhR6R6yNmSAU/ivNOZ0o/3ZWj437k=;
        h=Date:To:From:Subject:From;
        b=kUkS8g6amio7A6SGpnd58EcyyPzvQTcOlhRej/R2bWBwCPD2RAGdtO2TziNC/KnqX
         3JX1u5C+dEmDGYFxN0lBkC9P9Hg5C3BWXi+nrsvbp+03NT37D0Ste1s1PTTjQ2G2SE
         UqAhC5Hym+5VlQ/nWWwNCJs1OIa4yCPyJoNi9TXc=
Date:   Mon, 03 Oct 2022 14:09:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-freeing-static-percpu-memory.patch removed from -mm tree
Message-Id: <20221003210932.99C8BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: fix freeing static percpu memory
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-freeing-static-percpu-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: fix freeing static percpu memory
Date: Fri, 16 Sep 2022 15:22:47 +0800

The size of struct per_cpu_zonestat can be 0 on !SMP && !NUMA.  In that
case, zone->per_cpu_zonestats will always equal to boot_zonestats.  But in
zone_pcp_reset(), zone->per_cpu_zonestats is freed via free_percpu()
directly without checking against boot_zonestats first.  boot_zonestats
will be released by free_percpu() unexpectedly.

Link: https://lkml.kernel.org/r/20220916072257.9639-7-linmiaohe@huawei.com
Fixes: 28f836b6777b ("mm/page_alloc: split per cpu page lists and zone stats")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-freeing-static-percpu-memory
+++ a/mm/page_alloc.c
@@ -9513,9 +9513,11 @@ void zone_pcp_reset(struct zone *zone)
 			drain_zonestat(zone, pzstats);
 		}
 		free_percpu(zone->per_cpu_pageset);
-		free_percpu(zone->per_cpu_zonestats);
 		zone->per_cpu_pageset = &boot_pageset;
-		zone->per_cpu_zonestats = &boot_zonestats;
+		if (zone->per_cpu_zonestats != &boot_zonestats) {
+			free_percpu(zone->per_cpu_zonestats);
+			zone->per_cpu_zonestats = &boot_zonestats;
+		}
 	}
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


