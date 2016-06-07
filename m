From: akpm@linux-foundation.org
Subject: + mm-add-nr_zsmalloc-to-vmstat-fix-2.patch added to -mm tree
Date: Tue, 07 Jun 2016 12:55:47 -0700
Message-ID: <575726c3.k4h1AmbIo/F40TNQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161210AbcFGTzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 15:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: follow up zsmalloc vmstat
has been added to the -mm tree.  Its filename is
     mm-add-nr_zsmalloc-to-vmstat-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-nr_zsmalloc-to-vmstat-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1021,8 +1021,8 @@ static void __free_zspage(struct zs_pool
 		next = get_next_page(page);
 		reset_page(page);
 		unlock_page(page);
+		dec_zone_page_state(page, NR_ZSPAGES);
 		put_page(page);
-		dec_zone_page_state(page, NR_ZSMALLOC);
 		page = next;
 	} while (page != NULL);
 
@@ -1151,14 +1151,14 @@ static struct zspage *alloc_zspage(struc
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
zsmalloc-page-migration-support-fix.patch
zram-use-__gfp_movable-for-memory-allocation.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch

