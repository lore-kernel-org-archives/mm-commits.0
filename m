From: akpm@linux-foundation.org
Subject: + genirq-warn-when-irqf_disabled-may-be-ignored.patch added to -mm tree
Date: Thu, 30 Oct 2008 15:20:55 -0700
Message-ID: <200810302220.m9UMKtMm006152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbYJ3WWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 18:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     genirq: warn when IRQF_DISABLED may be ignored
has been added to the -mm tree.  Its filename is
     genirq-warn-when-irqf_disabled-may-be-ignored.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: warn when IRQF_DISABLED may be ignored
From: David Brownell <dbrownell@users.sourceforge.net>

We periodically waste time tracking down problems from the genirq
framework not respecting IRQF_DISABLED for some shared IRQ cases.  Linus
views this as "will not fix", but we're still left with the bugs caused by
this misbehavior.

This patch adds a nag message in request_irq(), so that drivers can fix
their IRQ handlers to avoid this problem.

Note that developers will never see the relevant bugs when they run with
LOCKDEP, so it's no wonder these bugs are hard to find.  (That also means
LOCKDEP is overlooking some IRQ-related bugs involving IRQ handlers that
don't set IRQF_DISABLED...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/irq/manage.c~genirq-warn-when-irqf_disabled-may-be-ignored kernel/irq/manage.c
--- a/kernel/irq/manage.c~genirq-warn-when-irqf_disabled-may-be-ignored
+++ a/kernel/irq/manage.c
@@ -635,6 +635,18 @@ int request_irq(unsigned int irq, irq_ha
 	struct irq_desc *desc;
 	int retval;
 
+	/*
+	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
+	 * the _first_ irqaction (sigh).  That can cause oopsing, but
+	 * the behavior is classified as "will not fix" so we need to
+	 * start nudging drivers away from using that idiom.
+	 */
+	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED))
+			== (IRQF_SHARED|IRQF_DISABLED))
+		pr_warning("IRQ %d/%s: IRQF_DISABLED is not "
+				"guaranteed on shared IRQs\n",
+				irq, devname);
+
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * Lockdep wants atomic interrupt handlers:
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
rtc-ds1307-remove-legacy-probe-checks.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch

