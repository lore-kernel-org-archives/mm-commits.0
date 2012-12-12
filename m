From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-fix-nr_free_pages-mismatch.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:38 -0800
Message-ID: <20121212195739.90D2420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64496 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2LLT5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:44 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so65301fae.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, dave@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, len.brown@intel.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, paulus@samba.org, rientjes@google.com, wujianguo106@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix NR_FREE_PAGES mismatch
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-nr_free_pages-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory-hotplug: fix NR_FREE_PAGES mismatch

NR_FREE_PAGES will be wrong after offlining pages.  We add/dec
NR_FREE_PAGES like this now:

1. move all pages in buddy system to MIGRATE_ISOLATE, and dec NR_FREE_PAGES

2. don't add NR_FREE_PAGES when it is freed and the migratetype is
   MIGRATE_ISOLATE

3. dec NR_FREE_PAGES when offlining isolated pages.

4. add NR_FREE_PAGES when undoing isolate pages.

When we come to step 3, all pages are in MIGRATE_ISOLATE list, and
NR_FREE_PAGES are right.  When we come to step4, all pages are not in
buddy system, so we don't change NR_FREE_PAGES in this step, but we change
NR_FREE_PAGES in step3.  So NR_FREE_PAGES is wrong after offlining pages. 
So there is no need to change NR_FREE_PAGES in step3.

This patch also fixs a problem in step2: if the migratetype is
MIGRATE_ISOLATE, we should not add NR_FRR_PAGES when we remove pages from
pcppages.

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
Cc: Jianguo Wu <wujianguo106@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-nr_free_pages-mismatch mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-nr_free_pages-mismatch
+++ a/mm/page_alloc.c
@@ -667,11 +667,13 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (is_migrate_cma(mt))
-				__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
+			if (likely(get_pageblock_migratetype(page) != MIGRATE_ISOLATE)) {
+				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
+				if (is_migrate_cma(mt))
+					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
+			}
 		} while (--to_free && --batch_free && !list_empty(list));
 	}
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	spin_unlock(&zone->lock);
 }
 
@@ -6047,8 +6049,6 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES,
-				      - (1UL << order));
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
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

