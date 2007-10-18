From: akpm@linux-foundation.org
Subject: - make-the-pr_-family-of-macros-in-kernelh-complete.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:19 -0700
Message-ID: <200710180700.l9I70JsL031089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932524AbXJRHrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Emilian.Medve@Freescale.com, adaplas@pol.net, jeff@garzik.org, khali@linux-fr.org, randy.dunlap@oracle.com, satyam@infradead.org, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Make the pr_*() family of macros in kernel.h complete
has been removed from the -mm tree.  Its filename was
     make-the-pr_-family-of-macros-in-kernelh-complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make the pr_*() family of macros in kernel.h complete
From: Emil Medve <Emilian.Medve@Freescale.com>

Other/Some pr_*() macros are already defined in kernel.h, but pr_err() was
defined multiple times in several other places

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Tony Lindgren <tony@atomide.com>
Reviewed-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/menelaus.c     |   10 ++++------
 drivers/net/spider_net.h         |    3 ---
 drivers/video/omap/lcd_h3.c      |    6 ++----
 drivers/video/omap/lcd_inn1610.c |    6 ++----
 include/linux/kernel.h           |   22 +++++++++++++++++-----
 5 files changed, 25 insertions(+), 22 deletions(-)

diff -puN drivers/i2c/chips/menelaus.c~make-the-pr_-family-of-macros-in-kernelh-complete drivers/i2c/chips/menelaus.c
--- a/drivers/i2c/chips/menelaus.c~make-the-pr_-family-of-macros-in-kernelh-complete
+++ a/drivers/i2c/chips/menelaus.c
@@ -49,8 +49,6 @@
 
 #define DRIVER_NAME			"menelaus"
 
-#define pr_err(fmt, arg...)	printk(KERN_ERR DRIVER_NAME ": ", ## arg);
-
 #define MENELAUS_I2C_ADDRESS		0x72
 
 #define MENELAUS_REV			0x01
@@ -155,7 +153,7 @@ static int menelaus_write_reg(int reg, u
 	int val = i2c_smbus_write_byte_data(the_menelaus->client, reg, value);
 
 	if (val < 0) {
-		pr_err("write error");
+		pr_err(DRIVER_NAME ": write error");
 		return val;
 	}
 
@@ -167,7 +165,7 @@ static int menelaus_read_reg(int reg)
 	int val = i2c_smbus_read_byte_data(the_menelaus->client, reg);
 
 	if (val < 0)
-		pr_err("read error");
+		pr_err(DRIVER_NAME ": read error");
 
 	return val;
 }
@@ -1177,7 +1175,7 @@ static int menelaus_probe(struct i2c_cli
 	/* If a true probe check the device */
 	rev = menelaus_read_reg(MENELAUS_REV);
 	if (rev < 0) {
-		pr_err("device not found");
+		pr_err(DRIVER_NAME ": device not found");
 		err = -ENODEV;
 		goto fail1;
 	}
@@ -1258,7 +1256,7 @@ static int __init menelaus_init(void)
 
 	res = i2c_add_driver(&menelaus_i2c_driver);
 	if (res < 0) {
-		pr_err("driver registration failed\n");
+		pr_err(DRIVER_NAME ": driver registration failed\n");
 		return res;
 	}
 
diff -puN drivers/net/spider_net.h~make-the-pr_-family-of-macros-in-kernelh-complete drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~make-the-pr_-family-of-macros-in-kernelh-complete
+++ a/drivers/net/spider_net.h
@@ -494,7 +494,4 @@ struct spider_net_card {
 	struct spider_net_descr darray[0];
 };
 
-#define pr_err(fmt,arg...) \
-	printk(KERN_ERR fmt ,##arg)
-
 #endif
diff -puN drivers/video/omap/lcd_h3.c~make-the-pr_-family-of-macros-in-kernelh-complete drivers/video/omap/lcd_h3.c
--- a/drivers/video/omap/lcd_h3.c~make-the-pr_-family-of-macros-in-kernelh-complete
+++ a/drivers/video/omap/lcd_h3.c
@@ -28,8 +28,6 @@
 
 #define MODULE_NAME	"omapfb-lcd_h3"
 
-#define pr_err(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
-
 static int h3_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
 {
 	return 0;
@@ -48,7 +46,7 @@ static int h3_panel_enable(struct lcd_pa
 	if (!r)
 		r = tps65010_set_gpio_out_value(GPIO2, HIGH);
 	if (r)
-		pr_err("Unable to turn on LCD panel\n");
+		pr_err(MODULE_NAME ": Unable to turn on LCD panel\n");
 
 	return r;
 }
@@ -62,7 +60,7 @@ static void h3_panel_disable(struct lcd_
 	if (!r)
 		tps65010_set_gpio_out_value(GPIO2, LOW);
 	if (r)
-		pr_err("Unable to turn off LCD panel\n");
+		pr_err(MODULE_NAME ": Unable to turn off LCD panel\n");
 }
 
 static unsigned long h3_panel_get_caps(struct lcd_panel *panel)
diff -puN drivers/video/omap/lcd_inn1610.c~make-the-pr_-family-of-macros-in-kernelh-complete drivers/video/omap/lcd_inn1610.c
--- a/drivers/video/omap/lcd_inn1610.c~make-the-pr_-family-of-macros-in-kernelh-complete
+++ a/drivers/video/omap/lcd_inn1610.c
@@ -27,20 +27,18 @@
 
 #define MODULE_NAME	"omapfb-lcd_h3"
 
-#define pr_err(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
-
 static int innovator1610_panel_init(struct lcd_panel *panel,
 				    struct omapfb_device *fbdev)
 {
 	int r = 0;
 
 	if (omap_request_gpio(14)) {
-		pr_err("can't request GPIO 14\n");
+		pr_err(MODULE_NAME ": can't request GPIO 14\n");
 		r = -1;
 		goto exit;
 	}
 	if (omap_request_gpio(15)) {
-		pr_err("can't request GPIO 15\n");
+		pr_err(MODULE_NAME ": can't request GPIO 15\n");
 		omap_free_gpio(14);
 		r = -1;
 		goto exit;
diff -puN include/linux/kernel.h~make-the-pr_-family-of-macros-in-kernelh-complete include/linux/kernel.h
--- a/include/linux/kernel.h~make-the-pr_-family-of-macros-in-kernelh-complete
+++ a/include/linux/kernel.h
@@ -251,10 +251,25 @@ extern void print_hex_dump_bytes(const c
 			const void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
+#define pr_emerg(fmt, arg...) \
+	printk(KERN_EMERG fmt, ##arg)
+#define pr_alert(fmt, arg...) \
+	printk(KERN_ALERT fmt, ##arg)
+#define pr_crit(fmt, arg...) \
+	printk(KERN_CRIT fmt, ##arg)
+#define pr_err(fmt, arg...) \
+	printk(KERN_ERR fmt, ##arg)
+#define pr_warning(fmt, arg...) \
+	printk(KERN_WARNING fmt, ##arg)
+#define pr_notice(fmt, arg...) \
+	printk(KERN_NOTICE fmt, ##arg)
+#define pr_info(fmt, arg...) \
+	printk(KERN_INFO fmt, ##arg)
+
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
-#define pr_debug(fmt,arg...) \
-	printk(KERN_DEBUG fmt,##arg)
+#define pr_debug(fmt, arg...) \
+	printk(KERN_DEBUG fmt, ##arg)
 #else
 static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char * fmt, ...)
 {
@@ -262,9 +277,6 @@ static inline int __attribute__ ((format
 }
 #endif
 
-#define pr_info(fmt,arg...) \
-	printk(KERN_INFO fmt,##arg)
-
 /*
  *      Display an IP address in readable format.
  */
_

Patches currently in -mm which might be from Emilian.Medve@Freescale.com are

origin.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
