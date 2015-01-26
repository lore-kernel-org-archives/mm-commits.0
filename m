From: akpm@linux-foundation.org
Subject: + sh-eliminate-unused-irq_reg_readlwritel-accessors.patch added
 to -mm tree
Date: Mon, 26 Jan 2015 14:40:32 -0800
Message-ID: <54c6c260.6J2McH29q/aLWLmx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbbAZWkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 17:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cernekee@gmail.com, geert+renesas@glider.be, jason@lakedaemon.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: eliminate unused irq_reg_{readl,writel} accessors
has been added to the -mm tree.  Its filename is
     sh-eliminate-unused-irq_reg_readlwritel-accessors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-eliminate-unused-irq_reg_readlwritel-accessors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-eliminate-unused-irq_reg_readlwritel-accessors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kevin Cernekee <cernekee@gmail.com>
Subject: sh: eliminate unused irq_reg_{readl,writel} accessors

Defining these macros way down in arch/sh/.../irq.c doesn't cause
kernel/irq/generic-chip.c to use them.  As far as I can tell this code has
no effect.

Fixes: 332fd7c4fef5f3b1 ("genirq: Generic chip: Change irq_reg_{readl,writel} arguments")
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be> (cpp/asm comparison)
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/mach-se/7343/irq.c |    3 ---
 arch/sh/boards/mach-se/7722/irq.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN arch/sh/boards/mach-se/7343/irq.c~sh-eliminate-unused-irq_reg_readlwritel-accessors arch/sh/boards/mach-se/7343/irq.c
--- a/arch/sh/boards/mach-se/7343/irq.c~sh-eliminate-unused-irq_reg_readlwritel-accessors
+++ a/arch/sh/boards/mach-se/7343/irq.c
@@ -14,9 +14,6 @@
 #define DRV_NAME "SE7343-FPGA"
 #define pr_fmt(fmt) DRV_NAME ": " fmt
 
-#define irq_reg_readl	ioread16
-#define irq_reg_writel	iowrite16
-
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff -puN arch/sh/boards/mach-se/7722/irq.c~sh-eliminate-unused-irq_reg_readlwritel-accessors arch/sh/boards/mach-se/7722/irq.c
--- a/arch/sh/boards/mach-se/7722/irq.c~sh-eliminate-unused-irq_reg_readlwritel-accessors
+++ a/arch/sh/boards/mach-se/7722/irq.c
@@ -11,9 +11,6 @@
 #define DRV_NAME "SE7722-FPGA"
 #define pr_fmt(fmt) DRV_NAME ": " fmt
 
-#define irq_reg_readl	ioread16
-#define irq_reg_writel	iowrite16
