Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8E8C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CB021D7F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sDyAtrqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgKLX5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgKLX5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:57:12 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16FF121D79;
        Thu, 12 Nov 2020 23:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225431;
        bh=sPoFooY9YRwAkXOP3+oIEDDvL7bdZ/eqmSfU75775DE=;
        h=Date:From:To:Subject:From;
        b=sDyAtrqn5jH0Jr2+7YJ0T8mXnyvdjz7+8FNJMSr2GL7a8FingOgkbiNLPnO1S68Cb
         mEx9IRi5rnd4Tt4Z5rKZu0b7VGWg2KDPY6TnlL8mItvmp5xiE/DT6CvPuSdt8saymO
         L4l0ZCMWcjb1UdR081/99jZf38OccvljAjZh0Zdc=
Date:   Thu, 12 Nov 2020 15:57:10 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pankaj.gupta@cloud.ionos.com, vbabka@suse.cz
Subject:  +
 mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch added to
 -mm tree
Message-ID: <20201112235710.BJ-gFQ2oG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: calculate pageset high and batch once per zone
has been added to the -mm tree.  Its filename is
     mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -6301,13 +6301,14 @@ static void setup_pageset(struct per_cpu
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
@@ -6319,23 +6320,25 @@ static void pageset_set_high_and_batch(s
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
@@ -8069,15 +8072,6 @@ int lowmem_reserve_ratio_sysctl_handler(
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
@@ -8110,7 +8104,7 @@ int percpu_pagelist_fraction_sysctl_hand
 		goto out;
 
 	for_each_populated_zone(zone)
-		__zone_pcp_update(zone);
+		zone_set_pageset_high_and_batch(zone);
 out:
 	mutex_unlock(&pcp_batch_high_lock);
 	return ret;
@@ -8717,7 +8711,7 @@ EXPORT_SYMBOL(free_contig_range);
 void __meminit zone_pcp_update(struct zone *zone)
 {
 	mutex_lock(&pcp_batch_high_lock);
-	__zone_pcp_update(zone);
+	zone_set_pageset_high_and_batch(zone);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch

