Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7811C4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiLAAEo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiLAADY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74808DBC1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82337B81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244EAC4347C;
        Thu,  1 Dec 2022 00:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852893;
        bh=9UfRPWenUu4rKtLSKWkxXvitnQAGT3UaaxrXdexxVDE=;
        h=Date:To:From:Subject:From;
        b=EC3wXKQ/VsxbDlDrC7fQkAjYvvqbQZYtnwftOMygxnUb0bDjVSLZgbipDmIIGNte2
         GdMGh2ljIti9YKHITJF6/+37pANlVTzPGC9c5W5Iw8d1Ssk9uTjWUc5FMcXedGOwfL
         A8PhwX9H2ssEHFCjM2MqYfRs14MF4Pc/GEEBkfTs=
Date:   Wed, 30 Nov 2022 16:01:32 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, ngupta@vflare.org,
        minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-size-class-equals-check-into-recompression.patch removed from -mm tree
Message-Id: <20221201000133.244EAC4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: add size class equals check into recompression
has been removed from the -mm tree.  Its filename was
     zram-add-size-class-equals-check-into-recompression.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zram: add size class equals check into recompression
Date: Wed, 9 Nov 2022 20:50:42 +0900

It makes no sense for us to recompress the object if it will be in the
same size class.  We anyway don't get any memory gain.  But, at the same
time, we get a CPU time overhead when inserting this object into zspage
and decompressing it afterwards.

[senozhatsky: rebased and fixed conflicts]
Link: https://lkml.kernel.org/r/20221109115047.2921851-9-senozhatsky@chromium.org
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++++++++-
 include/linux/zsmalloc.h      |    2 ++
 mm/zsmalloc.c                 |   21 +++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-size-class-equals-check-into-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1672,6 +1672,8 @@ static int zram_recompress(struct zram *
 	unsigned long handle_new;
 	unsigned int comp_len_old;
 	unsigned int comp_len_new;
+	unsigned int class_index_old;
+	unsigned int class_index_new;
 	void *src, *dst;
 	int ret;
 
@@ -1690,6 +1692,7 @@ static int zram_recompress(struct zram *
 	if (ret)
 		return ret;
 
+	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)
 	 * and try to recompress the page.
@@ -1715,9 +1718,13 @@ static int zram_recompress(struct zram *
 			return ret;
 		}
 
+		class_index_new = zs_lookup_class_index(zram->mem_pool,
+							comp_len_new);
+
 		/* Continue until we make progress */
 		if (comp_len_new >= huge_class_size ||
 		    comp_len_new >= comp_len_old ||
+		    class_index_new >= class_index_old ||
 		    (threshold && comp_len_new >= threshold)) {
 			zcomp_stream_put(zram->comps[prio]);
 			continue;
@@ -1740,7 +1747,9 @@ static int zram_recompress(struct zram *
 	 * that would save memory, mark the object as incompressible so that
 	 * we will not try to compress it again.
 	 */
-	if (comp_len_new >= huge_class_size || comp_len_new >= comp_len_old) {
+	if (comp_len_new >= huge_class_size ||
+	    comp_len_new >= comp_len_old ||
+	    class_index_new >= class_index_old) {
 		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
--- a/include/linux/zsmalloc.h~zram-add-size-class-equals-check-into-recompression
+++ a/include/linux/zsmalloc.h
@@ -55,5 +55,7 @@ void zs_unmap_object(struct zs_pool *poo
 unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
+unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
+
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 #endif
--- a/mm/zsmalloc.c~zram-add-size-class-equals-check-into-recompression
+++ a/mm/zsmalloc.c
@@ -1205,6 +1205,27 @@ static bool zspage_full(struct size_clas
 	return get_zspage_inuse(zspage) == class->objs_per_zspage;
 }
 
+/**
+ * zs_lookup_class_index() - Returns index of the zsmalloc &size_class
+ * that hold objects of the provided size.
+ * @pool: zsmalloc pool to use
+ * @size: object size
+ *
+ * Context: Any context.
+ *
+ * Return: the index of the zsmalloc &size_class that hold objects of the
+ * provided size.
+ */
+unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size)
+{
+	struct size_class *class;
+
+	class = pool->size_class[get_size_class_index(size)];
+
+	return class->index;
+}
+EXPORT_SYMBOL_GPL(zs_lookup_class_index);
+
 unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
 	return atomic_long_read(&pool->pages_allocated);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are


