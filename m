Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9C5C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjFSXVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjFSXUs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA98C1A3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E0B60F59
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD13C433C8;
        Mon, 19 Jun 2023 23:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216844;
        bh=BUCyH1wEMVOsMvxFZyjBxO8QBwIIM2lBPcS/D9xd0MQ=;
        h=Date:To:From:Subject:From;
        b=NXlf9uonpXepG0UUgsBkiHXGv70XaQ2u2ZnVwtb/GCKMSzvKfJZvmzgXBKWmlTAsx
         JKFkBDkusFcb4Ky9BMfECRq2h7gsrKvGAvVovWIscbP03w/t1t7SNaTt1hqwO0UPMz
         eGq3KTxM16/X52QExBz1u0Ex9qyz+OX25WfdXHd8=
Date:   Mon, 19 Jun 2023 16:20:44 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, osalvador@suse.de,
        mhocko@kernel.org, david@redhat.com, haifeng.xu@shopee.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-reset_node_present_pages.patch removed from -mm tree
Message-Id: <20230619232044.CDD13C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: remove reset_node_present_pages()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-reset_node_present_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: remove reset_node_present_pages()
Date: Wed, 7 Jun 2023 02:50:56 +0000

reset_node_present_pages() only get called in hotadd_init_pgdat(), move
the action that clear present pages to free_area_init_core_hotplug(), so
the helper can be removed.

Link: https://lkml.kernel.org/r/20230607025056.1348-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   18 ------------------
 mm/mm_init.c        |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 20 deletions(-)

--- a/mm/memory_hotplug.c~mm-mm_initc-remove-reset_node_present_pages
+++ a/mm/memory_hotplug.c
@@ -1156,16 +1156,6 @@ failed_addition:
 	return ret;
 }
 
-static void reset_node_present_pages(pg_data_t *pgdat)
-{
-	struct zone *z;
-
-	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
-		z->present_pages = 0;
-
-	pgdat->node_present_pages = 0;
-}
-
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_init_pgdat(int nid)
 {
@@ -1188,14 +1178,6 @@ static pg_data_t __ref *hotadd_init_pgda
 	 */
 	build_all_zonelists(pgdat);
 
-	/*
-	 * When memory is hot-added, all the memory is in offline state. So
-	 * clear all zones' present_pages because they will be updated in
-	 * online_pages() and offline_pages().
-	 * TODO: should be in free_area_init_core_hotplug?
-	 */
-	reset_node_present_pages(pgdat);
-
 	return pgdat;
 }
 
--- a/mm/mm_init.c~mm-mm_initc-remove-reset_node_present_pages
+++ a/mm/mm_init.c
@@ -1509,6 +1509,8 @@ void __ref free_area_init_core_hotplug(s
 	pgdat->kswapd_order = 0;
 	pgdat->kswapd_highest_zoneidx = 0;
 	pgdat->node_start_pfn = 0;
+	pgdat->node_present_pages = 0;
+
 	for_each_online_cpu(cpu) {
 		struct per_cpu_nodestat *p;
 
@@ -1516,8 +1518,17 @@ void __ref free_area_init_core_hotplug(s
 		memset(p, 0, sizeof(*p));
 	}
 
-	for (z = 0; z < MAX_NR_ZONES; z++)
-		zone_init_internals(&pgdat->node_zones[z], z, nid, 0);
+	/*
+	 * When memory is hot-added, all the memory is in offline state. So
+	 * clear all zones' present_pages and managed_pages because they will
+	 * be updated in online_pages() and offline_pages().
+	 */
+	for (z = 0; z < MAX_NR_ZONES; z++) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		zone->present_pages = 0;
+		zone_init_internals(zone, z, nid, 0);
+	}
 }
 #endif
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch

