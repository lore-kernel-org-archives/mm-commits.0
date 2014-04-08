From: akpm@linux-foundation.org
Subject: [merged] memblock-use-for_each_memblock.patch removed from -mm
 tree
Date: Tue, 08 Apr 2014 13:57:01 -0700
Message-ID: <5344629d.8Uk8UGXL3Ce9TxNF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbaDHU5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Emilian.Medve@Freescale.com, Emilian.Medve@freescale.com

Subject: [merged] memblock-use-for_each_memblock.patch removed from -mm tree
To: Emilian.Medve@freescale.com,Emilian.Medve@Freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:57:01 -0700


The patch titled
     Subject: memblock: use for_each_memblock()
has been removed from the -mm tree.  Its filename was
     memblock-use-for_each_memblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Emil Medve <Emilian.Medve@freescale.com>
Subject: memblock: use for_each_memblock()

This is a small cleanup.

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c   |   24 +++++++++++-------------
 mm/page_alloc.c |   10 +++++-----
 2 files changed, 16 insertions(+), 18 deletions(-)

diff -puN mm/memblock.c~memblock-use-for_each_memblock mm/memblock.c
--- a/mm/memblock.c~memblock-use-for_each_memblock
+++ a/mm/memblock.c
@@ -1271,16 +1271,14 @@ phys_addr_t __init_memblock memblock_end
 
 void __init memblock_enforce_memory_limit(phys_addr_t limit)
 {
-	unsigned long i;
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
+	struct memblock_region *r;
 
 	if (!limit)
 		return;
 
 	/* find out max address */
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		struct memblock_region *r = &memblock.memory.regions[i];
-
+	for_each_memblock(memory, r) {
 		if (limit <= r->size) {
 			max_addr = r->base + limit;
 			break;
@@ -1379,13 +1377,12 @@ int __init_memblock memblock_is_region_r
 
 void __init_memblock memblock_trim_memory(phys_addr_t align)
 {
-	int i;
 	phys_addr_t start, end, orig_start, orig_end;
-	struct memblock_type *mem = &memblock.memory;
+	struct memblock_region *r;
 
-	for (i = 0; i < mem->cnt; i++) {
-		orig_start = mem->regions[i].base;
-		orig_end = mem->regions[i].base + mem->regions[i].size;
+	for_each_memblock(memory, r) {
+		orig_start = r->base;
+		orig_end = r->base + r->size;
 		start = round_up(orig_start, align);
 		end = round_down(orig_end, align);
 
@@ -1393,11 +1390,12 @@ void __init_memblock memblock_trim_memor
 			continue;
 
 		if (start < end) {
-			mem->regions[i].base = start;
-			mem->regions[i].size = end - start;
+			r->base = start;
+			r->size = end - start;
 		} else {
-			memblock_remove_region(mem, i);
-			i--;
+			memblock_remove_region(&memblock.memory,
+					       r - memblock.memory.regions);
+			r--;
 		}
 	}
 }
diff -puN mm/page_alloc.c~memblock-use-for_each_memblock mm/page_alloc.c
--- a/mm/page_alloc.c~memblock-use-for_each_memblock
+++ a/mm/page_alloc.c
@@ -5071,7 +5071,7 @@ static void __init find_zone_movable_pfn
 	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
-	struct memblock_type *type = &memblock.memory;
+	struct memblock_region *r;
 
 	/* Need to find movable_zone earlier when movable_node is specified. */
 	find_usable_zone_for_movable();
@@ -5081,13 +5081,13 @@ static void __init find_zone_movable_pfn
 	 * options.
 	 */
 	if (movable_node_is_enabled()) {
-		for (i = 0; i < type->cnt; i++) {
-			if (!memblock_is_hotpluggable(&type->regions[i]))
+		for_each_memblock(memory, r) {
+			if (!memblock_is_hotpluggable(r))
 				continue;
 
-			nid = type->regions[i].nid;
+			nid = r->nid;
 
-			usable_startpfn = PFN_DOWN(type->regions[i].base);
+			usable_startpfn = PFN_DOWN(r->base);
 			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
 				min(usable_startpfn, zone_movable_pfn[nid]) :
 				usable_startpfn;
_

Patches currently in -mm which might be from Emilian.Medve@freescale.com are

origin.patch

