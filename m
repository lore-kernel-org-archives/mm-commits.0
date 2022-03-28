Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2EBC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiC1VMk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiC1VMj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:12:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997CF3B2A4
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44A0DB811A2
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6FCC340F0;
        Mon, 28 Mar 2022 21:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648501847;
        bh=M31X4eWbhBwCj+5rKK7dkJ1uLMCxOMAhrNjw9vnBEPc=;
        h=Date:To:From:Subject:From;
        b=ROx1r929iq2cfhusi8+oNceEJZLiYa9yZOXYWXgDBToSQhcXxJHYiYyafyNKBLSzk
         y9AKrsAWot2N0NAMltR8GXsqoJY595wkShJ9twAPmGYi0IyARHRk7QJKwfDYIp/sVY
         ixo6/fdR9dmbxz2yHfZEPmwzJkytBeITriowkdjA=
Date:   Mon, 28 Mar 2022 14:10:47 -0700
To:     mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.com,
        krupa.ramakrishnan@amd.com, kamezawa.hiroyu@jp.fujitsu.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-page_alloc-add-penalty-to-local_node.patch removed from -mm tree
Message-Id: <20220328211047.BE6FCC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add penalty to local_node
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-penalty-to-local_node.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: add penalty to local_node

Commit 54d032ced983 ("mm/page_alloc: use accumulated load when building
node fallback list") fixed a bug on zonelist order.  This made me think
about what would happen if we have a node system with the following
distance matrix.

   Node 0  1  2  3  4  5  6  7
   ----------------------------
   0    10 12 12 12 32 32 32 32
   1    12 10 12 12 32 32 32 32
   2    12 12 10 12 32 32 32 32
   3    12 12 12 10 32 32 32 32
   4    32 32 32 32 10 12 12 12
   5    32 32 32 32 12 10 12 12
   6    32 32 32 32 12 12 10 12
   7    32 32 32 32 12 12 12 10

Unfortunately for this case, the node fallback list gets built like this:

   Node Fallback list
   ---------------------
    0:   0  1  2  3  4  5  6  7
    1:   1  0  2  3  5  6  7  4
    2:   2  3  0  1  6  7  4  5
    3:   3  2  0  1  7  4  5  6
    4:   4  5  6  7  0  1  2  3
    5:   5  4  6  7  1  2  3  0
    6:   6  7  4  5  2  3  0  1
    7:   7  6  4  5  3  0  1  2

We found the order in diagonal block is not expected.  The reason is we
don't penaltize local node.

After penalizing local node, the node fallback list gets built like this:

   Node Fallback list
   ---------------------
   0:   0  1  2  3  4  5  6  7
   1:   1  2  3  0  5  6  7  4
   2:   2  3  0  1  6  7  4  5
   3:   3  0  1  2  7  4  5  6
   4:   4  5  6  7  0  1  2  3
   5:   5  6  7  4  1  2  3  0
   6:   6  7  4  5  2  3  0  1
   7:   7  4  5  6  3  0  1  2

Now the fallback list is in round-robin order.

I am not very familiar with the node distance pattern, while I tried the
following distance matrix.  Both of them works with this change.

   Node 0  1  2  3
   ----------------
   0    10 10 10 10
   1    10 10 10 10
   2    10 10 10 10
   3    10 10 10 10

   Node 0  1  2  3  4  5  6  7
   ----------------------------
   0    10 10 10 10 32 32 32 32
   1    10 10 10 10 32 32 32 32
   2    10 10 10 10 32 32 32 32
   3    10 10 10 10 32 32 32 32
   4    32 32 32 32 10 10 10 10
   5    32 32 32 32 10 10 10 10
   6    32 32 32 32 10 10 10 10
   7    32 32 32 32 10 10 10 10

Link: https://lkml.kernel.org/r/20220123013537.20491-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-penalty-to-local_node
+++ a/mm/page_alloc.c
@@ -6278,8 +6278,9 @@ static void build_zonelists(pg_data_t *p
 		 * So adding penalty to the first node in same
 		 * distance group to make it round-robin.
 		 */
-		if (node_distance(local_node, node) !=
-		    node_distance(local_node, prev_node))
+		if ((node_distance(local_node, node) !=
+		    node_distance(local_node, prev_node)) ||
+		    node == local_node)
 			node_load[node] += nr_online_nodes;
 
 		node_order[nr_nodes++] = node;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-vmscan-reclaim-only-affects-managed_zones.patch
mm-vmscan-make-sure-wakeup_kswapd-with-managed-zone.patch

