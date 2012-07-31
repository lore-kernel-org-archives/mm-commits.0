From: akpm@linux-foundation.org
Subject: [merged] gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:47 -0700
Message-ID: <20120731184847.D1CC71E007B@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab2GaSst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:49 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gadget/r8a66597: remove conditional compilation of clk code
has been removed from the -mm tree.  Its filename was
     gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/r8a66597-udc.c |   11 +++--------
 drivers/usb/gadget/r8a66597-udc.h |    5 -----
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN drivers/usb/gadget/r8a66597-udc.c~gadget-r8a66597-remove-conditional-compilation-of-clk-code drivers/usb/gadget/r8a66597-udc.c
--- a/drivers/usb/gadget/r8a66597-udc.c~gadget-r8a66597-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/gadget/r8a66597-udc.c
@@ -1831,12 +1831,12 @@ static int __exit r8a66597_remove(struct
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
@@ -1868,9 +1868,7 @@ static int __init r8a66597_sudmac_iorema
 
 static int __init r8a66597_probe(struct platform_device *pdev)
 {
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	struct resource *res, *ires;
 	int irq;
 	void __iomem *reg = NULL;
@@ -1934,7 +1932,6 @@ static int __init r8a66597_probe(struct 
 	r8a66597->timer.data = (unsigned long)r8a66597;
 	r8a66597->reg = reg;
 
-#ifdef CONFIG_HAVE_CLK
 	if (r8a66597->pdata->on_chip) {
 		snprintf(clk_name, sizeof(clk_name), "usb%d", pdev->id);
 		r8a66597->clk = clk_get(&pdev->dev, clk_name);
@@ -1946,7 +1943,7 @@ static int __init r8a66597_probe(struct 
 		}
 		clk_enable(r8a66597->clk);
 	}
-#endif
+
 	if (r8a66597->pdata->sudmac) {
 		ret = r8a66597_sudmac_ioremap(r8a66597, pdev);
 		if (ret < 0)
@@ -2006,13 +2003,11 @@ err_add_udc:
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
