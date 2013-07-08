From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:24:27 -0700
Message-ID: <51db11eb.FFElt2zX0O/SBZD0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:27 -0700


The patch titled
     Subject: mm/page_alloc: in zone_pcp_update(), uze zone_pageset_init()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: in zone_pcp_update(), uze zone_pageset_init()

Previously, zone_pcp_update() called pageset_set_batch() directly,
essentially assuming that percpu_pagelist_fraction == 0.  Correct this by
calling zone_pageset_init(), which chooses the appropriate ->batch and
->high calculations.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init
+++ a/mm/page_alloc.c
@@ -6098,11 +6098,9 @@ void free_contig_range(unsigned long pfn
 void __meminit zone_pcp_update(struct zone *zone)
 {
 	unsigned cpu;
-	unsigned long batch;
 	mutex_lock(&pcp_batch_high_lock);
-	batch = zone_batchsize(zone);
 	for_each_possible_cpu(cpu)
-		pageset_set_batch(per_cpu_ptr(zone->pageset, cpu), batch);
+		zone_pageset_init(zone, cpu);
 	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

