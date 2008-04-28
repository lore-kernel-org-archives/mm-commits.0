From: akpm@linux-foundation.org
Subject: - sm501-add-uart-support.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:00 -0700
Message-ID: <200804282156.m3SLu02b018174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937271AbYD1V4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, ben-linux@fluff.org, damm@igel.co.jp, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sm501: add uart support
has been removed from the -mm tree.  Its filename was
     sm501-add-uart-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: add uart support
From: Magnus Damm <magnus.damm@gmail.com>

This patch extends the sm501 mfd with 8250 uart support. We're currently
doing this in the board specific r2d-1 code already, but it would be nice to
do move things into the mfd since it's more chip specific than board specific.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c         |   86 +++++++++++++++++++++++++++-------
 include/linux/serial_8250.h |    1 
 2 files changed, 70 insertions(+), 17 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-add-uart-support drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-add-uart-support
+++ a/drivers/mfd/sm501.c
@@ -22,6 +22,7 @@
 
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
+#include <linux/serial_8250.h>
 
 #include <asm/io.h>
 
@@ -723,13 +724,14 @@ static void sm501_device_release(struct 
 */
 
 static struct platform_device *
-sm501_create_subdev(struct sm501_devdata *sm,
-		    char *name, unsigned int res_count)
+sm501_create_subdev(struct sm501_devdata *sm, char *name,
+		    unsigned int res_count, unsigned int platform_data_size)
 {
 	struct sm501_device *smdev;
 
 	smdev = kzalloc(sizeof(struct sm501_device) +
-			sizeof(struct resource) * res_count, GFP_KERNEL);
+			(sizeof(struct resource) * res_count) +
+			platform_data_size, GFP_KERNEL);
 	if (!smdev)
 		return NULL;
 
@@ -737,11 +739,15 @@ sm501_create_subdev(struct sm501_devdata
 
 	smdev->pdev.name = name;
 	smdev->pdev.id = sm->pdev_id;
-	smdev->pdev.resource = (struct resource *)(smdev+1);
-	smdev->pdev.num_resources = res_count;
-
 	smdev->pdev.dev.parent = sm->dev;
 
+	if (res_count) {
+		smdev->pdev.resource = (struct resource *)(smdev+1);
+		smdev->pdev.num_resources = res_count;
+	}
+	if (platform_data_size)
+		smdev->pdev.dev.platform_data = (void *)(smdev+1);
+
 	return &smdev->pdev;
 }
 
@@ -829,7 +835,7 @@ static int sm501_register_usbhost(struct
 {
 	struct platform_device *pdev;
 
-	pdev = sm501_create_subdev(sm, "sm501-usb", 3);
+	pdev = sm501_create_subdev(sm, "sm501-usb", 3, 0);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -840,12 +846,55 @@ static int sm501_register_usbhost(struct
 	return sm501_register_device(sm, pdev);
 }
 
+static void sm501_setup_uart_data(struct sm501_devdata *sm,
+				  struct plat_serial8250_port *uart_data,
+				  unsigned int offset)
+{
+	uart_data->membase = sm->regs + offset;
+	uart_data->mapbase = sm->io_res->start + offset;
+	uart_data->iotype = UPIO_MEM;
+	uart_data->irq = sm->irq;
+	uart_data->flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ;
+	uart_data->regshift = 2;
+	uart_data->uartclk = (9600 * 16);
+}
+
+static int sm501_register_uart(struct sm501_devdata *sm, int devices)
+{
+	struct platform_device *pdev;
+	struct plat_serial8250_port *uart_data;
+
+	pdev = sm501_create_subdev(sm, "serial8250", 0,
+				   sizeof(struct plat_serial8250_port) * 3);
+	if (!pdev)
+		return -ENOMEM;
+
+	uart_data = pdev->dev.platform_data;
+
+	if (devices & SM501_USE_UART0) {
+		sm501_setup_uart_data(sm, uart_data++, 0x30000);
+		sm501_unit_power(sm->dev, SM501_GATE_UART0, 1);
+		sm501_modify_reg(sm->dev, SM501_IRQ_MASK, 1 << 12, 0);
+		sm501_modify_reg(sm->dev, SM501_GPIO63_32_CONTROL, 0x01e0, 0);
+	}
+	if (devices & SM501_USE_UART1) {
+		sm501_setup_uart_data(sm, uart_data++, 0x30020);
+		sm501_unit_power(sm->dev, SM501_GATE_UART1, 1);
+		sm501_modify_reg(sm->dev, SM501_IRQ_MASK, 1 << 13, 0);
+		sm501_modify_reg(sm->dev, SM501_GPIO63_32_CONTROL, 0x1e00, 0);
+	}
+
+	pdev->id = PLAT8250_DEV_SM501;
+
+	return sm501_register_device(sm, pdev);
+}
+
 static int sm501_register_display(struct sm501_devdata *sm,
 				  resource_size_t *mem_avail)
 {
 	struct platform_device *pdev;
 
-	pdev = sm501_create_subdev(sm, "sm501-fb", 4);
+	pdev = sm501_create_subdev(sm, "sm501-fb", 4, 0);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -963,6 +1012,7 @@ static unsigned int sm501_mem_local[] = 
 
 static int sm501_init_dev(struct sm501_devdata *sm)
 {
+	struct sm501_initdata *idata;
 	resource_size_t mem_avail;
 	unsigned long dramctrl;
 	unsigned long devid;
@@ -980,6 +1030,9 @@ static int sm501_init_dev(struct sm501_d
 		return -EINVAL;
 	}
 
+	/* disable irqs */
+	writel(0, sm->regs + SM501_IRQ_MASK);
+
 	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
 	mem_avail = sm501_mem_local[(dramctrl >> 13) & 0x7];
 
@@ -998,15 +1051,14 @@ static int sm501_init_dev(struct sm501_d
 
 	/* check to see if we have some device initialisation */
 
-	if (sm->platdata) {
-		struct sm501_platdata *pdata = sm->platdata;
-
-		if (pdata->init) {
-			sm501_init_regs(sm, sm->platdata->init);
-
-			if (pdata->init->devices & SM501_USE_USB_HOST)
-				sm501_register_usbhost(sm, &mem_avail);
-		}
+	idata = sm->platdata ? sm->platdata->init : NULL;
+	if (idata) {
+		sm501_init_regs(sm, idata);
+
+		if (idata->devices & SM501_USE_USB_HOST)
+			sm501_register_usbhost(sm, &mem_avail);
+		if (idata->devices & (SM501_USE_UART0 | SM501_USE_UART1))
+			sm501_register_uart(sm, idata->devices);
 	}
 
 	ret = sm501_check_clocks(sm);
diff -puN include/linux/serial_8250.h~sm501-add-uart-support include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~sm501-add-uart-support
+++ a/include/linux/serial_8250.h
@@ -46,6 +46,7 @@ enum {
 	PLAT8250_DEV_HUB6,
 	PLAT8250_DEV_MCA,
 	PLAT8250_DEV_AU1X00,
+	PLAT8250_DEV_SM501,
 };
 
 /*
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

origin.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-sh.patch

