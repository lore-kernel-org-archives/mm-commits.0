From: akpm@linux-foundation.org
Subject: - m32r-fix-ei_tx_timeout-in-drivers-net-lib8390c.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:12:32 -0700
Message-ID: <200707290612.l6T6CWsB011133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759531AbXG2GYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takata@linux-m32r.org, hitoshiy@linux-m32r.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     m32r: Fix ei_tx_timeout() in drivers/net/lib8390.c
has been removed from the -mm tree.  Its filename was
     m32r-fix-ei_tx_timeout-in-drivers-net-lib8390c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m32r: Fix ei_tx_timeout() in drivers/net/lib8390.c
From: Hirokazu Takata <takata@linux-m32r.org>

Change INT0 trigger mode from edge-sense mode to level-sense mode,
in order to fix the following timeout error:
  'NETDEV WATCHDOG: eth0: transmit timed out'.

This patch is required only for the Mappi platform.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Cc: Hitoshi Yamamoto <hitoshiy@linux-m32r.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/setup_mappi.c |    5 +++--
 drivers/net/lib8390.c          |    9 ---------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff -puN arch/m32r/kernel/setup_mappi.c~m32r-fix-ei_tx_timeout-in-drivers-net-lib8390c arch/m32r/kernel/setup_mappi.c
--- a/arch/m32r/kernel/setup_mappi.c~m32r-fix-ei_tx_timeout-in-drivers-net-lib8390c
+++ a/arch/m32r/kernel/setup_mappi.c
@@ -45,7 +45,8 @@ static void mask_and_ack_mappi(unsigned 
 
 static void end_mappi_irq(unsigned int irq)
 {
-	enable_mappi_irq(irq);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		enable_mappi_irq(irq);
 }
 
 static unsigned int startup_mappi_irq(unsigned int irq)
@@ -88,7 +89,7 @@ void __init init_IRQ(void)
 	irq_desc[M32R_IRQ_INT0].chip = &mappi_irq_type;
 	irq_desc[M32R_IRQ_INT0].action = NULL;
 	irq_desc[M32R_IRQ_INT0].depth = 1;
-	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD10;
+	icu_data[M32R_IRQ_INT0].icucr = M32R_ICUCR_IEN|M32R_ICUCR_ISMOD11;
 	disable_mappi_irq(M32R_IRQ_INT0);
 #endif /* CONFIG_M32R_NE2000 */
 
diff -puN drivers/net/lib8390.c~m32r-fix-ei_tx_timeout-in-drivers-net-lib8390c drivers/net/lib8390.c
--- a/drivers/net/lib8390.c~m32r-fix-ei_tx_timeout-in-drivers-net-lib8390c
+++ a/drivers/net/lib8390.c
@@ -219,15 +219,6 @@ static void ei_tx_timeout(struct net_dev
 	int txsr, isr, tickssofar = jiffies - dev->trans_start;
 	unsigned long flags;
 
-#if defined(CONFIG_M32R) && defined(CONFIG_SMP)
-	unsigned long icucr;
-
-	local_irq_save(flags);
-	icucr = inl(M32R_ICU_CR1_PORTL);
-	icucr |= M32R_ICUCR_ISMOD11;
-	outl(icucr, M32R_ICU_CR1_PORTL);
-	local_irq_restore(flags);
-#endif
 	ei_local->stat.tx_errors++;
 
 	spin_lock_irqsave(&ei_local->page_lock, flags);
_

Patches currently in -mm which might be from takata@linux-m32r.org are

origin.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
