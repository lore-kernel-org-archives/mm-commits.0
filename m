From: akpm@linux-foundation.org
Subject: + memory-hotplug-update-zone-pcp-at-memory-online.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:49:49 -0700
Message-ID: <200906291949.n5TJno8X028680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbZF2Tuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com


The patch titled
     memory hotplug: update zone pcp at memory online
has been added to the -mm tree.  Its filename is
     memory-hotplug-update-zone-pcp-at-memory-online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: update zone pcp at memory online
From: Shaohua Li <shaohua.li@intel.com>

In my test, 128M memory is hot added, but zone's pcp batch is 0, which is
an obvious error.  When pages are onlined, zone pcp should be updated
accordingly.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yakui Zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 ++
 mm/memory_hotplug.c |    1 +
 mm/page_alloc.c     |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff -puN include/linux/mm.h~memory-hotplug-update-zone-pcp-at-memory-online include/linux/mm.h
--- a/include/linux/mm.h~memory-hotplug-update-zone-pcp-at-memory-online
+++ a/include/linux/mm.h
@@ -1073,6 +1073,8 @@ extern void setup_per_cpu_pageset(void);
 static inline void setup_per_cpu_pageset(void) {}
 #endif
 
+extern void zone_pcp_update(struct zone *zone);
+
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 
diff -puN mm/memory_hotplug.c~memory-hotplug-update-zone-pcp-at-memory-online mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-update-zone-pcp-at-memory-online
+++ a/mm/memory_hotplug.c
@@ -422,6 +422,7 @@ int online_pages(unsigned long pfn, unsi
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
+	zone_pcp_update(zone);
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);
 	if (onlined_pages) {
diff -puN mm/page_alloc.c~memory-hotplug-update-zone-pcp-at-memory-online mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-update-zone-pcp-at-memory-online
+++ a/mm/page_alloc.c
@@ -3135,6 +3135,31 @@ int zone_wait_table_init(struct zone *zo
 	return 0;
 }
 
+static int __zone_pcp_update(void *data)
+{
+	struct zone *zone = data;
+	int cpu;
+	unsigned long batch = zone_batchsize(zone), flags;
+
+	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		struct per_cpu_pageset *pset;
+		struct per_cpu_pages *pcp;
+
+		pset = zone_pcp(zone, cpu);
+		pcp = &pset->pcp;
+
+		local_irq_save(flags);
+		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
+		setup_pageset(pset, batch);
+		local_irq_restore(flags);
+	}
+}
+
+void zone_pcp_update(struct zone *zone)
+{
+	stop_machine(__zone_pcp_update, zone, NULL);
+}
+
 static __meminit void zone_pcp_init(struct zone *zone)
 {
 	int cpu;
_

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch

