Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68EDC11F66
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9265E61CA2
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGFTYA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhGFTYA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E69A61C9C;
        Tue,  6 Jul 2021 19:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599281;
        bh=U+XbiQiJWXn405hP/yNMWTKuueExMC0UcSVWUbR1jhM=;
        h=Date:From:To:Subject:From;
        b=SHaCv2CEHJa4LosNU7WxOrG+70qnoOOXEz7AiWG9LWKuUbRyE0nll29BZsBrBWUKh
         X7f9tU1wmrGlsDh09Sii9nv9q5CDvSxahi3T9Fart7vTtrWkidOz8uZ9TYTDVGyLk5
         ehMzYZYN0S6x+rwXAVxmVNmPzIhM9rqOGVYXtg2w=
Date:   Tue, 06 Jul 2021 12:21:21 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kfence-unconditionally-use-unbound-work-queue.patch removed from -mm tree
Message-ID: <20210706192121.LmYD3h65A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: unconditionally use unbound work queue
has been removed from the -mm tree.  Its filename was
     kfence-unconditionally-use-unbound-work-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: unconditionally use unbound work queue

Unconditionally use unbound work queue, and not just if wq_power_efficient
is true.  Because if the system is idle, KFENCE may wait, and by being run
on the unbound work queue, we permit the scheduler to make better
scheduling decisions and not require pinning KFENCE to the same CPU upon
waking up.

Link: https://lkml.kernel.org/r/20210521111630.472579-1-elver@google.com
Fixes: 36f0b35d0894 ("kfence: use power-efficient work queue to run delayed work")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Hillf Danton <hdanton@sina.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~kfence-unconditionally-use-unbound-work-queue
+++ a/mm/kfence/core.c
@@ -636,7 +636,7 @@ static void toggle_allocation_gate(struc
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
-	queue_delayed_work(system_power_efficient_wq, &kfence_timer,
+	queue_delayed_work(system_unbound_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
 static DECLARE_DELAYED_WORK(kfence_timer, toggle_allocation_gate);
@@ -666,7 +666,7 @@ void __init kfence_init(void)
 	}
 
 	WRITE_ONCE(kfence_enabled, true);
-	queue_delayed_work(system_power_efficient_wq, &kfence_timer, 0);
+	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
 		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
_

Patches currently in -mm which might be from elver@google.com are


