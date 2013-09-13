From: akpm@linux-foundation.org
Subject: [wrecked]
 include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch removed from -mm tree
Date: Fri, 13 Sep 2013 12:36:16 -0700
Message-ID: <52336930.ZDJWOhWEjk+yJJOr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3IMTgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 15:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, gang.chen@asianux.com

Subject: [wrecked] include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch removed from -mm tree
To: gang.chen@asianux.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 12:36:16 -0700


The patch titled
     Subject: include/linux/interrupt.h: add dummy irq_set_irq_wake() for "!GENERIC_HARDIRQS"
has been removed from the -mm tree.  Its filename was
     include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: include/linux/interrupt.h: add dummy irq_set_irq_wake() for "!GENERIC_HARDIRQS"

Since irq_set_irq_wake() has already declared in header file, when
GENERIC_HARDIRQS enabled.

Recommend to define the dummy one for GENERIC_HARDIRQS disabled, and also
let the other related "static inline" functions are independent from
GENERIC_HARDIRQS.

So can avoid the compiling error below, and also let the code simpler
and clearer.

The related compiling error (ARCH=s390 allmodconfig):

  sound/soc/codecs/wm0010.c: In function ‘wm0010_spi_probe’:
  sound/soc/codecs/wm0010.c:976:2: error: implicit declaration of function ‘irq_set_irq_wake’ [-Werror=implicit-function-declaration]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interrupt.h |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN include/linux/interrupt.h~include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs include/linux/interrupt.h
--- a/include/linux/interrupt.h~include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs
+++ a/include/linux/interrupt.h
@@ -344,16 +344,6 @@ static inline void enable_irq_lockdep_ir
 /* IRQ wakeup (PM) control: */
 extern int irq_set_irq_wake(unsigned int irq, unsigned int on);
 
-static inline int enable_irq_wake(unsigned int irq)
-{
-	return irq_set_irq_wake(irq, 1);
-}
-
-static inline int disable_irq_wake(unsigned int irq)
-{
-	return irq_set_irq_wake(irq, 0);
-}
-
 #else /* !CONFIG_GENERIC_HARDIRQS */
 /*
  * NOTE: non-genirq architectures, if they want to support the lock
@@ -370,16 +360,23 @@ static inline int disable_irq_wake(unsig
 						enable_irq(irq)
 # endif
 
-static inline int enable_irq_wake(unsigned int irq)
+/* IRQ wakeup (PM) control: */
+static inline int irq_set_irq_wake(unsigned int irq, unsigned int on)
 {
 	return 0;
 }
 
+#endif /* CONFIG_GENERIC_HARDIRQS */
+
+static inline int enable_irq_wake(unsigned int irq)
+{
+	return irq_set_irq_wake(irq, 1);
+}
+
 static inline int disable_irq_wake(unsigned int irq)
 {
-	return 0;
+	return irq_set_irq_wake(irq, 0);
 }
-#endif /* CONFIG_GENERIC_HARDIRQS */
 
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
h8300-kernel-timer-timer8c-add-missing-semicolon.patch
linux-next.patch

