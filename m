From: akpm@linux-foundation.org
Subject: + net-c_can-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:33:02 -0700
Message-ID: <20120508223302.F16E7A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51669 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab2EHWdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:33:03 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so256119vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:33:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, bhupesh.sharma@st.com, davem@davemloft.net, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com


The patch titled
     Subject: net/c_can: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     net-c_can-remove-conditional-compilation-of-clk-code.patch

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
Subject: net/c_can: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/can/c_can/c_can_platform.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/net/can/c_can/c_can_platform.c~net-c_can-remove-conditional-compilation-of-clk-code drivers/net/can/c_can/c_can_platform.c
--- a/drivers/net/can/c_can/c_can_platform.c~net-c_can-remove-conditional-compilation-of-clk-code
+++ a/drivers/net/can/c_can/c_can_platform.c
@@ -73,7 +73,6 @@ static int __devinit c_can_plat_probe(st
 	struct c_can_priv *priv;
 	struct resource *mem;
 	int irq;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
 
 	/* get the appropriate clk */
@@ -83,7 +82,6 @@ static int __devinit c_can_plat_probe(st
 		ret = -ENODEV;
 		goto exit;
 	}
-#endif
 
 	/* get the platform data */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -118,10 +116,8 @@ static int __devinit c_can_plat_probe(st
 
 	dev->irq = irq;
 	priv->regs = addr;
-#ifdef CONFIG_HAVE_CLK
 	priv->can.clock.freq = clk_get_rate(clk);
 	priv->priv = clk;
-#endif
 
 	switch (mem->flags & IORESOURCE_MEM_TYPE_MASK) {
 	case IORESOURCE_MEM_32BIT:
@@ -157,10 +153,8 @@ exit_iounmap:
 exit_release_mem:
 	release_mem_region(mem->start, resource_size(mem));
 exit_free_clk:
-#ifdef CONFIG_HAVE_CLK
 	clk_put(clk);
 exit:
-#endif
 	dev_err(&pdev->dev, "probe failed\n");
 
 	return ret;
@@ -181,9 +175,7 @@ static int __devexit c_can_plat_remove(s
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 
-#ifdef CONFIG_HAVE_CLK
 	clk_put(priv->priv);
-#endif
 
 	return 0;
 }
_
Subject: Subject: net/c_can: remove conditional compilation of clk code

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

