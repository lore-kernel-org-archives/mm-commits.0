From: akpm@linux-foundation.org
Subject: + gpio-adding-new-xilinx-driver-update.patch added to -mm tree
Date: Thu, 30 Oct 2008 02:12:53 -0700
Message-ID: <200810300912.m9U9Crmq026533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbYJ3JOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 05:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: john.linn@xilinx.com, avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca, kirans@xilinx.com, paulus@samba.org


The patch titled
     GPIO: Adding new Xilinx driver (update)
has been added to the -mm tree.  Its filename is
     gpio-adding-new-xilinx-driver-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GPIO: Adding new Xilinx driver (update)
From: John Linn <john.linn@xilinx.com>

V2 - Updated based on Anton's comments
V3 - Cleaned up Kconfig badness in patch generation and added Grant's signoff

Signed-off-by: Kiran Sutariya <kirans@xilinx.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: John Linn <john.linn@xilinx.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    2 
 drivers/gpio/xilinx_gpio.c |   71 ++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 39 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-adding-new-xilinx-driver-update drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-adding-new-xilinx-driver-update
+++ a/drivers/gpio/Kconfig
@@ -69,7 +69,7 @@ comment "Memory mapped GPIO expanders:"
 
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
-	depends on OF
+	depends on PPC_OF
 	help
 	  Say yes here to support the Xilinx FPGA GPIO device
 
diff -puN drivers/gpio/xilinx_gpio.c~gpio-adding-new-xilinx-driver-update drivers/gpio/xilinx_gpio.c
--- a/drivers/gpio/xilinx_gpio.c~gpio-adding-new-xilinx-driver-update
+++ a/drivers/gpio/xilinx_gpio.c
@@ -12,6 +12,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/init.h>
+#include <linux/errno.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
@@ -135,16 +137,27 @@ static int xgpio_dir_out(struct gpio_chi
 }
 
 /**
+ * xgpio_save_regs - Set initial values of GPIO pins
+ * @mm_gc: pointer to memory mapped GPIO chip structure
+ */
+static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
+{
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+}
+
+/**
  * xgpio_of_probe - Probe method for the GPIO device.
- * @of_dev: pointer to OF device structure.
- * @match:  pointer to the structure used for matching a device.
+ * @np: pointer to device tree node
  *
  * This function probes the GPIO device in the device tree. It initializes the
  * driver data structure. It returns 0, if the driver is bound to the GPIO
  * device, or a negative value if there is an error.
  */
-static int __devinit xgpio_of_probe(struct of_device *ofdev,
-				    const struct of_device_id *match)
+static int __devinit xgpio_of_probe(struct device_node *np)
 {
 	struct xgpio_instance *chip;
 	struct of_gpio_chip *ofchip;
@@ -157,21 +170,21 @@ static int __devinit xgpio_of_probe(stru
 	ofchip = &chip->mmchip.of_gc;
 
 	/* Update GPIO state shadow register with default value */
-	tree_info = of_get_property(ofdev->node, "xlnx,dout-default", NULL);
+	tree_info = of_get_property(np, "xlnx,dout-default", NULL);
 	if (tree_info)
 		chip->gpio_state = *tree_info;
 
 	/* Update GPIO direction shadow register with default value */
 	chip->gpio_dir = 0xFFFFFFFF; /* By default, all pins are inputs */
-	tree_info = of_get_property(ofdev->node, "xlnx,tri-default", NULL);
+	tree_info = of_get_property(np, "xlnx,tri-default", NULL);
 	if (tree_info)
 		chip->gpio_dir = *tree_info;
 
 	/* Check device node and parent device node for device width */
 	ofchip->gc.ngpio = 32; /* By default assume full GPIO controller */
-	tree_info = of_get_property(ofdev->node, "xlnx,gpio-width", NULL);
+	tree_info = of_get_property(np, "xlnx,gpio-width", NULL);
 	if (!tree_info)
-		tree_info = of_get_property(ofdev->node->parent,
+		tree_info = of_get_property(np->parent,
 					    "xlnx,gpio-width", NULL);
 	if (tree_info)
 		ofchip->gc.ngpio = *tree_info;
@@ -184,51 +197,33 @@ static int __devinit xgpio_of_probe(stru
 	ofchip->gc.get = xgpio_get;
 	ofchip->gc.set = xgpio_set;
 
+	chip->mmchip.save_regs = xgpio_save_regs;
+
 	/* Call the OF gpio helper to setup and register the GPIO device */
-	status = of_mm_gpiochip_add(ofdev->node, &chip->mmchip);
+	status = of_mm_gpiochip_add(np, &chip->mmchip);
 	if (status) {
 		kfree(chip);
-		dev_err(&ofdev->dev, "Error in probe function error value %d\n",
-			status);
+		pr_err("%s: error in probe function with status %d\n",
+		       np->full_name, status);
 		return status;
 	}
-
-	/* Finally, write the initial state to the device */
-	out_be32(chip->mmchip.regs + XGPIO_DATA_OFFSET, chip->gpio_state);
-	out_be32(chip->mmchip.regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
-
-	dev_info(&ofdev->dev, "registered Xilinx GPIO controller\n");
+	pr_info("XGpio: %s: registered\n", np->full_name);
 	return 0;
 }
 
-/**
- * xgpio_of_remove - Remove method for the GPIO device.
- * @of_dev: pointer to OF device structure.
- *
- * This function returns a negative error as we cannot unregister GPIO chips.
- */
-static int __devexit xgpio_of_remove(struct of_device *ofdev)
-{
-	return -EBUSY;
-}
-
 static struct of_device_id xgpio_of_match[] __devinitdata = {
 	{ .compatible = "xlnx,xps-gpio-1.00.a", },
 	{ /* end of list */ },
 };
 
-MODULE_DEVICE_TABLE(of, xgpio_of_match);
-
-static struct of_platform_driver xgpio_of_driver = {
-	.name = "xilinx_gpio",
-	.match_table = xgpio_of_match,
-	.probe = xgpio_of_probe,
-	.remove = __devexit_p(xgpio_of_remove),
-};
