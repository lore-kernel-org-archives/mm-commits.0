From: akpm@linux-foundation.org
Subject: + zram-zram-memory-size-limitation-fix-2.patch added to -mm tree
Date: Wed, 27 Aug 2014 12:49:39 -0700
Message-ID: <53fe3653.G1HqOv89GtkvehPq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:50379 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaH0Ttk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 15:49:40 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so122817oah.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 12:49:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-zram-memory-size-limitation-fix-2
has been added to the -mm tree.  Its filename is
     zram-zram-memory-size-limitation-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-zram-memory-size-limitation-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-zram-memory-size-limitation-fix-2.patch

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
Subject: zram-zram-memory-size-limitation-fix-2



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-zram-memory-size-limitation-fix-2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-zram-memory-size-limitation-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -139,9 +139,13 @@ static ssize_t mem_limit_store(struct de
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 limit;
+	char *tmp;
 	struct zram *zram = dev_to_zram(dev);
 
-	limit = memparse(buf, NULL);
+	limit = memparse(buf, &tmp);
+	if (buf == tmp) /* no chars parsed, invalid input */
+		return -EINVAL;
+
 	down_write(&zram->init_lock);
 	zram->limit_pages = PAGE_ALIGN(limit) >> PAGE_SHIFT;
 	up_write(&zram->init_lock);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-incorrectly-stat-with-failed_reads.patch
mm-zpool-use-prefixed-module-loading.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
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
zram-zram-memory-size-limitation-fix-fix.patch
zram-zram-memory-size-limitation-fix-2.patch
zram-report-maximum-used-memory.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

