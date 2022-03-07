Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84AD9C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 02:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiCGCMj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 21:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiCGCMj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 21:12:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124EDE0E7
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 18:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A9461124
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 02:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D24C340EC;
        Mon,  7 Mar 2022 02:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646619105;
        bh=dqYogKFd93kGrSjZg3MgKX2DpdWcNDqIy2cqjIE9onc=;
        h=Date:To:From:Subject:From;
        b=xhEq6CbwU8MFuLdNH+GqrEONbK2bM7qZ8/hCn7YO5gaor2dKBPR7RclkJf1sDi6ku
         ws/+DZ88Q96Km3adL+rfuSt+B7QD9kittnYDJDTF+C5ZkSLbZHhEb+k56nSlcvzIV+
         TLGcOuzGTU/GsrFzcy3RoWt0XoIni1DoXQs+JIvY=
Date:   Sun, 06 Mar 2022 18:11:44 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, dtcccc@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kfence-allow-re-enabling-kfence-after-system-startup.patch removed from -mm tree
Message-Id: <20220307021145.07D24C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: allow re-enabling KFENCE after system startup
has been removed from the -mm tree.  Its filename was
     kfence-allow-re-enabling-kfence-after-system-startup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: kfence: allow re-enabling KFENCE after system startup

Patch series "provide the flexibility to enable KFENCE", v2.


This patch (of 2):

If once KFENCE is disabled by:
echo 0 > /sys/module/kfence/parameters/sample_interval
KFENCE could never be re-enabled until next rebooting.

Allow re-enabling it by writing a positive num to sample_interval.

Link: https://lkml.kernel.org/r/20220305144858.17040-1-dtcccc@linux.alibaba.com
Link: https://lkml.kernel.org/r/20220305144858.17040-2-dtcccc@linux.alibaba.com
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
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

Patches currently in -mm which might be from dtcccc@linux.alibaba.com are

kfence-alloc-kfence_pool-after-system-startup.patch

