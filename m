From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:17 -0700
Message-ID: <51db11e1.kercSgWzHUjOqDdD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3GHTYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:17 -0700


The patch titled
     Subject: mm/page_alloc: convert zone_pcp_update() to rely on memory barriers instead of stop_machine()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: convert zone_pcp_update() to rely on memory barriers instead of stop_machine()

zone_pcp_update()'s goal is to adjust the ->high and ->mark members of a
percpu pageset based on a zone's ->managed_pages.  We don't need to drain
the entire percpu pageset just to modify these fields.

This lets us avoid calling setup_pageset() (and the draining required to
call it) and instead allows simply setting the fields' values (with some
attention paid to memory barriers to prevent the relationship between
->batch and ->high from being thrown off).

This does change the behavior of zone_pcp_update() as the percpu pagesets
will not be drained when zone_pcp_update() is called (they will end up
being shrunk, not completely drained, later when a 0-order page is freed
in free_hot_cold_page()).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine
+++ a/mm/page_alloc.c
@@ -6085,33 +6085,18 @@ void free_contig_range(unsigned long pfn
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-static int __meminit __zone_pcp_update(void *data)
-{
-	struct zone *zone = data;
-	int cpu;
-	unsigned long batch = zone_batchsize(zone), flags;
-
-	for_each_possible_cpu(cpu) {
-		struct per_cpu_pageset *pset;
-		struct per_cpu_pages *pcp;
-
-		pset = per_cpu_ptr(zone->pageset, cpu);
-		pcp = &pset->pcp;
-
-		local_irq_save(flags);
-		if (pcp->count > 0)
-			free_pcppages_bulk(zone, pcp->count, pcp);
-		drain_zonestat(zone, pset);
-		setup_pageset(pset, batch);
-		local_irq_restore(flags);
-	}
-	return 0;
-}
-
+/*
+ * The zone indicated has a new number of managed_pages; batch sizes and percpu
+ * page high values need to be recalulated.
+ */
 void __meminit zone_pcp_update(struct zone *zone)
 {
+	unsigned cpu;
+	unsigned long batch;
 	mutex_lock(&pcp_batch_high_lock);
-	stop_machine(__zone_pcp_update, zone, NULL);
+	batch = zone_batchsize(zone);
+	for_each_possible_cpu(cpu)
+		pageset_set_batch(per_cpu_ptr(zone->pageset, cpu), batch);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

