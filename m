Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC764C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9219D61490
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3GBl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhD3GBk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61ECA61482;
        Fri, 30 Apr 2021 06:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762452;
        bh=rep6HKRUTv6IBwjMTY5aCj3DijjQGK/hcJFjtBBCuKU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pz990X1LOAs1sXa6uHMGXNflzvtkCRyMLvnGOsU+ItXdSNlTZZxv0pyX4GNxB14iy
         bfkgXBiInQaShpGzWVopcDlNAdFKvxLNRwIhtofsPlHogT7gPB5vU/M2VuDA1xo5A9
         rzvelLMDAsu97mdTlgClRJd2sflYloxj6DHOpdKE=
Date:   Thu, 29 Apr 2021 23:00:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, frederic@kernel.org, glider@google.com,
        linux-mm@kvack.org, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        qiang.zhang@windriver.com, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 149/178] irq_work: record irq_work_queue() call
 stack
Message-ID: <20210430060052.keBnrf36M%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
