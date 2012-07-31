From: akpm@linux-foundation.org
Subject: [merged] usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:50 -0700
Message-ID: <20120731184851.3042C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43906 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2GaSsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:53 -0400
Received: by wibhr14 with SMTP id hr14so146925wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: usb/host/r8a66597: remove conditional compilation of clk code
has been removed from the -mm tree.  Its filename was
     usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: usb/host/r8a66597: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/r8a66597-hcd.c |   12 ------------
 drivers/usb/host/r8a66597.h     |    5 -----
 2 files changed, 17 deletions(-)

diff -puN drivers/usb/host/r8a66597-hcd.c~usb-host-r8a66597-remove-conditional-compilation-of-clk-code drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~usb-host-r8a66597-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -95,9 +95,7 @@ static int r8a66597_clock_enable(struct 
 	int i = 0;
 
 	if (r8a66597->pdata->on_chip) {
-#ifdef CONFIG_HAVE_CLK
 		clk_enable(r8a66597->clk);
-#endif
 		do {
 			r8a66597_write(r8a66597, SCKE, SYSCFG0);
 			tmp = r8a66597_read(r8a66597, SYSCFG0);
@@ -141,9 +139,7 @@ static void r8a66597_clock_disable(struc
 	udelay(1);
 
 	if (r8a66597->pdata->on_chip) {
-#ifdef CONFIG_HAVE_CLK
 		clk_disable(r8a66597->clk);
-#endif
 	} else {
 		r8a66597_bclr(r8a66597, PLLC, SYSCFG0);
 		r8a66597_bclr(r8a66597, XCKE, SYSCFG0);
@@ -2406,19 +2402,15 @@ static int __devexit r8a66597_remove(str
 	del_timer_sync(&r8a66597->rh_timer);
 	usb_remove_hcd(hcd);
 	iounmap(r8a66597->reg);
-#ifdef CONFIG_HAVE_CLK
 	if (r8a66597->pdata->on_chip)
 		clk_put(r8a66597->clk);
-#endif
 	usb_put_hcd(hcd);
 	return 0;
 }
 
 static int __devinit r8a66597_probe(struct platform_device *pdev)
 {
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	struct resource *res = NULL, *ires;
 	int irq = -1;
 	void __iomem *reg = NULL;
@@ -2482,7 +2474,6 @@ static int __devinit r8a66597_probe(stru
 	r8a66597->irq_sense_low = irq_trigger == IRQF_TRIGGER_LOW;
 
 	if (r8a66597->pdata->on_chip) {
-#ifdef CONFIG_HAVE_CLK
 		snprintf(clk_name, sizeof(clk_name), "usb%d", pdev->id);
 		r8a66597->clk = clk_get(&pdev->dev, clk_name);
 		if (IS_ERR(r8a66597->clk)) {
@@ -2491,7 +2482,6 @@ static int __devinit r8a66597_probe(stru
 			ret = PTR_ERR(r8a66597->clk);
 			goto clean_up2;
 		}
-#endif
 		r8a66597->max_root_hub = 1;
 	} else
 		r8a66597->max_root_hub = 2;
@@ -2531,11 +2521,9 @@ static int __devinit r8a66597_probe(stru
 	return 0;
 
 clean_up3:
-#ifdef CONFIG_HAVE_CLK
 	if (r8a66597->pdata->on_chip)
 		clk_put(r8a66597->clk);
 clean_up2:
-#endif
 	usb_put_hcd(hcd);
 
 clean_up:
diff -puN drivers/usb/host/r8a66597.h~usb-host-r8a66597-remove-conditional-compilation-of-clk-code drivers/usb/host/r8a66597.h
--- a/drivers/usb/host/r8a66597.h~usb-host-r8a66597-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/host/r8a66597.h
@@ -26,10 +26,7 @@
 #ifndef __R8A66597_H__
 #define __R8A66597_H__
 
-#ifdef CONFIG_HAVE_CLK
 #include <linux/clk.h>
-#endif
