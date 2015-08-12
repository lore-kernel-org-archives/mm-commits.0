From: akpm@linux-foundation.org
Subject: + zram-unify-error-reporting.patch added to -mm tree
Date: Wed, 12 Aug 2015 15:42:16 -0700
Message-ID: <55cbcbc8.G0CssTQuSQNGnJP5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbHLWmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 18:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: unify error reporting
has been added to the -mm tree.  Its filename is
     zram-unify-error-reporting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-unify-error-reporting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-unify-error-reporting.patch

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
Subject: zram: unify error reporting

Make zram syslog error reporting more consistent. We have random
error levels in some places. For example, critical errors like
  "Error allocating memory for compressed page"
and
  "Unable to allocate temp memory"
are reported as KERN_INFO messages.

a) Reassign error levels

Error messages that directly affect zram
functionality -- pr_err():

 Error allocating zram address table
 Error creating memory pool
 Decompression failed! err=%d, page=%u
 Unable to allocate temp memory
 Compression failed! err=%d
 Error allocating memory for compressed page: %u, size=%zu
 Cannot initialise %s compressing backend
 Error allocating disk queue for device %d
 Error allocating disk structure for device %d
 Error creating sysfs group for device %d
 Unable to register zram-control class
 Unable to get major number

Messages that do not affect functionality, but user
must be warned (because sysfs attrs will be removed in
this particular case) -- pr_warn():

 %d (%s) Attribute %s (and others) will be removed. %s

Messages that do not affect functionality and mostly are
informative -- pr_info():

 Cannot change max compression streams
 Can't change algorithm for initialized device
 Cannot change disksize for initialized device
 Added device: %s
 Removed device: %s

b) Update sysfs_create_group() error message

First, it lacks a trailing new line; add it.  Second, every error message
in zram_add() has a "for device %d" part, which makes errors more
informative.  Add missing part to "Error creating sysfs group" message.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-unify-error-reporting drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-unify-error-reporting
+++ a/drivers/block/zram/zram_drv.c
@@ -624,7 +624,7 @@ static int zram_bvec_read(struct zram *z
 		uncmem = user_mem;
 
 	if (!uncmem) {
-		pr_info("Unable to allocate temp memory\n");
+		pr_err("Unable to allocate temp memory\n");
 		ret = -ENOMEM;
 		goto out_cleanup;
 	}
@@ -721,7 +721,7 @@ static int zram_bvec_write(struct zram *
 
 	handle = zs_malloc(meta->mem_pool, clen);
 	if (!handle) {
-		pr_info("Error allocating memory for compressed page: %u, size=%zu\n",
+		pr_err("Error allocating memory for compressed page: %u, size=%zu\n",
 			index, clen);
 		ret = -ENOMEM;
 		goto out;
@@ -1040,7 +1040,7 @@ static ssize_t disksize_store(struct dev
 
 	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
 	if (IS_ERR(comp)) {
-		pr_info("Cannot initialise %s compressing backend\n",
+		pr_err("Cannot initialise %s compressing backend\n",
 				zram->compressor);
 		err = PTR_ERR(comp);
 		goto out_free_meta;
@@ -1218,7 +1218,7 @@ static int zram_add(void)
 	/* gendisk structure */
 	zram->disk = alloc_disk(1);
 	if (!zram->disk) {
-		pr_warn("Error allocating disk structure for device %d\n",
+		pr_err("Error allocating disk structure for device %d\n",
 			device_id);
 		ret = -ENOMEM;
 		goto out_free_queue;
@@ -1267,7 +1267,8 @@ static int zram_add(void)
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
 				&zram_disk_attr_group);
 	if (ret < 0) {
-		pr_warn("Error creating sysfs group");
+		pr_err("Error creating sysfs group for device %d\n",
+				device_id);
 		goto out_free_disk;
 	}
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
@@ -1407,13 +1408,13 @@ static int __init zram_init(void)
 
 	ret = class_register(&zram_control_class);
 	if (ret) {
-		pr_warn("Unable to register zram-control class\n");
+		pr_err("Unable to register zram-control class\n");
 		return ret;
 	}
 
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
-		pr_warn("Unable to get major number\n");
+		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
 		return -EBUSY;
 	}
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

