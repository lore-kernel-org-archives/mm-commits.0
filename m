From: akpm@linux-foundation.org
Subject: [merged]
 mm-percpu-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:18 -0800
Message-ID: <52e0269a.o5488asn0iCGOtBH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaAVUOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: [merged] mm-percpu-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:18 -0800


The patch titled
     Subject: mm/percpu.c: use memblock apis for early memory allocations
has been removed from the -mm tree.  Its filename was
     mm-percpu-use-memblock-apis-for-early-memory-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: mm/percpu.c: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff -puN mm/percpu.c~mm-percpu-use-memblock-apis-for-early-memory-allocations mm/percpu.c
--- a/mm/percpu.c~mm-percpu-use-memblock-apis-for-early-memory-allocations
+++ a/mm/percpu.c
@@ -1063,7 +1063,7 @@ struct pcpu_alloc_info * __init pcpu_all
 			  __alignof__(ai->groups[0].cpu_map[0]));
 	ai_size = base_size + nr_units * sizeof(ai->groups[0].cpu_map[0]);
 
-	ptr = alloc_bootmem_nopanic(PFN_ALIGN(ai_size));
+	ptr = memblock_virt_alloc_nopanic(PFN_ALIGN(ai_size), 0);
 	if (!ptr)
 		return NULL;
 	ai = ptr;
@@ -1088,7 +1088,7 @@ struct pcpu_alloc_info * __init pcpu_all
  */
 void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 {
-	free_bootmem(__pa(ai), ai->__ai_size);
+	memblock_free_early(__pa(ai), ai->__ai_size);
 }
 
 /**
@@ -1246,10 +1246,12 @@ int __init pcpu_setup_first_chunk(const
 	PCPU_SETUP_BUG_ON(pcpu_verify_alloc_info(ai) < 0);
 
 	/* process group information and build config tables accordingly */
-	group_offsets = alloc_bootmem(ai->nr_groups * sizeof(group_offsets[0]));
-	group_sizes = alloc_bootmem(ai->nr_groups * sizeof(group_sizes[0]));
-	unit_map = alloc_bootmem(nr_cpu_ids * sizeof(unit_map[0]));
-	unit_off = alloc_bootmem(nr_cpu_ids * sizeof(unit_off[0]));
+	group_offsets = memblock_virt_alloc(ai->nr_groups *
+					     sizeof(group_offsets[0]), 0);
+	group_sizes = memblock_virt_alloc(ai->nr_groups *
+					   sizeof(group_sizes[0]), 0);
+	unit_map = memblock_virt_alloc(nr_cpu_ids * sizeof(unit_map[0]), 0);
+	unit_off = memblock_virt_alloc(nr_cpu_ids * sizeof(unit_off[0]), 0);
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
 		unit_map[cpu] = UINT_MAX;
@@ -1311,7 +1313,8 @@ int __init pcpu_setup_first_chunk(const
 	 * empty chunks.
 	 */
 	pcpu_nr_slots = __pcpu_size_to_slot(pcpu_unit_size) + 2;
-	pcpu_slot = alloc_bootmem(pcpu_nr_slots * sizeof(pcpu_slot[0]));
+	pcpu_slot = memblock_virt_alloc(
+			pcpu_nr_slots * sizeof(pcpu_slot[0]), 0);
 	for (i = 0; i < pcpu_nr_slots; i++)
 		INIT_LIST_HEAD(&pcpu_slot[i]);
 
@@ -1322,7 +1325,7 @@ int __init pcpu_setup_first_chunk(const
 	 * covers static area + reserved area (mostly used for module
 	 * static percpu allocation).
 	 */
-	schunk = alloc_bootmem(pcpu_chunk_struct_size);
+	schunk = memblock_virt_alloc(pcpu_chunk_struct_size, 0);
 	INIT_LIST_HEAD(&schunk->list);
 	schunk->base_addr = base_addr;
 	schunk->map = smap;
@@ -1346,7 +1349,7 @@ int __init pcpu_setup_first_chunk(const
 
 	/* init dynamic chunk if necessary */
 	if (dyn_size) {
-		dchunk = alloc_bootmem(pcpu_chunk_struct_size);
+		dchunk = memblock_virt_alloc(pcpu_chunk_struct_size, 0);
 		INIT_LIST_HEAD(&dchunk->list);
 		dchunk->base_addr = base_addr;
 		dchunk->map = dmap;
@@ -1626,7 +1629,7 @@ int __init pcpu_embed_first_chunk(size_t
 	size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
 	areas_size = PFN_ALIGN(ai->nr_groups * sizeof(void *));
 
-	areas = alloc_bootmem_nopanic(areas_size);
+	areas = memblock_virt_alloc_nopanic(areas_size, 0);
 	if (!areas) {
 		rc = -ENOMEM;
 		goto out_free;
@@ -1712,7 +1715,7 @@ out_free_areas:
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
-		free_bootmem(__pa(areas), areas_size);
+		memblock_free_early(__pa(areas), areas_size);
 	return rc;
 }
 #endif /* BUILD_EMBED_FIRST_CHUNK */
@@ -1760,7 +1763,7 @@ int __init pcpu_page_first_chunk(size_t
 	/* unaligned allocations can't be freed, round up to page size */
 	pages_size = PFN_ALIGN(unit_pages * num_possible_cpus() *
 			       sizeof(pages[0]));
-	pages = alloc_bootmem(pages_size);
+	pages = memblock_virt_alloc(pages_size, 0);
 
 	/* allocate pages */
 	j = 0;
@@ -1823,7 +1826,7 @@ enomem:
 		free_fn(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
-	free_bootmem(__pa(pages), pages_size);
+	memblock_free_early(__pa(pages), pages_size);
 	pcpu_free_alloc_info(ai);
 	return rc;
 }
@@ -1848,12 +1851,13 @@ EXPORT_SYMBOL(__per_cpu_offset);
 static void * __init pcpu_dfl_fc_alloc(unsigned int cpu, size_t size,
 				       size_t align)
 {
-	return __alloc_bootmem_nopanic(size, align, __pa(MAX_DMA_ADDRESS));
+	return  memblock_virt_alloc_from_nopanic(
+			size, align, __pa(MAX_DMA_ADDRESS));
 }
 
 static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
 {
-	free_bootmem(__pa(ptr), size);
+	memblock_free_early(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
@@ -1896,7 +1900,9 @@ void __init setup_per_cpu_areas(void)
 	void *fc;
 
 	ai = pcpu_alloc_alloc_info(1, 1);
-	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	fc = memblock_virt_alloc_from_nopanic(unit_size,
+					      PAGE_SIZE,
+					      __pa(MAX_DMA_ADDRESS));
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
 	/* kmemleak tracks the percpu allocations separately */
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
linux-next.patch

