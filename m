Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F572ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 20:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiIIUdX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 16:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIIUco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 16:32:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80923F6B8D
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 13:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5334B82655
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 20:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638B5C433D7;
        Fri,  9 Sep 2022 20:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662755552;
        bh=VVE75KtB0EQIe4qsVnfqcO6Uli1q7G2MpvjZMFDJYMU=;
        h=Date:To:From:Subject:From;
        b=Eyz/7vZild02Sg+gY2QaPh0pX47krqxeyb1xT9e9Jn3+pEQnL2KyVHiwf8Vz6L1DP
         rh8e9qzcwdCfaR62bDaykjav21YO8XUDJoFlQKsLARtSusdsamUrh9oGREw+5RJPCZ
         3+f5DAsQrhAToyLWl1c+h+KAPUZl74AY6AIUQaGA=
Date:   Fri, 09 Sep 2022 13:32:31 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch removed from -mm tree
Message-Id: <20220909203232.638B5C433D7@smtp.kernel.org>
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
Date: Mon, 29 Aug 2022 21:23:00 +0800

zswap_init_started indicates that the initialization is started.  And
zswap_init_failed indicates that the initialization is failed.  As we will
support to init zswap after system startup, it's necessary to add a state
to indicate the initialization is complete and succeed to avoid
concurrency issues.  Since we don't care about the difference between init
started with init completion.  We only need three states: uninitialized,
initialization failed, initialization succeeded.

Link: https://lkml.kernel.org/r/20220829132302.3367054-5-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
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
@@ -1515,6 +1514,7 @@ static int __init init_zswap(void)
 	frontswap_register_ops(&zswap_frontswap_ops);
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
+	zswap_init_state = ZSWAP_INIT_SUCCEED;
 	return 0;
 
 fallback_fail:
@@ -1526,7 +1526,7 @@ dstmem_fail:
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
mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch

