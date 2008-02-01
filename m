From: akpm@linux-foundation.org
Subject: - m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:36 -0800
Message-ID: <200802012229.m11MTa6a001816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756303AbYBAWay (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:30:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: use raw read/write for all register access in ColdFire timer
has been removed from the -mm tree.  Its filename was
     m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: use raw read/write for all register access in ColdFire timer
From: Greg Ungerer <gerg@snapgear.com>

Use __raw_read/__raw_write to write to all registers (instead of using local
pointer de-referencing in ColdFirePIT timer code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5307/pit.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/m68knommu/platform/5307/pit.c~m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer arch/m68knommu/platform/5307/pit.c
--- a/arch/m68knommu/platform/5307/pit.c~m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer
+++ a/arch/m68knommu/platform/5307/pit.c
@@ -29,6 +29,7 @@
  *	By default use timer1 as the system clock timer.
  */
 #define	TA(a)	(MCF_IPSBAR + MCFPIT_BASE1 + (a))
+#define	INTC0	(MCF_IPSBAR + MCFICM_INTC0)
 
 /***************************************************************************/
 
@@ -53,17 +54,14 @@ static struct irqaction coldfire_pit_irq
 
 void hw_timer_init(void)
 {
-	volatile unsigned char *icrp;
-	volatile unsigned long *imrp;
+	u32 imr;
 
 	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &coldfire_pit_irq);
 
-	icrp = (volatile unsigned char *) (MCF_IPSBAR + MCFICM_INTC0 +
-		MCFINTC_ICR0 + MCFINT_PIT1);
-	*icrp = ICR_INTRCONF;
-
-	imrp = (volatile unsigned long *) (MCF_IPSBAR + MCFICM_INTC0 + MCFPIT_IMR);
-	*imrp &= ~MCFPIT_IMR_IBIT;
+	__raw_writeb(ICR_INTRCONF, INTC0 + MCFINTC_ICR0 + MCFINT_PIT1);
+	imr = __raw_readl(INTC0 + MCFPIT_IMR);
+	imr &= ~MCFPIT_IMR_IBIT;
+	__raw_writel(imr, INTC0 + MCFPIT_IMR);
 
 	/* Set up PIT timer 1 as poll clock */
 	__raw_writew(MCFPIT_PCSR_DISABLE, TA(MCFPIT_PCSR));
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
add-cmpxchg_local-to-m68knommu.patch
