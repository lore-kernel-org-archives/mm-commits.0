From: akpm@linux-foundation.org
Subject: +
 cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2.patch added to -mm tree
Date: Tue, 06 Jan 2015 14:32:51 -0800
Message-ID: <54ac6293.8u3ym8ASZHw5RCVB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbbAFWcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 17:32:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, liuweixing@xiaomi.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, vbabka@suse.cz, zhuhui@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2
has been added to the -mm tree.  Its filename is
     cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2

fix build with CONFIG_CMA=n

Cc: David Rientjes <rientjes@google.com>
Cc: Hui Zhu <zhuhui@xiaomi.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Weixing Liu <liuweixing@xiaomi.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |   36 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c     |   31 +++++++++++++++----------------
 2 files changed, 51 insertions(+), 16 deletions(-)

diff -puN include/linux/cma.h~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2 include/linux/cma.h
--- a/include/linux/cma.h~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2
+++ a/include/linux/cma.h
@@ -1,6 +1,8 @@
 #ifndef __CMA_H__
 #define __CMA_H__
 
+#include <linux/mmzone.h>
+
 /*
  * There is always at least global CMA area and a few optional
  * areas configured in kernel .config.
@@ -28,4 +30,38 @@ extern int cma_init_reserved_mem(phys_ad
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
 extern bool cma_release(struct cma *cma, struct page *pages, int count);
+
+#ifdef CONFIG_CMA
+static inline void cma_nr_free_add(int migratetype, struct free_area *area,
+				   int delta)
+{
+	if (is_migrate_cma(migratetype))
+		area->cma_nr_free += delta;
+}
+
+static inline void cma_nr_free_inc(int migratetype, struct free_area *area)
+{
+	cma_nr_free_add(migratetype, area, 1);
+}
+
+static inline void cma_nr_free_dec(int migratetype, struct free_area *area)
+{
+	cma_nr_free_add(migratetype, area, -1);
+}
+#else
+static inline void cma_nr_free_add(int migratetype, struct free_area *area,
+				   int delta)
+{
+}
+
+static inline void cma_nr_free_inc(int migratetype, struct free_area *area)
+{
+}
+
+static inline void cma_nr_free_dec(int migratetype, struct free_area *area)
+{
+}
+#endif		/* CONFIG_CMA */
+
+
 #endif
diff -puN mm/page_alloc.c~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2
+++ a/mm/page_alloc.c
@@ -32,6 +32,8 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/oom.h>
+#include <linux/mmzone.h>
+#include <linux/cma.h>
 #include <linux/notifier.h>
 #include <linux/topology.h>
 #include <linux/sysctl.h>
@@ -650,8 +652,7 @@ static inline void __free_one_page(struc
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
-			if (is_migrate_cma(migratetype))
-				zone->free_area[order].cma_nr_free--;
+			cma_nr_free_dec(migratetype, &zone->free_area[order]);
 			rmv_page_order(buddy);
 		}
 		combined_idx = buddy_idx & page_idx;
@@ -685,8 +686,7 @@ static inline void __free_one_page(struc
 	list_add(&page->lru, &zone->free_area[order].free_list[migratetype]);
 out:
 	zone->free_area[order].nr_free++;
-	if (is_migrate_cma(migratetype))
-		zone->free_area[order].cma_nr_free++;
+	cma_nr_free_inc(migratetype, &zone->free_area[order]);
 }
 
 static inline int free_pages_check(struct page *page)
@@ -941,8 +941,7 @@ static inline void expand(struct zone *z
 		}
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
-		if (is_migrate_cma(migratetype))
-			area->cma_nr_free++;
+		cma_nr_free_inc(migratetype, area);
 		set_page_order(&page[size], high);
 	}
 }
@@ -1026,8 +1025,7 @@ struct page *__rmqueue_smallest(struct z
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
-		if (is_migrate_cma(migratetype))
-			area->cma_nr_free--;
+		cma_nr_free_dec(migratetype, area);
 		expand(zone, page, order, current_order, area, migratetype);
 		set_freepage_migratetype(page, migratetype);
 		return page;
@@ -1216,8 +1214,7 @@ __rmqueue_fallback(struct zone *zone, un
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
 			area->nr_free--;
-			if (is_migrate_cma(migratetype))
-				area->cma_nr_free--;
+			cma_nr_free_dec(migratetype, area);
 
 			new_type = try_to_steal_freepages(zone, page,
 							  start_migratetype,
@@ -1607,8 +1604,7 @@ int __isolate_free_page(struct page *pag
 	/* Remove page from free list */
 	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
-	if (is_migrate_cma(mt))
-		zone->free_area[order].cma_nr_free--;
+	cma_nr_free_dec(mt, &zone->free_area[order]);
 	rmv_page_order(page);
 
 	/* Set the pageblock if the isolated page is at least a pageblock */
@@ -1845,9 +1841,10 @@ static bool __zone_watermark_ok(struct z
 		 * "z->free_area[o].nr_free << o" subtracted CMA's page number
 		 * of this order again.  So add it back.
 		 */
-		if (IS_ENABLED(CONFIG_CMA) && free_cma)
+#ifdef COFNIG_CMA
+		if (free_cma)
 			free_pages += z->free_area[o].cma_nr_free << o;
-
+#endif
 		/* Require fewer higher order pages to be free */
 		min >>= 1;
 
@@ -4249,7 +4246,9 @@ static void __meminit zone_init_free_lis
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
+#ifdef CONFIG_CMA
 		zone->free_area[order].cma_nr_free = 0;
+#endif
 	}
 }
 
@@ -6622,8 +6621,8 @@ __offline_isolated_pages(unsigned long s
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
-		if (is_migrate_cma(get_pageblock_migratetype(page)))
-			zone->free_area[order].cma_nr_free--;
+		cma_nr_free_dec(get_pageblock_migratetype(page),
+				&zone->free_area[order]);
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix-2.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

