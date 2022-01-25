Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3615EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387047AbiAYDqe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378529AbiAYC2L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 21:28:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D851C094264
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 16:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F886134C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 00:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C800C340ED;
        Tue, 25 Jan 2022 00:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643069863;
        bh=5401A3sin24rz1XIiGr+zftCWtHYs1gzUEcCkF+Br6k=;
        h=Date:From:To:Subject:From;
        b=XUtJjTeSV2F2dCrKfbA54y/bfJQfCwmt/EHkxuB+okXZVN+s6FF2L+thAu9DYNqau
         0kkwqah2+Wy9U1osO0ae+2DktKy+8FOOWvHC1ADlBvw5jnlVUCfNrHZqrVRfc/Vujo
         8ppOQODWSXwD5egd0JMwMbiAK2v+KIjHluUlIyz8=
Date:   Mon, 24 Jan 2022 16:17:42 -0800
From:   akpm@linux-foundation.org
To:     kamezawa.hiroyu@jp.fujitsu.com, krupa.ramakrishnan@amd.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, rientjes@google.com
Subject:  +
 mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
 added to -mm tree
Message-ID: <20220125001742.EfykzBG6a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: adding same penalty is enough to get round-robin order
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch

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
Subject: mm/page_alloc: adding same penalty is enough to get round-robin order

To make node order in round-robin in the same distance group, we add a
penalty to the first node we got in each round.

To get a round-robin order in the same distance group, we don't need to
decrease the penalty since:

  * find_next_best_node() always iterates node in the same order
  * distance matters more then penalty in find_next_best_node()
  * in nodes with the same distance, the first one would be picked up

So it is fine to increase same penalty when we get the first node in the
same distance group.

Link: https://lkml.kernel.org/r/20220123013537.20491-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order
+++ a/mm/page_alloc.c
@@ -6319,13 +6319,12 @@ static void build_thisnode_zonelists(pg_
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
@@ -6337,11 +6336,10 @@ static void build_zonelists(pg_data_t *p
 		 */
 		if (node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
-			node_load[node] += load;
+			node_load[node] += nr_online_nodes;
 
 		node_order[nr_nodes++] = node;
 		prev_node = node;
-		load--;
 	}
 
 	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page-mapping-folio-mapping-should-have-the-same-offset.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch

