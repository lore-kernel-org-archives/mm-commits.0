Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5063DECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJaW3f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJaW3U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:29:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A264D265F
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9F1614D3
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909EBC433D6;
        Mon, 31 Oct 2022 22:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667255338;
        bh=fOXQA4ZiPvgKUbIHKD1xCRhK/rmf/q+wSiE+DpEQHQY=;
        h=Date:To:From:Subject:From;
        b=fguiUGAG2sn69ZkPTTBeBiBPsumj0eF+4sw+UTRY01VSV5VnOF49gPv6CiySUPU5G
         22TFvzfvvHY+/Pmt483Zq+yQVjC+IMDSzAszy8q678cfvrY2WWfCEyrtZQAdI4gRHC
         Vm3+lgNICh6Q6VEeJh9dHhpVdfbSELDCAyyxPhq8=
Date:   Mon, 31 Oct 2022 15:28:57 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-pages_per_pool_page-device-attribute.patch added to mm-unstable branch
Message-Id: <20221031222858.909EBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add pages_per_pool_page device attribute
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-pages_per_pool_page-device-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-pages_per_pool_page-device-attribute.patch

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
Subject: zram: add pages_per_pool_page device attribute
Date: Mon, 31 Oct 2022 14:41:06 +0900

Add a new sysfs knob that allows user-space to set zsmalloc pages
per-zspage limit value on per-device basis.

Link: https://lkml.kernel.org/r/20221031054108.541190-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   44 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |    2 +
 2 files changed, 45 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-pages_per_pool_page-device-attribute
+++ a/drivers/block/zram/zram_drv.c
@@ -1180,6 +1180,45 @@ static ssize_t mm_stat_show(struct devic
 	return ret;
 }
 
+static ssize_t pages_per_pool_page_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	u32 val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->pages_per_pool_page;
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
+}
+
+static ssize_t pages_per_pool_page_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+
+	if (kstrtou32(buf, 10, &val))
+		return -EINVAL;
+
+	if (val < ZS_MIN_PAGES_PER_ZSPAGE || val > ZS_MAX_PAGES_PER_ZSPAGE)
+		return -EINVAL;
+
+	down_read(&zram->init_lock);
+	if (init_done(zram)) {
+		up_read(&zram->init_lock);
+		return -EINVAL;
+	}
+
+	zram->pages_per_pool_page = val;
+	up_read(&zram->init_lock);
+
+	return len;
+}
+
 #ifdef CONFIG_ZRAM_WRITEBACK
 #define FOUR_K(x) ((x) * (1 << (PAGE_SHIFT - 12)))
 static ssize_t bd_stat_show(struct device *dev,
@@ -1248,7 +1287,7 @@ static bool zram_meta_alloc(struct zram
 		return false;
 
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name,
-					ZS_DEFAULT_PAGES_PER_ZSPAGE);
+					zram->pages_per_pool_page);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
 		return false;
@@ -2174,6 +2213,7 @@ static DEVICE_ATTR_RW(writeback_limit_en
 static DEVICE_ATTR_RW(recomp_algorithm);
 static DEVICE_ATTR_WO(recompress);
 #endif
+static DEVICE_ATTR_RW(pages_per_pool_page);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -2201,6 +2241,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_recomp_algorithm.attr,
 	&dev_attr_recompress.attr,
 #endif
+	&dev_attr_pages_per_pool_page.attr,
 	NULL,
 };
 
@@ -2238,6 +2279,7 @@ static int zram_add(void)
 		goto out_free_idr;
 	}
 
+	zram->pages_per_pool_page = ZS_DEFAULT_PAGES_PER_ZSPAGE;
 	zram->disk->major = zram_major;
 	zram->disk->first_minor = device_id;
 	zram->disk->minors = 1;
--- a/drivers/block/zram/zram_drv.h~zram-add-pages_per_pool_page-device-attribute
+++ a/drivers/block/zram/zram_drv.h
@@ -120,6 +120,8 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_ZCOMPS];
+
+	u32 pages_per_pool_page;
 	/*
 	 * Pages that compress to sizes equal or greater than this are stored
 	 * uncompressed in memory.
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

