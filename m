From: akpm@osdl.org
Subject: + convert-pxaficp_irc-to-platform_driver.patch added to -mm tree
Date: Tue, 05 Dec 2006 23:25:35 -0800
Message-ID: <200612060725.kB67PZK2027035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38506 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760283AbWLFH0S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 02:26:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pmiscml@gmail.com, samuel@sortiz.org, stable@kernel.org


The patch titled
     Convert pxaficp_ir.c to platform_driver
has been added to the -mm tree.  Its filename is
     convert-pxaficp_irc-to-platform_driver.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Convert pxaficp_ir.c to platform_driver
From: Paul Sokolovsky <pmiscml@gmail.com>

drivers/ner/irda/pxaficp_ir.c was not converted to platform_driver, which
in 2.6.19 ( after commit
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=386415d88b1ae50304f9c61aa3e0db082fa90428;hp=bb84c89f94851161f387285d0a449b4a3f29f4df
) leads to random memory corruption, resume problems, etc

We specifically face issues with HP iPaq hx4700 device, which has
nondeterministic resume problems depending on the changes to kernel config
options (not directly related to pxaficp_ir).  More info on the issue:
http://lkml.org/lkml/2006/10/25/73 .

Signed-off-by: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/irda/pxaficp_ir.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/net/irda/pxaficp_ir.c~convert-pxaficp_irc-to-platform_driver drivers/net/irda/pxaficp_ir.c
--- a/drivers/net/irda/pxaficp_ir.c~convert-pxaficp_irc-to-platform_driver
+++ a/drivers/net/irda/pxaficp_ir.c
@@ -704,9 +704,9 @@ static int pxa_irda_stop(struct net_devi
 	return 0;
 }
 
-static int pxa_irda_suspend(struct device *_dev, pm_message_t state)
+static int pxa_irda_suspend(struct platform_device *_dev, pm_message_t state)
 {
-	struct net_device *dev = dev_get_drvdata(_dev);
+	struct net_device *dev = platform_get_drvdata(_dev);
 	struct pxa_irda *si;
 
 	if (dev && netif_running(dev)) {
@@ -718,9 +718,9 @@ static int pxa_irda_suspend(struct devic
 	return 0;
 }
 
-static int pxa_irda_resume(struct device *_dev)
+static int pxa_irda_resume(struct platform_device *_dev)
 {
-	struct net_device *dev = dev_get_drvdata(_dev);
+	struct net_device *dev = platform_get_drvdata(_dev);
 	struct pxa_irda *si;
 
 	if (dev && netif_running(dev)) {
@@ -746,9 +746,8 @@ static int pxa_irda_init_iobuf(iobuff_t 
 	return io->head ? 0 : -ENOMEM;
 }
 
-static int pxa_irda_probe(struct device *_dev)
+static int pxa_irda_probe(struct platform_device *pdev)
 {
-	struct platform_device *pdev = to_platform_device(_dev);
 	struct net_device *dev;
 	struct pxa_irda *si;
 	unsigned int baudrate_mask;
@@ -822,9 +821,9 @@ err_mem_1:
 	return err;
 }
 
-static int pxa_irda_remove(struct device *_dev)
+static int pxa_irda_remove(struct platform_device *_dev)
 {
-	struct net_device *dev = dev_get_drvdata(_dev);
+	struct net_device *dev = platform_get_drvdata(_dev);
 
 	if (dev) {
 		struct pxa_irda *si = netdev_priv(dev);
@@ -840,9 +839,10 @@ static int pxa_irda_remove(struct device
 	return 0;
 }
 
-static struct device_driver pxa_ir_driver = {
-	.name		= "pxa2xx-ir",
-	.bus		= &platform_bus_type,
+static struct platform_driver pxa_ir_driver = {
+	.driver         = {
+		.name   = "pxa2xx-ir",
+	},
 	.probe		= pxa_irda_probe,
 	.remove		= pxa_irda_remove,
 	.suspend	= pxa_irda_suspend,
@@ -851,12 +851,12 @@ static struct device_driver pxa_ir_drive
 
 static int __init pxa_irda_init(void)
 {
-	return driver_register(&pxa_ir_driver);
+	return platform_driver_register(&pxa_ir_driver);
 }
 
 static void __exit pxa_irda_exit(void)
 {
-	driver_unregister(&pxa_ir_driver);
+	platform_driver_unregister(&pxa_ir_driver);
 }
 
 module_init(pxa_irda_init);
_

Patches currently in -mm which might be from pmiscml@gmail.com are

convert-pxaficp_irc-to-platform_driver.patch

