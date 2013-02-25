From: akpm@linux-foundation.org
Subject: [merged] mm-add-helper-ensure_zone_is_initialized.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:47 -0800
Message-ID: <20130225205447.BE9AC5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:47021 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BYUyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:49 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so362904qah.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add helper ensure_zone_is_initialized()
has been removed from the -mm tree.  Its filename was
     mm-add-helper-ensure_zone_is_initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm: add helper ensure_zone_is_initialized()

ensure_zone_is_initialized() checks if a zone is in a empty & not
initialized state (typically occuring after it is created in memory
hotplugging), and, if so, calls init_currently_empty_zone() to initialize
the zone.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/memory_hotplug.c~mm-add-helper-ensure_zone_is_initialized mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-add-helper-ensure_zone_is_initialized
+++ a/mm/memory_hotplug.c
@@ -282,6 +282,17 @@ static void fix_zone_id(struct zone *zon
 		set_page_links(pfn_to_page(pfn), zid, nid, pfn);
 }
 
+/* Can fail with -ENOMEM from allocating a wait table with vmalloc() or
+ * alloc_bootmem_node_nopanic() */
+static int __ref ensure_zone_is_initialized(struct zone *zone,
+			unsigned long start_pfn, unsigned long num_pages)
+{
+	if (!zone_is_initialized(zone))
+		return init_currently_empty_zone(zone, start_pfn, num_pages,
+						 MEMMAP_HOTPLUG);
+	return 0;
+}
+
 static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

