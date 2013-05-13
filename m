From: akpm@linux-foundation.org
Subject: + mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:51 -0700
Message-ID: <20130513211151.E2ED65A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:61000 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3EMVLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:11:53 -0400
Received: by mail-ve0-f202.google.com with SMTP id 14so252012vea.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:11:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: convert zone_pcp_update() to rely on memory barriers instead of stop_machine()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch

