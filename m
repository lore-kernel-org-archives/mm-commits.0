From: akpm@linux-foundation.org
Subject: +
 drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch added
 to -mm tree
Date: Fri, 03 Oct 2014 12:37:11 -0700
Message-ID: <542efae7.r3c0xDBGrOfzwsDT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbaJCThL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 15:37:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-dma-contiguous-add-initialization-from-device-tree-fix
has been added to the -mm tree.  Its filename is
     drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: drivers-dma-contiguous-add-initialization-from-device-tree-fix



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree-fix drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree-fix
+++ a/drivers/base/dma-contiguous.c
@@ -223,13 +223,9 @@ bool dma_release_from_contiguous(struct
 #undef pr_fmt
 #define pr_fmt(fmt) fmt
 
-static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+static void rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
-	struct cma *cma = rmem->priv;
-	if (!cma)
-		return -ENODEV;
-
-	dev_set_cma_area(dev, cma);
+	dev_set_cma_area(dev, rmem->priv);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mina86@mina86.com are

mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
include-kernelh-deduplicate-code-implementing-clamp-macros.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

