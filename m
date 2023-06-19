Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3899EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjFSXVN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjFSXUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE41E7E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A32D60F56
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740D3C433C0;
        Mon, 19 Jun 2023 23:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216841;
        bh=3fktQnW2Oq/eKE0JRfJV0290Mhm/9je4oRryDZ6SO4c=;
        h=Date:To:From:Subject:From;
        b=SipzLpmnpfAiRbUOS1OFx//NOyMIQhMMmZrbJVvrcgmmtBihpvPufOwHbnAIqSRbi
         y6qcrcRDTWoXoH1489JPdHiU7vKF9icSlis8N0N4W6IlG8FJLtMNp2KKUbzal0crdR
         COqpTUItx1F8VCDzgTv9SnhUq3yUWzhQ5lGub1mw=
Date:   Mon, 19 Jun 2023 16:20:40 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, mhocko@suse.com,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch removed from -mm tree
Message-Id: <20230619232041.740D3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: drop 'nid' parameter from check_for_memory()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: drop 'nid' parameter from check_for_memory()
Date: Wed, 7 Jun 2023 03:24:02 +0000

The node_id in pgdat has already been set in free_area_init_node(),
so use it internally instead of passing a redundant parameter.

Link: https://lkml.kernel.org/r/20230607032402.4679-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-drop-nid-parameter-from-check_for_memory
+++ a/mm/mm_init.c
@@ -1724,7 +1724,7 @@ static void __init free_area_init_node(i
 }
 
 /* Any regular or high memory on that node ? */
-static void check_for_memory(pg_data_t *pgdat, int nid)
+static void check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
@@ -1732,9 +1732,9 @@ static void check_for_memory(pg_data_t *
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (populated_zone(zone)) {
 			if (IS_ENABLED(CONFIG_HIGHMEM))
-				node_set_state(nid, N_HIGH_MEMORY);
+				node_set_state(pgdat->node_id, N_HIGH_MEMORY);
 			if (zone_type <= ZONE_NORMAL)
-				node_set_state(nid, N_NORMAL_MEMORY);
+				node_set_state(pgdat->node_id, N_NORMAL_MEMORY);
 			break;
 		}
 	}
@@ -1886,7 +1886,7 @@ void __init free_area_init(unsigned long
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
 			node_set_state(nid, N_MEMORY);
-		check_for_memory(pgdat, nid);
+		check_for_memory(pgdat);
 	}
 
 	memmap_init();
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-memcontrol-do-not-tweak-node-in-mem_cgroup_init.patch
selftests-cgroup-fix-unexpected-failure-on-test_memcg_sock.patch

