From: akpm@linux-foundation.org
Subject: [merged] rtc-twl-ensure-all-interrupts-are-disabled-during-probe.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:05:18 -0700
Message-ID: <20120918190518.C1B43100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59370 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2IRTFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:05:19 -0400
Received: by mail-qa0-f74.google.com with SMTP id l39so47604qaf.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:05:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@ti.com, a.zummo@towertech.it, balbi@ti.com, omaplinuxkernel@gmail.com, stable@vger.kernel.org, steve@sakoman.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe
has been removed from the -mm tree.  Its filename was
     rtc-twl-ensure-all-interrupts-are-disabled-during-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kevin Hilman <khilman@ti.com>
Subject: drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

On some platforms, bootloaders are known to do some interesting RTC
programming.  Without going into the obscurities as to why this may be the
case, suffice it to say the the driver should not make any assumptions
about the state of the RTC when the driver loads.  In particular, the
driver probe should be sure that all interrupts are disabled until
otherwise programmed.

This was discovered when finding bursty I2C traffic every second on Overo
platforms.  This I2C overhead was keeping the SoC from hitting deep power
states.  The cause was found to be the RTC firing every second on the
I2C-connected TWL PMIC.

Special thanks to Felipe Balbi for suggesting to look for a rogue driver
as the source of the I2C traffic rather than the I2C driver itself.

Special thanks to Steve Sakoman for helping track down the source of the
continuous RTC interrups on the Overo boards.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Tested-by: Steve Sakoman <steve@sakoman.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Tested-by: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/rtc/rtc-twl.c~rtc-twl-ensure-all-interrupts-are-disabled-during-probe drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-twl-ensure-all-interrupts-are-disabled-during-probe
+++ a/drivers/rtc/rtc-twl.c
@@ -495,6 +495,11 @@ static int __devinit twl_rtc_probe(struc
 	if (ret < 0)
 		goto out1;
 
+	/* ensure interrupts are disabled, bootloaders can be strange */
+	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "unable to disable interrupt\n");
+
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
_

Patches currently in -mm which might be from khilman@ti.com are

origin.patch
linux-next.patch

