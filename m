From: akpm@linux-foundation.org
Subject: + powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:42:07 -0700
Message-ID: <200806032342.m53Ng7jg025914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbYFCXmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, galak@kernel.crashing.org, wim@iguana.be


The patch titled
     powerpc: fsl_soc: remove mpc83xx_wdt code
has been added to the -mm tree.  Its filename is
     powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: fsl_soc: remove mpc83xx_wdt code
From: Anton Vorontsov <avorontsov@ru.mvista.com>

mpc83xx_wdt is the OF driver now, so we don't need fsl_soc constructor.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_soc.c |   46 --------------------------------
 1 file changed, 46 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_soc.c~powerpc-fsl_soc-remove-mpc83xx_wdt-code arch/powerpc/sysdev/fsl_soc.c
--- a/arch/powerpc/sysdev/fsl_soc.c~powerpc-fsl_soc-remove-mpc83xx_wdt-code
+++ a/arch/powerpc/sysdev/fsl_soc.c
@@ -542,52 +542,6 @@ err:
 arch_initcall(fsl_i2c_of_init);
 #endif
 
-#ifdef CONFIG_PPC_83xx
-static int __init mpc83xx_wdt_init(void)
-{
-	struct resource r;
-	struct device_node *np;
-	struct platform_device *dev;
-	u32 freq = fsl_get_sys_freq();
-	int ret;
-
-	np = of_find_compatible_node(NULL, "watchdog", "mpc83xx_wdt");
-
-	if (!np) {
-		ret = -ENODEV;
-		goto nodev;
-	}
-
-	memset(&r, 0, sizeof(r));
-
-	ret = of_address_to_resource(np, 0, &r);
-	if (ret)
-		goto err;
-
-	dev = platform_device_register_simple("mpc83xx_wdt", 0, &r, 1);
-	if (IS_ERR(dev)) {
-		ret = PTR_ERR(dev);
-		goto err;
-	}
-
-	ret = platform_device_add_data(dev, &freq, sizeof(freq));
-	if (ret)
-		goto unreg;
-
-	of_node_put(np);
-	return 0;
-
-unreg:
-	platform_device_unregister(dev);
-err:
-	of_node_put(np);
-nodev:
-	return ret;
-}
-
-arch_initcall(mpc83xx_wdt_init);
-#endif
