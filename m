From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:19 -0700
Message-ID: <51db11e3.qnVRDGfIIh4hvrrr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab3GHTYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:19 -0700


The patch titled
     Subject: mm/page_alloc: when handling percpu_pagelist_fraction, don't unneedly recalulate high
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: when handling percpu_pagelist_fraction, don't unneedly recalulate high

Simply moves calculation of the new 'high' value outside the
for_each_possible_cpu() loop, as it does not depend on the cpu.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high
+++ a/mm/page_alloc.c
@@ -5575,7 +5575,6 @@ int lowmem_reserve_ratio_sysctl_handler(
  * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
  * can have before it gets flushed back to buddy allocator.
  */
-
 int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
@@ -5589,12 +5588,11 @@ int percpu_pagelist_fraction_sysctl_hand
 
 	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
-		for_each_possible_cpu(cpu) {
-			unsigned long  high;
-			high = zone->managed_pages / percpu_pagelist_fraction;
+		unsigned long  high;
+		high = zone->managed_pages / percpu_pagelist_fraction;
+		for_each_possible_cpu(cpu)
 			setup_pagelist_highmark(
-				per_cpu_ptr(zone->pageset, cpu), high);
-		}
+					per_cpu_ptr(zone->pageset, cpu), high);
 	}
 	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

