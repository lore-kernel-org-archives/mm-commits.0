From: akpm@linux-foundation.org
Subject: [merged] atmel_tc-tcb_clksrc-fix-init-sequence.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:52 -0800
Message-ID: <201101262032.p0QKWqWH003231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112Ab1AZUdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: N.Voss@weinmann.de, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, n.voss@weinmann.de, mm-commits@vger.kernel.org


The patch titled
     drivers/clocksource/tcb_clksrc.c: fix init sequence
has been removed from the -mm tree.  Its filename was
     atmel_tc-tcb_clksrc-fix-init-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
