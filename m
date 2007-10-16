From: akpm@linux-foundation.org
Subject: - provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:58 -0700
Message-ID: <200710162029.l9GKTwdM014358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935241AbXJPUaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     provide stubs for enable_irq_wake() and disable_irq_wake()
has been removed from the -mm tree.  Its filename was
     provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: provide stubs for enable_irq_wake() and disable_irq_wake()
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Provide {enable,disable}_irq_wakeup dummies for undefined
cross-compilers for platforms without CONFIG_GENERIC_IRQ.

Needed by wake-up-from-a-serial-port.patch

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/interrupt.h~provide-stubs-for-enable_irq_wake-and-disable_irq_wake include/linux/interrupt.h
--- a/include/linux/interrupt.h~provide-stubs-for-enable_irq_wake-and-disable_irq_wake
+++ a/include/linux/interrupt.h
@@ -205,6 +205,15 @@ static inline int disable_irq_wake(unsig
 						enable_irq(irq)
 # endif
 
+static inline int enable_irq_wake(unsigned int irq)
+{
+	return 0;
+}
+
+static inline int disable_irq_wake(unsigned int irq)
+{
+	return 0;
+}
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #ifndef __ARCH_SET_SOFTIRQ_PENDING
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

origin.patch
