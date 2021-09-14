Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A93C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0640460F9F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhINC6P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238425AbhINC6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 22:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E964360F6F;
        Tue, 14 Sep 2021 02:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631588207;
        bh=O9HauAEZWB9VM0gGRlFRw/Hz1uheipRtS2Wggy6vIaM=;
        h=Date:From:To:Subject:From;
        b=vjpyo0urH+1l5Onv8X8cZLW1Y++rUpySUla7fIp7ScMiV1VbWhwL52uHukd5lE3UY
         FDPlQcQf26HdXVxVtlcShrbZoV2Px0Ht2pIWG/9lIBcWFmO2jM66WU/es79+5KLEta
         aMXtw61TwDvi2yykositR8kfo/spGGjIeWa7oi4c=
Date:   Mon, 13 Sep 2021 19:56:46 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  +
 workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch added to -mm
 tree
Message-ID: <20210914025646.BSThYtr_B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: workqueue, kasan: avoid alloc_pages() when recording stack
has been added to the -mm tree.  Its filename is
     workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch

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
Subject: workqueue, kasan: avoid alloc_pages() when recording stack

Shuah Khan reported:

 | When CONFIG_PROVE_RAW_LOCK_NESTING=y and CONFIG_KASAN are enabled,
 | kasan_record_aux_stack() runs into "BUG: Invalid wait context" when
 | it tries to allocate memory attempting to acquire spinlock in page
 | allocation code while holding workqueue pool raw_spinlock.
 |
 | There are several instances of this problem when block layer tries
 | to __queue_work(). Call trace from one of these instances is below:
 |
 |     kblockd_mod_delayed_work_on()
 |       mod_delayed_work_on()
 |         __queue_delayed_work()
 |           __queue_work() (rcu_read_lock, raw_spin_lock pool->lock held)
 |             insert_work()
 |               kasan_record_aux_stack()
 |                 kasan_save_stack()
 |                   stack_depot_save()
 |                     alloc_pages()
 |                       __alloc_pages()
 |                         get_page_from_freelist()
 |                           rm_queue()
 |                             rm_queue_pcplist()
 |                               local_lock_irqsave(&pagesets.lock, flags);
 |                               [ BUG: Invalid wait context triggered ]

The default kasan_record_aux_stack() calls stack_depot_save() with
GFP_NOWAIT, which in turn can then call alloc_pages(GFP_NOWAIT, ...).  In
general, however, it is not even possible to use either GFP_ATOMIC nor
GFP_NOWAIT in certain non-preemptive contexts, including raw_spin_locks
(see gfp.h and ab00db216c9c7).

Fix it by instructing stackdepot to not expand stack storage via
alloc_pages() in case it runs out by using
kasan_record_aux_stack_noalloc().

While there is an increased risk of failing to insert the stack trace,
this is typically unlikely, especially if the same insertion had already
succeeded previously (stack depot hit).  For frequent calls from the same
location, it therefore becomes extremely unlikely that
kasan_record_aux_stack_noalloc() fails.

Link: https://lkml.kernel.org/r/20210902200134.25603-1-skhan@linuxfoundation.org
Link: https://lkml.kernel.org/r/20210913112609.2651084-7-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c~workqueue-kasan-avoid-alloc_pages-when-recording-stack
+++ a/kernel/workqueue.c
@@ -1350,7 +1350,7 @@ static void insert_work(struct pool_work
 	struct worker_pool *pool = pwq->pool;
 
 	/* record the work call stack in order to print it in KASAN reports */
-	kasan_record_aux_stack(work);
+	kasan_record_aux_stack_noalloc(work);
 
 	/* we own @work, set data and link */
 	set_work_pwq(work, pwq, extra_flags);
_

Patches currently in -mm which might be from elver@google.com are

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
lib-stackdepot-include-gfph.patch
lib-stackdepot-remove-unused-function-argument.patch
lib-stackdepot-introduce-__stack_depot_save.patch
kasan-common-provide-can_alloc-in-kasan_save_stack.patch
kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
mm-fix-data-race-in-pagepoisoned.patch

