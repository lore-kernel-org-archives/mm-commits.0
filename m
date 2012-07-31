From: akpm@linux-foundation.org
Subject: [merged] net-c_can-remove-conditional-compilation-of-clk-code.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:34 -0700
Message-ID: <20120731184835.27CA0200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54607 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234Ab2GaSsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:37 -0400
Received: by eekd4 with SMTP id d4so295391eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, bhupesh.sharma@st.com, davem@davemloft.net, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/c_can: remove conditional compilation of clk code
has been removed from the -mm tree.  Its filename was
     net-c_can-remove-conditional-compilation-of-clk-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: net/c_can: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/can/c_can/c_can_platform.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/net/can/c_can/c_can_platform.c~net-c_can-remove-conditional-compilation-of-clk-code drivers/net/can/c_can/c_can_platform.c
--- a/drivers/net/can/c_can/c_can_platform.c~net-c_can-remove-conditional-compilation-of-clk-code
+++ a/drivers/net/can/c_can/c_can_platform.c
@@ -74,7 +74,6 @@ static int __devinit c_can_plat_probe(st
 	const struct platform_device_id *id;
 	struct resource *mem;
 	int irq;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
 
 	/* get the appropriate clk */
@@ -84,7 +83,6 @@ static int __devinit c_can_plat_probe(st
 		ret = -ENODEV;
 		goto exit;
 	}
-#endif
 
 	/* get the platform data */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -145,10 +143,8 @@ static int __devinit c_can_plat_probe(st
 
 	dev->irq = irq;
 	priv->base = addr;
-#ifdef CONFIG_HAVE_CLK
 	priv->can.clock.freq = clk_get_rate(clk);
 	priv->priv = clk;
-#endif
 
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
@@ -172,10 +168,8 @@ exit_iounmap:
 exit_release_mem:
 	release_mem_region(mem->start, resource_size(mem));
 exit_free_clk:
-#ifdef CONFIG_HAVE_CLK
 	clk_put(clk);
 exit:
-#endif
 	dev_err(&pdev->dev, "probe failed\n");
 
 	return ret;
@@ -196,9 +190,7 @@ static int __devexit c_can_plat_remove(s
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 
-#ifdef CONFIG_HAVE_CLK
 	clk_put(priv->priv);
-#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
linux-next.patch

