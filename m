Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A76C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57999611C4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhKEUm7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233511AbhKEUm6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92CDC60FBF;
        Fri,  5 Nov 2021 20:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144818;
        bh=YU7hP/JtUSwR4tnYDgs1/WcSM6xX8jJ9zMNKGyU4QxA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BsSyeuLHuhGxXa30Bat/K9AXfoyuGu7PEORd+GOILNG7UGyixMqL0Xcs0AYs8MZ9Y
         1X6x2an9JtBgnDEAllOWgMRLFynOzf/84nIC3f5jLLsoyrn5atRhVCxioCjBmEsBIy
         JvqPh2RJpHJa4ckwRbnbOGvcVL2c2I87CAFQUHgI=
Date:   Fri, 05 Nov 2021 13:40:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        bharata@amd.com, kamezawa.hiroyu@jp.fujitsu.com,
        krupa.ramakrishnan@amd.com, lee.schermerhorn@hp.com,
        linux-mm@kvack.org, mgorman@suse.de, mm-commits@vger.kernel.org,
        Sadagopan.Srinivasan@amd.com, torvalds@linux-foundation.org
Subject:  [patch 108/262] mm/page_alloc: print node fallback order
Message-ID: <20211105204018.ngy5d_MGm%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
