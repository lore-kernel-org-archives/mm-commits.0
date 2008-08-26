From: akpm@linux-foundation.org
Subject: + mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch added to -mm tree
Date: Tue, 26 Aug 2008 14:16:45 -0700
Message-ID: <200808262116.m7QLGjn7028103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbYHZVRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 17:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, benh@kernel.crashing.org, david-b@pacbell.net, grant.likely@secretlab.ca, paulus@samba.org


The patch titled
     mpc52xx_psc_spi: remove code associated with !CONFIG_PPC_MERGE
has been added to the -mm tree.  Its filename is
     mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge.patch

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
Subject: mpc52xx_psc_spi: remove code associated with !CONFIG_PPC_MERGE
From: Kumar Gala <galak@kernel.crashing.org>

Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore
remove the dead code associated with !CONFIG_PPC_MERGE.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |   55 --------------------------------
 1 file changed, 55 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-remove-code-associated-with-config_ppc_merge
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -15,13 +15,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
-
-#if defined(CONFIG_PPC_MERGE)
 #include <linux/of_platform.h>
-#else
-#include <linux/platform_device.h>
-#endif
-
 #include <linux/workqueue.h>
 #include <linux/completion.h>
 #include <linux/io.h>
@@ -471,53 +465,6 @@ static int __exit mpc52xx_psc_spi_do_rem
 	return 0;
 }
 
-#if !defined(CONFIG_PPC_MERGE)
-static int __init mpc52xx_psc_spi_probe(struct platform_device *dev)
-{
-	switch(dev->id) {
-	case 1:
-	case 2:
-	case 3:
-	case 6:
-		return mpc52xx_psc_spi_do_probe(&dev->dev,
-			MPC52xx_PA(MPC52xx_PSCx_OFFSET(dev->id)),
-			MPC52xx_PSC_SIZE, platform_get_irq(dev, 0), dev->id);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int __exit mpc52xx_psc_spi_remove(struct platform_device *dev)
-{
-	return mpc52xx_psc_spi_do_remove(&dev->dev);
-}
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:mpc52xx-psc-spi");
-
-static struct platform_driver mpc52xx_psc_spi_platform_driver = {
-	.remove = __exit_p(mpc52xx_psc_spi_remove),
-	.driver = {
-		.name = "mpc52xx-psc-spi",
-		.owner = THIS_MODULE,
-	},
-};
-
-static int __init mpc52xx_psc_spi_init(void)
-{
-	return platform_driver_probe(&mpc52xx_psc_spi_platform_driver,
-			mpc52xx_psc_spi_probe);
-}
-module_init(mpc52xx_psc_spi_init);
-
-static void __exit mpc52xx_psc_spi_exit(void)
-{
-	platform_driver_unregister(&mpc52xx_psc_spi_platform_driver);
-}
-module_exit(mpc52xx_psc_spi_exit);
-
-#else	/* defined(CONFIG_PPC_MERGE) */
-
 static int __init mpc52xx_psc_spi_of_probe(struct of_device *op,
 	const struct of_device_id *match)
 {
@@ -586,8 +533,6 @@ static void __exit mpc52xx_psc_spi_exit(
 }
 module_exit(mpc52xx_psc_spi_exit);
 
-#endif	/* defined(CONFIG_PPC_MERGE) */
