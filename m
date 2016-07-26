From: akpm@linux-foundation.org
Subject: [folded-merged] mm-add-nr_zsmalloc-to-vmstat-fix-2.patch removed
 from -mm tree
Date: Tue, 26 Jul 2016 14:58:27 -0700
Message-ID: <5797dd03.oXAytaxdzBLtdpsJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbcGZV62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:58:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: follow up zsmalloc vmstat
has been removed from the -mm tree.  Its filename was
     mm-add-nr_zsmalloc-to-vmstat-fix-2.patch

This patch was dropped because it was folded into mm-add-nr_zsmalloc-to-vmstat.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: follow up zsmalloc vmstat

It's follow-up patch based on comment and report of static checker.

* Use more general term 'zspages' rather than 'zsmalloc' - Sergey
* decrease zone stat NR_ZSPAGES on right page - Dan

Link: http://lkml.kernel.org/r/20160607091737.GC23435@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmstat.c            |    2 +-
 mm/zsmalloc.c          |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat-fix-2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat-fix-2
+++ a/include/linux/mmzone.h
@@ -141,7 +141,7 @@ enum zone_stat_item {
 	NR_WRITTEN,		/* page writings since bootup */
 	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
 #if IS_ENABLED(CONFIG_ZSMALLOC)
-	NR_ZSMALLOC,
+	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
diff -puN mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat-fix-2 mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat-fix-2
+++ a/mm/vmstat.c
@@ -719,7 +719,7 @@ const char * const vmstat_text[] = {
 	"nr_written",
 	"nr_pages_scanned",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
-	"nr_zsmalloc",
+	"nr_zspages",
 #endif
 #ifdef CONFIG_NUMA
 	"numa_hit",
diff -puN mm/zsmalloc.c~mm-add-nr_zsmalloc-to-vmstat-fix-2 mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-add-nr_zsmalloc-to-vmstat-fix-2
+++ a/mm/zsmalloc.c
@@ -1007,8 +1007,8 @@ static void __free_zspage(struct zs_pool
 		next = get_next_page(page);
 		reset_page(page);
 		unlock_page(page);
+		dec_zone_page_state(page, NR_ZSPAGES);
 		put_page(page);
-		dec_zone_page_state(page, NR_ZSMALLOC);
 		page = next;
 	} while (page != NULL);
 
@@ -1139,14 +1139,14 @@ static struct zspage *alloc_zspage(struc
 		page = alloc_page(gfp);
 		if (!page) {
 			while (--i >= 0) {
+				dec_zone_page_state(pages[i], NR_ZSPAGES);
 				__free_page(pages[i]);
-				dec_zone_page_state(page, NR_ZSMALLOC);
 			}
 			cache_free_zspage(pool, zspage);
 			return NULL;
 		}
 
-		inc_zone_page_state(page, NR_ZSMALLOC);
+		inc_zone_page_state(page, NR_ZSPAGES);
 		pages[i] = page;
 	}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-fix-build-warnings-in-linux-compactionh.patch

