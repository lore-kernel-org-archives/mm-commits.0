From: akpm@linux-foundation.org
Subject: [merged] softirq-reduce-invoke_softirq-code-duplication.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:49 -0800
Message-ID: <20120308191749.5EEA9A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42849 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab2CHTRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:51 -0500
Received: by eaaq10 with SMTP id q10so29212eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: softirq: reduce invoke_softirq() code duplication
has been removed from the -mm tree.  Its filename was
     softirq-reduce-invoke_softirq-code-duplication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: softirq: reduce invoke_softirq() code duplication

The two invoke_softirq() variants are identical except for a single
line. So move the #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED inside one of
the functions and get rid of the other one.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN kernel/softirq.c~softirq-reduce-invoke_softirq-code-duplication kernel/softirq.c
--- a/kernel/softirq.c~softirq-reduce-invoke_softirq-code-duplication
+++ a/kernel/softirq.c
@@ -310,31 +310,21 @@ void irq_enter(void)
 	__irq_enter();
 }
 
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
+	if (!force_irqthreads) {
+#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
-	else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
-}
 #else
-static inline void invoke_softirq(void)
-{
-	if (!force_irqthreads)
 		do_softirq();
-	else {
+#endif
+	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
 }
-#endif
 
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
bitops-introduce-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch

