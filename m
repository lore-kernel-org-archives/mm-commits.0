From: akpm@linux-foundation.org
Subject: + kernel-irq-chipc-irq-disable-shutdown-bug.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:55 -0800
Message-ID: <200802230733.m1N7Xi2i018247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYBWHyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Michael.Hennerich@analog.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/irq/chip.c IRQ disable, shutdown bug
has been added to the -mm tree.  Its filename is
     kernel-irq-chipc-irq-disable-shutdown-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/irq/chip.c IRQ disable, shutdown bug
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>

free_irq() does not disable/mask the irq, in case disable or shutdown in
struct irq_chip is left uninitilazied.

/**
 * struct irq_chip - hardware interrupt chip descriptor
 *
 * @name:		name for /proc/interrupts
 * @startup:		start up the interrupt (defaults to ->enable if NULL)
 * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
 * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
 * @disable:		disable the interrupt (defaults to chip->mask if NULL)

According to linux/irq.h struct irq_chip information, chip->disable should
default to chip->mask if NULL.  However irq_chip_set_defaults(struct irq_chip
*chip) will set it to default_disable a empty function.

Looking through various architectures, it's pretty common that disable and
shutdown is NULL.  So this bug affects many architectures.

This patch fixes the issue.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/irq/chip.c~kernel-irq-chipc-irq-disable-shutdown-bug kernel/irq/chip.c
--- a/kernel/irq/chip.c~kernel-irq-chipc-irq-disable-shutdown-bug
+++ a/kernel/irq/chip.c
@@ -233,6 +233,10 @@ static void default_enable(unsigned int 
  */
 static void default_disable(unsigned int irq)
 {
+       struct irq_desc *desc = irq_desc + irq;
+
+       desc->chip->mask(irq);
+       desc->status |= IRQ_MASKED;
 }
 
 /*
_

Patches currently in -mm which might be from Michael.Hennerich@analog.com are

kernel-irq-chipc-irq-disable-shutdown-bug.patch
