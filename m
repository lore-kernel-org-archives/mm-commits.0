From: akpm@linux-foundation.org
Subject: - m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:35 -0800
Message-ID: <200802052233.m15MXG8m012392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761066AbYBEWmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68knomu: remove dead config symbols from m68knomu code
has been removed from the -mm tree.  Its filename was
     m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knomu: remove dead config symbols from m68knomu code
From: Jiri Olsa <olsajiri@gmail.com>

remove dead config symbols from m68knommu code

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/setup.c    |    3 ---
 include/asm-m68knommu/mcfne.h    |   27 ---------------------------
 include/asm-m68knommu/mcfsim.h   |    4 +---
 include/asm-m68knommu/mcftimer.h |    2 +-
 include/asm-m68knommu/mcfuart.h  |    2 +-
 include/asm-m68knommu/system.h   |   17 -----------------
 6 files changed, 3 insertions(+), 52 deletions(-)

diff -puN arch/m68knommu/kernel/setup.c~m68knomu-remove-dead-config-symbols-from-m68knomu-code arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c~m68knomu-remove-dead-config-symbols-from-m68knomu-code
+++ a/arch/m68knommu/kernel/setup.c
@@ -64,9 +64,6 @@ void (*mach_power_off)(void);
 #ifdef CONFIG_M68VZ328
 	#define CPU "MC68VZ328"
 #endif
-#ifdef CONFIG_M68332
-	#define CPU "MC68332"
-#endif
 #ifdef CONFIG_M68360
 	#define CPU "MC68360"
 #endif
diff -puN include/asm-m68knommu/mcfne.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code include/asm-m68knommu/mcfne.h
--- a/include/asm-m68knommu/mcfne.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code
+++ a/include/asm-m68knommu/mcfne.h
@@ -60,17 +60,6 @@
 #define	NE2000_BYTE		volatile unsigned char
 #endif
 
-#if defined(CONFIG_CFV240)
-#define NE2000_ADDR             0x40010000
-#define NE2000_ADDR1            0x40010001
-#define NE2000_ODDOFFSET        0x00000000
-#define NE2000_IRQ              1
-#define NE2000_IRQ_VECTOR       0x19
-#define NE2000_IRQ_PRIORITY     2
-#define NE2000_IRQ_LEVEL        1
-#define	NE2000_BYTE		volatile unsigned char
-#endif
-
 #if defined(CONFIG_M5307C3)
 #define NE2000_ADDR		0x40000300
 #define NE2000_ODDOFFSET	0x00010000
@@ -173,13 +162,8 @@ void ne2000_outsw(unsigned int addr, voi
  *	On most NE2000 implementations on ColdFire boards the chip is
  *	mapped in kinda funny, due to its ISA heritage.
  */
-#ifdef CONFIG_CFV240
-#define NE2000_PTR(addr)	(NE2000_ADDR + ((addr & 0x3f) << 1) + 1)
-#define NE2000_DATA_PTR(addr)	(NE2000_ADDR + ((addr & 0x3f) << 1))
-#else
 #define	NE2000_PTR(addr)	((addr&0x1)?(NE2000_ODDOFFSET+addr-1):(addr))
 #define	NE2000_DATA_PTR(addr)	(addr)
-#endif
 
 
 void ne2000_outb(unsigned int val, unsigned int addr)
@@ -285,17 +269,6 @@ void ne2000_irqsetup(int irq)
 }
 #endif
 
-#if defined(CONFIG_CFV240)
-void ne2000_irqsetup(int irq)
-{
-	volatile unsigned char  *icrp;
-
-	icrp = (volatile unsigned char *) (MCF_MBAR + MCFSIM_ICR1);
-	*icrp = MCFSIM_ICR_LEVEL1 | MCFSIM_ICR_PRI2 | MCFSIM_ICR_AUTOVEC;
-	mcf_setimr(mcf_getimr() & ~MCFSIM_IMR_EINT1);
-}
-#endif
-
 #if defined(CONFIG_M5206e) && defined(CONFIG_NETtel)
 void ne2000_irqsetup(int irq)
 {
diff -puN include/asm-m68knommu/mcfsim.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code include/asm-m68knommu/mcfsim.h
--- a/include/asm-m68knommu/mcfsim.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code
+++ a/include/asm-m68knommu/mcfsim.h
@@ -17,9 +17,7 @@
  *	Include 5204, 5206/e, 5235, 5249, 5270/5271, 5272, 5280/5282,
  *	5307 or 5407 specific addresses.
  */
-#if defined(CONFIG_M5204)
-#include <asm/m5204sim.h>
-#elif defined(CONFIG_M5206) || defined(CONFIG_M5206e)
+#if defined(CONFIG_M5206) || defined(CONFIG_M5206e)
 #include <asm/m5206sim.h>
 #elif defined(CONFIG_M520x)
 #include <asm/m520xsim.h>
diff -puN include/asm-m68knommu/mcftimer.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code include/asm-m68knommu/mcftimer.h
--- a/include/asm-m68knommu/mcftimer.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code
+++ a/include/asm-m68knommu/mcftimer.h
@@ -16,7 +16,7 @@
 /*
  *	Get address specific defines for this ColdFire member.
  */
-#if defined(CONFIG_M5204) || defined(CONFIG_M5206) || defined(CONFIG_M5206e)
+#if defined(CONFIG_M5206) || defined(CONFIG_M5206e)
 #define	MCFTIMER_BASE1		0x100		/* Base address of TIMER1 */
 #define	MCFTIMER_BASE2		0x120		/* Base address of TIMER2 */
 #elif defined(CONFIG_M5272)
diff -puN include/asm-m68knommu/mcfuart.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code include/asm-m68knommu/mcfuart.h
--- a/include/asm-m68knommu/mcfuart.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code
+++ a/include/asm-m68knommu/mcfuart.h
@@ -19,7 +19,7 @@
 #if defined(CONFIG_M5272)
 #define	MCFUART_BASE1		0x100		/* Base address of UART1 */
 #define	MCFUART_BASE2		0x140		/* Base address of UART2 */
-#elif defined(CONFIG_M5204) || defined(CONFIG_M5206) || defined(CONFIG_M5206e)
+#elif defined(CONFIG_M5206) || defined(CONFIG_M5206e)
 #if defined(CONFIG_NETtel)
 #define	MCFUART_BASE1		0x180		/* Base address of UART1 */
 #define	MCFUART_BASE2		0x140		/* Base address of UART2 */
diff -puN include/asm-m68knommu/system.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code include/asm-m68knommu/system.h
--- a/include/asm-m68knommu/system.h~m68knomu-remove-dead-config-symbols-from-m68knomu-code
+++ a/include/asm-m68knommu/system.h
@@ -207,23 +207,6 @@ cmpxchg(volatile int *p, int old, int ne
 }
 
 
-#ifdef CONFIG_M68332
-#define HARD_RESET_NOW() ({		\
-        local_irq_disable();		\
-        asm("				\
-	movew   #0x0000, 0xfffa6a;	\
-        reset;				\
-        /*movew #0x1557, 0xfffa44;*/	\
-        /*movew #0x0155, 0xfffa46;*/	\
-        moveal #0, %a0;			\
-        movec %a0, %vbr;		\
-        moveal 0, %sp;			\
-        moveal 4, %a0;			\
-        jmp (%a0);			\
-        ");				\
-})
-#endif
-
 #if defined( CONFIG_M68328 ) || defined( CONFIG_M68EZ328 ) || \
 	defined (CONFIG_M68360) || defined( CONFIG_M68VZ328 )
 #define HARD_RESET_NOW() ({		\
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
