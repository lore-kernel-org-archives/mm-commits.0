Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FBEC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65BBA6144A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhDVESO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDVESO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:18:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFD3461450;
        Thu, 22 Apr 2021 04:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065060;
        bh=A/ehHG/dYRzBHm4PhQrl1xK8ONkmtXL9Z8h0ItRmM60=;
        h=Date:From:To:Subject:From;
        b=mA5DCD3X2NSkmjRyVv5WOT9SW1GPW+9PCKgS1i5+mQYvKvKaP18cMGP+7JmXMqwxK
         h4pP3G+Os4uF4KPELpOocJh7dpZvHVc8PvP9xgK428aJeKDazNNYF3GHmz2PbBs+cH
         +yl7VduznLoM4yLmVCNqUGKumYJJbcbutbAX7ePk=
Date:   Wed, 21 Apr 2021 21:17:39 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, jannh@google.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org
Subject:  +
 kfence-use-power-efficient-work-queue-to-run-delayed-work.patch added to
 -mm tree
Message-ID: <20210422041739.UwxlbOCFB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: use power-efficient work queue to run delayed work
has been added to the -mm tree.  Its filename is
     kfence-use-power-efficient-work-queue-to-run-delayed-work.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-use-power-efficient-work-queue-to-run-delayed-work.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-use-power-efficient-work-queue-to-run-delayed-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: use power-efficient work queue to run delayed work

Use the power-efficient work queue, to avoid the pathological case where
we keep pinning ourselves on the same possibly idle CPU on systems that
want to be power-efficient (https://lwn.net/Articles/731052/).

Link: https://lkml.kernel.org/r/20210421105132.3965998-4-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~kfence-use-power-efficient-work-queue-to-run-delayed-work
+++ a/mm/kfence/core.c
@@ -636,7 +636,8 @@ static void toggle_allocation_gate(struc
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);
 #endif
-	schedule_delayed_work(&kfence_timer, msecs_to_jiffies(kfence_sample_interval));
+	queue_delayed_work(system_power_efficient_wq, &kfence_timer,
+			   msecs_to_jiffies(kfence_sample_interval));
 }
 static DECLARE_DELAYED_WORK(kfence_timer, toggle_allocation_gate);
 
@@ -665,7 +666,7 @@ void __init kfence_init(void)
 	}
 
 	WRITE_ONCE(kfence_enabled, true);
-	schedule_delayed_work(&kfence_timer, 0);
+	queue_delayed_work(system_power_efficient_wq, &kfence_timer, 0);
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
 		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
_

Patches currently in -mm which might be from elver@google.com are

kfence-zero-guard-page-after-out-of-bounds-access.patch
kfence-await-for-allocation-using-wait_event.patch
kfence-maximize-allocation-wait-timeout-duration.patch
kfence-use-power-efficient-work-queue-to-run-delayed-work.patch

