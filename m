Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B77ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiJ0UEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiJ0UD4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:03:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC3357200
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D989B824DD
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC0FC433C1;
        Thu, 27 Oct 2022 20:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901028;
        bh=aoXupyDFi3X3Iy2iAi3GpOkp3b+Df1oRTuN/MMzGj0M=;
        h=Date:To:From:Subject:From;
        b=MA5a+73mIFT5cOK8dB+DAroX7uFcAFdzSNWJ8VtUwk7eLQxQ4Q9PiSUyswyrZH4zC
         bn/tBszf6zta8qGaoKyuMdKWGWYFsB9rq60/XIG2nmAliQLqI7t1rbVxvBkBpTjYCe
         GgII4hiuZT7dWwuVApoYk0ozoWxfggbTmfzBRE2Q=
Date:   Thu, 27 Oct 2022 13:03:47 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-size-class-equals-check-into-recompression.patch added to mm-unstable branch
Message-Id: <20221027200348.1BC0FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add size class equals check into recompression
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-size-class-equals-check-into-recompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-size-class-equals-check-into-recompression.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zram: add size class equals check into recompression
Date: Thu, 27 Oct 2022 13:26:43 +0900

Patch series "zsmalloc/zram: configurable zspage size", v3.

It makes no sense for us to recompress the object if it will be in the
same size class.  We anyway don't get any memory gain.  But, at the same
time, we get a CPU time overhead when inserting this object into zspage
and decompressing it afterwards.

Link: https://lkml.kernel.org/r/20221027042651.234524-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20221027042651.234524-2-senozhatsky@chromium.org
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/block/zram/zram_drv.c~zram-add-size-class-equals-check-into-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1632,6 +1632,8 @@ static int zram_recompress(struct zram *
 	unsigned long handle_next;
 	unsigned int comp_len_next;
 	unsigned int comp_len_prev;
+	unsigned int class_index_prev;
+	unsigned int class_index_next;
 	struct zcomp_strm *zstrm;
 	void *src, *dst;
 	int ret;
@@ -1656,6 +1658,8 @@ static int zram_recompress(struct zram *
 	ret = zcomp_compress(zstrm, src, &comp_len_next);
 	kunmap_atomic(src);
 
+	class_index_prev = zs_lookup_class_index(zram->mem_pool, comp_len_prev);
+	class_index_next = zs_lookup_class_index(zram->mem_pool, comp_len_next);
 	/*
 	 * Either a compression error or we failed to compressed the object
 	 * in a way that will save us memory. Mark the object so that we
@@ -1663,6 +1667,7 @@ static int zram_recompress(struct zram *
 	 */
 	if (comp_len_next >= huge_class_size ||
 	    comp_len_next >= comp_len_prev ||
+	    class_index_next >= class_index_prev ||
 	    ret) {
 		zram_set_flag(zram, index, ZRAM_RECOMP_SKIP);
 		zram_clear_flag(zram, index, ZRAM_IDLE);
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

zram-add-size-class-equals-check-into-recompression.patch

