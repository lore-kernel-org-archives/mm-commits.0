Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4494BC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15BCF611AB
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbhDCAYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDCAYp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE50C61185;
        Sat,  3 Apr 2021 00:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617409483;
        bh=tFWEGNJm7GgChNQnSR+R5C3DWkH/tURMtSgWvwKLqlU=;
        h=Date:From:To:Subject:From;
        b=V/r+Wo8hQ0leNdICjx3IpQIPJK5ImDGCi5Y1wPV8A7wBCY3KXswtnKK2J+5qCbdy/
         kuIeD3qSm95nCvwj3jLe7wWIOzCuk56h6i0Mx0yCAWtZkEMf83SmWZ2lShIdL1lEA0
         3xwGP4EKtUgWXofFuHeaX06wL+EpLQ0Hcl0CPA0I=
Date:   Fri, 02 Apr 2021 17:24:42 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, frederic@kernel.org,
        glider@google.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        qiang.zhang@windriver.com, ryabinin.a.a@gmail.com,
        walter-zh.wu@mediatek.com
Subject:  + irq_work-record-irq_work_queue-call-stack.patch added
 to -mm tree
Message-ID: <20210403002442.StyBsSvaB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: irq_work: record irq_work_queue() call stack
has been added to the -mm tree.  Its filename is
     irq_work-record-irq_work_queue-call-stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/irq_work-record-irq_work_queue-call-stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/irq_work-record-irq_work_queue-call-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zqiang <qiang.zhang@windriver.com>
Subject: irq_work: record irq_work_queue() call stack

Add the irq_work_queue() call stack into the KASAN auxiliary stack in
order to improve KASAN reports.  this will let us know where the irq work
be queued.

Link: https://lkml.kernel.org/r/20210331063202.28770-1-qiang.zhang@windriver.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq_work.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/irq_work.c~irq_work-record-irq_work_queue-call-stack
+++ a/kernel/irq_work.c
@@ -19,7 +19,7 @@
 #include <linux/notifier.h>
 #include <linux/smp.h>
 #include <asm/processor.h>
-
+#include <linux/kasan.h>
 
 static DEFINE_PER_CPU(struct llist_head, raised_list);
 static DEFINE_PER_CPU(struct llist_head, lazy_list);
@@ -70,6 +70,9 @@ bool irq_work_queue(struct irq_work *wor
 	if (!irq_work_claim(work))
 		return false;
 
+	/*record irq_work call stack in order to print it in KASAN reports*/
+	kasan_record_aux_stack(work);
+
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 	__irq_work_queue_local(work);
@@ -98,6 +101,8 @@ bool irq_work_queue_on(struct irq_work *
 	if (!irq_work_claim(work))
 		return false;
 
+	kasan_record_aux_stack(work);
+
 	preempt_disable();
 	if (cpu != smp_processor_id()) {
 		/* Arch remote IPI send/receive backend aren't NMI safe */
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are

irq_work-record-irq_work_queue-call-stack.patch
lib-stackdepot-turn-depot_lock-spinlock-to-raw_spinlock.patch

