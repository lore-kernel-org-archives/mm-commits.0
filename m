From: akpm@linux-foundation.org
Subject: + provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:42:53 -0700
Message-ID: <200709210642.l8L6grUP022986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbXIUGnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     provide stubs for enable_irq_wake() and disable_irq_wake()
has been added to the -mm tree.  Its filename is
     provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/linux/interrupt.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/interrupt.h~provide-stubs-for-enable_irq_wake-and-disable_irq_wake include/linux/interrupt.h
--- a/include/linux/interrupt.h~provide-stubs-for-enable_irq_wake-and-disable_irq_wake
+++ a/include/linux/interrupt.h
@@ -205,6 +205,9 @@ static inline int disable_irq_wake(unsig
 						enable_irq(irq)
 # endif
 
+#define enable_irq_wake(irq) ({ (void)(irq); 0; })
+#define disable_irq_wake(irq) ({ (void)(irq); 0; })
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #ifndef __ARCH_SET_SOFTIRQ_PENDING
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

git-powerpc.patch
git-powerpc-galak.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
wake-up-from-a-serial-port.patch
