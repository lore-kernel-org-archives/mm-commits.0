Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33EEC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9F3D61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhEHWpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWpq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F506100C;
        Sat,  8 May 2021 22:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513884;
        bh=t4PaoG0ciOMCIHk7D4KoAztOX2mGPgDJwM60VDDxRjA=;
        h=Date:From:To:Subject:From;
        b=wJ+bt7eWiyqGmA+oVhDqCrC15OQO48MEJk8uhr77ymcFj/7Yo2ZMQZfotzNHpJo0R
         hSSv1bm4H6Vnfs7VkSJAvYZcD04bIqN1xpFV1QBe6FEhrGguJg/kjGIVcy4pEluCng
         +uFipa68agjPHq0PyluKr8FE2al56L3nznbBR5Q8=
Date:   Sat, 08 May 2021 15:44:43 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, frederic@kernel.org,
        glider@google.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        qiang.zhang@windriver.com, ryabinin.a.a@gmail.com,
        walter-zh.wu@mediatek.com
Subject:  [merged] irq_work-record-irq_work_queue-call-stack.patch
 removed from -mm tree
Message-ID: <20210508224443.ex5Zdh7nk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: irq_work: record irq_work_queue() call stack
has been removed from the -mm tree.  Its filename was
     irq_work-record-irq_work_queue-call-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


