Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3457DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiDLXTj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiDLXTb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290D28FE40
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A497461CBF
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED25DC385A5;
        Tue, 12 Apr 2022 21:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649800272;
        bh=f0RMdL4TvUF2MEVi7FWVs8oF5W4VhuTlfKERAdDc0rI=;
        h=Date:To:From:Subject:From;
        b=aPQTnULDrDs0rZRnYHVQyU6L3jPsfAQWBCu+KaXAhBUd5w6o3nHePcTXpPxh+CnnJ
         fDyLJK5kAKroJUTMgIOEW2p/xgTPMVAeYLIMRkoplOMj9o7XUyN6vA2GnrG25yCmJx
         /O3CnJ0gi1F0isyna5B7k9XJQLH5xlTWNmFnSGfs=
Date:   Tue, 12 Apr 2022 14:51:09 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        osalvador@suse.de, mhocko@suse.com, krupa.ramakrishnan@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, david@redhat.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch added to -mm tree
Message-Id: <20220412215111.ED25DC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch

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


--- a/mm/page_alloc.c~mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3
+++ a/mm/page_alloc.c
@@ -6182,7 +6182,6 @@ int numa_zonelist_order_handler(struct c
 }
 
 
-#define MAX_NODE_LOAD (nr_online_nodes)
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -6229,7 +6228,7 @@ int find_next_best_node(int node, nodema
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
-		val *= (MAX_NODE_LOAD*MAX_NUMNODES);
+		val *= MAX_NUMNODES;
 		val += node_load[n];
 
 		if (val < min_val) {
@@ -6312,7 +6311,7 @@ static void build_zonelists(pg_data_t *p
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
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order-v3.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone-v2.patch
mm-vmscan-sc-reclaim_idx-must-be-a-valid-zone-index.patch

