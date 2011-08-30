From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-imxdic-needs-linux-schedh.patch added to -mm tree
Date: Tue, 30 Aug 2011 14:11:53 -0700
Message-ID: <201108302111.p7ULBruF017444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756733Ab1H3VMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 17:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, baruch@tkos.co.il, mcuos.com@gmail.com


The patch titled
     drivers/rtc/rtc-imxdi.c needs linux/sched.h
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-imxdic-needs-linux-schedh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-rtc-rtc-imxdic-needs-linux-schedh.patch
linux-next.patch
leds-renesas-tpu-led-driver-v2-fix.patch

