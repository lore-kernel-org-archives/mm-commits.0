From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:55 -0800
Message-ID: <20121212195756.88EA520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40873 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:01 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so65681eei.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: allocate zone's pcp before onlining pages
has been removed from the -mm tree.  Its filename was
     memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: allocate zone's pcp before onlining pages

We use __free_page() to put a page to buddy system when onlining pages. 
__free_page() will store NR_FREE_PAGES in zone's pcp.vm_stat_diff, so we
should allocate zone's pcp before onlining pages, otherwise we will lose
some free pages.

[mhocko@suse.cz: make zone_pcp_reset independent of MEMORY_HOTREMOVE]
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++--
 mm/page_alloc.c     |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages
+++ a/mm/memory_hotplug.c
@@ -498,12 +498,16 @@ int __ref online_pages(unsigned long pfn
 	 * So, zonelist must be updated after online.
 	 */
 	mutex_lock(&zonelists_mutex);
-	if (!populated_zone(zone))
+	if (!populated_zone(zone)) {
 		need_zonelists_rebuild = 1;
+		build_all_zonelists(NULL, zone);
+	}
 
 	ret = walk_system_ram_range(pfn, nr_pages, &onlined_pages,
 		online_pages_range);
 	if (ret) {
+		if (need_zonelists_rebuild)
+			zone_pcp_reset(zone);
 		mutex_unlock(&zonelists_mutex);
 		printk(KERN_DEBUG "online_pages [mem %#010llx-%#010llx] failed\n",
 		       (unsigned long long) pfn << PAGE_SHIFT,
@@ -519,7 +523,7 @@ int __ref online_pages(unsigned long pfn
 	if (onlined_pages) {
 		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
 		if (need_zonelists_rebuild)
-			build_all_zonelists(NULL, zone);
+			build_all_zonelists(NULL, NULL);
 		else
 			zone_pcp_update(zone);
 	}
diff -puN mm/page_alloc.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages
+++ a/mm/page_alloc.c
@@ -5983,7 +5983,6 @@ void __meminit zone_pcp_update(struct zo
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
@@ -6003,6 +6002,7 @@ void zone_pcp_reset(struct zone *zone)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
  */
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
hotplug-update-nodemasks-management-fix.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
linux-next.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

