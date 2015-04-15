From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-cma-add-functions-to-get-region-pages-counters-fix.patch removed from
 -mm tree
Date: Wed, 15 Apr 2015 15:42:35 -0700
Message-ID: <552ee95b.1hGZXbYa3apkwrWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbbDOWmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.mateosian@samsung.com, d.safonov@partner.samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, pintu.k@samsung.com, stefan.strogin@gmail.com, v.tyrtov@samsung.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-add-functions-to-get-region-pages-counters-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-add-functions-to-get-region-pages-counters-fix.patch

This patch was dropped because it was folded into mm-cma-add-functions-to-get-region-pages-counters.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-add-functions-to-get-region-pages-counters-fix

move debug code from cma.c into cma_debug.c so it doesn't get included in
CONFIG_CMA_DEBUGFS=n builds

Cc: Dmitry Safonov <d.safonov@partner.samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: Aleksei Mateosian <a.mateosian@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    2 --
 mm/cma.c            |   30 ------------------------------
 mm/cma_debug.c      |   31 +++++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 32 deletions(-)

diff -puN include/linux/cma.h~mm-cma-add-functions-to-get-region-pages-counters-fix include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-add-functions-to-get-region-pages-counters-fix
+++ a/include/linux/cma.h
@@ -18,8 +18,6 @@ struct cma;
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
 extern unsigned long cma_get_size(const struct cma *cma);
-extern unsigned long cma_get_used(struct cma *cma);
-extern unsigned long cma_get_maxchunk(struct cma *cma);
 
 extern int __init cma_declare_contiguous(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
diff -puN mm/cma.c~mm-cma-add-functions-to-get-region-pages-counters-fix mm/cma.c
--- a/mm/cma.c~mm-cma-add-functions-to-get-region-pages-counters-fix
+++ a/mm/cma.c
@@ -53,36 +53,6 @@ unsigned long cma_get_size(const struct
 	return cma->count << PAGE_SHIFT;
 }
 
-unsigned long cma_get_used(struct cma *cma)
-{
-	unsigned long ret = 0;
-
-	mutex_lock(&cma->lock);
-	/* pages counter is smaller than sizeof(int) */
-	ret = bitmap_weight(cma->bitmap, (int)cma->count);
-	mutex_unlock(&cma->lock);
-
-	return ret << cma->order_per_bit;
-}
-
-unsigned long cma_get_maxchunk(struct cma *cma)
-{
-	unsigned long maxchunk = 0;
-	unsigned long start, end = 0;
-
-	mutex_lock(&cma->lock);
-	for (;;) {
-		start = find_next_zero_bit(cma->bitmap, cma->count, end);
-		if (start >= cma->count)
-			break;
-		end = find_next_bit(cma->bitmap, cma->count, start);
-		maxchunk = max(end - start, maxchunk);
-	}
-	mutex_unlock(&cma->lock);
-
-	return maxchunk << cma->order_per_bit;
-}
-
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     int align_order)
 {
diff -puN mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters-fix mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters-fix
+++ a/mm/cma_debug.c
@@ -22,6 +22,37 @@ struct cma_mem {
 
 static struct dentry *cma_debugfs_root;
 
+static unsigned long cma_get_used(struct cma *cma)
+{
+	unsigned long ret = 0;
+
+	mutex_lock(&cma->lock);
+	/* pages counter is smaller than sizeof(int) */
+	ret = bitmap_weight(cma->bitmap, (int)cma->count);
+	mutex_unlock(&cma->lock);
+
+	return ret << cma->order_per_bit;
+}
+
+static unsigned long cma_get_maxchunk(struct cma *cma)
+{
+	unsigned long maxchunk = 0;
+	unsigned long start, end = 0;
+
+	mutex_lock(&cma->lock);
+	for (;;) {
+		start = find_next_zero_bit(cma->bitmap, cma->count, end);
+		if (start >= cma->count)
+			break;
+		end = find_next_bit(cma->bitmap, cma->count, start);
+		maxchunk = max(end - start, maxchunk);
+	}
+	mutex_unlock(&cma->lock);
+
+	return maxchunk << cma->order_per_bit;
+}
+
+
 static int cma_debugfs_get(void *data, u64 *val)
 {
 	unsigned long *p = data;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

