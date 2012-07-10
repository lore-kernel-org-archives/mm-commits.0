From: akpm@linux-foundation.org
Subject: + mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch added to -mm tree
Date: Tue, 10 Jul 2012 13:58:47 -0700
Message-ID: <20120710205848.4DBDE10007D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36312 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2GJU6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 16:58:50 -0400
Received: by ghbz15 with SMTP id z15so50793ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 13:58:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jiang.liu@huawei.com, Bessel.Wang@huawei.com, chenkeping@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rusty@rustcorp.com.au, tony.luck@intel.com, yinghai@kernel.org


The patch titled
     Subject: mm/hotplug: free zone->pageset when a zone becomes empty
has been added to the -mm tree.  Its filename is
     mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <jiang.liu@huawei.com>
Subject: mm/hotplug: free zone->pageset when a zone becomes empty

When a zone becomes empty after memory offlining, free zone->pageset. 
Otherwise it will cause memory leak when adding memory to the empty zone
again because build_all_zonelists() will allocate zone->pageset for an
empty zone.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Wei Wang <Bessel.Wang@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Keping Chen <chenkeping@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 +
 mm/memory_hotplug.c |    3 +++
 mm/page_alloc.c     |   13 +++++++++++++
 3 files changed, 17 insertions(+)

diff -puN include/linux/mm.h~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty include/linux/mm.h
--- a/include/linux/mm.h~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty
+++ a/include/linux/mm.h
@@ -1331,6 +1331,7 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 extern void setup_per_cpu_pageset(void);
 
 extern void zone_pcp_update(struct zone *zone);
+extern void zone_pcp_reset(struct zone *zone);
 
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
diff -puN mm/memory_hotplug.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty
+++ a/mm/memory_hotplug.c
@@ -966,6 +966,9 @@ repeat:
 
 	init_per_zone_wmark_min();
 
+	if (!populated_zone(zone))
+		zone_pcp_reset(zone);
+
 	if (!node_present_pages(node)) {
 		node_clear_state(node, N_HIGH_MEMORY);
 		kswapd_stop(node);
diff -puN mm/page_alloc.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty
+++ a/mm/page_alloc.c
@@ -5893,6 +5893,19 @@ void free_contig_range(unsigned long pfn
 #endif
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+void zone_pcp_reset(struct zone *zone)
+{
+	unsigned long flags;
+
+	/* avoid races with drain_pages()  */
+	local_irq_save(flags);
+	if (zone->pageset != &boot_pageset) {
+		free_percpu(zone->pageset);
+		zone->pageset = &boot_pageset;
+	}
+	local_irq_restore(flags);
+}
+
 /*
  * All pages in the range must be isolated before calling this.
  */
_
Subject: Subject: mm/hotplug: free zone->pageset when a zone becomes empty

Patches currently in -mm which might be from jiang.liu@huawei.com are

linux-next.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

