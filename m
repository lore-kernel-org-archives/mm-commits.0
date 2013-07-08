From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:25 -0700
Message-ID: <51db11e9.LpuBazRJvq+0IrEw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:25 -0700


The patch titled
     Subject: mm/page_alloc: factor zone_pageset_init() out of setup_zone_pageset()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: factor zone_pageset_init() out of setup_zone_pageset()

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset
+++ a/mm/page_alloc.c
@@ -4104,22 +4104,25 @@ static void setup_pagelist_highmark(stru
 	pageset_update(&p->pcp, high, batch);
 }
 
+static void __meminit zone_pageset_init(struct zone *zone, int cpu)
+{
+	struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
+
+	pageset_init(pcp);
+	if (percpu_pagelist_fraction)
+		setup_pagelist_highmark(pcp,
+			(zone->managed_pages /
+				percpu_pagelist_fraction));
+	else
+		pageset_set_batch(pcp, zone_batchsize(zone));
+}
+
 static void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
-
 	zone->pageset = alloc_percpu(struct per_cpu_pageset);
-
-	for_each_possible_cpu(cpu) {
-		struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
-
-		setup_pageset(pcp, zone_batchsize(zone));
