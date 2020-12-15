Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD24EC2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9854622D07
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgLOX7T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgLOXX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:28 -0500
Date:   Tue, 15 Dec 2020 15:21:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074489;
        bh=sFYnQX6Iam1i0mvHbB3OBE/irRdC+9desht5NNa3imw=;
        h=From:To:Subject:From;
        b=CzE1JjSkVXgR4SSGvLR2t5RlPWYxkmlJKb/CVgMVeNbwpGa+a2fZmCtixJZgxp4yt
         vQ5sbuv+Yq1qum34wv0eUsDEkSHw7kYNw5Eq7V6bhx46wTHihpASvrF/8sD6lb8iYT
         t2VsDYu4CKudHTJsR+zlXtRTW7U5kXWAbb9NijlM=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pankaj.gupta@cloud.ionos.com, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-clean-up-pageset-high-and-batch-update.patch removed from -mm
 tree
Message-ID: <20201215232128.28KWu24CA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: clean up pageset high and batch update
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clean-up-pageset-high-and-batch-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: clean up pageset high and batch update

Patch series "disable pcplists during memory offline", v3.

As per the discussions [1] [2] this is an attempt to implement David's
suggestion that page isolation should disable pcplists to avoid races with
page freeing in progress.  This is done without extra checks in fast
paths, as explained in Patch 9.  The repeated draining done by [2] is then
no longer needed.  Previous version (RFC) is at [3].

The RFC tried to hide pcplists disabling/enabling into page isolation, but
it wasn't completely possible, as memory offline does not unisolation. 
Michal suggested an explicit API in [4] so that's the current
implementation and it seems indeed nicer.

Once we accept that page isolation users need to do explicit actions
around it depending on the needed guarantees, we can also IMHO accept that
the current pcplist draining can be also done by the callers, which is
more effective.  After all, there are only two users of page isolation. 
So patch 6 does effectively the same thing as Pavel proposed in [5], and
patch 7 implement stronger guarantees only for memory offline.  If CMA
decides to opt-in to the stronger guarantee, it can be added later.

Patches 1-5 are preparatory cleanups for pcplist disabling.

Patchset was briefly tested in QEMU so that memory online/offline works,
but I haven't done a stress test that would prove the race fixed by [2] is
eliminated.

Note that patch 7 could be avoided if we instead adjusted page freeing in
shown in [6], but I believe the current implementation of disabling
pcplists is not too much complex, so I would prefer this instead of adding
new checks and longer irq-disabled section into page freeing hotpaths.

[1] https://lore.kernel.org/linux-mm/20200901124615.137200-1-pasha.tatashin@soleen.com/
[2] https://lore.kernel.org/linux-mm/20200903140032.380431-1-pasha.tatashin@soleen.com/
[3] https://lore.kernel.org/linux-mm/20200907163628.26495-1-vbabka@suse.cz/
[4] https://lore.kernel.org/linux-mm/20200909113647.GG7348@dhcp22.suse.cz/
[5] https://lore.kernel.org/linux-mm/20200904151448.100489-3-pasha.tatashin@soleen.com/
[6] https://lore.kernel.org/linux-mm/3d3b53db-aeaa-ff24-260b-36427fac9b1c@suse.cz/
[7] https://lore.kernel.org/linux-mm/20200922143712.12048-1-vbabka@suse.cz/
[8] https://lore.kernel.org/linux-mm/20201008114201.18824-1-vbabka@suse.cz/


This patch (of 7):

The updates to pcplists' high and batch values are handled by multiple
functions that make the calculations hard to follow.  Consolidate
everything to pageset_set_high_and_batch() and remove pageset_set_batch()
and pageset_set_high() wrappers.

The only special case using one of the removed wrappers was:
build_all_zonelists_init()

  setup_pageset()
    pageset_set_batch()

which was hardcoding batch as 0, so we can just open-code a call to
pageset_update() with constant parameters instead.

No functional change.

Link: https://lkml.kernel.org/r/20201111092812.11329-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20201111092812.11329-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   49 ++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clean-up-pageset-high-and-batch-update
+++ a/mm/page_alloc.c
@@ -5919,7 +5919,7 @@ static void build_zonelists(pg_data_t *p
  * not check if the processor is online before following the pageset pointer.
  * Other parts of the kernel may not check if the zone is available.
  */
-static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch);
+static void setup_pageset(struct per_cpu_pageset *p);
 static DEFINE_PER_CPU(struct per_cpu_pageset, boot_pageset);
 static DEFINE_PER_CPU(struct per_cpu_nodestat, boot_nodestats);
 
@@ -5987,7 +5987,7 @@ build_all_zonelists_init(void)
 	 * (a chicken-egg dilemma).
 	 */
 	for_each_possible_cpu(cpu)
-		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
+		setup_pageset(&per_cpu(boot_pageset, cpu));
 
 	mminit_verify_zonelist();
 	cpuset_init_current_mems_allowed();
@@ -6296,12 +6296,6 @@ static void pageset_update(struct per_cp
 	pcp->batch = batch;
 }
 
-/* a companion to pageset_set_high() */
-static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
-{
-	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
-}
-
 static void pageset_init(struct per_cpu_pageset *p)
 {
 	struct per_cpu_pages *pcp;
@@ -6314,35 +6308,32 @@ static void pageset_init(struct per_cpu_
 		INIT_LIST_HEAD(&pcp->lists[migratetype]);
 }
 
-static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)
+static void setup_pageset(struct per_cpu_pageset *p)
 {
 	pageset_init(p);
-	pageset_set_batch(p, batch);
+	pageset_update(&p->pcp, 0, 1);
 }
 
 /*
- * pageset_set_high() sets the high water mark for hot per_cpu_pagelist
- * to the value high for the pageset p.
+ * Calculate and set new high and batch values for given per-cpu pageset of a
+ * zone, based on the zone's size and the percpu_pagelist_fraction sysctl.
  */
-static void pageset_set_high(struct per_cpu_pageset *p,
-				unsigned long high)
-{
-	unsigned long batch = max(1UL, high / 4);
-	if ((high / 4) > (PAGE_SHIFT * 8))
-		batch = PAGE_SHIFT * 8;
-
-	pageset_update(&p->pcp, high, batch);
-}
-
 static void pageset_set_high_and_batch(struct zone *zone,
-				       struct per_cpu_pageset *pcp)
+				       struct per_cpu_pageset *p)
 {
-	if (percpu_pagelist_fraction)
-		pageset_set_high(pcp,
-			(zone_managed_pages(zone) /
-				percpu_pagelist_fraction));
-	else
-		pageset_set_batch(pcp, zone_batchsize(zone));
+	unsigned long new_high, new_batch;
+
+	if (percpu_pagelist_fraction) {
+		new_high = zone_managed_pages(zone) / percpu_pagelist_fraction;
+		new_batch = max(1UL, new_high / 4);
+		if ((new_high / 4) > (PAGE_SHIFT * 8))
+			new_batch = PAGE_SHIFT * 8;
+	} else {
+		new_batch = zone_batchsize(zone);
+		new_high = 6 * new_batch;
+		new_batch = max(1UL, 1 * new_batch);
+	}
+	pageset_update(&p->pcp, new_high, new_batch);
 }
 
 static void __meminit zone_pageset_init(struct zone *zone, int cpu)
_

Patches currently in -mm which might be from vbabka@suse.cz are


