From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:11 -0700
Message-ID: <51db11db.J//xXTc4If+KbE27%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3GHTYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:11 -0700


The patch titled
     Subject: mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->high
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->high

Because we are going to rely upon a careful transision between old and new
->high and ->batch values using memory barriers and will remove
stop_machine(), we need to prevent multiple updaters from interweaving
their memory writes.

Add a simple mutex to protect both update loops.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high
+++ a/mm/page_alloc.c
@@ -65,6 +65,9 @@
 #include <asm/div64.h>
 #include "internal.h"
 
+/* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
+static DEFINE_MUTEX(pcp_batch_high_lock);
+
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
@@ -5557,6 +5560,8 @@ int percpu_pagelist_fraction_sysctl_hand
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (!write || (ret < 0))
 		return ret;
+
+	mutex_lock(&pcp_batch_high_lock);
 	for_each_populated_zone(zone) {
 		for_each_possible_cpu(cpu) {
 			unsigned long  high;
@@ -5565,6 +5570,7 @@ int percpu_pagelist_fraction_sysctl_hand
 				per_cpu_ptr(zone->pageset, cpu), high);
 		}
 	}
+	mutex_unlock(&pcp_batch_high_lock);
 	return 0;
 }
 
@@ -6078,7 +6084,9 @@ static int __meminit __zone_pcp_update(v
 
 void __meminit zone_pcp_update(struct zone *zone)
 {
+	mutex_lock(&pcp_batch_high_lock);
 	stop_machine(__zone_pcp_update, zone, NULL);
+	mutex_unlock(&pcp_batch_high_lock);
 }
 #endif
 
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

