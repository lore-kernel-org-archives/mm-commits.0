From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:20 -0700
Message-ID: <51db125c.G/fn1K2OdimA+vG9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GHT0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:20 -0700


The patch titled
     Subject: mm: use a dedicated lock to protect totalram_pages and zone->managed_pages
has been removed from the -mm tree.  Its filename was
     mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: use a dedicated lock to protect totalram_pages and zone->managed_pages

Currently lock_memory_hotplug()/unlock_memory_hotplug() are used to
protect totalram_pages and zone->managed_pages.  Other than the memory
hotplug driver, totalram_pages and zone->managed_pages may also be
modified at runtime by other drivers, such as Xen balloon, virtio_balloon
etc.  For those cases, memory hotplug lock is a little too heavy, so
introduce a dedicated lock to protect totalram_pages and
zone->managed_pages.

Now we have a simplified locking rules totalram_pages and
zone->managed_pages as:
1) no locking for read accesses because they are unsigned long.
2) no locking for write accesses at boot time in single-threaded context.
3) serialize write accesses at runtime by acquiring the dedicated
   managed_page_count_lock.

Also adjust zone->managed_pages when freeing reserved pages into the buddy
system, to keep totalram_pages and zone->managed_pages in consistence.

[akpm@linux-foundation.org: don't export adjust_managed_page_count to modules (for now)]
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h     |    6 ++----
 include/linux/mmzone.h |   14 ++++++++++----
 mm/page_alloc.c        |   11 +++++++++++
 3 files changed, 23 insertions(+), 8 deletions(-)

diff -puN include/linux/mm.h~mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages include/linux/mm.h
--- a/include/linux/mm.h~mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages
+++ a/include/linux/mm.h
@@ -1313,6 +1313,7 @@ extern void free_initmem(void);
  */
 extern unsigned long free_reserved_area(void *start, void *end,
 					int poison, char *s);
+
 #ifdef	CONFIG_HIGHMEM
 /*
  * Free a highmem page into the buddy system, adjusting totalhigh_pages
@@ -1321,10 +1322,7 @@ extern unsigned long free_reserved_area(
 extern void free_highmem_page(struct page *page);
 #endif
 
-static inline void adjust_managed_page_count(struct page *page, long count)
-{
-	totalram_pages += count;
-}
+extern void adjust_managed_page_count(struct page *page, long count);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void __free_reserved_page(struct page *page)
diff -puN include/linux/mmzone.h~mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages
+++ a/include/linux/mmzone.h
@@ -474,10 +474,16 @@ struct zone {
 	 * frequently read in proximity to zone->lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
-	 * Write access to present_pages and managed_pages at runtime should
-	 * be protected by lock_memory_hotplug()/unlock_memory_hotplug().
-	 * Any reader who can't tolerant drift of present_pages and
-	 * managed_pages should hold memory hotplug lock to get a stable value.
+	 * Write access to present_pages at runtime should be protected by
+	 * lock_memory_hotplug()/unlock_memory_hotplug().  Any reader who can't
+	 * tolerant drift of present_pages should hold memory hotplug lock to
+	 * get a stable value.
+	 *
+	 * Read access to managed_pages should be safe because it's unsigned
+	 * long. Write access to zone->managed_pages and totalram_pages are
+	 * protected by managed_page_count_lock at runtime. Idealy only
+	 * adjust_managed_page_count() should be used instead of directly
+	 * touching zone->managed_pages and totalram_pages.
 	 */
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
diff -puN mm/page_alloc.c~mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages
+++ a/mm/page_alloc.c
@@ -103,6 +103,9 @@ nodemask_t node_states[NR_NODE_STATES] _
 };
 EXPORT_SYMBOL(node_states);
 
+/* Protect totalram_pages and zone->managed_pages */
+static DEFINE_SPINLOCK(managed_page_count_lock);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 /*
@@ -5206,6 +5209,14 @@ early_param("movablecore", cmdline_parse
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
+void adjust_managed_page_count(struct page *page, long count)
+{
+	spin_lock(&managed_page_count_lock);
+	page_zone(page)->managed_pages += count;
+	totalram_pages += count;
+	spin_unlock(&managed_page_count_lock);
+}
+
 unsigned long free_reserved_area(void *start, void *end, int poison, char *s)
 {
 	void *pos;
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

