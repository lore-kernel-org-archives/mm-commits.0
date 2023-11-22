Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55702C27C40
	for <mm-commits@archiver.kernel.org>; Wed, 22 Nov 2023 21:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjKVVKt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjKVVKk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Nov 2023 16:10:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296251B9
        for <mm-commits@vger.kernel.org>; Wed, 22 Nov 2023 13:10:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61011C433C8;
        Wed, 22 Nov 2023 21:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700687436;
        bh=lA/P6Tf6GxhUpW7Q2c/EclzcXq4+gsMrc49BFeqLVKU=;
        h=Date:To:From:Subject:From;
        b=0yx/GBeGbvAXIePCSe5gi80+okPoJx1Zyq108868/Fxvh7r3Mya7MQTYPifSm5dEe
         cHRzj52Eyh1NBc5oewXgX9JxsGbXfTax9bFCM76tCSnStSAH0C0eutN1mjT1BrVCTi
         IrewYH68HR8iw823qQglodTCcWuT2/OygvyNPUgE=
Date:   Wed, 22 Nov 2023 13:10:34 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, juntong.deng@outlook.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] kfence-replace-local_clock-with-ktime_get_boot_fast_ns.patch removed from -mm tree
Message-Id: <20231122211036.61011C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kfence: replace local_clock() with ktime_get_boot_fast_ns()
has been removed from the -mm tree.  Its filename was
     kfence-replace-local_clock-with-ktime_get_boot_fast_ns.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Juntong Deng <juntong.deng@outlook.com>
Subject: kfence: replace local_clock() with ktime_get_boot_fast_ns()
Date: Wed, 22 Nov 2023 20:00:26 +0000

The time obtained by local_clock() is the local CPU time, which may
drift between CPUs and is not suitable for comparison across CPUs.

It is possible for allocation and free to occur on different CPUs,
and using local_clock() to record timestamps may cause confusion.

ktime_get_boot_fast_ns() is based on clock sources and can be used
reliably and accurately for comparison across CPUs.

Link: https://lkml.kernel.org/r/VI1P193MB0752A2F21C050D701945B62799BAA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/core.c~kfence-replace-local_clock-with-ktime_get_boot_fast_ns
+++ a/mm/kfence/core.c
@@ -295,7 +295,7 @@ metadata_update_state(struct kfence_meta
 	track->num_stack_entries = num_stack_entries;
 	track->pid = task_pid_nr(current);
 	track->cpu = raw_smp_processor_id();
-	track->ts_nsec = local_clock(); /* Same source as printk timestamps. */
+	track->ts_nsec = ktime_get_boot_fast_ns();
 
 	/*
 	 * Pairs with READ_ONCE() in
_

Patches currently in -mm which might be from juntong.deng@outlook.com are

kasan-improve-free-meta-storage-in-generic-kasan.patch

