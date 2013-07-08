From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:29 -0700
Message-ID: <51db11ed.no91a5LVPQ5FqWWL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:29 -0700


The patch titled
     Subject: mm/page_alloc: rename setup_pagelist_highmark() to match naming of pageset_set_batch()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: rename setup_pagelist_highmark() to match naming of pageset_set_batch()

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch
+++ a/mm/page_alloc.c
@@ -4065,7 +4065,7 @@ static void pageset_update(struct per_cp
 	pcp->batch = batch;
 }
 
-/* a companion to setup_pagelist_highmark() */
+/* a companion to pageset_set_high() */
 static void pageset_set_batch(struct per_cpu_pageset *p, unsigned long batch)
 {
 	pageset_update(&p->pcp, 6 * batch, max(1UL, 1 * batch));
@@ -4091,10 +4091,10 @@ static void setup_pageset(struct per_cpu
 }
 
 /*
- * setup_pagelist_highmark() sets the high water mark for hot per_cpu_pagelist
+ * pageset_set_high() sets the high water mark for hot per_cpu_pagelist
  * to the value high for the pageset p.
  */
-static void setup_pagelist_highmark(struct per_cpu_pageset *p,
+static void pageset_set_high(struct per_cpu_pageset *p,
 				unsigned long high)
 {
 	unsigned long batch = max(1UL, high / 4);
@@ -4110,7 +4110,7 @@ static void __meminit zone_pageset_init(
 
 	pageset_init(pcp);
 	if (percpu_pagelist_fraction)
-		setup_pagelist_highmark(pcp,
+		pageset_set_high(pcp,
 			(zone->managed_pages /
 				percpu_pagelist_fraction));
 	else
@@ -5599,8 +5599,8 @@ int percpu_pagelist_fraction_sysctl_hand
 		unsigned long  high;
 		high = zone->managed_pages / percpu_pagelist_fraction;
 		for_each_possible_cpu(cpu)
-			setup_pagelist_highmark(
-					per_cpu_ptr(zone->pageset, cpu), high);
+			pageset_set_high(per_cpu_ptr(zone->pageset, cpu),
+					 high);
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

