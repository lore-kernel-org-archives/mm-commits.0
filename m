Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC33C43219
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbiKJAa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiKJAaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F211182C
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 777BBB82058
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188BCC433C1;
        Thu, 10 Nov 2022 00:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040250;
        bh=nc2Y8Bp+d6TKwx0rPHurQYEYouMyPmYUaaBEFBAZ+O0=;
        h=Date:To:From:Subject:From;
        b=jbOkoZq/R3yS7gJ7vxnNRi2yXm13we31/iAG9KB6b6rXWBGZitif4Gkou/vR0wx/q
         D/fodb/MAHbEMzOc/KuzQu4nSnkiVlwKowTkdij4MZXDxtgiUXvwAP0pruTOWbFvFR
         PNsBDoOpqmgKOmlcfNYqTq7lvliOmUmfsJYBySVs=
Date:   Wed, 09 Nov 2022 16:30:49 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-recompression-algorithm-sysfs-knob.patch added to mm-unstable branch
Message-Id: <20221110003050.188BCC433C1@smtp.kernel.org>
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
Date: Wed, 9 Nov 2022 20:50:36 +0900

Introduce recomp_algorithm sysfs knob that controls secondary algorithm
selection used for recompression.

We will support up to 3 secondary compression algorithms which are sorted
in order of their priority.  To select an algorithm user has to provide
its name and priority:

  echo "algo=zstd priority=1" > /sys/block/zramX/recomp_algorithm
  echo "algo=deflate priority=2" > /sys/block/zramX/recomp_algorithm

During recompression zram iterates through the list of registered
secondary algorithms in order of their priorities.

We also have a short version for cases when there is only
one secondary compression algorithm:

  echo "algo=zstd" > /sys/block/zramX/recomp_algorithm

This will register zstd as the secondary algorithm with priority 1.

Link: https://lkml.kernel.org/r/20221109115047.2921851-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  124 +++++++++++++++++++++++++++-----
 1 file changed, 105 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-recompression-algorithm-sysfs-knob
+++ a/drivers/block/zram/zram_drv.c
@@ -997,31 +997,28 @@ static ssize_t max_comp_streams_store(st
 	return len;
 }
 
-static ssize_t comp_algorithm_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static void comp_algorithm_set(struct zram *zram, u32 prio, const char *alg)
 {
-	size_t sz;
-	struct zram *zram = dev_to_zram(dev);
+	/* Do not free statically defined compression algorithms */
+	if (zram->comp_algs[prio] != default_compressor)
+		kfree(zram->comp_algs[prio]);
+
+	zram->comp_algs[prio] = alg;
+}
+
+static ssize_t __comp_algorithm_show(struct zram *zram, u32 prio, char *buf)
+{
+	ssize_t sz;
 
 	down_read(&zram->init_lock);
-	sz = zcomp_available_show(zram->comp_algs[ZRAM_PRIMARY_COMP], buf);
+	sz = zcomp_available_show(zram->comp_algs[prio], buf);
 	up_read(&zram->init_lock);
 
 	return sz;
 }
 
-static void comp_algorithm_set(struct zram *zram, u32 prio, const char *alg)
-{
-	/* Do not kfree() algs that we didn't allocate, IOW the default ones */
-	if (zram->comp_algs[prio] != default_compressor)
-		kfree(zram->comp_algs[prio]);
-	zram->comp_algs[prio] = alg;
-}
-
-static ssize_t comp_algorithm_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
+static int __comp_algorithm_store(struct zram *zram, u32 prio, const char *buf)
 {
-	struct zram *zram = dev_to_zram(dev);
 	char *compressor;
 	size_t sz;
 
@@ -1050,11 +1047,94 @@ static ssize_t comp_algorithm_store(stru
 		return -EBUSY;
 	}
 
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, compressor);
+	comp_algorithm_set(zram, prio, compressor);
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
+	return __comp_algorithm_show(zram, ZRAM_PRIMARY_COMP, buf);
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
+	ret = __comp_algorithm_store(zram, ZRAM_PRIMARY_COMP, buf);
+	return ret ? ret : len;
 }
 
+#ifdef CONFIG_ZRAM_MULTI_COMP
+static ssize_t recomp_algorithm_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t sz = 0;
+	u32 prio;
+
+	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		if (!zram->comp_algs[prio])
+			continue;
+
+		sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2, "#%d: ", prio);
+		sz += __comp_algorithm_show(zram, prio, buf + sz);
+	}
+
+	return sz;
+}
+
+static ssize_t recomp_algorithm_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	int prio = ZRAM_SECONDARY_COMP;
+	char *args, *param, *val;
+	char *alg = NULL;
+	int ret;
+
+	args = skip_spaces(buf);
+	while (*args) {
+		args = next_arg(args, &param, &val);
+
+		if (!*val)
+			return -EINVAL;
+
+		if (!strcmp(param, "algo")) {
+			alg = val;
+			continue;
+		}
+
+		if (!strcmp(param, "priority")) {
+			ret = kstrtoint(val, 10, &prio);
+			if (ret)
+				return ret;
+			continue;
+		}
+	}
+
+	if (!alg)
+		return -EINVAL;
+
+	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS)
+		return -EINVAL;
+
+	ret = __comp_algorithm_store(zram, prio, alg);
+	return ret ? ret : len;
+}
+#endif
+
 static ssize_t compact_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -1895,6 +1975,9 @@ static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 #endif
+#ifdef CONFIG_ZRAM_MULTI_COMP
+static DEVICE_ATTR_RW(recomp_algorithm);
+#endif
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -1918,6 +2001,9 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_bd_stat.attr,
 #endif
 	&dev_attr_debug_stat.attr,
+#ifdef CONFIG_ZRAM_MULTI_COMP
+	&dev_attr_recomp_algorithm.attr,
+#endif
 	NULL,
 };
 
@@ -1997,7 +2083,7 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	zram->comp_algs[ZRAM_PRIMARY_COMP] = default_compressor;
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch

