From: akpm@linux-foundation.org
Subject: + atmel_tc-tcb_clksrc-fix-init-sequence.patch added to -mm tree
Date: Mon, 24 Jan 2011 16:12:08 -0800
Message-ID: <201101250012.p0P0C8HM019435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab1AYAMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 19:12:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: N.Voss@weinmann.de, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, n.voss@weinmann.de


The patch titled
     drivers/clocksource/tcb_clksrc.c: fix init sequence
has been added to the -mm tree.  Its filename is
     atmel_tc-tcb_clksrc-fix-init-sequence.patch

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
Subject: drivers/clocksource/tcb_clksrc.c: fix init sequence
From: "Voss, Nikolaus" <N.Voss@weinmann.de>

setup_irq() was called before clockevents_register_device() which is
needed by the irq handler.  Bug was reproducible by restarting the kernel
using kexec (reliable crash).

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/tcb_clksrc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/clocksource/tcb_clksrc.c~atmel_tc-tcb_clksrc-fix-init-sequence drivers/clocksource/tcb_clksrc.c
--- a/drivers/clocksource/tcb_clksrc.c~atmel_tc-tcb_clksrc-fix-init-sequence
+++ a/drivers/clocksource/tcb_clksrc.c
@@ -196,9 +196,9 @@ static void __init setup_clkevents(struc
 	clkevt.clkevt.min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	setup_irq(irq, &tc_irqaction);
