From: akpm@linux-foundation.org
Subject: [merged] mm-correctly-update-zone-managed_pages.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:26:24 -0700
Message-ID: <51db1260.WjsU/LwqimN4B6AK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3GHT00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, sergei.shtylyov@cogentembedded.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, fengguang.wu@intel.com, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-correctly-update-zone-managed_pages.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,fengguang.wu@intel.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sergei.shtylyov@cogentembedded.com,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:24 -0700


The patch titled
     Subject: mm: correctly update zone->managed_pages
has been removed from the -mm tree.  Its filename was
     mm-correctly-update-zone-managed_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: correctly update zone->managed_pages

Enhance adjust_managed_page_count() to adjust totalhigh_pages for highmem
pages.  And change code which directly adjusts totalram_pages to use
adjust_managed_page_count() because it adjusts totalram_pages,
totalhigh_pages and zone->managed_pages altogether in a safe way.

Remove inc_totalhigh_pages() and dec_totalhigh_pages() from xen/balloon
driver bacause adjust_managed_page_count() has already adjusted
totalhigh_pages.

This patch also fixes two bugs:
1) enhances virtio_balloon driver to adjust totalhigh_pages when
   reserve/unreserve pages.
2) enhance memory_hotplug.c to adjust totalhigh_pages when hot-removing
   memory.

We still need to deal with modifications of totalram_pages in file
arch/powerpc/platforms/pseries/cmm.c, but need help from PPC experts.

[akpm@linux-foundation.org: remove ifdef, per Wanpeng Li, virtio_balloon.c cleanup, per Sergei]
[akpm@linux-foundation.org: export adjust_managed_page_count() to modules, for drivers/virtio/virtio_balloon.c]
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    7 ++++---
 drivers/xen/balloon.c           |   23 +++++------------------
 mm/hugetlb.c                    |    2 +-
 mm/memory_hotplug.c             |   16 +++-------------
 mm/page_alloc.c                 |   11 ++++++-----
 5 files changed, 19 insertions(+), 40 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~mm-correctly-update-zone-managed_pages drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-correctly-update-zone-managed_pages
+++ a/drivers/virtio/virtio_balloon.c
@@ -148,7 +148,7 @@ static void fill_balloon(struct virtio_b
 		}
 		set_page_pfns(vb->pfns + vb->num_pfns, page);
 		vb->num_pages += VIRTIO_BALLOON_PAGES_PER_PAGE;
-		totalram_pages--;
+		adjust_managed_page_count(page, -1);
 	}
 
 	/* Did we get any? */
@@ -163,8 +163,9 @@ static void release_pages_by_pfn(const u
 
 	/* Find pfns pointing at start of each page, get pages and free them. */
 	for (i = 0; i < num; i += VIRTIO_BALLOON_PAGES_PER_PAGE) {
-		balloon_page_free(balloon_pfn_to_page(pfns[i]));
-		totalram_pages++;
+		struct page *page = balloon_pfn_to_page(pfns[i]);
+		balloon_page_free(page);
+		adjust_managed_page_count(page, 1);
 	}
 }
 
diff -puN drivers/xen/balloon.c~mm-correctly-update-zone-managed_pages drivers/xen/balloon.c
--- a/drivers/xen/balloon.c~mm-correctly-update-zone-managed_pages
+++ a/drivers/xen/balloon.c
@@ -89,14 +89,6 @@ EXPORT_SYMBOL_GPL(balloon_stats);
 /* We increase/decrease in batches which fit in a page */
 static xen_pfn_t frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
-#ifdef CONFIG_HIGHMEM
-#define inc_totalhigh_pages() (totalhigh_pages++)
-#define dec_totalhigh_pages() (totalhigh_pages--)
-#else
-#define inc_totalhigh_pages() do {} while (0)
-#define dec_totalhigh_pages() do {} while (0)
-#endif
-
 /* List of ballooned pages, threaded through the mem_map array. */
 static LIST_HEAD(ballooned_pages);
 
@@ -132,9 +124,7 @@ static void __balloon_append(struct page
 static void balloon_append(struct page *page)
 {
 	__balloon_append(page);
-	if (PageHighMem(page))
-		dec_totalhigh_pages();
-	totalram_pages--;
+	adjust_managed_page_count(page, -1);
 }
 
 /* balloon_retrieve: rescue a page from the balloon, if it is not empty. */
@@ -151,13 +141,12 @@ static struct page *balloon_retrieve(boo
 		page = list_entry(ballooned_pages.next, struct page, lru);
 	list_del(&page->lru);
 
-	if (PageHighMem(page)) {
+	if (PageHighMem(page))
 		balloon_stats.balloon_high--;
-		inc_totalhigh_pages();
-	} else
+	else
 		balloon_stats.balloon_low--;
 
-	totalram_pages++;
+	adjust_managed_page_count(page, 1);
 
 	return page;
 }
@@ -372,9 +361,7 @@ static enum bp_state increase_reservatio
 #endif
 
 		/* Relinquish the page back to the allocator. */
-		ClearPageReserved(page);
-		init_page_count(page);
-		__free_page(page);
+		__free_reserved_page(page);
 	}
 
 	balloon_stats.current_pages += rc;
diff -puN mm/hugetlb.c~mm-correctly-update-zone-managed_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-correctly-update-zone-managed_pages
+++ a/mm/hugetlb.c
@@ -1263,7 +1263,7 @@ static void __init gather_bootmem_preall
 		 * side-effects, like CommitLimit going negative.
 		 */
 		if (h->order > (MAX_ORDER - 1))
-			totalram_pages += 1 << h->order;
+			adjust_managed_page_count(page, 1 << h->order);
 	}
 }
 
diff -puN mm/memory_hotplug.c~mm-correctly-update-zone-managed_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-correctly-update-zone-managed_pages
+++ a/mm/memory_hotplug.c
@@ -772,20 +772,13 @@ EXPORT_SYMBOL_GPL(__online_page_set_limi
 
 void __online_page_increment_counters(struct page *page)
 {
-	totalram_pages++;
-
-#ifdef CONFIG_HIGHMEM
-	if (PageHighMem(page))
-		totalhigh_pages++;
-#endif
+	adjust_managed_page_count(page, 1);
 }
 EXPORT_SYMBOL_GPL(__online_page_increment_counters);
 
 void __online_page_free(struct page *page)
 {
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
+	__free_reserved_page(page);
 }
 EXPORT_SYMBOL_GPL(__online_page_free);
 
@@ -983,7 +976,6 @@ int __ref online_pages(unsigned long pfn
 		return ret;
 	}
 
-	zone->managed_pages += onlined_pages;
 	zone->present_pages += onlined_pages;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
@@ -1572,15 +1564,13 @@ repeat:
 	/* reset pagetype flags and makes migrate type to be MOVABLE */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	/* removal success */
-	zone->managed_pages -= offlined_pages;
+	adjust_managed_page_count(pfn_to_page(start_pfn), -offlined_pages);
 	zone->present_pages -= offlined_pages;
 
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
-	totalram_pages -= offlined_pages;
-
 	init_per_zone_wmark_min();
 
 	if (!populated_zone(zone)) {
diff -puN mm/page_alloc.c~mm-correctly-update-zone-managed_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-correctly-update-zone-managed_pages
+++ a/mm/page_alloc.c
@@ -780,11 +780,7 @@ void __init init_cma_reserved_pageblock(
 	set_page_refcounted(page);
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	__free_pages(page, pageblock_order);
-	totalram_pages += pageblock_nr_pages;
-#ifdef CONFIG_HIGHMEM
-	if (PageHighMem(page))
-		totalhigh_pages += pageblock_nr_pages;
-#endif
+	adjust_managed_page_count(page, pageblock_nr_pages);
 }
 #endif
 
@@ -5207,8 +5203,13 @@ void adjust_managed_page_count(struct pa
 	spin_lock(&managed_page_count_lock);
 	page_zone(page)->managed_pages += count;
 	totalram_pages += count;
+#ifdef CONFIG_HIGHMEM
+	if (PageHighMem(page))
+		totalhigh_pages += count;
+#endif
 	spin_unlock(&managed_page_count_lock);
 }
+EXPORT_SYMBOL(adjust_managed_page_count);
 
 unsigned long free_reserved_area(void *start, void *end, int poison, char *s)
 {
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

