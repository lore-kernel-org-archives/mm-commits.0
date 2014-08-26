From: akpm@linux-foundation.org
Subject: +
 zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch added to -mm tree
Date: Tue, 26 Aug 2014 14:39:40 -0700
Message-ID: <53fcfe9c.ychZAc83uFHfFbYQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:34023 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbaHZVjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:39:41 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so4054440pab.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:39:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, ds2horner@gmail.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: change return value unit of  zs_get_total_size_bytes
has been added to the -mm tree.  Its filename is
     zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch

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
Subject: zsmalloc: change return value unit of  zs_get_total_size_bytes

zs_get_total_size_bytes returns a amount of memory zsmalloc consumed with
*byte unit* but zsmalloc operates *page unit* rather than byte unit so
let's change the API so benefit we could get is that reduce unnecessary
overhead (ie, change page unit with byte unit) in zsmalloc.

Since return type is pages, "zs_get_total_pages" is better than
"zs_get_total_size_bytes".

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: <juno.choi@lge.com>
Cc: <seungho1.park@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: David Horner <ds2horner@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 include/linux/zsmalloc.h      |    2 +-
 mm/zsmalloc.c                 |    9 ++++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes
+++ a/drivers/block/zram/zram_drv.c
@@ -103,10 +103,10 @@ static ssize_t mem_used_total_show(struc
 
 	down_read(&zram->init_lock);
 	if (init_done(zram))
-		val = zs_get_total_size_bytes(meta->mem_pool);
+		val = zs_get_total_pages(meta->mem_pool);
 	up_read(&zram->init_lock);
 
-	return scnprintf(buf, PAGE_SIZE, "%llu\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
 }
 
 static ssize_t max_comp_streams_show(struct device *dev,
diff -puN include/linux/zsmalloc.h~zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes
+++ a/include/linux/zsmalloc.h
@@ -46,6 +46,6 @@ void *zs_map_object(struct zs_pool *pool
 			enum zs_mapmode mm);
 void zs_unmap_object(struct zs_pool *pool, unsigned long handle);
 
-u64 zs_get_total_size_bytes(struct zs_pool *pool);
+unsigned long zs_get_total_pages(struct zs_pool *pool);
 
 #endif
diff -puN mm/zsmalloc.c~zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes
+++ a/mm/zsmalloc.c
@@ -297,7 +297,7 @@ static void zs_zpool_unmap(void *pool, u
 
 static u64 zs_zpool_total_size(void *pool)
 {
-	return zs_get_total_size_bytes(pool);
+	return zs_get_total_pages(pool) << PAGE_SHIFT;
 }
 
 static struct zpool_driver zs_zpool_driver = {
@@ -1181,12 +1181,11 @@ void zs_unmap_object(struct zs_pool *poo
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
-u64 zs_get_total_size_bytes(struct zs_pool *pool)
+unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
-	u64 npages = atomic_long_read(&pool->pages_allocated);
-	return npages << PAGE_SHIFT;
+	return atomic_long_read(&pool->pages_allocated);
 }
-EXPORT_SYMBOL_GPL(zs_get_total_size_bytes);
+EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
 module_init(zs_init);
 module_exit(zs_exit);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-incorrectly-stat-with-failed_reads.patch
mm-zpool-use-prefixed-module-loading.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-zram-memory-size-limitation-fix.patch
zram-report-maximum-used-memory.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

