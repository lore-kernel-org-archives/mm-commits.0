Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805C4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiCVVsy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbiCVVsf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3685FF16
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF023B81DC7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7C7C340EE;
        Tue, 22 Mar 2022 21:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985624;
        bh=urddp+u7qEoMilszfxvuCzWkSMvo7mc65sO3QUuIc0s=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=kg/qReqmk0Kqs0dCFx+uZXRs6w2HeRNgNTdULm1IKUUj/mYfAFSafchKl4VvQsMvt
         uVTmnuW3ZD94HZF7apZ0S0kuV/d+uzntkEkgZ6uUUP3hKbXzfpUnkKn3BoaR0OdP5z
         QA8xjy4G6sX6VIJY+wgRSL+f1YncFdal7eVABBig=
Date:   Tue, 22 Mar 2022 14:47:03 -0700
To:     tj@kernel.org, rppt@linux.ibm.com, richard.weiyang@gmail.com,
        raquini@redhat.com, osalvador@suse.de, npache@redhat.com,
        eric.dumazet@gmail.com, dennis@kernel.org, david@redhat.com,
        cl@linux.com, amakhalov@vmware.com, mhocko@suse.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 168/227] mm: make free_area_init_node aware of memory less nodes
Message-Id: <20220322214704.4F7C7C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm: make free_area_init_node aware of memory less nodes

free_area_init_node is also called from memory less node initialization
path (free_area_init_memoryless_node).  It doesn't really make much sense
to display the physical memory range for those nodes: Initmem setup node
XX [mem 0x0000000000000000-0x0000000000000000]

Instead be explicit that the node is memoryless: Initmem setup node XX as
memoryless

Link: https://lkml.kernel.org/r/20220127085305.20890-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-make-free_area_init_node-aware-of-memory-less-nodes
+++ a/mm/page_alloc.c
@@ -7642,9 +7642,14 @@ static void __init free_area_init_node(i
 	pgdat->node_start_pfn = start_pfn;
 	pgdat->per_cpu_nodestats = NULL;
 
-	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-		(u64)start_pfn << PAGE_SHIFT,
-		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+	if (start_pfn != end_pfn) {
+		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
+			(u64)start_pfn << PAGE_SHIFT,
+			end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+	} else {
+		pr_info("Initmem setup node %d as memoryless\n", nid);
+	}
+
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn);
 
 	alloc_node_mem_map(pgdat);
_
