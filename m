Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CCAC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B977261208
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhKKCqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhKKCqs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F86D6113B;
        Thu, 11 Nov 2021 02:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598639;
        bh=2PJ32dL5mmRBH/7yup1n5bjptL8Qp+9cucZxOioch6M=;
        h=Date:From:To:Subject:From;
        b=Wg/lF1gH61U8RGuGkL5CAXKYBPID/VYWs1X4T0T4tOGG9AEp+X9xcdIRlp+Nw5Y+N
         alGHyhrNq39VuLsKbOMl0qkdTLK8gke+YB/gS/6hRs6XLWnSxe0yWAe4GWIthnAFWU
         ownxCpSN9mdAIQny+HEu7DIaf9LhyUZp44W2N/c4=
Date:   Wed, 10 Nov 2021 18:43:59 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bharata@amd.com,
        kamezawa.hiroyu@jp.fujitsu.com, krupa.ramakrishnan@amd.com,
        lee.schermerhorn@hp.com, mgorman@suse.de,
        mm-commits@vger.kernel.org, Sadagopan.Srinivasan@amd.com
Subject:  [merged] mm-page_alloc-print-node-fallback-order.patch
 removed from -mm tree
Message-ID: <20211111024359.kbF_k5GEI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: print node fallback order
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-print-node-fallback-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bharata B Rao <bharata@amd.com>
Subject: mm/page_alloc: print node fallback order

Patch series "Fix NUMA nodes fallback list ordering".

For a NUMA system that has multiple nodes at same distance from other
nodes, the fallback list generation prefers same node order for them
instead of round-robin thereby penalizing one node over others.  This
series fixes it.

More description of the problem and the fix is present in the patch
description.


This patch (of 2):

Print information message about the allocation fallback order for each
NUMA node during boot.

No functional changes here.  This makes it easier to illustrate the
problem in the node fallback list generation, which the next patch fixes.

Link: https://lkml.kernel.org/r/20210830121603.1081-1-bharata@amd.com
Link: https://lkml.kernel.org/r/20210830121603.1081-2-bharata@amd.com
Signed-off-by: Bharata B Rao <bharata@amd.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Krupa Ramakrishnan <krupa.ramakrishnan@amd.com>
Cc: Sadagopan Srinivasan <Sadagopan.Srinivasan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-print-node-fallback-order
+++ a/mm/page_alloc.c
@@ -6262,6 +6262,10 @@ static void build_zonelists(pg_data_t *p
 
 	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
 	build_thisnode_zonelists(pgdat);
+	pr_info("Fallback order for Node %d: ", local_node);
+	for (node = 0; node < nr_nodes; node++)
+		pr_cont("%d ", node_order[node]);
+	pr_cont("\n");
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
_

Patches currently in -mm which might be from bharata@amd.com are


