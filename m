Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A6FC77B72
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 01:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDRBEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjDRBEq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 21:04:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508C8AD
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 18:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD56D6216B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 01:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41395C433EF;
        Tue, 18 Apr 2023 01:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681779884;
        bh=g1TSAisBUu50r9yiWV0Tkz8TsWTEVMcRDNklWvR5nsU=;
        h=Date:To:From:Subject:From;
        b=ffQ4+48cwoYVTG6uAmOHGjGaSE1vjQQRjktKsIVxRqTsUPfPYX+K9q+8jwI1JIeCg
         bZmcbHYs7Xus1hXbTFNtPn/A/raN6va+jnJG6bu7BY1yJsEvm1gS8DuYy1YGlGA7oT
         2pkjJ2gAhrYwgMRWCzkhqSZHMRtfVIJkvdMbKYzw=
Date:   Mon, 17 Apr 2023 18:04:43 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        hannes@cmpxchg.org, yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-show_memc-use-for_each_populated_zone-simplify-code.patch added to mm-unstable branch
Message-Id: <20230418010444.41395C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/show_mem.c: use for_each_populated_zone() simplify code
has been added to the -mm mm-unstable branch.  Its filename is
     lib-show_memc-use-for_each_populated_zone-simplify-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-show_memc-use-for_each_populated_zone-simplify-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

lib-show_memc-use-for_each_populated_zone-simplify-code.patch

