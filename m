Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935FCC7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbjDUVxI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbjDUVwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C38268E
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4967361D01
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6FC433D2;
        Fri, 21 Apr 2023 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113964;
        bh=ooY4V1Drx7pGUEGas8u5EM95B5hgso7hDbZ1KUerRA4=;
        h=Date:To:From:Subject:From;
        b=ooWQAg24dcIrODm3Pus6PwViluMUOkRFHvFJbCPXF+mBmDyM3a3flszaVRvnxjM4O
         YLtJxqxcWZtTf3n2mtlD/Zrfx2D9zbkHLNqUnM7dp4BZjQgxvSEeS7ZlSBxf5YeA3W
         YJy8LhCrHio6LzC/Xvthhxz5QHstfmVVfByhzHaE=
Date:   Fri, 21 Apr 2023 14:52:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        hannes@cmpxchg.org, yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-show_memc-use-for_each_populated_zone-simplify-code.patch removed from -mm tree
Message-Id: <20230421215244.9DF6FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/show_mem.c: use for_each_populated_zone() simplify code
has been removed from the -mm tree.  Its filename was
     lib-show_memc-use-for_each_populated_zone-simplify-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: lib/show_mem.c: use for_each_populated_zone() simplify code
Date: Mon, 17 Apr 2023 11:52:26 +0800

__show_mem() needs to iterate over all zones that have memory, we can
simplify the code by using for_each_populated_zone().

Link: https://lkml.kernel.org/r/20230417035226.4013584-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/lib/show_mem.c~lib-show_memc-use-for_each_populated_zone-simplify-code
+++ a/lib/show_mem.c
@@ -10,26 +10,19 @@
 
 void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
-	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, highmem = 0;
+	struct zone *zone;
 
 	printk("Mem-Info:\n");
 	__show_free_areas(filter, nodemask, max_zone_idx);
 
-	for_each_online_pgdat(pgdat) {
-		int zoneid;
+	for_each_populated_zone(zone) {
 
-		for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
-			struct zone *zone = &pgdat->node_zones[zoneid];
-			if (!populated_zone(zone))
-				continue;
-
-			total += zone->present_pages;
-			reserved += zone->present_pages - zone_managed_pages(zone);
-
-			if (is_highmem_idx(zoneid))
-				highmem += zone->present_pages;
-		}
+		total += zone->present_pages;
+		reserved += zone->present_pages - zone_managed_pages(zone);
+
+		if (is_highmem(zone))
+			highmem += zone->present_pages;
 	}
 
 	printk("%lu pages RAM\n", total);
_

Patches currently in -mm which might be from yajun.deng@linux.dev are


