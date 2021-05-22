Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4967EC2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 21:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179A761164
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 21:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhEVVD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 17:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231379AbhEVVD7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 17:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD01161163;
        Sat, 22 May 2021 21:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621717352;
        bh=xfJlnOwNxkZSTEGRb8fXdrr0zLn8dwgX5xi3DKOjFuI=;
        h=Date:From:To:Subject:From;
        b=IVKzR+tZzv/vAm/aRQ66GSE+cSLrbev+pD55Xn7pT9BXWwM3zWA7tPMLxpWMMx66f
         fEbVVLv+PMWKkueIPxRcRSSbAw3cZrDIRslZOXB2dAxHWMTaCoftVMmHcT8oV7+ESl
         R5sNX9DKrn//OIecFknIuAALwXr/dhA+PbowDhXY=
Date:   Sat, 22 May 2021 14:02:32 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, mm-commits@vger.kernel.org
Subject:  + kfence-unconditionally-use-unbound-work-queue.patch
 added to -mm tree
Message-ID: <20210522210232.NSTKUMVyf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: unconditionally use unbound work queue
has been added to the -mm tree.  Its filename is
     kfence-unconditionally-use-unbound-work-queue.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-unconditionally-use-unbound-work-queue.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-unconditionally-use-unbound-work-queue.patch

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

mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
printk-introduce-dump_stack_lvl-fix.patch
kfence-unconditionally-use-unbound-work-queue.patch

