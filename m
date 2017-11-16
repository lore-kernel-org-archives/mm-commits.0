From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 17:12:48 -0800
Message-ID: <5a0ce610.NXv36uHFcs45brrl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932838AbdKPBMu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:12:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mhocko@suse.com, osalvador@techadventures.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix
has been removed from the -mm tree.  Its filename was
     mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

This patch was dropped because it was folded into mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix

clean up the printk while we're there

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@techadventures.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix
+++ a/mm/page_alloc.c
@@ -6178,9 +6178,9 @@ static void __ref alloc_node_mem_map(str
 							       pgdat->node_id);
 		pgdat->node_mem_map = map + offset;
 	}
-	printk(KERN_DEBUG "alloc_node_mem_map: node %d, pgdat %08lx, node_mem_map %08lx\n",
-							pgdat->node_id, (unsigned long)pgdat,
-							(unsigned long)pgdat->node_mem_map);
+	pr_debug("%s: node %d, pgdat %08lx, node_mem_map %08lx\n",
+				__func__, pgdat->node_id, (unsigned long)pgdat,
+				(unsigned long)pgdat->node_mem_map);
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	/*
 	 * With no DISCONTIG, the global mem_map is just set as node 0's
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch

