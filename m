From: akpm@linux-foundation.org
Subject: + gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:33:08 -0700
Message-ID: <20120508223308.E7D0FA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52312 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab2EHWdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:33:11 -0400
Received: by lbbgp10 with SMTP id gp10so344712lbb.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:33:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com


The patch titled
     Subject: gadget/r8a66597: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch

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
Subject: gadget/r8a66597: remove conditional compilation of clk code

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

 drivers/usb/gadget/r8a66597-udc.c |   11 +++--------
 drivers/usb/gadget/r8a66597-udc.h |    5 -----
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN drivers/usb/gadget/r8a66597-udc.c~gadget-r8a66597-remove-conditional-compilation-of-clk-code drivers/usb/gadget/r8a66597-udc.c
--- a/drivers/usb/gadget/r8a66597-udc.c~gadget-r8a66597-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/gadget/r8a66597-udc.c
@@ -1818,12 +1818,12 @@ static int __exit r8a66597_remove(struct
 		iounmap(r8a66597->sudmac_reg);
 	free_irq(platform_get_irq(pdev, 0), r8a66597);
 	r8a66597_free_request(&r8a66597->ep[0].ep, r8a66597->ep0_req);
-#ifdef CONFIG_HAVE_CLK
+
 	if (r8a66597->pdata->on_chip) {
 		clk_disable(r8a66597->clk);
 		clk_put(r8a66597->clk);
 	}
-#endif
+
 	device_unregister(&r8a66597->gadget.dev);
 	kfree(r8a66597);
 	return 0;
@@ -1855,9 +1855,7 @@ static int __init r8a66597_sudmac_iorema
 
 static int __init r8a66597_probe(struct platform_device *pdev)
 {
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	struct resource *res, *ires;
 	int irq;
 	void __iomem *reg = NULL;
@@ -1921,7 +1919,6 @@ static int __init r8a66597_probe(struct 
 	r8a66597->timer.data = (unsigned long)r8a66597;
 	r8a66597->reg = reg;
 
-#ifdef CONFIG_HAVE_CLK
 	if (r8a66597->pdata->on_chip) {
 		snprintf(clk_name, sizeof(clk_name), "usb%d", pdev->id);
 		r8a66597->clk = clk_get(&pdev->dev, clk_name);
@@ -1933,7 +1930,7 @@ static int __init r8a66597_probe(struct 
 		}
 		clk_enable(r8a66597->clk);
 	}
-#endif
+
 	if (r8a66597->pdata->sudmac) {
 		ret = r8a66597_sudmac_ioremap(r8a66597, pdev);
 		if (ret < 0)
@@ -1993,13 +1990,11 @@ err_add_udc:
 clean_up3:
 	free_irq(irq, r8a66597);
 clean_up2:
-#ifdef CONFIG_HAVE_CLK
 	if (r8a66597->pdata->on_chip) {
 		clk_disable(r8a66597->clk);
 		clk_put(r8a66597->clk);
 	}
 clean_up_dev:
-#endif
 	device_unregister(&r8a66597->gadget.dev);
 clean_up:
 	if (r8a66597) {
diff -puN drivers/usb/gadget/r8a66597-udc.h~gadget-r8a66597-remove-conditional-compilation-of-clk-code drivers/usb/gadget/r8a66597-udc.h
--- a/drivers/usb/gadget/r8a66597-udc.h~gadget-r8a66597-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/gadget/r8a66597-udc.h
@@ -13,10 +13,7 @@
 #ifndef __R8A66597_H__
 #define __R8A66597_H__
 
-#ifdef CONFIG_HAVE_CLK
 #include <linux/clk.h>
-#endif
-
 #include <linux/usb/r8a66597.h>
 
 #define R8A66597_MAX_SAMPLING	10
@@ -92,9 +89,7 @@ struct r8a66597 {
 	void __iomem		*reg;
 	void __iomem		*sudmac_reg;
 
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
-#endif
 	struct r8a66597_platdata	*pdata;
 
 	struct usb_gadget		gadget;
_
Subject: Subject: gadget/r8a66597: remove conditional compilation of clk code

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

