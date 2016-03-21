From: akpm@linux-foundation.org
Subject: [merged]
 calculate-available-memory-in-the-separate-function.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:39:17 -0700
Message-ID: <56f03fd5.UAYRMWfWjvKpmexp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: redkoi@virtuozzo.com, den@openvz.org, mst@redhat.com, rkagan@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: calculate 'available' memory in a separate function
has been removed from the -mm tree.  Its filename was
     calculate-available-memory-in-the-separate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Igor Redko <redkoi@virtuozzo.com>
Subject: mm/page_alloc.c: calculate 'available' memory in a separate function

Add a new field, VIRTIO_BALLOON_S_AVAIL, to virtio_balloon memory
statistics protocol, corresponding to 'Available' in /proc/meminfo.

It indicates to the hypervisor how big the balloon can be inflated without
pushing the guest system to swap.  This metric would be very useful in VM
orchestration software to improve memory management of different VMs under
overcommit.


This patch (of 2):

Factor out calculation of the available memory counter into a separate
exportable function, in order to be able to use it in other parts of the
kernel.

In particular, it appears a relevant metric to report to the hypervisor
via virtio-balloon statistics interface (in a followup patch).

Signed-off-by: Igor Redko <redkoi@virtuozzo.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: Roman Kagan <rkagan@virtuozzo.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c  |   31 +------------------------------
 include/linux/mm.h |    1 +
 mm/page_alloc.c    |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 30 deletions(-)

diff -puN fs/proc/meminfo.c~calculate-available-memory-in-the-separate-function fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~calculate-available-memory-in-the-separate-function
+++ a/fs/proc/meminfo.c
@@ -29,10 +29,7 @@ static int meminfo_proc_show(struct seq_
 	unsigned long committed;
 	long cached;
 	long available;
-	unsigned long pagecache;
-	unsigned long wmark_low = 0;
 	unsigned long pages[NR_LRU_LISTS];
-	struct zone *zone;
 	int lru;
 
 /*
@@ -51,33 +48,7 @@ static int meminfo_proc_show(struct seq_
 	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
 		pages[lru] = global_page_state(NR_LRU_BASE + lru);
 
-	for_each_zone(zone)
-		wmark_low += zone->watermark[WMARK_LOW];
-
-	/*
-	 * Estimate the amount of memory available for userspace allocations,
-	 * without causing swapping.
-	 */
-	available = i.freeram - totalreserve_pages;
-
-	/*
-	 * Not all the page cache can be freed, otherwise the system will
-	 * start swapping. Assume at least half of the page cache, or the
-	 * low watermark worth of cache, needs to stay.
-	 */
-	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
-	pagecache -= min(pagecache / 2, wmark_low);
-	available += pagecache;
-
-	/*
-	 * Part of the reclaimable slab consists of items that are in use,
-	 * and cannot be freed. Cap this estimate at the low watermark.
-	 */
-	available += global_page_state(NR_SLAB_RECLAIMABLE) -
-		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
-
-	if (available < 0)
-		available = 0;
+	available = si_mem_available();
 
 	/*
 	 * Tagged format, for easy grepping and expansion.
diff -puN include/linux/mm.h~calculate-available-memory-in-the-separate-function include/linux/mm.h
--- a/include/linux/mm.h~calculate-available-memory-in-the-separate-function
+++ a/include/linux/mm.h
@@ -1875,6 +1875,7 @@ extern int __meminit init_per_zone_wmark
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
+extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
diff -puN mm/page_alloc.c~calculate-available-memory-in-the-separate-function mm/page_alloc.c
--- a/mm/page_alloc.c~calculate-available-memory-in-the-separate-function
+++ a/mm/page_alloc.c
@@ -3713,6 +3713,49 @@ static inline void show_node(struct zone
 		printk("Node %d ", zone_to_nid(zone));
 }
 
+long si_mem_available(void)
+{
+	long available;
+	unsigned long pagecache;
+	unsigned long wmark_low = 0;
+	unsigned long pages[NR_LRU_LISTS];
+	struct zone *zone;
+	int lru;
+
+	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
+		pages[lru] = global_page_state(NR_LRU_BASE + lru);
+
+	for_each_zone(zone)
+		wmark_low += zone->watermark[WMARK_LOW];
+
+	/*
+	 * Estimate the amount of memory available for userspace allocations,
+	 * without causing swapping.
+	 */
+	available = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
+
+	/*
+	 * Not all the page cache can be freed, otherwise the system will
+	 * start swapping. Assume at least half of the page cache, or the
+	 * low watermark worth of cache, needs to stay.
+	 */
+	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
+	pagecache -= min(pagecache / 2, wmark_low);
+	available += pagecache;
+
+	/*
+	 * Part of the reclaimable slab consists of items that are in use,
+	 * and cannot be freed. Cap this estimate at the low watermark.
+	 */
+	available += global_page_state(NR_SLAB_RECLAIMABLE) -
+		     min(global_page_state(NR_SLAB_RECLAIMABLE) / 2, wmark_low);
+
+	if (available < 0)
+		available = 0;
+	return available;
+}
+EXPORT_SYMBOL_GPL(si_mem_available);
+
 void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages;
_

Patches currently in -mm which might be from redkoi@virtuozzo.com are


