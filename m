From: akpm@linux-foundation.org
Subject: + memory_hotplug-clear-zone-when-removing-the-memory.patch added to -mm tree
Date: Wed, 09 Jan 2013 15:34:16 -0800
Message-ID: <20130109233416.AF859100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:44177 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018Ab3AIXeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2013 18:34:18 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so317257yhr.2
        for <mm-commits@vger.kernel.org>; Wed, 09 Jan 2013 15:34:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, tangchen@cn.fujitsu.com, tglx@linutronix.de, wency@cn.fujitsu.com, wujianguo@huawei.com


The patch titled
     Subject: memory_hotplug: clear zone when removing the memory
has been added to the -mm tree.  Its filename is
     memory_hotplug-clear-zone-when-removing-the-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory_hotplug: clear zone when removing the memory

When memory is added, we update zone's and pgdat's start_pfn and
spanned_pages in __add_zone().  So we should revert them when the memory
is removed.

The patch adds a new function __remove_zone() to do this.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wu Jianguo <wujianguo@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |  207 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 207 insertions(+)

diff -puN mm/memory_hotplug.c~memory_hotplug-clear-zone-when-removing-the-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-clear-zone-when-removing-the-memory
+++ a/mm/memory_hotplug.c
@@ -430,8 +430,211 @@ static int __meminit __add_section(int n
 	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
 
+/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
+static int find_smallest_section_pfn(int nid, struct zone *zone,
+				     unsigned long start_pfn,
+				     unsigned long end_pfn)
+{
+	struct mem_section *ms;
+
+	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(start_pfn);
+
+		if (unlikely(!valid_section(ms)))
+			continue;
+
+		if (unlikely(pfn_to_nid(start_pfn) != nid))
+			continue;
+
+		if (zone && zone != page_zone(pfn_to_page(start_pfn)))
+			continue;
+
+		return start_pfn;
+	}
+
+	return 0;
+}
+
+/* find the biggest valid pfn in the range [start_pfn, end_pfn). */
+static int find_biggest_section_pfn(int nid, struct zone *zone,
+				    unsigned long start_pfn,
+				    unsigned long end_pfn)
+{
+	struct mem_section *ms;
+	unsigned long pfn;
+
+	/* pfn is the end pfn of a memory section. */
+	pfn = end_pfn - 1;
+	for (; pfn >= start_pfn; pfn -= PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+
+		if (unlikely(!valid_section(ms)))
+			continue;
+
+		if (unlikely(pfn_to_nid(pfn) != nid))
+			continue;
+
+		if (zone && zone != page_zone(pfn_to_page(pfn)))
+			continue;
+
+		return pfn;
+	}
+
+	return 0;
+}
+
+static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
+			     unsigned long end_pfn)
+{
+	unsigned long zone_start_pfn =  zone->zone_start_pfn;
+	unsigned long zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	unsigned long pfn;
+	struct mem_section *ms;
+	int nid = zone_to_nid(zone);
+
+	zone_span_writelock(zone);
+	if (zone_start_pfn == start_pfn) {
+		/*
+		 * If the section is smallest section in the zone, it need
+		 * shrink zone->zone_start_pfn and zone->zone_spanned_pages.
+		 * In this case, we find second smallest valid mem_section
+		 * for shrinking zone.
+		 */
+		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
+						zone_end_pfn);
+		if (pfn) {
+			zone->zone_start_pfn = pfn;
+			zone->spanned_pages = zone_end_pfn - pfn;
+		}
+	} else if (zone_end_pfn == end_pfn) {
+		/*
+		 * If the section is biggest section in the zone, it need
+		 * shrink zone->spanned_pages.
+		 * In this case, we find second biggest valid mem_section for
+		 * shrinking zone.
+		 */
+		pfn = find_biggest_section_pfn(nid, zone, zone_start_pfn,
+					       start_pfn);
+		if (pfn)
+			zone->spanned_pages = pfn - zone_start_pfn + 1;
+	}
+
+	/*
+	 * The section is not biggest or smallest mem_section in the zone, it
+	 * only creates a hole in the zone. So in this case, we need not
+	 * change the zone. But perhaps, the zone has only hole data. Thus
+	 * it check the zone has only hole or not.
+	 */
+	pfn = zone_start_pfn;
+	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+
+		if (unlikely(!valid_section(ms)))
+			continue;
+
+		if (page_zone(pfn_to_page(pfn)) != zone)
+			continue;
+
+		 /* If the section is current section, it continues the loop */
+		if (start_pfn == pfn)
+			continue;
+
+		/* If we find valid section, we have nothing to do */
+		zone_span_writeunlock(zone);
+		return;
+	}
+
+	/* The zone has no valid section */
+	zone->zone_start_pfn = 0;
+	zone->spanned_pages = 0;
+	zone_span_writeunlock(zone);
+}
+
+static void shrink_pgdat_span(struct pglist_data *pgdat,
+			      unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pgdat_start_pfn =  pgdat->node_start_pfn;
+	unsigned long pgdat_end_pfn =
+		pgdat->node_start_pfn + pgdat->node_spanned_pages;
+	unsigned long pfn;
+	struct mem_section *ms;
+	int nid = pgdat->node_id;
+
+	if (pgdat_start_pfn == start_pfn) {
+		/*
+		 * If the section is smallest section in the pgdat, it need
+		 * shrink pgdat->node_start_pfn and pgdat->node_spanned_pages.
+		 * In this case, we find second smallest valid mem_section
+		 * for shrinking zone.
+		 */
+		pfn = find_smallest_section_pfn(nid, NULL, end_pfn,
+						pgdat_end_pfn);
+		if (pfn) {
+			pgdat->node_start_pfn = pfn;
+			pgdat->node_spanned_pages = pgdat_end_pfn - pfn;
+		}
+	} else if (pgdat_end_pfn == end_pfn) {
+		/*
+		 * If the section is biggest section in the pgdat, it need
+		 * shrink pgdat->node_spanned_pages.
+		 * In this case, we find second biggest valid mem_section for
+		 * shrinking zone.
+		 */
+		pfn = find_biggest_section_pfn(nid, NULL, pgdat_start_pfn,
+					       start_pfn);
+		if (pfn)
+			pgdat->node_spanned_pages = pfn - pgdat_start_pfn + 1;
+	}
+
+	/*
+	 * If the section is not biggest or smallest mem_section in the pgdat,
+	 * it only creates a hole in the pgdat. So in this case, we need not
+	 * change the pgdat.
+	 * But perhaps, the pgdat has only hole data. Thus it check the pgdat
+	 * has only hole or not.
+	 */
+	pfn = pgdat_start_pfn;
+	for (; pfn < pgdat_end_pfn; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+
+		if (unlikely(!valid_section(ms)))
+			continue;
+
+		if (pfn_to_nid(pfn) != nid)
+			continue;
+
+		 /* If the section is current section, it continues the loop */
+		if (start_pfn == pfn)
+			continue;
+
+		/* If we find valid section, we have nothing to do */
+		return;
+	}
+
+	/* The pgdat has no valid section */
+	pgdat->node_start_pfn = 0;
+	pgdat->node_spanned_pages = 0;
+}
+
+static void __remove_zone(struct zone *zone, unsigned long start_pfn)
+{
+	struct pglist_data *pgdat = zone->zone_pgdat;
+	int nr_pages = PAGES_PER_SECTION;
+	int zone_type;
+	unsigned long flags;
+
+	zone_type = zone - pgdat->node_zones;
+
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
+	shrink_pgdat_span(pgdat, start_pfn, start_pfn + nr_pages);
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+}
+
 static int __remove_section(struct zone *zone, struct mem_section *ms)
 {
+	unsigned long start_pfn;
+	int scn_nr;
 	int ret = -EINVAL;
 
 	if (!valid_section(ms))
@@ -441,6 +644,10 @@ static int __remove_section(struct zone 
 	if (ret)
 		return ret;
 
+	scn_nr = __section_nr(ms);
+	start_pfn = section_nr_to_pfn(scn_nr);
+	__remove_zone(zone, start_pfn);
+
 	sparse_remove_one_section(zone, ms);
 	return 0;
 }
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-try-to-offline-the-memory-twice-to-avoid-dependence.patch
memory-hotplug-check-whether-all-memory-blocks-are-offlined-or-not-when-removing-memory.patch
memory-hotplug-remove-redundant-codes.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs.patch
memory-hotplug-introduce-new-arch_remove_memory-for-removing-page-table.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
memory-hotplug-move-pgdat_resize_lock-into-sparse_remove_one_section.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap.patch
memory-hotplug-integrated-__remove_section-of-config_sparsemem_vmemmap.patch
memory_hotplug-clear-zone-when-removing-the-memory.patch
memory-hotplug-remove-sysfs-file-of-node.patch
memory-hotplug-free-node_data-when-a-node-is-offlined.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch

