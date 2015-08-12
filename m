From: akpm@linux-foundation.org
Subject: [to-be-updated] zram-fix-pool-name-truncation.patch removed from
 -mm tree
Date: Wed, 12 Aug 2015 16:38:32 -0700
Message-ID: <55cbd8f8.aCH3Ww1ntrDwkh8N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbbHLXic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix pool name truncation
has been removed from the -mm tree.  Its filename was
     zram-fix-pool-name-truncation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: fix pool name truncation

zram_meta_alloc() constructs a pool name for zs_create_pool() call as

 snprintf(pool_name, sizeof(pool_name), "zram%d", device_id);

However, it defines pool name buffer to be only 8 chars long (minus
trailing zero), which means that we can have only 1000 pool names: zram0
-- zram999.

With CONFIG_ZSMALLOC_STAT enabled an attempt to create a device zram1000
can fail if device zram100 already exists, because snprintf() will
truncate new pool name to zram100 and pass it to debugfs_create_dir(),
causing:

  debugfs dir <zram100> creation failed
  zram: Error creating memory pool

... and so on (zram101 - zram1010, etc).

Fix it by increasing pool_name buffer size to 15:

- zram prefix (length 4)
- int device_id can use up to 10 chars
- terminating zero byte

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-pool-name-truncation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-pool-name-truncation
+++ a/drivers/block/zram/zram_drv.c
@@ -499,7 +499,7 @@ static void zram_meta_free(struct zram_m
 static struct zram_meta *zram_meta_alloc(int device_id, u64 disksize)
 {
 	size_t num_pages;
-	char pool_name[8];
+	char pool_name[15];
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 
 	if (!meta)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-fix-pool-name-truncation-v3.patch
mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
zsmalloc-consider-zs_almost_full-as-migrate-source.patch
zsmalloc-use-class-pages_per_zspage.patch
zsmalloc-do-not-take-class-lock-in-zs_shrinker_count.patch
zsmalloc-remove-null-check-from-destroy_handle_cache.patch
zram-unify-error-reporting.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch

