From: akpm@linux-foundation.org
Subject: [folded-merged] zram-zram-memory-size-limitation-fix-2.patch
 removed from -mm tree
Date: Thu, 09 Oct 2014 13:47:06 -0700
Message-ID: <5436f44a.MaAZwFEs/0YYRxq0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJIUrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:47:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-zram-memory-size-limitation-fix-2
has been removed from the -mm tree.  Its filename was
     zram-zram-memory-size-limitation-fix-2.patch

This patch was dropped because it was folded into zram-zram-memory-size-limitation.patch

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

mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
introduce-dump_vma.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
zram-use-notify_free-to-account-all-free-notifications.patch
mm-correct-comment-for-fullness-group-computation-in-zsmallocc.patch
zsmalloc-simplify-init_zspage-free-obj-linking.patch

