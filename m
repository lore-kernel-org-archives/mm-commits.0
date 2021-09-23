Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99696C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEBD6124F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhIWWGL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235768AbhIWWGL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C276124B;
        Thu, 23 Sep 2021 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632434679;
        bh=OAM9BMNJez7DyUH4XucfHAsfue+qJG9tP/ZzDlQxmS8=;
        h=Date:From:To:Subject:From;
        b=SkW/K+ofw4hKmi0jIBkSO43QBlh7geafukAnQfCdqXdhuiCnjr2wIZeNjb0eLkP2+
         RVMcKjqMyrA1E1B1S7Hvxd6Z/q8n3SZgDxRDruW8pC8qNgVRNHj+wk3nSRD5G/lWGb
         cGhV+fCyj0VSTlr5Lt2hvSMn3SUPF454w3d2VDbE=
Date:   Thu, 23 Sep 2021 15:04:38 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  + kcov-avoid-enabledisable-interrupts-if-in_task.patch
 added to -mm tree
Message-ID: <20210923220438.UpLfx-4o_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: avoid enable+disable interrupts if !in_task()
has been added to the -mm tree.  Its filename is
     kcov-avoid-enabledisable-interrupts-if-in_task.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-avoid-enabledisable-interrupts-if-in_task.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-avoid-enabledisable-interrupts-if-in_task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: kcov: avoid enable+disable interrupts if !in_task()

kcov_remote_start() may need to allocate memory in the in_task() case
(otherwise per-CPU memory has been pre-allocated) and therefore requires
enabled interrupts.

The interrupts are enabled before checking if the allocation is required
so if no allocation is required then the interrupts are needlessly enabled
and disabled again.

Enable interrupts only if memory allocation is performed.

Link: https://lkml.kernel.org/r/20210923164741.1859522-5-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-5-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/kcov.c~kcov-avoid-enabledisable-interrupts-if-in_task
+++ a/kernel/kcov.c
@@ -869,19 +869,19 @@ void kcov_remote_start(u64 handle)
 		size = CONFIG_KCOV_IRQ_AREA_SIZE;
 		area = this_cpu_ptr(&kcov_percpu_data)->irq_area;
 	}
-	spin_unlock_irqrestore(&kcov_remote_lock, flags);
+	spin_unlock(&kcov_remote_lock);
 
 	/* Can only happen when in_task(). */
 	if (!area) {
+		local_irqrestore(flags);
 		area = vmalloc(size * sizeof(unsigned long));
 		if (!area) {
 			kcov_put(kcov);
 			return;
 		}
+		local_irq_save(flags);
 	}
 
-	local_irq_save(flags);
-
 	/* Reset coverage size. */
 	*(u64 *)area = 0;
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-zsmalloc-on-preempt_rt.patch
documentation-kcov-include-typesh-in-the-example.patch
documentation-kcov-define-ip-in-the-example.patch
kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
kcov-avoid-enabledisable-interrupts-if-in_task.patch
kcov-replace-local_irq_save-with-a-local_lock_t.patch

