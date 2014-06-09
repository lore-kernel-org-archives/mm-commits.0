From: akpm@linux-foundation.org
Subject: [merged] cris-update-comments-for-generic-idle-conversion.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:41:51 -0700
Message-ID: <53960dff.w/VEwKOdl21agq8B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFITlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jesper.nilsson@axis.com, geert+renesas@glider.be

Subject: [merged] cris-update-comments-for-generic-idle-conversion.patch removed from -mm tree
To: geert+renesas@glider.be,jesper.nilsson@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:51 -0700


The patch titled
     Subject: cris: update comments for generic idle conversion
has been removed from the -mm tree.  Its filename was
     cris-update-comments-for-generic-idle-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: cris: update comments for generic idle conversion

As of 8dc7c5ecd8d0 ("cris: Use generic idle loop"), cris no longer
provides cpu_idle().

- On cris-v10, etrax_gpio_wake_up_check() is called from default_idle()
  instead of cpu_idle(),

- On cris-v32, etrax_gpio_wake_up_check() is not called from
  default_idle(), so remove this (copy-and-paste?) part.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/gpio.c         |    4 ++--
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |    6 +-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/cris/arch-v10/drivers/gpio.c~cris-update-comments-for-generic-idle-conversion arch/cris/arch-v10/drivers/gpio.c
--- a/arch/cris/arch-v10/drivers/gpio.c~cris-update-comments-for-generic-idle-conversion
+++ a/arch/cris/arch-v10/drivers/gpio.c
@@ -833,8 +833,8 @@ static int __init gpio_init(void)
 	printk(KERN_INFO "ETRAX 100LX GPIO driver v2.5, (c) 2001-2008 "
 		"Axis Communications AB\n");
 	/* We call etrax_gpio_wake_up_check() from timer interrupt and
-	 * from cpu_idle() in kernel/process.c
-	 * The check in cpu_idle() reduces latency from ~15 ms to ~6 ms
+	 * from default_idle() in kernel/process.c
+	 * The check in default_idle() reduces latency from ~15 ms to ~6 ms
 	 * in some tests.
 	 */
 	res = request_irq(TIMER0_IRQ_NBR, gpio_poll_timer_interrupt,
diff -puN arch/cris/arch-v32/drivers/mach-fs/gpio.c~cris-update-comments-for-generic-idle-conversion arch/cris/arch-v32/drivers/mach-fs/gpio.c
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c~cris-update-comments-for-generic-idle-conversion
+++ a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -958,11 +958,7 @@ gpio_init(void)
 
 	printk(KERN_INFO "ETRAX FS GPIO driver v2.5, (c) 2003-2007 "
 		"Axis Communications AB\n");
-	/* We call etrax_gpio_wake_up_check() from timer interrupt and
-	 * from cpu_idle() in kernel/process.c
-	 * The check in cpu_idle() reduces latency from ~15 ms to ~6 ms
-	 * in some tests.
-	 */
+	/* We call etrax_gpio_wake_up_check() from timer interrupt */
 	if (request_irq(TIMER0_INTR_VECT, gpio_poll_timer_interrupt,
 			IRQF_SHARED, "gpio poll", &alarmlist))
 		printk(KERN_ERR "timer0 irq for gpio\n");
_

Patches currently in -mm which might be from geert+renesas@glider.be are

origin.patch
linux-next.patch

