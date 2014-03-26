From: akpm@linux-foundation.org
Subject: + memblock-use-for_each_memblock.patch added to -mm tree
Date: Wed, 26 Mar 2014 15:24:44 -0700
Message-ID: <533353ac.MGw2GtMnFeexKlk+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaCZWYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 18:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Emilian.Medve@Freescale.com, Emilian.Medve@freescale.com

Subject: + memblock-use-for_each_memblock.patch added to -mm tree
To: Emilian.Medve@freescale.com,Emilian.Medve@Freescale.com
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 15:24:44 -0700


The patch titled
     Subject: memblock: use for_each_memblock()
has been added to the -mm tree.  Its filename is
     memblock-use-for_each_memblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memblock-use-for_each_memblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memblock-use-for_each_memblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memblock-use-for_each_memblock.patch

