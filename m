From: akpm@linux-foundation.org
Subject: + calculate-available-memory-in-the-separate-function.patch added to -mm tree
Date: Tue, 16 Feb 2016 16:28:11 -0800
Message-ID: <56c3be9b.WT1iuoiwT5v5xzAO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422AbcBQA2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 19:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: redkoi@virtuozzo.com, den@openvz.org, mst@redhat.com, rkagan@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: calculate 'available' memory in a separate function
has been added to the -mm tree.  Its filename is
     calculate-available-memory-in-the-separate-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/calculate-available-memory-in-the-separate-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/calculate-available-memory-in-the-separate-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1876,6 +1876,7 @@ extern int __meminit init_per_zone_wmark
 extern void mem_init(void);
 extern void __init mmap_init(void);
 extern void show_mem(unsigned int flags);
+extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
diff -puN mm/page_alloc.c~calculate-available-memory-in-the-separate-function mm/page_alloc.c
--- a/mm/page_alloc.c~calculate-available-memory-in-the-separate-function
+++ a/mm/page_alloc.c
@@ -3710,6 +3710,49 @@ static inline void show_node(struct zone
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

calculate-available-memory-in-the-separate-function.patch
virtio_balloon-export-available-memory-to-balloon-statistics.patch

