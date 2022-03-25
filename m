Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DBCC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356813AbiCYBfe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357452AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1653BF97D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3881A60909
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E4DC340EC;
        Fri, 25 Mar 2022 01:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171958;
        bh=fsYi+1TeJ8FO9bhL2ZQIFPiKKghD6g8Tbv9gpx3Qtso=;
        h=Date:To:From:Subject:From;
        b=xJCRvao5QT4uja5FeSgKQIxGfWkdIyzpXVtV2ExnWR3NgxprmBHV/gOUoqmfR/63E
         mz+z1s7SqTY7LhiVANQ1XELgnd3+61NtCsfoFIdMEtkDoZQY4l2UGbuItoVstiDJuY
         atn6Pq68c/j92IffkNgkegJ48F8LPQUoGfAzBtmM=
Date:   Thu, 24 Mar 2022 18:32:38 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-make-free_area_init_node-aware-of-memory-less-nodes.patch removed from -mm tree
Message-Id: <20220325013238.92E4DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make free_area_init_node aware of memory less nodes
has been removed from the -mm tree.  Its filename was
     mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are


