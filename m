Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0336DC38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 02:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJZCUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiJZCUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 22:20:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9B2F03A
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 19:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8236C61C54
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 02:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75B4C433D7;
        Wed, 26 Oct 2022 02:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666750790;
        bh=DguqLaaad9KXXdy8ys5xUNIC69tarB5U21q0UxAkh1w=;
        h=Date:To:From:Subject:From;
        b=bBcO4uN0qZW5KkfGoW+Uh5KzvdyD+mfta8W306ZdC36tA6J6nOLQvJF2mcePW8nKY
         YYzX+Xk/chVF+XL3jnxNBR0NkmRVkCh0pkZLSFOA3nekDMjQpkwlfdTHxM4b69e1p6
         QomQ13mWzSMMbkflXT9lpB4U2PKEwuFwt8DkSEkg=
Date:   Tue, 25 Oct 2022 19:19:49 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-size-class-equals-check-into-recompression-v2.patch added to mm-unstable branch
Message-Id: <20221026021950.B75B4C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-add-size-class-equals-check-into-recompression-v2
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-size-class-equals-check-into-recompression-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-size-class-equals-check-into-recompression-v2.patch

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
Subject: zram-add-size-class-equals-check-into-recompression-v2
Date: Tue, 25 Oct 2022 19:26:38 +0300

naming: s/size/class/ 

Link: https://lkml.kernel.org/r/20221025162638.7853-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/block/zram/zram_drv.c~zram-add-size-class-equals-check-into-recompression-v2
+++ a/drivers/block/zram/zram_drv.c
@@ -1671,8 +1671,8 @@ static int zram_recompress(struct zram *
 	unsigned long handle_next;
 	unsigned int comp_len_next;
 	unsigned int comp_len_prev;
-	unsigned int class_size_next;
-	unsigned int class_size_prev;
+	unsigned int class_index_prev;
+	unsigned int class_index_next;
 	struct zcomp_strm *zstrm;
 	void *src, *dst;
 	int ret;
@@ -1697,8 +1697,8 @@ static int zram_recompress(struct zram *
 	ret = zcomp_compress(zstrm, src, &comp_len_next);
 	kunmap_atomic(src);
 
-	class_size_prev = zs_get_class_size(zram->mem_pool, comp_len_prev);
-	class_size_next = zs_get_class_size(zram->mem_pool, comp_len_next);
+	class_index_prev = zs_lookup_class_index(zram->mem_pool, comp_len_prev);
+	class_index_next = zs_lookup_class_index(zram->mem_pool, comp_len_next);
 	/*
 	 * Either a compression error or we failed to compressed the object
 	 * in a way that will save us memory. Mark the object so that we
@@ -1706,7 +1706,7 @@ static int zram_recompress(struct zram *
 	 */
 	if (comp_len_next >= huge_class_size ||
 	    comp_len_next >= comp_len_prev ||
-	    class_size_next == class_size_prev ||
+	    class_index_next >= class_index_prev ||
 	    ret) {
 		zram_set_flag(zram, index, ZRAM_RECOMP_SKIP);
 		zram_clear_flag(zram, index, ZRAM_IDLE);
--- a/include/linux/zsmalloc.h~zram-add-size-class-equals-check-into-recompression-v2
+++ a/include/linux/zsmalloc.h
@@ -68,7 +68,7 @@ void zs_unmap_object(struct zs_pool *poo
 unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
-void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
+unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
 
-unsigned int zs_get_class_size(struct zs_pool *pool, unsigned int size);
+void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 #endif
--- a/mm/zsmalloc.c~zram-add-size-class-equals-check-into-recompression-v2
+++ a/mm/zsmalloc.c
@@ -1204,26 +1204,25 @@ static bool zspage_full(struct size_clas
 }
 
 /**
- * zs_get_class_size() - Returns the size (in bytes) of the
- * zsmalloc &size_class into which the object with specified
- * size will be inserted or already inserted.
- *
+ * zs_lookup_class_index() - Returns index of the zsmalloc &size_class
+ * that hold objects of the provided size.
  * @pool: zsmalloc pool to use
+ * @size: object size
  *
  * Context: Any context.
  *
- * Return: the size (in bytes) of the zsmalloc &size_class into which
- * the object with specified size will be inserted.
+ * Return: the index of the zsmalloc &size_class that hold objects of the
+ * provided size.
  */
-unsigned int zs_get_class_size(struct zs_pool *pool, unsigned int size)
+unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size)
 {
 	struct size_class *class;
 
 	class = pool->size_class[get_size_class_index(pool, size)];
 
-	return class->size;
+	return class->index;
 }
-EXPORT_SYMBOL_GPL(zs_get_class_size);
+EXPORT_SYMBOL_GPL(zs_lookup_class_index);
 
 unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zram-add-size-class-equals-check-into-recompression.patch
zram-add-size-class-equals-check-into-recompression-v2.patch

