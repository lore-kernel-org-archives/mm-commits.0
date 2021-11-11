Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 515AFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A236113B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhKKCqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCqu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9395161208;
        Thu, 11 Nov 2021 02:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598641;
        bh=oDKkPx1ds5PALp6YaPKy9BmN53tmcH79sO4jjaBCqLI=;
        h=Date:From:To:Subject:From;
        b=H5S5KSetLrSantfjtGRUixQkO0hTjv9f3QRYipPbJ1xL9b9qcoYzM3FCTiEdUKrvb
         mdM9BS2ocmerYZsjeULGBaRS912V6HLDTGceYbTMH4UJAREhfqGOmtNeddP1CB+CJf
         Uv5yWDhGBhwOfcMRyKeLNolq+CDZc0+BXMDmrBR8=
Date:   Wed, 10 Nov 2021 18:44:01 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bharata@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, krupa.ramakrishnan@amd.com,
        lee.schermerhorn@hp.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, Sadagopan.Srinivasan@amd.com
Subject:  [merged]
 mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch
 removed from -mm tree
Message-ID: <20211111024401.I-g-gOddb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use accumulated load when building node fallback list
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-accumulated-load-when-building-node-fallback-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Fixes: f0c0b2b808f2 ("change zonelist order: zonelist order selection logic")
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
@@ -6253,7 +6253,7 @@ static void build_zonelists(pg_data_t *p
 		 */
 		if (node_distance(local_node, node) !=
 		    node_distance(local_node, prev_node))
-			node_load[node] = load;
+			node_load[node] += load;
 
 		node_order[nr_nodes++] = node;
 		prev_node = node;
_

Patches currently in -mm which might be from krupa.ramakrishnan@amd.com are


