From: akpm@linux-foundation.org
Subject: + h8300-update-timer-handler-delete-files.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:14:59 -0700
Message-ID: <200808042314.m74NExtR004820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbYHDXPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: update timer handler - delete files
has been added to the -mm tree.  Its filename is
     h8300-update-timer-handler-delete-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: update timer handler - delete files
From: Yoshinori Sato <ysato@users.sourceforge.jp>

Delete old timer handler.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/platform/h8300h/aki3068net/Makefile |    1 
 arch/h8300/platform/h8300h/aki3068net/timer.c  |   51 --------
 arch/h8300/platform/h8300h/generic/Makefile    |    1 
 arch/h8300/platform/h8300h/generic/timer.c     |   95 ---------------
 arch/h8300/platform/h8300h/h8max/Makefile      |    1 
 arch/h8300/platform/h8300h/h8max/timer.c       |   52 --------
 arch/h8300/platform/h8s/edosk2674/Makefile     |    1 
 arch/h8300/platform/h8s/edosk2674/timer.c      |   54 --------
 arch/h8300/platform/h8s/generic/Makefile       |    1 
 arch/h8300/platform/h8s/generic/timer.c        |   53 --------
 10 files changed, 310 deletions(-)

diff -puN arch/h8300/platform/h8300h/aki3068net/Makefile~h8300-update-timer-handler-delete-files arch/h8300/platform/h8300h/aki3068net/Makefile
--- a/arch/h8300/platform/h8300h/aki3068net/Makefile~h8300-update-timer-handler-delete-files
+++ a/arch/h8300/platform/h8300h/aki3068net/Makefile
@@ -3,4 +3,3 @@
 #
 
 extra-y := crt0_ram.o
-obj-y := timer.o
diff -puN arch/h8300/platform/h8300h/aki3068net/timer.c~h8300-update-timer-handler-delete-files /dev/null
--- a/arch/h8300/platform/h8300h/aki3068net/timer.c
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- *  linux/arch/h8300/platform/h8300h/aki3068net/timer.c
- *
- *  Yoshinori Sato <ysato@users.sourcefoge.jp>
- *
- *  Platform depend Timer Handler
- *
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/timex.h>
-
-#include <asm/segment.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/regs306x.h>
-
-#define CMFA 6
-
-#define CMIEA 0x40
-#define CCLR_CMA 0x08
-#define CLK_DIV8192 0x03
-
-#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
-
-void __init platform_timer_setup(irqreturn_t (*timer_int)(int, void *, struct pt_regs *))
-{
-	/* setup 8bit timer ch2 */
-	ctrl_outb(H8300_TIMER_FREQ / HZ, TCORA2);      /* set interval */
-	ctrl_outb(0x00, _8TCSR2);                      /* no output */
-	request_irq(40, timer_int, 0, "timer", 0);
-	ctrl_outb(CMIEA|CCLR_CMA|CLK_DIV8192, _8TCR2); /* start count */
-}
-
-void platform_timer_eoi(void)
-{
-	*(volatile unsigned char *)_8TCSR2 &= ~(1 << CMFA);
-}
-
-void platform_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-	*year = *mon = *day = *hour = *min = *sec = 0;
-}
diff -puN arch/h8300/platform/h8300h/generic/Makefile~h8300-update-timer-handler-delete-files arch/h8300/platform/h8300h/generic/Makefile
--- a/arch/h8300/platform/h8300h/generic/Makefile~h8300-update-timer-handler-delete-files
+++ a/arch/h8300/platform/h8300h/generic/Makefile
@@ -3,4 +3,3 @@
 #
 
 extra-y :=  crt0_$(MODEL).o
-obj-y := timer.o
diff -puN arch/h8300/platform/h8300h/generic/timer.c~h8300-update-timer-handler-delete-files /dev/null
--- a/arch/h8300/platform/h8300h/generic/timer.c
+++ /dev/null
@@ -1,95 +0,0 @@
-/*
- *  linux/arch/h8300/platform/h8300h/generic/timer.c
- *
- *  Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- *  Platform depend Timer Handler
- *
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-
-#include <asm/segment.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-
-#include <linux/timex.h>
-
-#if defined(CONFIG_H83007) || defined(CONFIG_H83068)
-#include <asm/regs306x.h>
-#define CMFA 6
-
-#define CMIEA 0x40
-#define CCLR_CMA 0x08
-#define CLK_DIV8192 0x03
-
-#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
-
-void __init platform_timer_setup(irqreturn_t (*timer_int)(int, void *, struct pt_regs *))
-{
-	/* setup 8bit timer ch2 */
-	ctrl_outb(H8300_TIMER_FREQ / HZ, TCORA2);      /* set interval */
-	ctrl_outb(0x00, _8TCSR2);                      /* no output */
-	request_irq(40, timer_int, 0, "timer", 0);
-	ctrl_outb(CMIEA|CCLR_CMA|CLK_DIV8192, _8TCR2); /* start count */
-}
-
-void platform_timer_eoi(void)
-{
-	*(volatile unsigned char *)_8TCSR2 &= ~(1 << CMFA);
-}
-#endif
-
-#if defined(CONFIG_H83002) || defined(CONFIG_H83048)
-/* FIXME! */
-#define TSTR 0x00ffff60
-#define TSNC 0x00ffff61
-#define TMDR 0x00ffff62
-#define TFCR 0x00ffff63
-#define TOER 0x00ffff90
-#define TOCR 0x00ffff91
-/* ITU0 */
-#define TCR  0x00ffff64
-#define TIOR 0x00ffff65
-#define TIER 0x00ffff66
-#define TSR  0x00ffff67
-#define TCNT 0x00ffff68
-#define GRA  0x00ffff6a
-#define GRB  0x00ffff6c
-
-#define CCLR_CMGRA 0x20
-#define CLK_DIV8 0x03
-
-#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*1000/8 /* Timer input freq. */
-
-void __init platform_timer_setup(irqreturn_t (*timer_int)(int, void *, struct pt_regs *))
-{
-	*(unsigned short *)GRA= H8300_TIMER_FREQ / HZ;  /* set interval */
-	*(unsigned short *)TCNT=0;                      /* clear counter */
-	ctrl_outb(0x80|CCLR_CMGRA|CLK_DIV8, TCR);       /* set ITU0 clock */
-	ctrl_outb(0x88, TIOR);                          /* no output */
-	request_irq(26, timer_int, 0, "timer", 0);
-	ctrl_outb(0xf9, TIER);                          /* compare match GRA interrupt */
-	ctrl_outb(ctrl_inb(TSNC) & ~0x01, TSNC);        /* ITU0 async */
-	ctrl_outb(ctrl_inb(TMDR) & ~0x01, TMDR);        /* ITU0 normal mode */
-	ctrl_outb(ctrl_inb(TSTR) | 0x01, TSTR);         /* ITU0 Start */
-	return 0;
-}
-
-void platform_timer_eoi(void)
-{
-	ctrl_outb(ctrl_inb(TSR) & ~0x01,TSR);
-}
-#endif
-
-void platform_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-	*year = *mon = *day = *hour = *min = *sec = 0;
-}
diff -puN arch/h8300/platform/h8300h/h8max/Makefile~h8300-update-timer-handler-delete-files arch/h8300/platform/h8300h/h8max/Makefile
--- a/arch/h8300/platform/h8300h/h8max/Makefile~h8300-update-timer-handler-delete-files
+++ a/arch/h8300/platform/h8300h/h8max/Makefile
@@ -3,4 +3,3 @@
 #
 
 extra-y := crt0_ram.o
-obj-y := timer.o
diff -puN arch/h8300/platform/h8300h/h8max/timer.c~h8300-update-timer-handler-delete-files /dev/null
--- a/arch/h8300/platform/h8300h/h8max/timer.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- *  linux/arch/h8300/platform/h8300h/h8max/timer.c
- *
- *  Yoshinori Sato <ysato@users.sourcefoge.jp>
- *
- *  Platform depend Timer Handler
- *
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/timex.h>
-
-#include <asm/segment.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/regs306x.h>
-
-#define CMFA 6
-
-#define CMIEA 0x40
-#define CCLR_CMA 0x08
-#define CLK_DIV8192 0x03
-
-#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
-
-void __init platform_timer_setup(irqreturn_t (*timer_int)(int, void *, struct pt_regs *))
-{
-	/* setup 8bit timer ch2 */
-	ctrl_outb(H8300_TIMER_FREQ / HZ, TCORA2);      /* set interval */
-	ctrl_outb(0x00, _8TCSR2);                      /* no output */
-	request_irq(40, timer_int, 0, "timer", 0);
-	ctrl_outb(CMIEA|CCLR_CMA|CLK_DIV8192, _8TCR2); /* start count */
-}
-
-void platform_timer_eoi(void)
-{
-	*(volatile unsigned char *)_8TCSR2 &= ~(1 << CMFA);
-}
-
-void platform_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-	*year = *mon = *day = *hour = *min = *sec = 0;
-}
-
diff -puN arch/h8300/platform/h8s/edosk2674/Makefile~h8300-update-timer-handler-delete-files arch/h8300/platform/h8s/edosk2674/Makefile
--- a/arch/h8300/platform/h8s/edosk2674/Makefile~h8300-update-timer-handler-delete-files
+++ a/arch/h8300/platform/h8s/edosk2674/Makefile
@@ -3,4 +3,3 @@
 #
 
 extra-y := crt0_$(MODEL).o
-obj-y := timer.o
diff -puN arch/h8300/platform/h8s/edosk2674/timer.c~h8300-update-timer-handler-delete-files /dev/null
--- a/arch/h8300/platform/h8s/edosk2674/timer.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- *  linux/arch/h8300/platform/h8s/edosk2674/timer.c
- *
- *  Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- *  Platform depend Timer Handler
- *
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/timex.h>
-
-#include <asm/segment.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/regs267x.h>
-
-#define CMFA 6
-
-#define CMIEA 0x40
-#define CCLR_CMA 0x08
-#define CLK_DIV8192 0x03
-
-#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
-
-void __init platform_timer_setup(irqreturn_t (*timer_int)(int, void *, struct pt_regs *))
-{
-	/* 8bit timer module enabled */
-	ctrl_outb(ctrl_inb(MSTPCRL) & ~0x01, MSTPCRL);
-	/* setup 8bit timer ch1 */
-	ctrl_outb(H8300_TIMER_FREQ / HZ, _8TCORA1);      /* set interval */
-	ctrl_outb(0x00, _8TCSR1);                        /* no output */
-	request_irq(76, timer_int, 0, "timer" ,0);
-	ctrl_outb(CMIEA|CCLR_CMA|CLK_DIV8192, _8TCR1);   /* start count */
-}
-
-void platform_timer_eoi(void)
-{
-	*(volatile unsigned char *)_8TCSR1 &= ~(1 << CMFA);
-}
-
-void platform_gettod(int *year, int *mon, int *day, int *hour,
-		 int *min, int *sec)
-{
-/* FIXME! not RTC support */
-	*year = *mon = *day = *hour = *min = *sec = 0;
-}
diff -puN arch/h8300/platform/h8s/generic/Makefile~h8300-update-timer-handler-delete-files arch/h8300/platform/h8s/generic/Makefile
--- a/arch/h8300/platform/h8s/generic/Makefile~h8300-update-timer-handler-delete-files
+++ a/arch/h8300/platform/h8s/generic/Makefile
@@ -3,4 +3,3 @@
 #
 
 extra-y =  crt0_$(MODEL).o
-obj-y := timer.o
diff -puN arch/h8300/platform/h8s/generic/timer.c~h8300-update-timer-handler-delete-files /dev/null
--- a/arch/h8300/platform/h8s/generic/timer.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- *  linux/arch/h8300/platform/h8s/generic/timer.c
- *
- *  Yoshinori Sato <ysato@users.sourceforge.jp>
- *
- *  Platform depend Timer Handler
- *
- */
-
-#include <linux/errno.h>
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/param.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/timex.h>
-
-#include <asm/segment.h>
-#include <asm/io.h>
-#include <asm/irq.h>
-#include <asm/regs267x.h>
-
-#define CMFA 6
-
-#define CMIEA 0x40
-#define CCLR_CMA 0x08
-#define CLK_DIV8192 0x03
-
-#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*1000/8192 /* Timer input freq. */
-
-void __init platform_timer_setup(irqreturn_t (*timer_int)(int, void *, struct pt_regs *))
-{
-	/* 8bit timer module enabled */
-	ctrl_outb(ctrl_inb(MSTPCRL) & ~0x01, MSTPCRL);
-	/* setup 8bit timer ch1 */
-	ctrl_outb(H8300_TIMER_FREQ / HZ, _8TCORA1);      /* set interval */
-	ctrl_outb(0x00, _8TCSR1);                        /* no output */
-	request_irq(76, timer_int, 0, "timer" ,0);
-	ctrl_outb(CMIEA|CCLR_CMA|CLK_DIV8192, _8TCR1);   /* start count */
-}
-
-void platform_timer_eoi(void)
-{
-	*(volatile unsigned char *)_8TCSR1 &= ~(1 << CMFA);
-}
