Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1EDC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F0D61185
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 03:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhIPDst (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232541AbhIPDst (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 23:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1232A6112E;
        Thu, 16 Sep 2021 03:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631764049;
        bh=0RBM9UK6G4jktLPRZP5U0NV1NCThF1wwMcv03qhAHjM=;
        h=Date:From:To:Subject:From;
        b=avb9vc2FZfPa2tN1hGfihfva0FfllaZykN72v06n0zWK6Z/2QLZFWoYnopwAP1CuO
         dh6ytVD5k9FVse484KCndCN6NcVobC3vEWWh5ZE0iQma3QE/CWr1YkUsljRCjIdywA
         8GNGP0u/l+63/HPaGI9sp3QSkE/8RosWBvjfaEYI=
Date:   Wed, 15 Sep 2021 20:47:28 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bharata@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, krupa.ramakrishnan@amd.com,
        lee.schermerhorn@hp.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, Sadagopan.Srinivasan@amd.com
Subject:  +
 mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch
 added to -mm tree
Message-ID: <20210916034728.bCSOeep4I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use accumulated load when building node fallback list
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Subject: mm/page_alloc: use accumulated load when building node fallback list

In build_zonelists(), when the fallback list is built for the nodes, the
node load gets reinitialized during each iteration.  This results in nodes
with same distances occupying the same slot in different node fallback
lists rather than appearing in the intended round- robin manner.  This
results in one node getting picked for allocation more compared to other
nodes with the same distance.

As an example, consider a 4 node system with the following distance
matrix.

Node 0  1  2  3
----------------
0    10 12 32 32
1    12 10 32 32
2    32 32 10 12
3    32 32 12 10

For this case, the node fallback list gets built like this:

Node	Fallback list
---------------------
0	0 1 2 3
1	1 0 3 2
2	2 3 0 1
3	3 2 0 1 <-- Unexpected fallback order

In the fallback list for nodes 2 and 3, the nodes 0 and 1 appear in the
same order which results in more allocations getting satisfied from node 0
compared to node 1.

The effect of this on remote memory bandwidth as seen by stream benchmark
is shown below:

Case 1: Bandwidth from cores on nodes 2 & 3 to memory on nodes 0 & 1
	(numactl -m 0,1 ./stream_lowOverhead ... --cores <from 2, 3>)
Case 2: Bandwidth from cores on nodes 0 & 1 to memory on nodes 2 & 3
	(numactl -m 2,3 ./stream_lowOverhead ... --cores <from 0, 1>)

----------------------------------------
		BANDWIDTH (MB/s)
    TEST	Case 1		Case 2
----------------------------------------
    COPY	57479.6		110791.8
   SCALE	55372.9		105685.9
     ADD	50460.6		96734.2
  TRIADD	50397.6		97119.1
----------------------------------------

The bandwidth drop in Case 1 occurs because most of the allocations get
satisfied by node 0 as it appears first in the fallback order for both
nodes 2 and 3.

This can be fixed by accumulating the node load in build_zonelists()
rather than reinitializing it during each iteration.  With this the nodes
with the same distance rightly get assigned in the round robin manner.  In
fact this was how it was originally until the commit f0c0b2b808f2 ("change
zonelist order: zonelist order selection logic") dropped the load
accumulation and resorted to initializing the load during each iteration. 
While zonelist ordering was removed by commit c9bff3eebc09 ("mm,
page_alloc: rip out ZONELIST_ORDER_ZONE"), the change to the node load
accumulation in build_zonelists() remained.  So essentially this patch
reverts back to the accumulated node load logic.

After this fix, the fallback order gets built like this:

Node Fallback list
------------------
0    0 1 2 3
1    1 0 3 2
2    2 3 0 1
3    3 2 1 0 <-- Note the change here

The bandwidth in Case 1 improves and matches Case 2 as shown below.

----------------------------------------
		BANDWIDTH (MB/s)
    TEST	Case 1		Case 2
----------------------------------------
    COPY	110438.9	110107.2
   SCALE	105930.5	105817.5
     ADD	97005.1		96159.8
  TRIADD	97441.5		96757.1
----------------------------------------

The correctness of the fallback list generation has been verified for the
above node configuration where the node 3 starts as memory-less node and
comes up online only during memory hotplug.

[bharata@amd.com: Added changelog, review, test validation]
Link: https://lkml.kernel.org/r/20210830121603.1081-3-bharata@amd.com
Fixes: f0c0b2b808f2 ("change zonelist order: zonelist order selection
logic")
Signed-off-by: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Co-developed-by: Sadagopan Srinivasan <Sadagopan.Srinivasan@amd.com>
Signed-off-by: Sadagopan Srinivasan <Sadagopan.Srinivasan@amd.com>
Signed-off-by: Bharata B Rao <bharata@amd.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-accumulated-load-when-building-node-fallback-list
+++ a/mm/page_alloc.c
@@ -6247,7 +6247,7 @@ static void build_zonelists(pg_data_t *p
 		 */
 		if (node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
-			node_load[node] = load;
+			node_load[node] += load;
 
 		node_order[nr_nodes++] = node;
 		prev_node = node;
_

Patches currently in -mm which might be from krupa.ramakrishnan@amd.com are

mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch

