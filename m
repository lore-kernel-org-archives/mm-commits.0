From: akpm@linux-foundation.org
Subject: + zram-fix-pool-name-truncation.patch added to -mm tree
Date: Wed, 12 Aug 2015 16:39:13 -0700
Message-ID: <55cbd921.YNIUdwYJjRxOv/+i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbHLXjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix pool name truncation
has been added to the -mm tree.  Its filename is
     zram-fix-pool-name-truncation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-pool-name-truncation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-pool-name-truncation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: fix pool name truncation

zram_meta_alloc() constructs a pool name for zs_create_pool() call as

 snprintf(pool_name, sizeof(pool_name), "zram%d", device_id);

However, it defines pool name buffer to be only 8 bytes long (minus
trailing zero), which means that we can have only 1000 pool names: zram0
-- zram999.

With CONFIG_ZSMALLOC_STAT enabled an attempt to create a device zram1000
can fail if device zram100 already exists, because snprintf() will
truncate new pool name to zram100 and pass it debugfs_create_dir(),
causing:

  debugfs dir <zram100> creation failed
  zram: Error creating memory pool

... and so on.

Fix it by passing zram->disk->disk_name to zram_meta_alloc() instead of
divice_id.  We construct zram%d name earlier and keep it as a ->disk_name,
no need to snprintf() it again.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-pool-name-truncation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-pool-name-truncation
+++ a/drivers/block/zram/zram_drv.c
@@ -496,10 +496,9 @@ static void zram_meta_free(struct zram_m
 	kfree(meta);
 }
 
-static struct zram_meta *zram_meta_alloc(int device_id, u64 disksize)
+static struct zram_meta *zram_meta_alloc(char *pool_name, u64 disksize)
 {
 	size_t num_pages;
-	char pool_name[8];
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 
 	if (!meta)
@@ -512,7 +511,6 @@ static struct zram_meta *zram_meta_alloc
 		goto out_error;
 	}
 
-	snprintf(pool_name, sizeof(pool_name), "zram%d", device_id);
 	meta->mem_pool = zs_create_pool(pool_name, GFP_NOIO | __GFP_HIGHMEM);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
@@ -1031,7 +1029,7 @@ static ssize_t disksize_store(struct dev
 		return -EINVAL;
 
 	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(zram->disk->first_minor, disksize);
+	meta = zram_meta_alloc(zram->disk->disk_name, disksize);
 	if (!meta)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-fix-pool-name-truncation.patch
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

