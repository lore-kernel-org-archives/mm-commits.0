Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39C6C3526A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2B322D6F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgLOX7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728219AbgLOXXa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:30 -0500
Date:   Tue, 15 Dec 2020 15:21:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074492;
        bh=zscuzgoyhhcRWjRoflhYmWYqj7uc0ErjZEOml9tweqc=;
        h=From:To:Subject:From;
        b=JM+f9V0Ye6fsdBKisSgiOhwfBWM58HpXjQ7c1rin8zSrQIJDNiZFdYUani1/2iqmC
         zzzxy8AeHa39B7SseKpBUiVx7q2F1l+4CvOR8bs3N53CSyl9D+26R49AfuqqIE/ex0
         /ImhKRpoRBkgqwYuRi/d3iQrCHRMXNnDH00pOcyE=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pankaj.gupta@cloud.ionos.com, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch removed
 from -mm tree
Message-ID: <20201215232131.vxPahHJ_I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: calculate pageset high and batch once per zone
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: calculate pageset high and batch once per zone

We currently call pageset_set_high_and_batch() for each possible cpu,
which repeats the same calculations of high and batch values.

Instead call the function just once per zone, and make it apply the
calculated values to all per-cpu pagesets of the zone.

This also allows removing the zone_pageset_init() and __zone_pcp_update()
wrappers.

No functional change.

Link: https://lkml.kernel.org/r/20201111092812.11329-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone
+++ a/mm/page_alloc.c
@@ -6315,13 +6315,14 @@ static void setup_pageset(struct per_cpu
 }
 
 /*
- * Calculate and set new high and batch values for given per-cpu pageset of a
+ * Calculate and set new high and batch values for all per-cpu pagesets of a
  * zone, based on the zone's size and the percpu_pagelist_fraction sysctl.
  */
-static void pageset_set_high_and_batch(struct zone *zone,
-				       struct per_cpu_pageset *p)
+static void zone_set_pageset_high_and_batch(struct zone *zone)
 {
 	unsigned long new_high, new_batch;
+	struct per_cpu_pageset *p;
+	int cpu;
 
 	if (percpu_pagelist_fraction) {
 		new_high = zone_managed_pages(zone) / percpu_pagelist_fraction;
@@ -6333,23 +6334,25 @@ static void pageset_set_high_and_batch(s
 		new_high = 6 * new_batch;
 		new_batch = max(1UL, 1 * new_batch);
 	}
-	pageset_update(&p->pcp, new_high, new_batch);
-}
-
-static void __meminit zone_pageset_init(struct zone *zone, int cpu)
-{
-	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
 
-	pageset_init(pcp);
-	pageset_set_high_and_batch(zone, pcp);
+	for_each_possible_cpu(cpu) {
+		p = per_cpu_ptr(zone->pageset, cpu);
+		pageset_update(&p->pcp, new_high, new_batch);
+	}
 }
 
 void __meminit setup_zone_pageset(struct zone *zone)
 {
+	struct per_cpu_pageset *p;
 	int cpu;
+
 	zone->pageset = alloc_percpu(struct per_cpu_pageset);
-	for_each_possible_cpu(cpu)
-		zone_pageset_init(zone, cpu);
+	for_each_possible_cpu(cpu) {
+		p = per_cpu_ptr(zone->pageset, cpu);
+		pageset_init(p);
+	}
+
+	zone_set_pageset_high_and_batch(zone);
 }
 
 /*
@@ -8083,15 +8086,6 @@ int lowmem_reserve_ratio_sysctl_handler(
 	return 0;
 }
 
-static void __zone_pcp_update(struct zone *zone)
-{
-	unsigned int cpu;
-
-	for_each_possible_cpu(cpu)
-		pageset_set_high_and_batch(zone,
-				per_cpu_ptr(zone->pageset, cpu));
-}
-
 /*
  * percpu_pagelist_fraction - changes the pcp->high for each zone on each
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu
@@ -8124,7 +8118,7 @@ int percpu_pagelist_fraction_sysctl_hand
 		goto out;
 
 	for_each_populated_zone(zone)
-		__zone_pcp_update(zone);
+		zone_set_pageset_high_and_batch(zone);
 out:
 	mutex_unlock(&pcp_batch_high_lock);
 	return ret;
@@ -8731,7 +8725,7 @@ EXPORT_SYMBOL(free_contig_range);
 void __meminit zone_pcp_update(struct zone *zone)
 {
 	mutex_lock(&pcp_batch_high_lock);
-	__zone_pcp_update(zone);
+	zone_set_pageset_high_and_batch(zone);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are


