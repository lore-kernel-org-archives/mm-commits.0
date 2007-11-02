From: akpm@linux-foundation.org
Subject: + m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:35:11 -0700
Message-ID: <200711022135.lA2LZBcp011984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXKBVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: use raw read/write for all register access in ColdFire timer
has been added to the -mm tree.  Its filename is
     m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-fix-pread-pwrite-defines.patch
m68knommu-use-raw-read-write-for-all-register-access-in-coldfire-timer.patch
m68knommu-use-container_of-to-access-uart-struct-in-coldfire-serial-driver.patch
m68knommu-cleanup-port-field-access-from-uart-struct-in-coldfire-serial-driver.patch
m68knommu-use-array_size-in-coldfire-serial-driver.patch
add-build-support-for-new-coldfire-serial-driver.patch
add-configure-support-for-new-coldfire-serial-driver.patch
m68knommu-platform-setup-for-5206-coldfire-uarts.patch
m68knommu-platform-setup-for-5206e-coldfire-uarts.patch
m68knommu-platform-setup-for-520x-coldfire-uarts.patch
m68knommu-platform-setup-for-5249-coldfire-uarts.patch
m68knommu-platform-setup-for-5272-coldfire-uarts.patch
add-cmpxchg_local-to-m68knommu.patch
