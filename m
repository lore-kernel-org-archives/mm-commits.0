Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03034C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 22:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiAaWTA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 17:19:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37880 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiAaWTA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 17:19:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0193D615B0
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 22:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7400C340E8;
        Mon, 31 Jan 2022 22:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643667539;
        bh=qDOENqs8wbwf4PJV/Uqbt3solK6j+reXU/Uhn29j/Eo=;
        h=Date:To:From:Subject:From;
        b=t+EUL2CvXLs2uhmU2BeUwep/4+la1rp00YJpniWNPTcjO+NRVFyC0wvAL1uW/FhRI
         SNlXolrS0TVnih7/fQ9GEpt3ic17u/8Mt14Nsjj8goUCTbAWm1cx7136uLBd5KowZv
         DRMNdz6jNkcpe0r3c1bIM218D+JM/lm4pO6lWDnA=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 14:18:57 -0800
Date:   Mon, 31 Jan 2022 14:18:57 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@gmail.com, raquini@redhat.com, osalvador@suse.de,
        npache@redhat.com, eric.dumazet@gmail.com, dennis@kernel.org,
        david@redhat.com, cl@linux.com, amakhalov@vmware.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-free_area_init_node-aware-of-memory-less-nodes.patch added to -mm tree
Message-Id: <20220131221857.E7400C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make free_area_init_node aware of memory less nodes
has been added to the -mm tree.  Its filename is
     mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-free_area_init_node-aware-of-memory-less-nodes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7727,9 +7727,14 @@ static void __init free_area_init_node(i
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

mm-memory_hotplug-make-arch_alloc_nodedata-independent-on-config_memory_hotplug.patch
mm-handle-uninitialized-numa-nodes-gracefully.patch
mm-memory_hotplug-drop-arch_free_nodedata.patch
mm-memory_hotplug-reorganize-new-pgdat-initialization.patch
mm-make-free_area_init_node-aware-of-memory-less-nodes.patch

