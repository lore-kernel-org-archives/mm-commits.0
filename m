Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF52C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbjHKXEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236894AbjHKXDH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5BB358E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A901F6526A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B70AC433C8;
        Fri, 11 Aug 2023 23:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794874;
        bh=rKyPUi2cs8YaLn4AqPMc7zBlKGhFD5YetTTgSTx1/x8=;
        h=Date:To:From:Subject:From;
        b=B8sdJ2p3JxAQyamM8+KH810A1Q4VfchOJFqlU3j9CuNDCuOqvT8tse4gotmwanGoM
         jxqyWU9IBTbxtrcwZxXGGfUHdMzj8ZKUgSE2cMkYzL5pjT/MOL1jWW7UZvIEe2LJrx
         h5ICke69ovxSmA85ZWhlM0S3eqt9I2pToN1c6FQE=
Date:   Fri, 11 Aug 2023 16:01:13 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch removed from -mm tree
Message-Id: <20230811230114.0B70AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: move functions around for minor cleanups to page_ext
has been removed from the -mm tree.  Its filename was
     mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: move functions around for minor cleanups to page_ext
Date: Fri, 14 Jul 2023 19:47:49 +0800

1. move page_ext_get and page_ext_put down to remove forward
   declaration of lookup_page_ext.

2. move page_ext_init_flatmem_late down to existing non SPARS block to
   remove a new non SPARS block and to keep code for non SPARS tight.

Link: https://lkml.kernel.org/r/20230714114749.1743032-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |   96 +++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

--- a/mm/page_ext.c~mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext
+++ a/mm/page_ext.c
@@ -90,7 +90,6 @@ static struct page_ext_operations *page_
 unsigned long page_ext_size;
 
 static unsigned long total_usage;
-static struct page_ext *lookup_page_ext(const struct page *page);
 
 bool early_page_ext __meminitdata;
 static int __init setup_early_page_ext(char *str)
@@ -137,62 +136,16 @@ static void __init invoke_init_callbacks
 	}
 }
 
-#ifndef CONFIG_SPARSEMEM
-void __init page_ext_init_flatmem_late(void)
-{
-	invoke_init_callbacks();
-}
-#endif
-
 static inline struct page_ext *get_entry(void *base, unsigned long index)
 {
 	return base + page_ext_size * index;
 }
 
-/**
- * page_ext_get() - Get the extended information for a page.
- * @page: The page we're interested in.
- *
- * Ensures that the page_ext will remain valid until page_ext_put()
- * is called.
- *
- * Return: NULL if no page_ext exists for this page.
- * Context: Any context.  Caller may not sleep until they have called
- * page_ext_put().
- */
-struct page_ext *page_ext_get(struct page *page)
-{
-	struct page_ext *page_ext;
-
-	rcu_read_lock();
-	page_ext = lookup_page_ext(page);
-	if (!page_ext) {
-		rcu_read_unlock();
-		return NULL;
-	}
-
-	return page_ext;
-}
-
-/**
- * page_ext_put() - Working with page extended information is done.
- * @page_ext: Page extended information received from page_ext_get().
- *
- * The page extended information of the page may not be valid after this
- * function is called.
- *
- * Return: None.
- * Context: Any context with corresponding page_ext_get() is called.
- */
-void page_ext_put(struct page_ext *page_ext)
+#ifndef CONFIG_SPARSEMEM
+void __init page_ext_init_flatmem_late(void)
 {
-	if (unlikely(!page_ext))
-		return;
-
-	rcu_read_unlock();
+	invoke_init_callbacks();
 }
-#ifndef CONFIG_SPARSEMEM
-
 
 void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
 {
@@ -536,3 +489,46 @@ void __meminit pgdat_page_ext_init(struc
 }
 
 #endif
+
+/**
+ * page_ext_get() - Get the extended information for a page.
+ * @page: The page we're interested in.
+ *
+ * Ensures that the page_ext will remain valid until page_ext_put()
+ * is called.
+ *
+ * Return: NULL if no page_ext exists for this page.
+ * Context: Any context.  Caller may not sleep until they have called
+ * page_ext_put().
+ */
+struct page_ext *page_ext_get(struct page *page)
+{
+	struct page_ext *page_ext;
+
+	rcu_read_lock();
+	page_ext = lookup_page_ext(page);
+	if (!page_ext) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	return page_ext;
+}
+
+/**
+ * page_ext_put() - Working with page extended information is done.
+ * @page_ext: Page extended information received from page_ext_get().
+ *
+ * The page extended information of the page may not be valid after this
+ * function is called.
+ *
+ * Return: None.
+ * Context: Any context with corresponding page_ext_get() is called.
+ */
+void page_ext_put(struct page_ext *page_ext)
+{
+	if (unlikely(!page_ext))
+		return;
+
+	rcu_read_unlock();
+}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
mm-page_poison-remove-unused-page_exth-from-page_poison.patch
mm-vmstat-remove-unused-page_exth-from-vmstat.patch
mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch
mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch
mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch
mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch
mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch
mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch
mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch
mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch
mm-compaction-correct-comment-to-complete-migration-failure.patch
mm-compaction-remove-unnecessary-return-for-void-function.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free.patch
mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch
mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch
mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask.patch
mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch

