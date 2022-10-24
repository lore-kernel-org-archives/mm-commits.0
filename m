Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54524C38A2D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiJXWUx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJXWUf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:20:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83E7310134
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 683C2B81212
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151D8C433D6;
        Mon, 24 Oct 2022 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666643739;
        bh=23DHMVazJmBg/mRTUEXnY0EEDGwcwjsl/VuKy++fwZA=;
        h=Date:To:From:Subject:From;
        b=1FT3t+59xcF7mSv8NUUAtP3QhTdds1U0Zx0MldZMQO0XtD2S1Aro8eCtDKnJRavzI
         PpRrwJFuXmwgOLQPvOwEIi968Hi4h+cgdjiMhWnxpa4DXl/O6BVrtX1OuW7BdVy33Y
         kXaFlpWkv6G6m8Ood86fn5VF7lHXqEecQm7JEOfk=
Date:   Mon, 24 Oct 2022 13:35:38 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-pool_page_order-device-attribute.patch added to mm-unstable branch
Message-Id: <20221024203539.151D8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add pool_page_order device attribute
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-pool_page_order-device-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-pool_page_order-device-attribute.patch

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
Subject: zram: add pool_page_order device attribute
Date: Tue, 25 Oct 2022 01:12:10 +0900

Add a new sysfs knob that allows user-space to set zsmalloc page order
value on per-device basis.

Link: https://lkml.kernel.org/r/20221024161213.3221725-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   43 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |    2 +
 2 files changed, 44 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-pool_page_order-device-attribute
+++ a/drivers/block/zram/zram_drv.c
@@ -1186,6 +1186,44 @@ static ssize_t mm_stat_show(struct devic
 	return ret;
 }
 
+static ssize_t pool_page_order_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	u32 val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->pool_page_order;
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
+}
+
+static ssize_t pool_page_order_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+
+	if (kstrtou32(buf, 10, &val))
+		return -EINVAL;
+
+	if (val < ZS_MIN_PAGE_ORDER || val > ZS_MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	down_read(&zram->init_lock);
+	if (init_done(zram)) {
+		up_read(&zram->init_lock);
+		return -EINVAL;
+	}
+
+	zram->pool_page_order = val;
+	up_read(&zram->init_lock);
+
+	return len;
+}
+
 #ifdef CONFIG_ZRAM_WRITEBACK
 #define FOUR_K(x) ((x) * (1 << (PAGE_SHIFT - 12)))
 static ssize_t bd_stat_show(struct device *dev,
@@ -1254,7 +1292,7 @@ static bool zram_meta_alloc(struct zram
 		return false;
 
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name,
-					ZS_DEFAULT_PAGE_ORDER);
+					zram->pool_page_order);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
 		return false;
@@ -2176,6 +2214,7 @@ static DEVICE_ATTR_RW(writeback_limit_en
 static DEVICE_ATTR_RW(recomp_algorithm);
 static DEVICE_ATTR_WO(recompress);
 #endif
+static DEVICE_ATTR_RW(pool_page_order);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -2203,6 +2242,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_recomp_algorithm.attr,
 	&dev_attr_recompress.attr,
 #endif
+	&dev_attr_pool_page_order.attr,
 	NULL,
 };
 
@@ -2240,6 +2280,7 @@ static int zram_add(void)
 		goto out_free_idr;
 	}
 
+	zram->pool_page_order = ZS_DEFAULT_PAGE_ORDER;
 	zram->disk->major = zram_major;
 	zram->disk->first_minor = device_id;
 	zram->disk->minors = 1;
--- a/drivers/block/zram/zram_drv.h~zram-add-pool_page_order-device-attribute
+++ a/drivers/block/zram/zram_drv.h
@@ -120,6 +120,8 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_ZCOMPS];
+
+	u32 pool_page_order;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
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
zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch
zram-add-pool_page_order-device-attribute.patch
documentation-document-zram-pool_page_order-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch
zsmalloc-make-sure-we-select-best-zspage-size.patch

