From: akpm@linux-foundation.org
Subject: + layered-parport-code-uses-parport-dev.patch added to -mm tree
Date: Mon, 26 Mar 2007 15:39:51 -0700
Message-ID: <200703262239.l2QMdps1032506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56667 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbXCZWkJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, khali@linux-fr.org


The patch titled
     layered parport code uses parport->dev
has been added to the -mm tree.  Its filename is
     layered-parport-code-uses-parport-dev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: layered parport code uses parport->dev
From: David Brownell <david-b@pacbell.net>

Update some of the layered parport_driver code to use parport->dev:

	- i2c-parport (parent of i2c_adapter)
	- spi_butterfly (parent of spi_master, allowing cruft removal)
	- lp (creating class_device)
	- ppdev (parent of parportN device)
	- tipar (creating class_device)

There are still drivers that should be updated, like some of the input
drivers; but they won't be any worse off than they are today.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c                |    2 +-
 drivers/char/ppdev.c             |    2 +-
 drivers/char/tipar.c             |    2 +-
 drivers/i2c/busses/i2c-parport.c |    1 +
 drivers/spi/spi_butterfly.c      |   21 ++++-----------------
 5 files changed, 8 insertions(+), 20 deletions(-)

diff -puN drivers/char/lp.c~layered-parport-code-uses-parport-dev drivers/char/lp.c
--- a/drivers/char/lp.c~layered-parport-code-uses-parport-dev
+++ a/drivers/char/lp.c
@@ -803,7 +803,7 @@ static int lp_register(int nr, struct pa
 	if (reset)
 		lp_reset(nr);
 
-	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), NULL,
+	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), port->dev,
 				"lp%d", nr);
 
 	printk(KERN_INFO "lp%d: using %s (%s).\n", nr, port->name, 
diff -puN drivers/char/ppdev.c~layered-parport-code-uses-parport-dev drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~layered-parport-code-uses-parport-dev
+++ a/drivers/char/ppdev.c
@@ -752,7 +752,7 @@ static const struct file_operations pp_f
 
 static void pp_attach(struct parport *port)
 {
-	device_create(ppdev_class, NULL, MKDEV(PP_MAJOR, port->number),
+	device_create(ppdev_class, port->dev, MKDEV(PP_MAJOR, port->number),
 			"parport%d", port->number);
 }
 
diff -puN drivers/char/tipar.c~layered-parport-code-uses-parport-dev drivers/char/tipar.c
--- a/drivers/char/tipar.c~layered-parport-code-uses-parport-dev
+++ a/drivers/char/tipar.c
@@ -442,7 +442,7 @@ tipar_register(int nr, struct parport *p
 	}
 
 	class_device_create(tipar_class, NULL, MKDEV(TIPAR_MAJOR,
-			TIPAR_MINOR + nr), NULL, "par%d", nr);
+			TIPAR_MINOR + nr), port->dev, "par%d", nr);
 
 	/* Display informations */
 	pr_info("tipar%d: using %s (%s)\n", nr, port->name, (port->irq ==
diff -puN drivers/i2c/busses/i2c-parport.c~layered-parport-code-uses-parport-dev drivers/i2c/busses/i2c-parport.c
--- a/drivers/i2c/busses/i2c-parport.c~layered-parport-code-uses-parport-dev
+++ a/drivers/i2c/busses/i2c-parport.c
@@ -175,6 +175,7 @@ static void i2c_parport_attach (struct p
 	}
 	adapter->algo_data.data = port;
 	adapter->adapter.algo_data = &adapter->algo_data;
+	adapter->adapter.dev.parent = port->physport->dev;
 
 	if (parport_claim_or_block(adapter->pdev) < 0) {
 		printk(KERN_ERR "i2c-parport: Could not claim parallel port\n");
diff -puN drivers/spi/spi_butterfly.c~layered-parport-code-uses-parport-dev drivers/spi/spi_butterfly.c
--- a/drivers/spi/spi_butterfly.c~layered-parport-code-uses-parport-dev
+++ a/drivers/spi/spi_butterfly.c
@@ -20,7 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/platform_device.h>
+#include <linux/device.h>
 #include <linux/parport.h>
 
 #include <linux/sched.h>
@@ -237,24 +237,16 @@ static void butterfly_attach(struct parp
 	int			status;
 	struct butterfly	*pp;
 	struct spi_master	*master;
-	struct platform_device	*pdev;
+	struct device		*dev = p->physport->dev;
 
-	if (butterfly)
+	if (butterfly || !dev)
 		return;
 
 	/* REVISIT:  this just _assumes_ a butterfly is there ... no probe,
 	 * and no way to be selective about what it binds to.
 	 */
 
-	/* FIXME where should master->cdev.dev come from?
-	 * e.g. /sys/bus/pnp0/00:0b, some PCI thing, etc
-	 * setting up a platform device like this is an ugly kluge...
-	 */
-	pdev = platform_device_register_simple("butterfly", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return;
-
-	master = spi_alloc_master(&pdev->dev, sizeof *pp);
+	master = spi_alloc_master(dev, sizeof *pp);
 	if (!master) {
 		status = -ENOMEM;
 		goto done;
@@ -366,14 +358,12 @@ clean1:
 clean0:
 	(void) spi_master_put(pp->bitbang.master);
 done:
-	platform_device_unregister(pdev);
 	pr_debug("%s: butterfly probe, fail %d\n", p->name, status);
 }
 
 static void butterfly_detach(struct parport *p)
 {
 	struct butterfly	*pp;
-	struct platform_device	*pdev;
 	int			status;
 
 	/* FIXME this global is ugly ... but, how to quickly get from
@@ -386,7 +376,6 @@ static void butterfly_detach(struct parp
 	butterfly = NULL;
 
 	/* stop() unregisters child devices too */
-	pdev = to_platform_device(pp->bitbang.master->cdev.dev);
 	status = spi_bitbang_stop(&pp->bitbang);
 
 	/* turn off VCC */
@@ -397,8 +386,6 @@ static void butterfly_detach(struct parp
 	parport_unregister_device(pp->pd);
 
 	(void) spi_master_put(pp->bitbang.master);
-
-	platform_device_unregister(pdev);
 }
 
 static struct parport_driver butterfly_driver = {
_

Patches currently in -mm which might be from david-b@pacbell.net are

8250-make-probing-for-txen-bug-a-config-option.patch
scsi-newstyle-hotplug-coldplug-support.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
layered-parport-code-uses-parport-dev.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-kconfig-cleanup.patch
