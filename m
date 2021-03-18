Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5153C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9736C64EEE
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 00:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhCRA5H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 20:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhCRA4y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 20:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B99764EED;
        Thu, 18 Mar 2021 00:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616029014;
        bh=W0N+Ub4YS/OB1QehpxADkbyZSKaZOoyGl21/R2hJA9k=;
        h=Date:From:To:Subject:From;
        b=yr46QTD13eKD+B8nYF83owCt8pynQy1s0Mz9Inh2SEVaz4LphIIoCh1o46PK0QksD
         KJEDM/aqiC4teENz0Z8B9YmD/iEqrC07C69+I6cYlzF+dO7GCjnNTpCyjpYyjYNlWs
         iR6mfvaU7jfpYfNbAH2ClzGSg5l2+58Id2jj4WU4=
Date:   Wed, 17 Mar 2021 17:56:53 -0700
From:   akpm@linux-foundation.org
To:     krzysztof.kozlowski@canonical.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, tglx@linutronix.de
Subject:  + genirq-fix-language-typos.patch added to -mm tree
Message-ID: <20210318005653.YRSp8WcUW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq/: fix language typos
has been added to the -mm tree.  Its filename is
     genirq-fix-language-typos.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/genirq-fix-language-typos.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/genirq-fix-language-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: kernel/irq/: fix language typos

Fix some language typos and misspellings in comments.  No functional
changes.

Link: https://lkml.kernel.org/r/20210316100205.23492-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c      |    6 +++---
 kernel/irq/ipi.c       |    2 +-
 kernel/irq/manage.c    |    6 +++---
 kernel/irq/matrix.c    |    2 +-
 kernel/irq/migration.c |    2 +-
 kernel/irq/resend.c    |    2 +-
 kernel/irq/timings.c   |    6 +++---
 7 files changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/irq/chip.c~genirq-fix-language-typos
+++ a/kernel/irq/chip.c
@@ -761,7 +761,7 @@ EXPORT_SYMBOL_GPL(handle_fasteoi_nmi);
  *	handle_edge_irq - edge type IRQ handler
  *	@desc:	the interrupt description structure for this irq
  *
- *	Interrupt occures on the falling and/or rising edge of a hardware
+ *	Interrupt occurs on the falling and/or rising edge of a hardware
  *	signal. The occurrence is latched into the irq controller hardware
  *	and must be acked in order to be reenabled. After the ack another
  *	interrupt can happen on the same source even before the first one
@@ -1419,7 +1419,7 @@ EXPORT_SYMBOL_GPL(irq_chip_eoi_parent);
  * @dest:	The affinity mask to set
  * @force:	Flag to enforce setting (disable online checks)
  *
- * Conditinal, as the underlying parent chip might not implement it.
+ * Conditional, as the underlying parent chip might not implement it.
  */
 int irq_chip_set_affinity_parent(struct irq_data *data,
 				 const struct cpumask *dest, bool force)
@@ -1531,7 +1531,7 @@ EXPORT_SYMBOL_GPL(irq_chip_release_resou
 #endif
 
 /**
- * irq_chip_compose_msi_msg - Componse msi message for a irq chip
+ * irq_chip_compose_msi_msg - Compose msi message for a irq chip
  * @data:	Pointer to interrupt specific data
  * @msg:	Pointer to the MSI message
  *
--- a/kernel/irq/ipi.c~genirq-fix-language-typos
+++ a/kernel/irq/ipi.c
@@ -107,7 +107,7 @@ free_descs:
  * @irq:	linux irq number to be destroyed
  * @dest:	cpumask of cpus which should have the IPI removed
  *
- * The IPIs allocated with irq_reserve_ipi() are retuerned to the system
+ * The IPIs allocated with irq_reserve_ipi() are returned to the system
  * destroying all virqs associated with them.
  *
  * Return 0 on success or error code on failure.
--- a/kernel/irq/manage.c~genirq-fix-language-typos
+++ a/kernel/irq/manage.c
@@ -179,7 +179,7 @@ bool irq_can_set_affinity_usr(unsigned i
 
 /**
  *	irq_set_thread_affinity - Notify irq threads to adjust affinity
- *	@desc:		irq descriptor which has affitnity changed
+ *	@desc:		irq descriptor which has affinity changed
  *
  *	We just set IRQTF_AFFINITY and delegate the affinity setting
  *	to the interrupt thread itself. We can not call
@@ -1153,7 +1153,7 @@ irq_forced_thread_fn(struct irq_desc *de
 
 /*
  * Interrupts explicitly requested as threaded interrupts want to be
- * preemtible - many of them need to sleep and wait for slow busses to
+ * preemptible - many of them need to sleep and wait for slow busses to
  * complete.
  */
 static irqreturn_t irq_thread_fn(struct irq_desc *desc,
@@ -2742,7 +2742,7 @@ int __irq_get_irqchip_state(struct irq_d
  *	irq_get_irqchip_state - returns the irqchip state of a interrupt.
  *	@irq: Interrupt line that is forwarded to a VM
  *	@which: One of IRQCHIP_STATE_* the caller wants to know about
- *	@state: a pointer to a boolean where the state is to be storeed
+ *	@state: a pointer to a boolean where the state is to be stored
  *
  *	This call snapshots the internal irqchip state of an
  *	interrupt, returning into @state the bit corresponding to
--- a/kernel/irq/matrix.c~genirq-fix-language-typos
+++ a/kernel/irq/matrix.c
@@ -356,7 +356,7 @@ void irq_matrix_reserve(struct irq_matri
  * irq_matrix_remove_reserved - Remove interrupt reservation
  * @m:		Matrix pointer
  *
- * This is merily a book keeping call. It decrements the number of globally
+ * This is merely a book keeping call. It decrements the number of globally
  * reserved interrupt bits. This is used to undo irq_matrix_reserve() when the
  * interrupt was never in use and a real vector allocated, which undid the
  * reservation.
--- a/kernel/irq/migration.c~genirq-fix-language-typos
+++ a/kernel/irq/migration.c
@@ -7,7 +7,7 @@
 
 /**
  * irq_fixup_move_pending - Cleanup irq move pending from a dying CPU
- * @desc:		Interrupt descpriptor to clean up
+ * @desc:		Interrupt descriptor to clean up
  * @force_clear:	If set clear the move pending bit unconditionally.
  *			If not set, clear it only when the dying CPU is the
  *			last one in the pending mask.
--- a/kernel/irq/resend.c~genirq-fix-language-typos
+++ a/kernel/irq/resend.c
@@ -128,7 +128,7 @@ int check_irq_resend(struct irq_desc *de
 	if (!try_retrigger(desc))
 		err = irq_sw_resend(desc);
 
-	/* If the retrigger was successfull, mark it with the REPLAY bit */
+	/* If the retrigger was successful, mark it with the REPLAY bit */
 	if (!err)
 		desc->istate |= IRQS_REPLAY;
 	return err;
--- a/kernel/irq/timings.c~genirq-fix-language-typos
+++ a/kernel/irq/timings.c
@@ -84,7 +84,7 @@ void irq_timings_disable(void)
  * 2. Log interval
  *
  * We saw the irq timings allow to compute the interval of the
- * occurrences for a specific interrupt. We can reasonibly assume the
+ * occurrences for a specific interrupt. We can reasonably assume the
  * longer is the interval, the higher is the error for the next event
  * and we can consider storing those interval values into an array
  * where each slot in the array correspond to an interval at the power
@@ -416,7 +416,7 @@ static u64 __irq_timings_next_event(stru
 	 * Copy the content of the circular buffer into another buffer
 	 * in order to linearize the buffer instead of dealing with
 	 * wrapping indexes and shifted array which will be prone to
-	 * error and extremelly difficult to debug.
+	 * error and extremely difficult to debug.
 	 */
 	for (i = 0; i < count; i++) {
 		int index = (start + i) & IRQ_TIMINGS_MASK;
@@ -514,7 +514,7 @@ static inline void irq_timings_store(int
  *      If more than the array size interrupts happened during the
  *      last busy/idle cycle, the index wrapped up and we have to
  *      begin with the next element in the array which is the last one
- *      in the sequence, otherwise it is a the index 0.
+ *      in the sequence, otherwise it is at the index 0.
  *
  * - have an indication of the interrupts activity on this CPU
  *   (eg. irq/sec)
_

Patches currently in -mm which might be from krzysztof.kozlowski@canonical.com are

genirq-fix-language-typos.patch

