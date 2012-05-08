From: akpm@linux-foundation.org
Subject: + gadget-m66592-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:33:06 -0700
Message-ID: <20120508223306.EF9F6A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56810 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab2EHWdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:33:07 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so845570yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:33:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, gregkh@linuxfoundation.org, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com


The patch titled
     Subject: gadget/m66592: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     gadget-m66592-remove-conditional-compilation-of-clk-code.patch

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
Subject: gadget/m66592: remove conditional compilation of clk code

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

 drivers/usb/gadget/m66592-udc.c |    9 +--------
 drivers/usb/gadget/m66592-udc.h |    5 -----
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/usb/gadget/m66592-udc.c~gadget-m66592-remove-conditional-compilation-of-clk-code drivers/usb/gadget/m66592-udc.c
--- a/drivers/usb/gadget/m66592-udc.c~gadget-m66592-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/gadget/m66592-udc.c
@@ -1583,12 +1583,10 @@ static int __exit m66592_remove(struct p
 	iounmap(m66592->reg);
 	free_irq(platform_get_irq(pdev, 0), m66592);
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
-#ifdef CONFIG_HAVE_CLK
 	if (m66592->pdata->on_chip) {
 		clk_disable(m66592->clk);
 		clk_put(m66592->clk);
 	}
-#endif
 	kfree(m66592);
 	return 0;
 }
@@ -1602,9 +1600,7 @@ static int __init m66592_probe(struct pl
 	struct resource *res, *ires;
 	void __iomem *reg = NULL;
 	struct m66592 *m66592 = NULL;
-#ifdef CONFIG_HAVE_CLK
 	char clk_name[8];
-#endif
 	int ret = 0;
 	int i;
 
@@ -1671,7 +1667,6 @@ static int __init m66592_probe(struct pl
 		goto clean_up;
 	}
 
-#ifdef CONFIG_HAVE_CLK
 	if (m66592->pdata->on_chip) {
 		snprintf(clk_name, sizeof(clk_name), "usbf%d", pdev->id);
 		m66592->clk = clk_get(&pdev->dev, clk_name);
@@ -1683,7 +1678,7 @@ static int __init m66592_probe(struct pl
 		}
 		clk_enable(m66592->clk);
 	}
-#endif
+
 	INIT_LIST_HEAD(&m66592->gadget.ep_list);
 	m66592->gadget.ep0 = &m66592->ep[0].ep;
 	INIT_LIST_HEAD(&m66592->gadget.ep0->ep_list);
@@ -1731,13 +1726,11 @@ err_add_udc:
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
 
 clean_up3:
-#ifdef CONFIG_HAVE_CLK
 	if (m66592->pdata->on_chip) {
 		clk_disable(m66592->clk);
 		clk_put(m66592->clk);
 	}
 clean_up2:
-#endif
 	free_irq(ires->start, m66592);
 clean_up:
 	if (m66592) {
diff -puN drivers/usb/gadget/m66592-udc.h~gadget-m66592-remove-conditional-compilation-of-clk-code drivers/usb/gadget/m66592-udc.h
--- a/drivers/usb/gadget/m66592-udc.h~gadget-m66592-remove-conditional-compilation-of-clk-code
+++ a/drivers/usb/gadget/m66592-udc.h
@@ -13,10 +13,7 @@
 #ifndef __M66592_UDC_H__
 #define __M66592_UDC_H__
 
-#ifdef CONFIG_HAVE_CLK
 #include <linux/clk.h>
-#endif
-
 #include <linux/usb/m66592.h>
 
 #define M66592_SYSCFG		0x00
@@ -468,9 +465,7 @@ struct m66592_ep {
 struct m66592 {
 	spinlock_t		lock;
 	void __iomem		*reg;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
-#endif
 	struct m66592_platdata	*pdata;
 	unsigned long		irq_trigger;
 
_
Subject: Subject: gadget/m66592: remove conditional compilation of clk code

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

