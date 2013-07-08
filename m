From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-dont-re-init-pageset-in-zone_pcp_update.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:24:31 -0700
Message-ID: <51db11ef.o+GJNUfJs8gazn8H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Valdis.Kletnieks@vt.edu, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-dont-re-init-pageset-in-zone_pcp_update.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,Valdis.Kletnieks@vt.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:31 -0700


The patch titled
     Subject: mm/page_alloc: don't re-init pageset in zone_pcp_update()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-re-init-pageset-in-zone_pcp_update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: don't re-init pageset in zone_pcp_update()

When memory hotplug is triggered, we call pageset_init() on
per-cpu-pagesets which both contain pages and are in use, causing both the
leakage of those pages and (potentially) bad behaviour if a page is
allocated from a pageset while it is being cleared.

Avoid this by factoring out pageset_set_high_and_batch() (which contains
all needed logic too set a pageset's ->high and ->batch inrespective of
system state) from zone_pageset_init() and using the new
pageset_set_high_and_batch() instead of zone_pageset_init() in
zone_pcp_update().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-re-init-pageset-in-zone_pcp_update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-re-init-pageset-in-zone_pcp_update
+++ a/mm/page_alloc.c
@@ -4104,11 +4104,9 @@ static void pageset_set_high(struct per_
 	pageset_update(&p->pcp, high, batch);
 }
 
-static void __meminit zone_pageset_init(struct zone *zone, int cpu)
+static void __meminit pageset_set_high_and_batch(struct zone *zone,
+		struct per_cpu_pageset *pcp)
 {
-	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
-
-	pageset_init(pcp);
 	if (percpu_pagelist_fraction)
 		pageset_set_high(pcp,
 			(zone->managed_pages /
@@ -4117,6 +4115,14 @@ static void __meminit zone_pageset_init(
 		pageset_set_batch(pcp, zone_batchsize(zone));
 }
 
+static void __meminit zone_pageset_init(struct zone *zone, int cpu)
+{
+	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
+
+	pageset_init(pcp);
+	pageset_set_high_and_batch(zone, pcp);
+}
+
 static void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
@@ -6100,7 +6106,8 @@ void __meminit zone_pcp_update(struct zo
 	unsigned cpu;
 	mutex_lock(&pcp_batch_high_lock);
 	for_each_possible_cpu(cpu)
-		zone_pageset_init(zone, cpu);
+		pageset_set_high_and_batch(zone,
+				per_cpu_ptr(zone->pageset, cpu));
 	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

