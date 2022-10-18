Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DBAC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiJRAPG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiJRAOV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3D253D0C
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D38561324
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6CEC433C1;
        Tue, 18 Oct 2022 00:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666051756;
        bh=QqM/GbPwe3RNG8mpgvdO99bGQfgxg8753+C9o9cjKqQ=;
        h=Date:To:From:Subject:From;
        b=PBotXQrJe3yTCLgT6sCFIkQ2A1fC9puVDFMd9FPtpkXl00vDgcZDDUcUt6m6y2FTf
         1n9SlwzEjBbQwN7uu2/AOTxb34/HfWFaJOLP9ARKMI2IdYwoIFlavyZrcW1xk2mHB0
         ZkTQ7Nk6sX5oSG42p0Bx22EJRQ+VVkljWEnavcuU=
Date:   Mon, 17 Oct 2022 17:09:16 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-recompression-algorithm-sysfs-knob.patch added to mm-unstable branch
Message-Id: <20221018000916.BD6CEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add recompression algorithm sysfs knob
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-recompression-algorithm-sysfs-knob.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-recompression-algorithm-sysfs-knob.patch

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
Subject: zram: add recompression algorithm sysfs knob
Date: Sun, 9 Oct 2022 18:07:14 +0900

Introduce recomp_algorithm sysfs knob that controls secondary algorithm
selection used for recompression.  This device attribute works in a
similar way with comp_algorithm attribute.

Link: https://lkml.kernel.org/r/20221009090720.1040633-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  111 +++++++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 21 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-recompression-algorithm-sysfs-knob
+++ a/drivers/block/zram/zram_drv.c
@@ -41,7 +41,12 @@ static DEFINE_IDR(zram_index_idr);
 static DEFINE_MUTEX(zram_index_mutex);
 
 static int zram_major;
-static const char *default_compressor = CONFIG_ZRAM_DEF_COMP;
+static const char *default_comp_algs[ZRAM_MAX_ZCOMPS] = {
+	CONFIG_ZRAM_DEF_COMP,
+#ifdef CONFIG_ZRAM_MULTI_COMP
+	"zstd",
+#endif
+};
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
@@ -1000,31 +1005,37 @@ static ssize_t max_comp_streams_store(st
 	return len;
 }
 
-static ssize_t comp_algorithm_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static void comp_algorithm_set(struct zram *zram, u32 idx, const char *alg)
 {
-	size_t sz;
-	struct zram *zram = dev_to_zram(dev);
+	bool default_alg = false;
+	int i;
 
-	down_read(&zram->init_lock);
-	sz = zcomp_available_show(zram->comp_algs[ZRAM_PRIMARY_ZCOMP], buf);
-	up_read(&zram->init_lock);
+	/* Do not kfree() algs that we didn't allocate, IOW the default ones */
+	for (i = 0; i < ZRAM_MAX_ZCOMPS; i++) {
+		if (zram->comp_algs[idx] == default_comp_algs[i]) {
+			default_alg = true;
+			break;
+		}
+	}
 
-	return sz;
+	if (!default_alg)
+		kfree(zram->comp_algs[idx]);
+	zram->comp_algs[idx] = alg;
 }
 
-static void comp_algorithm_set(struct zram *zram, u32 idx, const char *alg)
+static ssize_t __comp_algorithm_show(struct zram *zram, u32 idx, char *buf)
 {
-	/* Do not kfree() algs that we didn't allocate, IOW the default ones */
-	if (zram->comp_algs[idx] != default_compressor)
-		kfree(zram->comp_algs[idx]);
-	zram->comp_algs[idx] = alg;
+	ssize_t sz;
+
+	down_read(&zram->init_lock);
+	sz = zcomp_available_show(zram->comp_algs[idx], buf);
+	up_read(&zram->init_lock);
+
+	return sz;
 }
 
-static ssize_t comp_algorithm_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+static int __comp_algorithm_store(struct zram *zram, u32 idx, const char *buf)
 {
-	struct zram *zram = dev_to_zram(dev);
 	char *compressor;
 	size_t sz;
 
@@ -1053,11 +1064,55 @@ static ssize_t comp_algorithm_store(stru
 		return -EBUSY;
 	}
 
-	comp_algorithm_set(zram, ZRAM_PRIMARY_ZCOMP, compressor);
+	comp_algorithm_set(zram, idx, compressor);
 	up_write(&zram->init_lock);
-	return len;
+	return 0;
+}
+
+static ssize_t comp_algorithm_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return __comp_algorithm_show(zram, ZRAM_PRIMARY_ZCOMP, buf);
+}
+
+static ssize_t comp_algorithm_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf,
+				    size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	int ret;
+
+	ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_ZCOMP, buf);
+	return ret ? ret : len;
 }
 
+#ifdef CONFIG_ZRAM_MULTI_COMP
+static ssize_t recomp_algorithm_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return __comp_algorithm_show(zram, ZRAM_SECONDARY_ZCOMP, buf);
+}
+
+static ssize_t recomp_algorithm_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	int ret;
+
+	ret = __comp_algorithm_store(zram, ZRAM_SECONDARY_ZCOMP, buf);
+	return ret ? ret : len;
+}
+#endif
+
 static ssize_t compact_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -1762,7 +1817,11 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
 
-	comp_algorithm_set(zram, ZRAM_PRIMARY_ZCOMP, default_compressor);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_ZCOMP,
+			   default_comp_algs[ZRAM_PRIMARY_ZCOMP]);
+	if (IS_ENABLED(CONFIG_ZRAM_MULTI_COMP))
+		comp_algorithm_set(zram, ZRAM_SECONDARY_ZCOMP,
+				   default_comp_algs[ZRAM_SECONDARY_ZCOMP]);
 	up_write(&zram->init_lock);
 }
 
@@ -1895,6 +1954,9 @@ static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 #endif
+#ifdef CONFIG_ZRAM_MULTI_COMP
+static DEVICE_ATTR_RW(recomp_algorithm);
+#endif
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -1918,6 +1980,9 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_bd_stat.attr,
 #endif
 	&dev_attr_debug_stat.attr,
+#ifdef CONFIG_ZRAM_MULTI_COMP
+	&dev_attr_recomp_algorithm.attr,
+#endif
 	NULL,
 };
 
@@ -1997,7 +2062,11 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	zram->comp_algs[ZRAM_PRIMARY_ZCOMP] = default_compressor;
+	zram->comp_algs[ZRAM_PRIMARY_ZCOMP] =
+		default_comp_algs[ZRAM_PRIMARY_ZCOMP];
+	if (IS_ENABLED(CONFIG_ZRAM_MULTI_COMP))
+		zram->comp_algs[ZRAM_SECONDARY_ZCOMP] =
+			default_comp_algs[ZRAM_SECONDARY_ZCOMP];
 
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-correct-typos.patch

