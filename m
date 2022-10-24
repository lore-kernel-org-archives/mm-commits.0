Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F038C38A2D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJXWqp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiJXWq2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:46:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1661A5253
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 14:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E09D760B3F
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 21:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FB0C433C1;
        Mon, 24 Oct 2022 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666645206;
        bh=1WJ7MGsvqWOlgixsdBCg4SCZThb8rbwObeZCktJVkmU=;
        h=Date:To:From:Subject:From;
        b=S5RVUA5/gGoJp4SmRwR+UiiIqjbTHL++W8PpxSyIWsXiMADWRMDLLhF9G9K0Z0CM9
         akIJIYk5Jx3VPC3k3cK+KsQX0DCN99W+B5qWu3bEIk+rvKfAmVBKAn4rdS+y83snZW
         /MXizvxyMYPOaHidnTE/fseNUZeaglGQ+CjDuFYo=
Date:   Mon, 24 Oct 2022 14:00:05 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-size-class-equals-check-into-recompression.patch added to mm-unstable branch
Message-Id: <20221024210006.40FB0C433C1@smtp.kernel.org>
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
Date: Mon, 24 Oct 2022 15:09:42 +0300

It makes no sense for us to recompress the object if it will be in the
same size class.  We don't get any memory gain anyway.  But at the same
time, we get a CPU time overhead when inserting this object into zspage
and decompressing it afterwards.

Link: https://lkml.kernel.org/r/20221024120942.13885-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 +++++
 include/linux/zsmalloc.h      |    2 ++
 mm/zsmalloc.c                 |   20 ++++++++++++++++++++
 3 files changed, 27 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-add-size-class-equals-check-into-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1671,6 +1671,8 @@ static int zram_recompress(struct zram *
 	unsigned long handle_next;
 	unsigned int comp_len_next;
 	unsigned int comp_len_prev;
+	unsigned int class_size_next;
+	unsigned int class_size_prev;
 	struct zcomp_strm *zstrm;
 	void *src, *dst;
 	int ret;
@@ -1695,6 +1697,8 @@ static int zram_recompress(struct zram *
 	ret = zcomp_compress(zstrm, src, &comp_len_next);
 	kunmap_atomic(src);
 
+	class_size_prev = zs_get_class_size(zram->mem_pool, comp_len_prev);
+	class_size_next = zs_get_class_size(zram->mem_pool, comp_len_next);
 	/*
 	 * Either a compression error or we failed to compressed the object
 	 * in a way that will save us memory. Mark the object so that we
@@ -1702,6 +1706,7 @@ static int zram_recompress(struct zram *
 	 */
 	if (comp_len_next >= huge_class_size ||
 	    comp_len_next >= comp_len_prev ||
+	    class_size_next == class_size_prev ||
 	    ret) {
 		zram_set_flag(zram, index, ZRAM_RECOMP_SKIP);
 		zram_clear_flag(zram, index, ZRAM_IDLE);
--- a/include/linux/zsmalloc.h~zram-add-size-class-equals-check-into-recompression
+++ a/include/linux/zsmalloc.h
@@ -69,4 +69,6 @@ unsigned long zs_get_total_pages(struct
 unsigned long zs_compact(struct zs_pool *pool);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
+
+unsigned int zs_get_class_size(struct zs_pool *pool, unsigned int size);
 #endif
--- a/mm/zsmalloc.c~zram-add-size-class-equals-check-into-recompression
+++ a/mm/zsmalloc.c
@@ -1209,6 +1209,26 @@ static bool zspage_full(struct size_clas
 	return get_zspage_inuse(zspage) == class->objs_per_zspage;
 }
 
+/**
+ * zs_get_class_size() - Returns the size (in bytes) of the
+ * zsmalloc &size_class into which the object with specified
+ * size will be inserted or already inserted.
+ *
+ * @pool: zsmalloc pool to use
+ *
+ * Context: Any context.
+ *
+ * Return: the size (in bytes) of the zsmalloc &size_class into which
+ * the object with specified size will be inserted.
+ */
+unsigned int zs_get_class_size(struct zs_pool *pool, unsigned int size)
+{
+	struct size_class *class = pool->size_class[get_size_class_index(size)];
+
+	return class->size;
+}
+EXPORT_SYMBOL_GPL(zs_get_class_size);
+
 unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
 	return atomic_long_read(&pool->pages_allocated);
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zram-add-size-class-equals-check-into-recompression.patch

