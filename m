Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80039C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 680396124B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 22:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhIWWGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhIWWGJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:06:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D807561241;
        Thu, 23 Sep 2021 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632434677;
        bh=7Q2clpBv3yFe/qanZumWd5MRYz8U5qkWYpaCKRsdA6s=;
        h=Date:From:To:Subject:From;
        b=2Bswzkb3XVClrfBoZjaKGCzyJUoPYh7P0GFPoIXvHSw5WAAQzMlIs6EAswBQqzwni
         Aa1qzh9kPsn8nGDpAgunIKha/J3Cpig6w6eF5Qd91gJ2mYsN53dyfNs7i1B/1p8xaG
         DL1i3+oLN6EOtAO4pL9lvGopYvrTRWO0deRmoJng=
Date:   Thu, 23 Sep 2021 15:04:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  + kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
 added to -mm tree
Message-ID: <20210923220436.EWtaO1pON%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: allocate per-CPU memory on the relevant node
has been added to the -mm tree.  Its filename is
     kcov-allocate-per-cpu-memory-on-the-relevant-node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcov-allocate-per-cpu-memory-on-the-relevant-node.patch

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
Subject: kcov: allocate per-CPU memory on the relevant node

During boot kcov allocates per-CPU memory which is used later if remote/
softirq processing is enabled.

Allocate the per-CPU memory on the CPU local node to avoid cross node
memory access.

Link: https://lkml.kernel.org/r/20210923164741.1859522-4-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-4-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c~kcov-allocate-per-cpu-memory-on-the-relevant-node
+++ a/kernel/kcov.c
@@ -1034,8 +1034,8 @@ static int __init kcov_init(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		void *area = vmalloc(CONFIG_KCOV_IRQ_AREA_SIZE *
-				sizeof(unsigned long));
+		void *area = vmalloc_node(CONFIG_KCOV_IRQ_AREA_SIZE *
+				sizeof(unsigned long), cpu_to_node(cpu));
 		if (!area)
 			return -ENOMEM;
 		per_cpu_ptr(&kcov_percpu_data, cpu)->irq_area = area;
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-zsmalloc-on-preempt_rt.patch
documentation-kcov-include-typesh-in-the-example.patch
documentation-kcov-define-ip-in-the-example.patch
kcov-allocate-per-cpu-memory-on-the-relevant-node.patch
kcov-avoid-enabledisable-interrupts-if-in_task.patch
kcov-replace-local_irq_save-with-a-local_lock_t.patch

