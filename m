From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch added to -mm tree
Date: Thu, 30 Mar 2017 14:42:23 -0700
Message-ID: <58dd7bbf.tT8wpHE54Iyk6kXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935055AbdC3Vmf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 17:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, benh@kernel.crashing.org, cmetcalf@mellanox.com, dan.j.williams@gmail.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, hpa@zytor.com, imammedo@redhat.com, js1304@gmail.com, laijs@cn.fujitsu.com, mgorman@suse.de, mingo@elte.hu, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, slaoub@gmail.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: do not associate hotadded memory to zones until online
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: do not associate hotadded memory to zones until online

The current memory hotplug implementation relies on having all the struct
pages associate with a zone during the physical hotplug phase
(arch_add_memory->__add_pages->__add_section->__add_zone).  In the vast
majority of cases this means that they are added to ZONE_NORMAL.  This has
been so since 9d99aaa31f59 ("[PATCH] x86_64: Support memory hotadd without
sparsemem") and it wasn't a big deal back then.

Much later memory hotplug wanted to (ab)use ZONE_MOVABLE for movable
onlining 511c2aba8f07 ("mm, memory-hotplug: dynamic configure movable
memory and portion memory") and then things got more complicated.  Rather
than reconsidering the zone association which was no longer needed
(because the memory hotplug already depended on SPARSEMEM) a convoluted
semantic of zone shifting has been developed.  Only the currently last
memblock or the one adjacent to the zone_movable can be onlined movable. 
This essentially means that the online time changes as the new memblocks
are added.

Let's simulate memory hot online manually
Normal Movable

/sys/devices/system/memory/memory32/valid_zones:Normal
/sys/devices/system/memory/memory33/valid_zones:Normal Movable

/sys/devices/system/memory/memory32/valid_zones:Normal
/sys/devices/system/memory/memory33/valid_zones:Normal
/sys/devices/system/memory/memory34/valid_zones:Normal Movable

/sys/devices/system/memory/memory32/valid_zones:Normal
/sys/devices/system/memory/memory33/valid_zones:Normal Movable
/sys/devices/system/memory/memory34/valid_zones:Movable Normal

This is an awkward semantic because an udev event is sent as soon as the
block is onlined and an udev handler might want to online it based on some
policy (e.g.  association with a node) but it will inherently race with
new blocks showing up.

This patch changes the physical online phase to not associate pages with
any zone at all.  All the pages are just marked reserved and wait for the
onlining phase to be associated with the zone as per the online request. 
There are only two requirements

	- existing ZONE_NORMAL and ZONE_MOVABLE cannot overlap
	- ZONE_NORMAL precedes ZONE_MOVABLE in physical addresses

the later on is not inherent and can be changed in the future.  It
preserves the current behavior and made the code slightly simpler.  This
is subject to change in future.

This means that the same physical online steps as above will lead to the
following state:

Normal Movable

/sys/devices/system/memory/memory32/valid_zones:Normal Movable
/sys/devices/system/memory/memory33/valid_zones:Normal Movable

/sys/devices/system/memory/memory32/valid_zones:Normal Movable
/sys/devices/system/memory/memory33/valid_zones:Normal Movable
/sys/devices/system/memory/memory34/valid_zones:Normal Movable

/sys/devices/system/memory/memory32/valid_zones:Normal Movable
/sys/devices/system/memory/memory33/valid_zones:Normal Movable
/sys/devices/system/memory/memory34/valid_zones:Movable

Implementation:

The current move_pfn_range is reimplemented to check the above
requirements (allow_online_pfn_range) and then updates the respective zone
(move_pfn_range_to_zone), the pgdat and links all the pages in the pfn
range with the zone/node.  __add_pages is updated to not require the zone
and only initializes sections in the range.  This allowed to simplify the
arch_add_memory code (s390 could get rid of quite some of code).

devm_memremap_pages is the only user of arch_add_memory which relies on
the zone association because it only hooks into the memory hotplug only
half way.  It uses it to associate the new memory with ZONE_DEVICE but
doesn't allow it to be {on,off}lined via sysfs.  This means that this
particular code path has to call move_pfn_range_to_zone explicitly.

The original zone shifting code is kept in place and will be removed in
the follow up patch for an easier review.

Link: http://lkml.kernel.org/r/20170330115454.32154-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <slaoub@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c            |    8 -
 arch/powerpc/mm/mem.c          |   10 -
 arch/s390/mm/init.c            |   30 ----
 arch/sh/mm/init.c              |    7 -
 arch/x86/mm/init_32.c          |    5 
 arch/x86/mm/init_64.c          |    9 -
 drivers/base/memory.c          |   54 ++++----
 include/linux/memory_hotplug.h |   13 +-
 kernel/memremap.c              |    3 
 mm/memory_hotplug.c            |  195 ++++++++++++++++++-------------
 mm/sparse.c                    |    3 
 11 files changed, 166 insertions(+), 171 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/arch/ia64/mm/init.c
@@ -648,17 +648,11 @@ mem_init (void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
 {
-	pg_data_t *pgdat;
-	struct zone *zone;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	pgdat = NODE_DATA(nid);
-
-	zone = pgdat->node_zones +
-		zone_for_memory(nid, start, size, ZONE_NORMAL, for_device);
-	ret = __add_pages(nid, zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, start_pfn, nr_pages);
 
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
diff -puN arch/powerpc/mm/mem.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/arch/powerpc/mm/mem.c
@@ -128,16 +128,12 @@ int __weak remove_section_mapping(unsign
 
 int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
 {
-	struct pglist_data *pgdata;
-	struct zone *zone;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int rc;
 
 	resize_hpt_for_hotplug(memblock_phys_mem_size());
 
-	pgdata = NODE_DATA(nid);
-
 	start = (unsigned long)__va(start);
 	rc = create_section_mapping(start, start + size);
 	if (rc) {
@@ -147,11 +143,7 @@ int arch_add_memory(int nid, u64 start,
 		return -EFAULT;
 	}
 
-	/* this should work for most non-highmem platforms */
-	zone = pgdata->node_zones +
-		zone_for_memory(nid, start, size, 0, for_device);
-
-	return __add_pages(nid, zone, start_pfn, nr_pages);
+	return __add_pages(nid, start_pfn, nr_pages);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN arch/s390/mm/init.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/arch/s390/mm/init.c
@@ -163,41 +163,15 @@ unsigned long memory_block_size_bytes(vo
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
 {
-	unsigned long zone_start_pfn, zone_end_pfn, nr_pages;
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long size_pages = PFN_DOWN(size);
-	pg_data_t *pgdat = NODE_DATA(nid);
-	struct zone *zone;
-	int rc, i;
+	int rc;
 
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		zone = pgdat->node_zones + i;
-		if (zone_idx(zone) != ZONE_MOVABLE) {
-			/* Add range within existing zone limits, if possible */
-			zone_start_pfn = zone->zone_start_pfn;
-			zone_end_pfn = zone->zone_start_pfn +
-				       zone->spanned_pages;
-		} else {
-			/* Add remaining range to ZONE_MOVABLE */
-			zone_start_pfn = start_pfn;
-			zone_end_pfn = start_pfn + size_pages;
-		}
-		if (start_pfn < zone_start_pfn || start_pfn >= zone_end_pfn)
-			continue;
-		nr_pages = (start_pfn + size_pages > zone_end_pfn) ?
-			   zone_end_pfn - start_pfn : size_pages;
-		rc = __add_pages(nid, zone, start_pfn, nr_pages);
-		if (rc)
-			break;
-		start_pfn += nr_pages;
-		size_pages -= nr_pages;
-		if (!size_pages)
-			break;
-	}
+	rc = __add_pages(nid, start_pfn, size_pages);
 	if (rc)
 		vmem_remove_mapping(start, size);
 	return rc;
diff -puN arch/sh/mm/init.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/arch/sh/mm/init.c
@@ -487,18 +487,13 @@ void free_initrd_mem(unsigned long start
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
 {
-	pg_data_t *pgdat;
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	pgdat = NODE_DATA(nid);
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(nid, pgdat->node_zones +
-			zone_for_memory(nid, start, size, ZONE_NORMAL,
-			for_device),
-			start_pfn, nr_pages);
+	ret = __add_pages(nid, start_pfn, nr_pages);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
diff -puN arch/x86/mm/init_32.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/arch/x86/mm/init_32.c
@@ -818,13 +818,10 @@ void __init mem_init(void)
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
 {
-	struct pglist_data *pgdata = NODE_DATA(nid);
-	struct zone *zone = pgdata->node_zones +
-		zone_for_memory(nid, start, size, ZONE_HIGHMEM, for_device);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	return __add_pages(nid, zone, start_pfn, nr_pages);
+	return __add_pages(nid, start_pfn, nr_pages);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN arch/x86/mm/init_64.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/arch/x86/mm/init_64.c
@@ -637,22 +637,15 @@ static void  update_end_of_memory_vars(u
 	}
 }
 
-/*
- * Memory is added always to NORMAL zone. This means you will never get
- * additional DMA/DMA32 memory.
- */
 int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
 {
-	struct pglist_data *pgdat = NODE_DATA(nid);
-	struct zone *zone = pgdat->node_zones +
-		zone_for_memory(nid, start, size, ZONE_NORMAL, for_device);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
 	init_memory_mapping(start, start + size);
 
-	ret = __add_pages(nid, zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
 	/* update max_pfn, max_low_pfn and high_memory */
diff -puN drivers/base/memory.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/drivers/base/memory.c
@@ -388,39 +388,43 @@ static ssize_t show_valid_zones(struct d
 				struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem = to_memory_block(dev);
-	unsigned long start_pfn, end_pfn;
-	unsigned long valid_start, valid_end, valid_pages;
+	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	struct zone *zone;
-	int zone_shift = 0;
-
-	start_pfn = section_nr_to_pfn(mem->start_section_nr);
-	end_pfn = start_pfn + nr_pages;
-
-	/* The block contains more than one zone can not be offlined. */
-	if (!test_pages_in_a_zone(start_pfn, end_pfn, &valid_start, &valid_end))
+	unsigned long valid_start_pfn, valid_end_pfn;
+	bool append = false;
+	int nid;
+
+	/*
+	 * The block contains more than one zone can not be offlined.
+	 * This can happen e.g. for ZONE_DMA and ZONE_DMA32
+	 */
+	if (!test_pages_in_a_zone(start_pfn, start_pfn + nr_pages, &valid_start_pfn, &valid_end_pfn))
 		return sprintf(buf, "none\n");
 
-	zone = page_zone(pfn_to_page(valid_start));
-	valid_pages = valid_end - valid_start;
+	start_pfn = valid_start_pfn;
+	nr_pages = valid_end_pfn - valid_end_pfn;
 
-	/* MMOP_ONLINE_KEEP */
-	sprintf(buf, "%s", zone->name);
-
-	/* MMOP_ONLINE_KERNEL */
-	zone_can_shift(valid_start, valid_pages, ZONE_NORMAL, &zone_shift);
-	if (zone_shift) {
-		strcat(buf, " ");
-		strcat(buf, (zone + zone_shift)->name);
+	/*
+	 * Check the existing zone. Make sure that we do that only on the
+	 * online nodes otherwise the page_zone is not reliable
+	 */
+	if (mem->state == MEM_ONLINE) {
+		strcat(buf, page_zone(pfn_to_page(start_pfn))->name);
+		goto out;
 	}
 
-	/* MMOP_ONLINE_MOVABLE */
-	zone_can_shift(valid_start, valid_pages, ZONE_MOVABLE, &zone_shift);
-	if (zone_shift) {
-		strcat(buf, " ");
-		strcat(buf, (zone + zone_shift)->name);
+	nid = pfn_to_nid(start_pfn);
+	if (allow_online_pfn_range(nid, start_pfn, nr_pages, MMOP_ONLINE_KERNEL)) {
+		strcat(buf, NODE_DATA(nid)->node_zones[ZONE_NORMAL].name);
+		append = true;
 	}
 
+	if (allow_online_pfn_range(nid, start_pfn, nr_pages, MMOP_ONLINE_MOVABLE)) {
+		if (append)
+			strcat(buf, " ");
+		strcat(buf, NODE_DATA(nid)->node_zones[ZONE_MOVABLE].name);
+	}
+out:
 	strcat(buf, "\n");
 
 	return strlen(buf);
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/include/linux/memory_hotplug.h
@@ -109,8 +109,8 @@ extern int __remove_pages(struct zone *z
 	unsigned long nr_pages);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-/* reasonably generic interface to expand the physical pages in a zone  */
-extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
+/* reasonably generic interface to expand the physical pages */
+extern int __add_pages(int nid, unsigned long start_pfn,
 	unsigned long nr_pages);
 
 #ifdef CONFIG_NUMA
@@ -277,15 +277,16 @@ extern int add_memory_resource(int nid,
 extern int zone_for_memory(int nid, u64 start, u64 size, int zone_default,
 		bool for_device);
 extern int arch_add_memory(int nid, u64 start, u64 size, bool for_device);
+extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
+		unsigned long nr_pages);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern void remove_memory(int nid, u64 start, u64 size);
-extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn);
+extern int sparse_add_one_section(struct pglist_data *pgdat, unsigned long start_pfn);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms,
 		unsigned long map_offset);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern bool zone_can_shift(unsigned long pfn, unsigned long nr_pages,
-			  enum zone_type target, int *zone_shift);
-
+extern bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages,
+		int online_type);
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN kernel/memremap.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online kernel/memremap.c
--- a/kernel/memremap.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/kernel/memremap.c
@@ -364,6 +364,9 @@ void *devm_memremap_pages(struct device
 
 	mem_hotplug_begin();
 	error = arch_add_memory(nid, align_start, align_size, true);
+	if (!error)
+		move_pfn_range_to_zone(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
+				align_start, align_size);
 	mem_hotplug_done();
 	if (error)
 		goto err_add_memory;
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/mm/memory_hotplug.c
@@ -433,25 +433,6 @@ out_fail:
 	return -1;
 }
 
-static struct zone * __meminit move_pfn_range(int zone_shift,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	struct zone *zone = page_zone(pfn_to_page(start_pfn));
-	int ret = 0;
-
-	if (zone_shift < 0)
-		ret = move_pfn_range_left(zone + zone_shift, zone,
-					  start_pfn, end_pfn);
-	else if (zone_shift)
-		ret = move_pfn_range_right(zone, zone + zone_shift,
-					   start_pfn, end_pfn);
-
-	if (ret)
-		return NULL;
-
-	return zone + zone_shift;
-}
-
 static void __meminit grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 				      unsigned long end_pfn)
 {
@@ -493,23 +474,29 @@ static int __meminit __add_zone(struct z
 	return 0;
 }
 
-static int __meminit __add_section(int nid, struct zone *zone,
-					unsigned long phys_start_pfn)
+static int __meminit __add_section(int nid, unsigned long phys_start_pfn)
 {
 	int ret;
+	int i;
 
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
 
-	ret = sparse_add_one_section(zone, phys_start_pfn);
-
+	ret = sparse_add_one_section(NODE_DATA(nid), phys_start_pfn);
 	if (ret < 0)
 		return ret;
 
-	ret = __add_zone(zone, phys_start_pfn);
+	/*
+	 * Make all the pages reserved so that nobody will stumble over half
+	 * initialized state.
+	 */
+	for (i = 0; i < PAGES_PER_SECTION; i++) {
+		unsigned long pfn = phys_start_pfn + i;
+		if (!pfn_valid(pfn))
+			continue;
 
-	if (ret < 0)
-		return ret;
+		SetPageReserved(pfn_to_page(phys_start_pfn + i));
+	}
 
 	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
@@ -520,7 +507,7 @@ static int __meminit __add_section(int n
  * call this function after deciding the zone to which to
  * add the new pages.
  */
-int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
+int __ref __add_pages(int nid, unsigned long phys_start_pfn,
 			unsigned long nr_pages)
 {
 	unsigned long i;
@@ -528,8 +515,6 @@ int __ref __add_pages(int nid, struct zo
 	int start_sec, end_sec;
 	struct vmem_altmap *altmap;
 
-	clear_zone_contiguous(zone);
-
 	/* during initialize mem_map, align hot-added range to section */
 	start_sec = pfn_to_section_nr(phys_start_pfn);
 	end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
@@ -549,7 +534,7 @@ int __ref __add_pages(int nid, struct zo
 	}
 
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(nid, zone, section_nr_to_pfn(i));
+		err = __add_section(nid, section_nr_to_pfn(i));
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
@@ -562,7 +547,6 @@ int __ref __add_pages(int nid, struct zo
 	}
 	vmemmap_populate_print_last();
 out:
-	set_zone_contiguous(zone);
 	return err;
 }
 EXPORT_SYMBOL_GPL(__add_pages);
@@ -1027,39 +1011,113 @@ static void node_states_set_node(int nod
 	node_set_state(node, N_MEMORY);
 }
 
-bool zone_can_shift(unsigned long pfn, unsigned long nr_pages,
-		   enum zone_type target, int *zone_shift)
+bool allow_online_pfn_range(int nid, unsigned long pfn, unsigned long nr_pages, int online_type)
 {
-	struct zone *zone = page_zone(pfn_to_page(pfn));
-	enum zone_type idx = zone_idx(zone);
-	int i;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	struct zone *movable_zone = &pgdat->node_zones[ZONE_MOVABLE];
+	struct zone *normal_zone =  &pgdat->node_zones[ZONE_NORMAL];
 
-	*zone_shift = 0;
+	/*
+	 * TODO there shouldn't be any inherent reason to have ZONE_NORMAL
+	 * physically before ZONE_MOVABLE. All we need is they do not
+	 * overlap. Historically we didn't allow ZONE_NORMAL after ZONE_MOVABLE
+	 * though so let's stick with it for simplicity for now.
+	 * TODO make sure we do not overlap with ZONE_DEVICE
+	 */
+	if (online_type == MMOP_ONLINE_KERNEL) {
+		if (!populated_zone(movable_zone))
+			return true;
+		return movable_zone->zone_start_pfn >= pfn + nr_pages;
+	} else if (online_type == MMOP_ONLINE_MOVABLE) {
+		return zone_end_pfn(normal_zone) <= pfn;
+	}
+
+	/* MMOP_ONLINE_KEEP will always succeed and inherits the current zone */
+	return online_type == MMOP_ONLINE_KEEP;
+}
 
-	if (idx < target) {
-		/* pages must be at end of current zone */
-		if (pfn + nr_pages != zone_end_pfn(zone))
-			return false;
+static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
+		unsigned long nr_pages)
+{
+	unsigned long old_end_pfn = zone_end_pfn(zone);
+
+	if (start_pfn < zone->zone_start_pfn)
+		zone->zone_start_pfn = start_pfn;
+
+	zone->spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - zone->zone_start_pfn;
+}
+
+static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned long start_pfn,
+                                     unsigned long nr_pages)
+{
+	unsigned long old_end_pfn = pgdat_end_pfn(pgdat);
+
+	if (start_pfn < pgdat->node_start_pfn)
+		pgdat->node_start_pfn = start_pfn;
 
-		/* no zones in use between current zone and target */
-		for (i = idx + 1; i < target; i++)
-			if (!zone_is_empty(zone - idx + i))
-				return false;
+	pgdat->node_spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - pgdat->node_start_pfn;
+}
+
+void move_pfn_range_to_zone(struct zone *zone,
+		unsigned long start_pfn, unsigned long nr_pages)
+{
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	int nid = pgdat->node_id;
+	unsigned long flags;
+	unsigned long i;
+
+	if (zone_is_empty(zone))
+		init_currently_empty_zone(zone, start_pfn, nr_pages);
+
+	clear_zone_contiguous(zone);
+
+	/* TODO Huh pgdat is irqsave while zone is not. It used to be like that before */
+	pgdat_resize_lock(pgdat, &flags);
+	zone_span_writelock(zone);
+	resize_zone_range(zone, start_pfn, nr_pages);
+	zone_span_writeunlock(zone);
+	resize_pgdat_range(pgdat, start_pfn, nr_pages);
+	pgdat_resize_unlock(pgdat, &flags);
+
+	/*
+	 * TODO now we have a visible range of pages which are not associated
+	 * with their zone properly. Not nice but set_pfnblock_flags_mask
+	 * expects the zone spans the pfn range. All the pages in the range
+	 * are reserved so nobody should be touching them so we should be safe
+	 */
+	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn, MEMMAP_HOTPLUG);
+	for (i = 0; i < nr_pages; i++) {
+		unsigned long pfn = start_pfn + i;
+		set_page_links(pfn_to_page(pfn), zone_idx(zone), nid, pfn);
 	}
 
-	if (target < idx) {
-		/* pages must be at beginning of current zone */
-		if (pfn != zone->zone_start_pfn)
-			return false;
+	set_zone_contiguous(zone);
+}
+
+/*
+ * Associates the given pfn range with the given node and the zone appropriate
+ * for the given online type.
+ */
+static struct zone * __meminit move_pfn_range(int online_type, int nid,
+		unsigned long start_pfn, unsigned long nr_pages)
+{
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	struct zone *zone = &pgdat->node_zones[ZONE_NORMAL];
 
-		/* no zones in use between current zone and target */
-		for (i = target + 1; i < idx; i++)
-			if (!zone_is_empty(zone - idx + i))
-				return false;
+	if (online_type == MMOP_ONLINE_KEEP) {
+		/*
+		 * MMOP_ONLINE_KEEP inherits the current zone which is
+		 * ZONE_NORMAL by default but we might be within ZONE_MOVABLE
+		 * already.
+		 */
+		if (allow_online_pfn_range(nid, start_pfn, nr_pages, MMOP_ONLINE_MOVABLE))
+			zone = &pgdat->node_zones[ZONE_MOVABLE];
+	} else if (online_type == MMOP_ONLINE_MOVABLE) {
+		zone = &pgdat->node_zones[ZONE_MOVABLE];
 	}
 
-	*zone_shift = target - idx;
-	return true;
+	move_pfn_range_to_zone(zone, start_pfn, nr_pages);
+	return zone;
 }
 
 /* Must be protected by mem_hotplug_begin() */
@@ -1072,29 +1130,16 @@ int __ref online_pages(unsigned long pfn
 	int nid;
 	int ret;
 	struct memory_notify arg;
-	int zone_shift = 0;
 
-	/*
-	 * This doesn't need a lock to do pfn_to_page().
-	 * The section can't be removed here because of the
-	 * memory_block->state_mutex.
-	 */
-	zone = page_zone(pfn_to_page(pfn));
-
-	if ((zone_idx(zone) > ZONE_NORMAL ||
-	    online_type == MMOP_ONLINE_MOVABLE) &&
-	    !can_online_high_movable(pfn_to_nid(pfn)))
+	nid = pfn_to_nid(pfn);
+	if (!allow_online_pfn_range(nid, pfn, nr_pages, online_type))
 		return -EINVAL;
 
-	if (online_type == MMOP_ONLINE_KERNEL) {
-		if (!zone_can_shift(pfn, nr_pages, ZONE_NORMAL, &zone_shift))
-			return -EINVAL;
-	} else if (online_type == MMOP_ONLINE_MOVABLE) {
-		if (!zone_can_shift(pfn, nr_pages, ZONE_MOVABLE, &zone_shift))
-			return -EINVAL;
-	}
+	if (online_type == MMOP_ONLINE_MOVABLE && !can_online_high_movable(nid))
+		return -EINVAL;
 
-	zone = move_pfn_range(zone_shift, pfn, pfn + nr_pages);
+	/* associate pfn range with the zone */
+	zone = move_pfn_range(online_type, nid, pfn, nr_pages);
 	if (!zone)
 		return -EINVAL;
 
@@ -1102,8 +1147,6 @@ int __ref online_pages(unsigned long pfn
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_online(nr_pages, zone, &arg);
 
-	nid = zone_to_nid(zone);
-
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
 	if (ret)
diff -puN mm/sparse.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online mm/sparse.c
--- a/mm/sparse.c~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online
+++ a/mm/sparse.c
@@ -686,10 +686,9 @@ static void free_map_bootmem(struct page
  * set.  If this is <=0, then that means that the passed-in
  * map was not consumed and must be freed.
  */
-int __meminit sparse_add_one_section(struct zone *zone, unsigned long start_pfn)
+int __meminit sparse_add_one_section(struct pglist_data *pgdat, unsigned long start_pfn)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct mem_section *ms;
 	struct page *memmap;
 	unsigned long *usemap;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-move-mm_percpu_wq-initialization-earlier.patch
lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-move-pcp-and-lru-pcp-drainging-into-single-wq.patch
mm-get-rid-of-zone_is_initialized.patch
mm-tile-drop-arch_addremove_memory.patch
mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch

