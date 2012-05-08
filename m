From: akpm@linux-foundation.org
Subject: + usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:33:10 -0700
Message-ID: <20120508223310.F041BA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38109 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2EHWdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:33:13 -0400
Received: by wgbdt11 with SMTP id dt11so383870wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:33:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com


The patch titled
     Subject: usb/host/r8a66597: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 #include <linux/usb/r8a66597.h>
 
 #define R8A66597_MAX_NUM_PIPE		10
@@ -113,9 +110,7 @@ struct r8a66597_root_hub {
 struct r8a66597 {
 	spinlock_t lock;
 	void __iomem *reg;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
-#endif
 	struct r8a66597_platdata	*pdata;
 	struct r8a66597_device		device0;
 	struct r8a66597_root_hub	root_hub[R8A66597_MAX_ROOT_HUB];
_
Subject: Subject: usb/host/r8a66597: remove conditional compilation of clk code

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
ata-sata_mv-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
rtc-spear-add-device-tree-probing-capability.patch

