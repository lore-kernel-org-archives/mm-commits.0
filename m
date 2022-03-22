Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C41EC4167B
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236770AbiCVVtw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbiCVVtl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E67622BCA
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F8276174A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFBDC340EC;
        Tue, 22 Mar 2022 21:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985691;
        bh=qj3zkiXxH1lU5fnTBu/L7vSbRLdo2ycVZo2tH+WdVpM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=LR882vkSSqVZA695slKuGBExxDqoPHEq7KAyX0mlx3ISh0GAC7/VD3h9rnDl1k6L0
         cj20z3MnYDnwHMek9DHku9QXYWcXZ5/mqc+ozGREDn1+bTBcQDttD+WKAgEGcsHxyq
         05A70Z0B0F59kdkgZJS9PViinQrsAHL67cGonIb4=
Date:   Tue, 22 Mar 2022 14:48:10 -0700
To:     glider@google.com, elver@google.com, dvyukov@google.com,
        dtcccc@linux.alibaba.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 190/227] kfence: allow re-enabling KFENCE after system startup
Message-Id: <20220322214810.EAFBDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: kfence: allow re-enabling KFENCE after system startup

Patch series "provide the flexibility to enable KFENCE", v3.

If CONFIG_CONTIG_ALLOC is not supported, we fallback to try
alloc_pages_exact().  Allocating pages in this way has limits about
MAX_ORDER (default 11).  So we will not support allocating kfence pool
after system startup with a large KFENCE_NUM_OBJECTS.

When handling failures in kfence_init_pool_late(), we pair
free_pages_exact() to alloc_pages_exact() for compatibility consideration,
though it actually does the same as free_contig_range().


This patch (of 2):

If once KFENCE is disabled by:
echo 0 > /sys/module/kfence/parameters/sample_interval
KFENCE could never be re-enabled until next rebooting.

Allow re-enabling it by writing a positive num to sample_interval.

Link: https://lkml.kernel.org/r/20220307074516.6920-1-dtcccc@linux.alibaba.com
Link: https://lkml.kernel.org/r/20220307074516.6920-2-dtcccc@linux.alibaba.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c~kfence-allow-re-enabling-kfence-after-system-startup
+++ a/mm/kfence/core.c
@@ -38,14 +38,17 @@
 #define KFENCE_WARN_ON(cond)                                                   \
 	({                                                                     \
 		const bool __cond = WARN_ON(cond);                             \
-		if (unlikely(__cond))                                          \
+		if (unlikely(__cond)) {                                        \
 			WRITE_ONCE(kfence_enabled, false);                     \
+			disabled_by_warn = true;                               \
+		}                                                              \
 		__cond;                                                        \
 	})
 
 /* === Data ================================================================= */
 
 static bool kfence_enabled __read_mostly;
+static bool disabled_by_warn __read_mostly;
 
 unsigned long kfence_sample_interval __read_mostly = CONFIG_KFENCE_SAMPLE_INTERVAL;
 EXPORT_SYMBOL_GPL(kfence_sample_interval); /* Export for test modules. */
@@ -55,6 +58,7 @@ EXPORT_SYMBOL_GPL(kfence_sample_interval
 #endif
 #define MODULE_PARAM_PREFIX "kfence."
 
+static int kfence_enable_late(void);
 static int param_set_sample_interval(const char *val, const struct kernel_param *kp)
 {
 	unsigned long num;
@@ -65,10 +69,11 @@ static int param_set_sample_interval(con
 
 	if (!num) /* Using 0 to indicate KFENCE is disabled. */
 		WRITE_ONCE(kfence_enabled, false);
-	else if (!READ_ONCE(kfence_enabled) && system_state != SYSTEM_BOOTING)
-		return -EINVAL; /* Cannot (re-)enable KFENCE on-the-fly. */
 
 	*((unsigned long *)kp->arg) = num;
+
+	if (num && !READ_ONCE(kfence_enabled) && system_state != SYSTEM_BOOTING)
+		return disabled_by_warn ? -EINVAL : kfence_enable_late();
 	return 0;
 }
 
@@ -787,6 +792,16 @@ void __init kfence_init(void)
 		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
 }
 
+static int kfence_enable_late(void)
+{
+	if (!__kfence_pool)
+		return -EINVAL;
+
+	WRITE_ONCE(kfence_enabled, true);
+	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	return 0;
+}
+
 void kfence_shutdown_cache(struct kmem_cache *s)
 {
 	unsigned long flags;
_
