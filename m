Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B64C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 18:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343952AbiDSSEh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343940AbiDSSEh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 14:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5D1186F8
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 11:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B89FCB8180C
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 18:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F0EC385A5;
        Tue, 19 Apr 2022 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650391311;
        bh=AKWbaJyKozt8nlYIjhim9q5v9rnzwOdECBay/y3XSvs=;
        h=Date:To:From:Subject:From;
        b=LmasTTQqjpmYxe2pHHEdYQIpsieEPA4Cu51tC/We7hrrDB+8N0uJUknQHwVT9Gjdn
         NvJOlqBLldxXSvIg3UCljJ3YGG76sIH8mNnFKfbXaDraPa+K7Lx85kpkcl613ONNBw
         mIgGCH/KvwGwqtvuaDRo4B0b/DUz8eJ1JinBU2SU=
Date:   Tue, 19 Apr 2022 11:01:50 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, hch@infradead.org,
        gregkh@linuxfoundation.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-irq_poll-add-local_bh_disable-in-irq_poll_cpu_dead.patch removed from -mm tree
Message-Id: <20220419180151.61F0EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/irq_poll: Add local_bh_disable() in irq_poll_cpu_dead()
has been removed from the -mm tree.  Its filename was
     lib-irq_poll-add-local_bh_disable-in-irq_poll_cpu_dead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: lib/irq_poll: Add local_bh_disable() in irq_poll_cpu_dead()

irq_poll_cpu_dead() pulls the blk_cpu_iopoll backlog from the dead CPU and
raises the POLL softirq with __raise_softirq_irqoff() on the CPU it is
running on.  That just sets the bit in the pending softirq mask.

This means the handling of the softirq is delayed until the next interrupt
or a local_bh_disable/enable() pair.  As a consequence the CPU on which
this code runs can reach idle with the POLL softirq pending, which
triggers a warning in the NOHZ idle code.

Add a local_bh_disable/enable() pair around the interrupts disabled
section in irq_poll_cpu_dead().  local_bh_enable will handle the pending
softirq.

[@linutronix.de: massaged changelog and comment]
Link: https://lkml.kernel.org/r/87k0bxgl27.ffs@tglx
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/irq_poll.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/irq_poll.c~lib-irq_poll-add-local_bh_disable-in-irq_poll_cpu_dead
+++ a/lib/irq_poll.c
@@ -188,14 +188,18 @@ EXPORT_SYMBOL(irq_poll_init);
 static int irq_poll_cpu_dead(unsigned int cpu)
 {
 	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
+	 * If a CPU goes away, splice its entries to the current CPU and
+	 * set the POLL softirq bit. The local_bh_disable()/enable() pair
+	 * ensures that it is handled. Otherwise the current CPU could
+	 * reach idle with the POLL softirq pending.
 	 */
+	local_bh_disable();
 	local_irq_disable();
 	list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
 			 this_cpu_ptr(&blk_cpu_iopoll));
 	__raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);
 	local_irq_enable();
+	local_bh_enable();
 
 	return 0;
 }
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


