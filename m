From: akpm@linux-foundation.org
Subject: + mm-fix-usemap-initialization.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:18:22 -0700
Message-ID: <200804271918.m3RJIMGE020792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762903AbYD0TTc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:19:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, mel@csn.ul.ie, shiwh@cn.fujitsu.com, xemul@openvz.org


The patch titled
     mm: fix usemap initialization
has been added to the -mm tree.  Its filename is
     mm-fix-usemap-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix usemap initialization
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

usemap must be initialized only when pfn is within zone.  If not, it corrupts
memory.

And this patch also reduces the number of calls to set_pageblock_migratetype()
from
	(pfn & (pageblock_nr_pages -1)
to
	!(pfn & (pageblock_nr_pages-1)
it should be called once per pageblock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-usemap-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-usemap-initialization
+++ a/mm/page_alloc.c
@@ -2524,7 +2524,9 @@ void __meminit memmap_init_zone(unsigned
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
+	struct zone *z;
 
+	z = &NODE_DATA(nid)->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
@@ -2542,7 +2544,6 @@ void __meminit memmap_init_zone(unsigned
 		init_page_count(page);
 		reset_page_mapcount(page);
 		SetPageReserved(page);
-
 		/*
 		 * Mark the block movable so that blocks are reserved for
 		 * movable at startup. This will force kernel allocations
@@ -2551,8 +2552,15 @@ void __meminit memmap_init_zone(unsigned
 		 * kernel allocations are made. Later some blocks near
 		 * the start are marked MIGRATE_RESERVE by
 		 * setup_zone_migrate_reserve()
+		 *
+		 * bitmap is created for zone's valid pfn range. but memmap
+		 * can be created for invalid pages (for alignment)
+		 * check here not to call set_pageblock_migratetype() against
+		 * pfn out of zone.
 		 */
-		if ((pfn & (pageblock_nr_pages-1)))
+		if ((z->zone_start_pfn <= pfn)
+		    && (pfn < z->zone_start_pfn + z->spanned_pages)
+		    && !(pfn & (pageblock_nr_pages - 1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
@@ -4464,6 +4472,8 @@ void set_pageblock_flags_group(struct pa
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
+	VM_BUG_ON(pfn < zone->zone_start_pfn);
+	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-fix-memcg-ooms.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx-just-return-do_try_to_free_pages-do_try_to_free_pages-gfp_mask-redundant.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-doc-fixes.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-make-dequeue_huge_page_vma-obey-mpol_bind-nodemask-rework.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask-deporkify.patch
mm-make-early_pfn_to_nid-a-c-function.patch
sparsemem-vmemmap-does-not-need-section-bits.patch
kbuild-create-a-way-to-create-preprocessor-constants-from-c-expressions.patch
pageflags-use-an-enum-for-the-flags.patch
pageflags-get-rid-of-flags_reserved.patch
pageflags-introduce-macros-to-generate-page-flag-functions.patch
pageflags-convert-to-the-use-of-new-macros.patch
pageflags-use-proper-page-flag-functions-in-xen.patch
pageflags-eliminate-pg_xxx-aliases.patch
mm-fix-broken-gfp_zone-with-__gfp_thisnode.patch
mm-fix-usemap-initialization.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
revert-part-of-sched-cpuset-customize-sched-domains-core.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
reapply-sched-cpuset-customize-sched-domains-core-bits.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-the-trigger-callback-to-struct-cftype.patch
cgroups-implement-device-whitelist-v6.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-doc.patch
cgroups-implement-device-whitelist-v6-fix.patch
cgroups-use-a-hash-table-for-css_set-finding.patch
cgroups-simplify-init_subsys.patch
cgroups-remove-the-css_set-linked-list.patch
cgroups-introduce-cft-read_seq-v2.patch
cgroups-add-an-owner-to-the-mm_struct.patch
memcgroup-add-the-max_usage-member-on-the-res_counter.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
memcgroup-use-triggers-in-force_empty-and-max_usage-files.patch
memcgroup-implement-failcounter-reset.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
memcg-remove-redundant-function-calls.patch
memcgroup-make-the-memory-controller-more-desktop-responsive.patch
use-vmalloc-for-mem_cgroup-allocation-v3.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch

