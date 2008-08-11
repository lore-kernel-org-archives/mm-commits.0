From: akpm@linux-foundation.org
Subject: + irq-warn-about-irqf_disabledirqf_shared.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:54:20 -0700
Message-ID: <200808112054.m7BKsK4V020918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYHKUz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     irq: warn about (IRQF_DISABLED|IRQF_SHARED)
has been added to the -mm tree.  Its filename is
     irq-warn-about-irqf_disabledirqf_shared.patch

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
Subject: irq: warn about (IRQF_DISABLED|IRQF_SHARED)
From: David Brownell <dbrownell@users.sourceforge.net>

We periodically waste time tracking down problems caused by the IRQ
framework not respecting IRQF_DISABLED for some shared IRQ cases.  Linus
views this as "will not fix", but we're still left with the bugs caused by
this misbehavior.

This patch adds a nag message in request_irq(), so that drivers can fix
their IRQ handlers to avoid this problem.

Note that developers will never see the relevant bugs when they run with
LOCKDEP, so it's no wonder these bugs are hard to find.  (That also means
LOCKDEP is overlooking some IRQ-related bugs involving IRQ handlers that
don't set IRQF_DISABLED...)

This was the root cause of some USB oopsing a while back ...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/irq/manage.c~irq-warn-about-irqf_disabledirqf_shared kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-warn-about-irqf_disabledirqf_shared
+++ a/kernel/irq/manage.c
@@ -604,6 +604,18 @@ int request_irq(unsigned int irq, irq_ha
 	struct irqaction *action;
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

revert-rtc-cdev-lock_kernel-pushdown.patch
linux-next.patch
usb-hso-driver-fix-kconfig.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
irq-warn-about-irqf_disabledirqf_shared.patch

