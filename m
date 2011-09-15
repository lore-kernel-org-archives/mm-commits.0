From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-imxdic-needs-linux-schedh.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:12 -0700
Message-ID: <201109151936.p8FJaC4L010277@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934580Ab1IOTgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, a.zummo@towertech.it, baruch@tkos.co.il, mcuos.com@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-imxdi.c needs linux/sched.h
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-imxdic-needs-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-imxdi.c needs linux/sched.h
From: Axel Lin <axel.lin@gmail.com>

Include linux/sched.h to fix below build error.

  CC      drivers/rtc/rtc-imxdi.o
drivers/rtc/rtc-imxdi.c: In function 'di_write_wait':
drivers/rtc/rtc-imxdi.c:168: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/rtc/rtc-imxdi.c:168: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-imxdi.c:168: error: for each function it appears in.)
drivers/rtc/rtc-imxdi.c:168: error: implicit declaration of function 'signal_pending'
drivers/rtc/rtc-imxdi.c:168: error: implicit declaration of function 'schedule_timeout'
drivers/rtc/rtc-imxdi.c: In function 'dryice_norm_irq':
drivers/rtc/rtc-imxdi.c:329: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-imxdi.c~drivers-rtc-rtc-imxdic-needs-linux-schedh drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~drivers-rtc-rtc-imxdic-needs-linux-schedh
+++ a/drivers/rtc/rtc-imxdi.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
+#include <linux/sched.h>
 #include <linux/workqueue.h>
 
 /* DryIce Register Definitions */
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

