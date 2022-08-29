Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D35BECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 19:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiH2T6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 15:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiH2T5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 15:57:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDA492F51
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 12:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D009B811F5
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 19:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C8DC433C1;
        Mon, 29 Aug 2022 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661803022;
        bh=1WWXKPsaVAxOoMhn/7pMgN/5V3/LBDgQib++jEAMOvQ=;
        h=Date:To:From:Subject:From;
        b=nFVfh9iFXtu+dQr73TlJnIuv4tQ4pnJPoLivSX/re2NR423KhTfx37wBH7iulAwVE
         fZnQQAj46BrCN9LVpxIZGBTKawgUGB+3NhUF5EG+w0k5/NZtnU5PH+ToQeZmx7J6oH
         LvjylRYdKLPHAxXoAXqfYLH/G47GO2ppdF2niOLU=
Date:   Mon, 29 Aug 2022 12:57:01 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch removed from -mm tree
Message-Id: <20220829195702.B5C8DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zswap: replace zswap_init_{started/failed} with zswap_init_state
has been removed from the -mm tree.  Its filename was
     mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: replace zswap_init_{started/failed} with zswap_init_state
Date: Sat, 27 Aug 2022 18:45:58 +0800

zswap_init_started indicates that the initialization is started.  And
zswap_init_failed indicates that the initialization is failed.  As we will
support to init zswap after system startup, it's necessary to add a state
to indicate the initialization is complete and succeed to avoid
concurrency issues.  Since we don't care about the difference between init
started with init completion.  We only need three states: uninitialized,
initial failed, initial succeed.

Link: https://lkml.kernel.org/r/20220827104600.1813214-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/zswap.c~mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state
+++ a/mm/zswap.c
@@ -214,11 +214,12 @@ static DEFINE_SPINLOCK(zswap_pools_lock)
 /* pool counter to provide unique names to zpool */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
-/* used by param callback function */
-static bool zswap_init_started;
+#define ZSWAP_UNINIT		0
+#define ZSWAP_INIT_SUCCEED	1
+#define ZSWAP_INIT_FAILED	2
 
-/* fatal error during init */
-static bool zswap_init_failed;
+/* init state */
+static int zswap_init_state;
 
 /* init completed, but couldn't create the initial pool */
 static bool zswap_has_pool;
@@ -772,7 +773,7 @@ static int __zswap_param_set(const char
 	char *s = strstrip((char *)val);
 	int ret;
 
-	if (zswap_init_failed) {
+	if (zswap_init_state == ZSWAP_INIT_FAILED) {
 		pr_err("can't set param, initialization failed\n");
 		return -ENODEV;
 	}
@@ -784,7 +785,7 @@ static int __zswap_param_set(const char
 	/* if this is load-time (pre-init) param setting,
 	 * don't create a pool; that's done during init.
 	 */
-	if (!zswap_init_started)
+	if (zswap_init_state == ZSWAP_UNINIT)
 		return param_set_charp(s, kp);
 
 	if (!type) {
@@ -875,11 +876,11 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
-	if (zswap_init_failed) {
+	if (zswap_init_state == ZSWAP_INIT_FAILED) {
 		pr_err("can't enable, initialization failed\n");
 		return -ENODEV;
 	}
-	if (!zswap_has_pool && zswap_init_started) {
+	if (!zswap_has_pool && zswap_init_state == ZSWAP_INIT_SUCCEED) {
 		pr_err("can't enable, no pool configured\n");
 		return -ENODEV;
 	}
@@ -1476,8 +1477,6 @@ static int __init init_zswap(void)
 	struct zswap_pool *pool;
 	int ret;
 
-	zswap_init_started = true;
-
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
 		goto cache_fail;
@@ -1517,6 +1516,7 @@ static int __init init_zswap(void)
 		goto destroy_wq;
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
+	zswap_init_state = ZSWAP_INIT_SUCCEED;
 	return 0;
 
 destroy_wq:
@@ -1530,7 +1530,7 @@ dstmem_fail:
 	zswap_entry_cache_destroy();
 cache_fail:
 	/* if built-in, we aren't unloaded on failure; don't allow use */
-	zswap_init_failed = true;
+	zswap_init_state = ZSWAP_INIT_FAILED;
 	zswap_enabled = false;
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

