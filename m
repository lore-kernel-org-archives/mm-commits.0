From: akpm@linux-foundation.org
Subject: + provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:19:05 -0700
Message-ID: <200709210719.l8L7J5iS024251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbXIUHTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:19:55 -0400
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

git-powerpc.patch
git-powerpc-galak.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
wake-up-from-a-serial-port.patch
