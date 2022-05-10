Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A611DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiEJEPd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbiEJEOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5411FCC6
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F234AB817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8D9C385A6;
        Tue, 10 May 2022 04:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155852;
        bh=/40YuqPpXWfyv8jm0gbv1IHstteeY3saSFGW/Uw4Keg=;
        h=Date:To:From:Subject:From;
        b=boJN3MADJZzAdQbFZXV9nk0NYGBGnv+dEkJy57f88LlHHQlYrNK+8MNUMwrZmZObU
         zP6s83dEhOhKc5xhSbs/vZkAnAPUsENWWPEsAVm3svori6TwXEp7QQD5t7fncL/Et9
         NMFaiJGxEsTn7ki/Smeca/wOZV6yOAkM89YeAKo0=
Date:   Mon, 09 May 2022 21:10:52 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        osalvador@suse.de, mhocko@suse.com, krupa.ramakrishnan@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, david@redhat.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch removed from -mm tree
Message-Id: <20220510041052.9F8D9C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: adding same penalty is enough to get round-robin order
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: adding same penalty is enough to get round-robin order

To make node order in round-robin in the same distance group, we add a
penalty to the first node we got in each round.

To get a round-robin order in the same distance group, we don't need to
decrease the penalty since:

  * find_next_best_node() always iterates node in the same order
  * distance matters more then penalty in find_next_best_node()
  * in nodes with the same distance, the first one would be picked up

So it is fine to increase same penalty when we get the first node in the
same distance group.  Since we just increase a constance of 1 to node
penalty, it is not necessary to multiply MAX_NODE_LOAD for preference.

[richard.weiyang@gmail.com: remove remove MAX_NODE_LOAD, per Vlastimil]
  Link: https://lkml.kernel.org/r/20220412001319.7462-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20220123013537.20491-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
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

 mm/page_alloc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order
+++ a/mm/page_alloc.c
@@ -6171,7 +6171,6 @@ int numa_zonelist_order_handler(struct c
 }
 
 
-#define MAX_NODE_LOAD (nr_online_nodes)
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -6218,7 +6217,7 @@ int find_next_best_node(int node, nodema
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
-		val *= (MAX_NODE_LOAD*MAX_NUMNODES);
+		val *= MAX_NUMNODES;
 		val += node_load[n];
 
 		if (val < min_val) {
@@ -6284,13 +6283,12 @@ static void build_thisnode_zonelists(pg_
 static void build_zonelists(pg_data_t *pgdat)
 {
 	static int node_order[MAX_NUMNODES];
-	int node, load, nr_nodes = 0;
+	int node, nr_nodes = 0;
 	nodemask_t used_mask = NODE_MASK_NONE;
 	int local_node, prev_node;
 
 	/* NUMA-aware ordering of nodes */
 	local_node = pgdat->node_id;
-	load = nr_online_nodes;
 	prev_node = local_node;
 
 	memset(node_order, 0, sizeof(node_order));
@@ -6302,11 +6300,10 @@ static void build_zonelists(pg_data_t *p
 		 */
 		if (node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
-			node_load[node] += load;
+			node_load[node] += 1;
 
 		node_order[nr_nodes++] = node;
 		prev_node = node;
-		load--;
 	}
 
 	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration.patch
mm-vmscan-filter-empty-page_list-at-the-beginning.patch
mm-vmscan-not-use-numa_no_node-as-indicator-of-page-on-different-node.patch

