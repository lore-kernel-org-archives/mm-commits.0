Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43B6FA3741
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiJaW3U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJaW27 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:28:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5395926C0
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F82B818CE
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892F2C433D6;
        Mon, 31 Oct 2022 22:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667255331;
        bh=LZ7SwBh0B0SZpNhSTYHmiA3pNoYLmENDLn6KWtUSuJE=;
        h=Date:To:From:Subject:From;
        b=KH9sfUmvx+tNrbPgjkagMlv91y2xpwhAT3LdeHlXsMRe0HGGtbk20XA6xNOuQPkxi
         GN2Z/futWH8/vb4uVVxNsxW6iDNPa036kuglCRjackDNRchlXWYWnWbC8e1EXQdq6I
         d4Ct2+9v2dkB5bNGzxRPhTBULHuAYYIz/H8PmPB8=
Date:   Mon, 31 Oct 2022 15:28:50 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-make-huge-class-watermark-zs_pool-member.patch added to mm-unstable branch
Message-Id: <20221031222851.892F2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: make huge class watermark zs_pool member
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-make-huge-class-watermark-zs_pool-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-huge-class-watermark-zs_pool-member.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: make huge class watermark zs_pool member
Date: Mon, 31 Oct 2022 14:41:03 +0900

We will permit per-pool configuration of pages per-zspage value, which
changes characteristics of the classes and moves around huge class size
watermark.  Thus huge class size needs to be a per-pool variable.

Link: https://lkml.kernel.org/r/20221031054108.541190-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-make-huge-class-watermark-zs_pool-member
+++ a/mm/zsmalloc.c
@@ -177,7 +177,6 @@ static struct dentry *zs_stat_root;
  * (see: fix_fullness_group())
  */
 static const int fullness_threshold_frac = 4;
-static size_t huge_class_size;
 
 struct size_class {
 	struct list_head fullness_list[NR_ZS_FULLNESS];
@@ -231,6 +230,7 @@ struct zs_pool {
 
 	u32 num_size_classes;
 	u32 min_alloc_size;
+	size_t huge_class_size;
 
 	struct zs_pool_stats stats;
 
@@ -1445,7 +1445,7 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
  */
 size_t zs_huge_class_size(struct zs_pool *pool)
 {
-	return huge_class_size;
+	return pool->huge_class_size;
 }
 EXPORT_SYMBOL_GPL(zs_huge_class_size);
 
@@ -2383,8 +2383,8 @@ struct zs_pool *zs_create_pool(const cha
 		 * endup in the huge class.
 		 */
 		if (pages_per_zspage != 1 && objs_per_zspage != 1 &&
-				!huge_class_size) {
-			huge_class_size = size;
+				!pool->huge_class_size) {
+			pool->huge_class_size = size;
 			/*
 			 * The object uses ZS_HANDLE_SIZE bytes to store the
 			 * handle. We need to subtract it, because zs_malloc()
@@ -2394,7 +2394,7 @@ struct zs_pool *zs_create_pool(const cha
 			 * class because it grows by ZS_HANDLE_SIZE extra bytes
 			 * right before class lookup.
 			 */
-			huge_class_size -= (ZS_HANDLE_SIZE - 1);
+			pool->huge_class_size -= (ZS_HANDLE_SIZE - 1);
 		}
 
 		/*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

