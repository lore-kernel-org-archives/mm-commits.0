From: akpm@linux-foundation.org
Subject: + h8300-update-timer-handler-new-files.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:15:01 -0700
Message-ID: <200808042315.m74NF1p6004823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567AbYHDXPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: update timer handler - new files
has been added to the -mm tree.  Its filename is
     h8300-update-timer-handler-new-files.patch

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
Subject: h8300: update timer handler - new files
From: Yoshinori Sato <ysato@users.sourceforge.jp>

New timer handler files.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/timer/Makefile  |    6 +
 arch/h8300/kernel/timer/itu.c     |   83 ++++++++++++++++++++++
 arch/h8300/kernel/timer/timer16.c |   78 +++++++++++++++++++++
 arch/h8300/kernel/timer/timer8.c  |  103 ++++++++++++++++++++++++++++
 arch/h8300/kernel/timer/tpu.c     |  102 +++++++++++++++++++++++++++
 include/asm-h8300/timer.h         |   25 ++++++
 6 files changed, 397 insertions(+)

diff -puN /dev/null arch/h8300/kernel/timer/Makefile
--- /dev/null
+++ a/arch/h8300/kernel/timer/Makefile
@@ -0,0 +1,6 @@
+# h8300 internal timer handler
+
+obj-$(CONFIG_H8300_TIMER8)  := timer8.o
+obj-$(CONFIG_H8300_TIMER16) := timer16.o
+obj-$(CONFIG_H8300_ITU)     := itu.o
+obj-$(CONFIG_H8300_TPU)     := tpu.o
diff -puN /dev/null arch/h8300/kernel/timer/itu.c
--- /dev/null
+++ a/arch/h8300/kernel/timer/itu.c
@@ -0,0 +1,83 @@
+/*
+ *  linux/arch/h8300/kernel/timer/itu.c
+ *
+ *  Yoshinori Sato <ysato@users.sourcefoge.jp>
+ *
+ *  ITU Timer Handler
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/timex.h>
+
+#include <asm/segment.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/regs306x.h>
+
+#if CONFIG_H8300_ITU_CH == 0
+#define ITUBASE	0xffff64
+#define ITUIRQ	24
+#elif CONFIG_H8300_ITU_CH == 1
+#define ITUBASE	0xffff6e
+#define ITUIRQ	28
+#elif CONFIG_H8300_ITU_CH == 2
+#define ITUBASE	0xffff78
+#define ITUIRQ	32
+#elif CONFIG_H8300_ITU_CH == 3
+#define ITUBASE	0xffff82
+#define ITUIRQ	36
+#elif CONFIG_H8300_ITU_CH == 4
+#define ITUBASE	0xffff92
+#define ITUIRQ	40
+#else
+#error Unknown timer channel.
+#endif
+
+#define TCR	0
+#define TIOR	1
+#define TIER	2
+#define TSR	3
+#define TCNT	4
+#define GRA	6
+#define GRB	8
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	h8300_timer_tick();
+	ctrl_bclr(IMFA, ITUBASE + TSR);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction itu_irq = {
+	.name		= "itu",
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.mask		= CPU_MASK_NONE,
+};
+
+static const int __initdata divide_rate[] = {1, 2, 4, 8};
+
+void __init h8300_timer_setup(void)
+{
+	unsigned int div;
+	unsigned int cnt;
+
+	calc_param(cnt, div, divide_rate, 0x10000);
+
+	setup_irq(ITUIRQ, &itu_irq);
+
+	/* initalize timer */
+	ctrl_outb(0, TSTR);
+	ctrl_outb(CCLR0 | div, ITUBASE + TCR);
+	ctrl_outb(0x01, ITUBASE + TIER);
+	ctrl_outw(cnt, ITUBASE + GRA);
+	ctrl_bset(CONFIG_H8300_ITU_CH, TSTR);
+}
diff -puN /dev/null arch/h8300/kernel/timer/timer16.c
--- /dev/null
+++ a/arch/h8300/kernel/timer/timer16.c
@@ -0,0 +1,78 @@
+/*
+ *  linux/arch/h8300/kernel/timer/timer16.c
+ *
+ *  Yoshinori Sato <ysato@users.sourcefoge.jp>
+ *
+ *  16bit Timer Handler
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/timex.h>
+
+#include <asm/segment.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/regs306x.h>
+
+/* 16bit timer */
+#if CONFIG_H8300_TIMER16_CH == 0
+#define _16BASE	0xffff78
+#define _16IRQ	24
+#elif CONFIG_H8300_TIMER16_CH == 1
+#define _16BASE	0xffff80
+#define _16IRQ	28
+#elif CONFIG_H8300_TIMER16_CH == 2
+#define _16BASE	0xffff88
+#define _16IRQ	32
+#else
+#error Unknown timer channel.
+#endif
+
+#define TCR	0
+#define TIOR	1
+#define TCNT	2
+#define GRA	4
+#define GRB	6
+
+#define H8300_TIMER_FREQ CONFIG_CPU_CLOCK*10000 /* Timer input freq. */
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	h8300_timer_tick();
+	ctrl_bclr(CONFIG_H8300_TIMER16_CH, TISRA);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer16_irq = {
+	.name		= "timer-16",
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.mask		= CPU_MASK_NONE,
+};
+
+static const int __initdata divide_rate[] = {1, 2, 4, 8};
+
+void __init h8300_timer_setup(void)
+{
+	unsigned int div;
+	unsigned int cnt;
+
+	calc_param(cnt, div, divide_rate, 0x10000);
+
+	setup_irq(_16IRQ, &timer16_irq);
+
+	/* initalize timer */
+	ctrl_outb(0, TSTR);
+	ctrl_outb(CCLR0 | div, _16BASE + TCR);
+	ctrl_outw(cnt, _16BASE + GRA);
+	ctrl_bset(4 + CONFIG_H8300_TIMER16_CH, TISRA);
+	ctrl_bset(CONFIG_H8300_TIMER16_CH, TSTR);
+}
diff -puN /dev/null arch/h8300/kernel/timer/timer8.c
--- /dev/null
+++ a/arch/h8300/kernel/timer/timer8.c
@@ -0,0 +1,103 @@
+/*
+ *  linux/arch/h8300/kernel/cpu/timer/timer8.c
+ *
+ *  Yoshinori Sato <ysato@users.sourcefoge.jp>
+ *
+ *  8bit Timer Handler
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/profile.h>
+
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/timer.h>
+#if defined(CONFIG_CPU_H8300H)
+#include <asm/regs306x.h>
+#endif
+#if defined(CONFIG_CPU_H8S)
+#include <asm/regs267x.h>
+#endif
+
+/* 8bit timer x2 */
+#define CMFA	6
+
+#if defined(CONFIG_H8300_TIMER8_CH0)
+#define _8BASE	_8TCR0
+#ifdef CONFIG_CPU_H8300H
+#define _8IRQ	36
+#endif
+#ifdef CONFIG_CPU_H8S
+#define _8IRQ	72
+#endif
+#elif defined(CONFIG_H8300_TIMER8_CH2)
+#ifdef CONFIG_CPU_H8300H
+#define _8BASE	_8TCR2
+#define _8IRQ	40
+#endif
+#endif
+
+#ifndef _8BASE
+#error Unknown timer channel.
+#endif
+
+#define _8TCR	0
+#define _8TCSR	2
+#define TCORA	4
+#define TCORB	6
+#define _8TCNT	8
+
+#define CMIEA	0x40
+#define CCLR_CMA 0x08
+#define CKS2	0x04
+
+/*
+ * timer_interrupt() needs to keep up the real-time clock,
+ * as well as call the "do_timer()" routine every clocktick
+ */
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	h8300_timer_tick();
+	ctrl_bclr(CMFA, _8BASE + _8TCSR);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction timer8_irq = {
+	.name		= "timer-8",
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.mask		= CPU_MASK_NONE,
+};
+
+static const int __initdata divide_rate[] = {8, 64, 8192};
+
+void __init h8300_timer_setup(void)
+{
+	unsigned int div;
+	unsigned int cnt;
+
+	calc_param(cnt, div, divide_rate, 0x10000);
+	div++;
+
+	setup_irq(_8IRQ, &timer8_irq);
+
+#if defined(CONFIG_CPU_H8S)
+	/* Timer module enable */
+	ctrl_bclr(0, MSTPCRL)
+#endif
+
+	/* initalize timer */
+	ctrl_outw(cnt, _8BASE + TCORA);
+	ctrl_outw(0x0000, _8BASE + _8TCSR);
+	ctrl_outw((CMIEA|CCLR_CMA|CKS2) << 8 | div,
+		  _8BASE + _8TCR);
+}
diff -puN /dev/null arch/h8300/kernel/timer/tpu.c
--- /dev/null
+++ a/arch/h8300/kernel/timer/tpu.c
@@ -0,0 +1,102 @@
+/*
+ *  linux/arch/h8300/kernel/timer/tpu.c
+ *
+ *  Yoshinori Sato <ysato@users.sourceforge.jp>
+ *
+ *  TPU Timer Handler
+ *
+ */
+
+#include <linux/config.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/timex.h>
+
+#include <asm/segment.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/regs267x.h>
+
+/* TPU */
+#if CONFIG_H8300_TPU_CH == 0
+#define TPUBASE	0xffffd0
+#define TPUIRQ	40
+#elif CONFIG_H8300_TPU_CH == 1
+#define TPUBASE	0xffffe0
+#define TPUIRQ	48
+#elif CONFIG_H8300_TPU_CH == 2
+#define TPUBASE	0xfffff0
+#define TPUIRQ	52
+#elif CONFIG_H8300_TPU_CH == 3
+#define TPUBASE	0xfffe80
+#define TPUIRQ	56
+#elif CONFIG_H8300_TPU_CH == 4
+#define TPUBASE	0xfffe90
+#define TPUIRQ	64
+#else
+#error Unknown timer channel.
+#endif
+
+#define _TCR	0
+#define _TMDR	1
+#define _TIOR	2
+#define _TIER	4
+#define _TSR	5
+#define _TCNT	6
+#define _GRA	8
+#define _GRB	10
+
+#define CCLR0	0x20
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	h8300_timer_tick();
+	ctrl_bclr(0, TPUBASE + _TSR);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction tpu_irq = {
+	.name		= "tpu",
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.mask		= CPU_MASK_NONE,
+};
+
+const static int __initdata divide_rate[] = {
+#if CONFIG_H8300_TPU_CH == 0
+	1,4,16,64,0,0,0,0,
+#elif (CONFIG_H8300_TPU_CH == 1) || (CONFIG_H8300_TPU_CH == 5)
+	1,4,16,64,0,0,256,0,
+#elif (CONFIG_H8300_TPU_CH == 2) || (CONFIG_H8300_TPU_CH == 4)
+	1,4,16,64,0,0,0,1024,
+#elif CONFIG_H8300_TPU_CH == 3
+	1,4,16,64,0,1024,256,4096,
+#endif
+};
+
+void __init h8300_timer_setup(void)
+{
+	unsigned int cnt;
+	unsigned int div;
+
+	calc_param(cnt, div, divide_rate, 0x10000);
+
+	setup_irq(TPUIRQ, &tpu_irq);
+
+	/* TPU module enabled */
+	ctrl_bclr(3, MSTPCRH);
+
+	ctrl_outb(0, TSTR);
+	ctrl_outb(CCLR0 | div, TPUBASE + _TCR);
+	ctrl_outb(0, TPUBASE + _TMDR);
+	ctrl_outw(0, TPUBASE + _TIOR);
+	ctrl_outb(0x01, TPUBASE + _TIER);
+	ctrl_outw(cnt, TPUBASE + _GRA);
+	ctrl_bset(CONFIG_H8300_TPU_CH, TSTR);
+}
diff -puN /dev/null include/asm-h8300/timer.h
--- /dev/null
+++ a/include/asm-h8300/timer.h
@@ -0,0 +1,25 @@
+#ifndef __H8300_TIMER_H
+#define __H8300_TIMER_H
+
+void h8300_timer_tick(void);
+void h8300_timer_setup(void);
+void h8300_gettod(unsigned int *year, unsigned int *mon, unsigned int *day,
+		   unsigned int *hour, unsigned int *min, unsigned int *sec);
+
+#define TIMER_FREQ (CONFIG_CPU_CLOCK*10000) /* Timer input freq. */
+
+#define calc_param(cnt, div, rate, limit)			\
+do {								\
+	cnt = TIMER_FREQ / HZ;					\
+	for (div = 0; div < ARRAY_SIZE(divide_rate); div++) {	\
+		if (rate[div] == 0)				\
+			continue;				\
+		if ((cnt / rate[div]) > limit)			\
+			break;					\
+	}							\
+	if (div == ARRAY_SIZE(divide_rate))			\
+		panic("Timer counter overflow");		\
+	cnt /= divide_rate[div];				\
+} while(0)
+
+#endif
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch
h8300-update-timer-handler-delete-files.patch
h8300-update-timer-handler-new-files.patch
h8300-update-timer-handler-misc-update.patch

