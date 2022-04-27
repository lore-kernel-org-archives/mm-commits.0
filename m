Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E00FC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 03:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357354AbiD0DKS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 23:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357386AbiD0DJM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 23:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E612FFD4
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:06:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F9661CA4
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 03:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331C9C385A4;
        Wed, 27 Apr 2022 03:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651028761;
        bh=RWVwxHBwoK6JHYie655buXqIWJHb7HRsAd9kPCIzhI0=;
        h=Date:To:From:Subject:From;
        b=MpgS5V6hyM1BpMliNLlOK2TeLRnR/MNi67fWK6Kxp/uMG5jsdwhxgwdR7AAmaL1zp
         zqF4/ToaBVx3euQgB1xaZrwRC4fJCA9ky8K0B9pJueRxoDlgEWQHGIB9Z24Hu0yeo/
         AC3aPcper31axa0JCg7m7/yAbo8g103187PTzCB0=
Date:   Tue, 26 Apr 2022 20:06:00 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        osalvador@suse.de, mhocko@suse.com, krupa.ramakrishnan@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, david@redhat.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch removed from -mm tree
Message-Id: <20220427030601.331C9C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch

This patch was dropped because it was folded into mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3

remove remove MAX_NODE_LOAD, per Vlastimil

Link: https://lkml.kernel.org/r/20220412001319.7462-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3
+++ a/mm/page_alloc.c
@@ -6173,7 +6173,6 @@ int numa_zonelist_order_handler(struct c
 }
 
 
-#define MAX_NODE_LOAD (nr_online_nodes)
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -6220,7 +6219,7 @@ int find_next_best_node(int node, nodema
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
-		val *= (MAX_NODE_LOAD*MAX_NUMNODES);
+		val *= MAX_NUMNODES;
 		val += node_load[n];
 
 		if (val < min_val) {
@@ -6303,7 +6302,7 @@ static void build_zonelists(pg_data_t *p
 		 */
 		if (node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
-			node_load[node] += nr_online_nodes;
+			node_load[node] += 1;
 
 		node_order[nr_nodes++] = node;
 		prev_node = node;
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
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch

