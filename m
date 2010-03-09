From: akpm@linux-foundation.org
Subject: + sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch added to -mm tree
Date: Tue, 09 Mar 2010 13:49:06 -0800
Message-ID: <201003092149.o29Ln6h0006960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0CIVuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 16:50:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, cl@linux-foundation.org, gthelen@google.com, hannes@cmpxchg.org, hpa@zytor.com, jirislaby@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     sparsemem: on no vmemmap path put mem_map on node high too
has been added to the -mm tree.  Its filename is
     sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch

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
Subject: sparsemem: on no vmemmap path put mem_map on node high too
From: Yinghai Lu <yinghai@kernel.org>

We need to put mem_map high when virtual memmap is not used.

before this patch
free mem pfn range on first node:
[    0.000000]  19 - 1f
[    0.000000]  28 40 - 80 95
[    0.000000]  702 740 - 1000 1000
[    0.000000]  347c - 347e
[    0.000000]  34e7 3500 - 3b80 3b8b
[    0.000000]  73b8b 73bc0 - 73c00 73c00
[    0.000000]  73ddd - 73e00
[    0.000000]  73fdd - 74000
[    0.000000]  741dd - 74200
[    0.000000]  743dd - 74400
[    0.000000]  745dd - 74600
[    0.000000]  747dd - 74800
[    0.000000]  749dd - 74a00
[    0.000000]  74bdd - 74c00
[    0.000000]  74ddd - 74e00
[    0.000000]  74fdd - 75000
[    0.000000]  751dd - 75200
[    0.000000]  753dd - 75400
[    0.000000]  755dd - 75600
[    0.000000]  757dd - 75800
[    0.000000]  759dd - 75a00
[    0.000000]  79bdd 79c00 - 7d540 7d550
[    0.000000]  7f745 - 7f750
[    0.000000]  10000b 100040 - 2080000 2080000
so only 79c00 - 7d540 are major free block under 4g...

after this patch, we will get
[    0.000000]  19 - 1f
[    0.000000]  28 40 - 80 95
[    0.000000]  702 740 - 1000 1000
[    0.000000]  347c - 347e
[    0.000000]  34e7 3500 - 3600 3600
[    0.000000]  37dd - 3800
[    0.000000]  39dd - 3a00
[    0.000000]  3bdd - 3c00
[    0.000000]  3ddd - 3e00
[    0.000000]  3fdd - 4000
[    0.000000]  41dd - 4200
[    0.000000]  43dd - 4400
[    0.000000]  45dd - 4600
[    0.000000]  47dd - 4800
[    0.000000]  49dd - 4a00
[    0.000000]  4bdd - 4c00
[    0.000000]  4ddd - 4e00
[    0.000000]  4fdd - 5000
[    0.000000]  51dd - 5200
[    0.000000]  53dd - 5400
[    0.000000]  95dd 9600 - 7d540 7d550
[    0.000000]  7f745 - 7f750
[    0.000000]  17000b 170040 - 2080000 2080000
we will have 9600 - 7d540 for major free block...

sparse-vmemmap path already used __alloc_bootmem_node_high()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/sparse.c~sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too mm/sparse.c
--- a/mm/sparse.c~sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too
+++ a/mm/sparse.c
@@ -381,13 +381,15 @@ static void __init sparse_early_usemaps_
 struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map;
+	unsigned long size;
 
 	map = alloc_remap(nid, sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)
 		return map;
 
-	map = alloc_bootmem_pages_node(NODE_DATA(nid),
-		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
+	size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
+	map = __alloc_bootmem_node_high(NODE_DATA(nid), size,
+					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	return map;
 }
 void __init sparse_mem_maps_populate_node(struct page **map_map,
@@ -411,7 +413,8 @@ void __init sparse_mem_maps_populate_nod
 	}
 
 	size = PAGE_ALIGN(size);
-	map = alloc_bootmem_pages_node(NODE_DATA(nodeid), size * map_count);
+	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
+					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 	if (map) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 			if (!present_section_nr(pnum))
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch

