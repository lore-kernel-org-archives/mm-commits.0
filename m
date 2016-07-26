From: akpm@linux-foundation.org
Subject: [patch 077/126] mm: add NR_ZSMALLOC to vmstat
Date: Tue, 26 Jul 2016 15:24:45 -0700
Message-ID: <5797e32d.K4BMNTaIjiedYKPc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbcGZWYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, chan.jeong@lge.com, chanho.min@lge.com, sangseok.lee@lge.com, sergey.senozhatsky.work@gmail.com

From: Minchan Kim <minchan@kernel.org>
Subject: mm: add NR_ZSMALLOC to vmstat

zram is very popular for some of the embedded world (e.g., TV, mobile
phones).  On those system, zsmalloc's consumed memory size is never
trivial (one of example from real product system, total memory: 800M,
zsmalloc consumed: 150M), so we have used this out of tree patch to
monitor system memory behavior via /proc/vmstat.

With zsmalloc in vmstat, it helps in tracking down system behavior due to
memory usage.

[minchan@kernel.org: zsmalloc: follow up zsmalloc vmstat]
  Link: http://lkml.kernel.org/r/20160607091737.GC23435@bbox
[akpm@linux-foundation.org: fix build with CONFIG_ZSMALLOC=m]
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
+#if IS_ENABLED(CONFIG_ZSMALLOC)
+	NR_ZSPAGES,		/* allocated in zsmalloc */
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
+#if IS_ENABLED(CONFIG_ZSMALLOC)
+	"nr_zspages",
+#endif
 #ifdef CONFIG_NUMA
 	"numa_hit",
 	"numa_miss",
diff -puN mm/zsmalloc.c~mm-add-nr_zsmalloc-to-vmstat mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-add-nr_zsmalloc-to-vmstat
+++ a/mm/zsmalloc.c
@@ -1007,6 +1007,7 @@ static void __free_zspage(struct zs_pool
 		next = get_next_page(page);
 		reset_page(page);
 		unlock_page(page);
+		dec_zone_page_state(page, NR_ZSPAGES);
 		put_page(page);
 		page = next;
 	} while (page != NULL);
@@ -1137,11 +1138,15 @@ static struct zspage *alloc_zspage(struc
 
 		page = alloc_page(gfp);
 		if (!page) {
-			while (--i >= 0)
+			while (--i >= 0) {
+				dec_zone_page_state(pages[i], NR_ZSPAGES);
 				__free_page(pages[i]);
+			}
 			cache_free_zspage(pool, zspage);
 			return NULL;
 		}
+
+		inc_zone_page_state(page, NR_ZSPAGES);
 		pages[i] = page;
 	}
 
_
