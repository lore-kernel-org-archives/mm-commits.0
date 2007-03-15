From: akpm@linux-foundation.org
Subject: - 26-altix-console-fix-for-config_debug_shirq-usage.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:31 -0800
Message-ID: <200703152156.l2FLuVKB027567@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXCOV5z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfg@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     2.6 Altix: console fix for CONFIG_DEBUG_SHIRQ usage
has been removed from the -mm tree.  Its filename was
     26-altix-console-fix-for-config_debug_shirq-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 2.6 Altix: console fix for CONFIG_DEBUG_SHIRQ usage
From: Pat Gefre <pfg@sgi.com>

The sn console driver was snagged by the use of CONFIG_DEBUG_SHIRQ!

The request_irq() immediate call to the interrupt handler caused
another attempt to lock the port lock - deadlock.

This is a patch to fix that.

Signed-off-by: Patrick Gefre <pfg@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sn_console.c |   52 +++++++++++-----------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff -puN drivers/serial/sn_console.c~26-altix-console-fix-for-config_debug_shirq-usage drivers/serial/sn_console.c
--- a/drivers/serial/sn_console.c~26-altix-console-fix-for-config_debug_shirq-usage
+++ a/drivers/serial/sn_console.c
@@ -636,25 +636,6 @@ static irqreturn_t sn_sal_interrupt(int 
 }
 
 /**
- * sn_sal_connect_interrupt - Request interrupt, handled by sn_sal_interrupt
- * @port: Our sn_cons_port (which contains the uart port)
- *
- * returns the console irq if interrupt is successfully registered, else 0
- *
- */
-static int sn_sal_connect_interrupt(struct sn_cons_port *port)
-{
-	if (request_irq(SGI_UART_VECTOR, sn_sal_interrupt,
-			IRQF_DISABLED | IRQF_SHARED,
-			"SAL console driver", port) >= 0) {
-		return SGI_UART_VECTOR;
-	}
-
-	printk(KERN_INFO "sn_console: console proceeding in polled mode\n");
-	return 0;
-}
-
-/**
  * sn_sal_timer_poll - this function handles polled console mode
  * @data: A pointer to our sn_cons_port (which contains the uart port)
  *
@@ -746,30 +727,31 @@ static void __init sn_sal_switch_to_asyn
  * mode.  We were previously in asynch/polling mode (using init_timer).
  *
  * We attempt to switch to interrupt mode here by calling
- * sn_sal_connect_interrupt.  If that works out, we enable receive interrupts.
+ * request_irq.  If that works out, we enable receive interrupts.
  */
 static void __init sn_sal_switch_to_interrupts(struct sn_cons_port *port)
 {
-	int irq;
 	unsigned long flags;
 
-	if (!port)
-		return;
-
-	DPRINTF("sn_console: switching to interrupt driven console\n");
-
-	spin_lock_irqsave(&port->sc_port.lock, flags);
+	if (port) {
+		DPRINTF("sn_console: switching to interrupt driven console\n");
 
-	irq = sn_sal_connect_interrupt(port);
+		if (request_irq(SGI_UART_VECTOR, sn_sal_interrupt,
+				IRQF_DISABLED | IRQF_SHARED,
+				"SAL console driver", port) >= 0) {
+			spin_lock_irqsave(&port->sc_port.lock, flags);
+			port->sc_port.irq = SGI_UART_VECTOR;
+			port->sc_ops = &intr_ops;
 
-	if (irq) {
-		port->sc_port.irq = irq;
-		port->sc_ops = &intr_ops;
-
-		/* turn on receive interrupts */
-		ia64_sn_console_intr_enable(SAL_CONSOLE_INTR_RECV);
+			/* turn on receive interrupts */
+			ia64_sn_console_intr_enable(SAL_CONSOLE_INTR_RECV);
+			spin_unlock_irqrestore(&port->sc_port.lock, flags);
+		}
+		else {
+			printk(KERN_INFO
+			    "sn_console: console proceeding in polled mode\n");
+		}
 	}
-	spin_unlock_irqrestore(&port->sc_port.lock, flags);
 }
 
 /*
_

Patches currently in -mm which might be from pfg@sgi.com are

origin.patch
