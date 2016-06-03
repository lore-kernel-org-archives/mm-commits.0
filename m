From: akpm@linux-foundation.org
Subject: + mm-add-nr_zsmalloc-to-vmstat.patch added to -mm tree
Date: Fri, 03 Jun 2016 14:18:47 -0700
Message-ID: <5751f437.DXQiYXJfB1pRBNgl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbcFCVSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:18:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, chan.jeong@lge.com, chanho.min@lge.com, sangseok.lee@lge.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add NR_ZSMALLOC to vmstat
has been added to the -mm tree.  Its filename is
     mm-add-nr_zsmalloc-to-vmstat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-nr_zsmalloc-to-vmstat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-nr_zsmalloc-to-vmstat.patch

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
Subject: mm: add NR_ZSMALLOC to vmstat

zram is very popular for some of the embedded world (e.g., TV, mobile
phones).  On those system, zsmalloc's consumed memory size is never
trivial (one of example from real product system, total memory: 800M,
zsmalloc consumed: 150M), so we have used this out of tree patch to
monitor system memory behavior via /proc/vmstat.

With zsmalloc in vmstat, it helps in tracking down system behavior due to
memory usage.

Link: http://lkml.kernel.org/r/1464919731-13255-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sangseok Lee <sangseok.lee@lge.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Chan Gyun Jeong <chan.jeong@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 mm/vmstat.c            |    4 +++-
 mm/zsmalloc.c          |    7 ++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-nr_zsmalloc-to-vmstat
+++ a/include/linux/mmzone.h
@@ -140,6 +140,9 @@ enum zone_stat_item {
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
 	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
+#ifdef CONFIG_ZSMALLOC
+	NR_ZSMALLOC,
+#endif
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
diff -puN mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat mm/vmstat.c
--- a/mm/vmstat.c~mm-add-nr_zsmalloc-to-vmstat
+++ a/mm/vmstat.c
@@ -718,7 +718,9 @@ const char * const vmstat_text[] = {
 	"nr_dirtied",
 	"nr_written",
 	"nr_pages_scanned",
-
+#ifdef CONFIG_ZSMALLOC
+	"nr_zsmalloc",
+#endif
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
diff -puN mm/zsmalloc.c~mm-add-nr_zsmalloc-to-vmstat mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-add-nr_zsmalloc-to-vmstat
+++ a/mm/zsmalloc.c
@@ -1022,6 +1022,7 @@ static void __free_zspage(struct zs_pool
 		reset_page(page);
 		unlock_page(page);
 		put_page(page);
+		dec_zone_page_state(page, NR_ZSMALLOC);
 		page = next;
 	} while (page != NULL);
 
@@ -1149,11 +1150,15 @@ static struct zspage *alloc_zspage(struc
 
 		page = alloc_page(gfp);
 		if (!page) {
-			while (--i >= 0)
+			while (--i >= 0) {
 				__free_page(pages[i]);
+				dec_zone_page_state(page, NR_ZSMALLOC);
+			}
 			cache_free_zspage(pool, zspage);
 			return NULL;
 		}
+
+		inc_zone_page_state(page, NR_ZSMALLOC);
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
mm-add-nr_zsmalloc-to-vmstat.patch

