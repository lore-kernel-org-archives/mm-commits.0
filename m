From: akpm@linux-foundation.org
Subject: - sm501-add-power-control-callback.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:36 -0700
Message-ID: <200807252255.m6PMtaps002989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597AbYGYXHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, apatard@mandriva.com, mm-commits@vger.kernel.org


The patch titled
     sm501: add power control callback
has been removed from the -mm tree.  Its filename was
     sm501-add-power-control-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: add power control callback
From: Ben Dooks <ben-linux@fluff.org>

Add callback to get or set the power control if the device has the sleep
connected to some form of GPIO.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <apatard@mandriva.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c   |   31 +++++++++++++++++++++++++++++++
 include/linux/sm501.h |    7 +++++++
 2 files changed, 38 insertions(+)

diff -puN drivers/mfd/sm501.c~sm501-add-power-control-callback drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-add-power-control-callback
+++ a/drivers/mfd/sm501.c
@@ -1138,8 +1138,31 @@ static int sm501_plat_probe(struct platf
 }
 
 #ifdef CONFIG_PM
+
 /* power management support */
 
+static void sm501_set_power(struct sm501_devdata *sm, int on)
+{
+	struct sm501_platdata *pd = sm->platdata;
+
+	if (pd == NULL)
+		return;
+
+	if (pd->get_power) {
+		if (pd->get_power(sm->dev) == on) {
+			dev_dbg(sm->dev, "is already %d\n", on);
+			return;
+		}
+	}
+
+	if (pd->set_power) {
+		dev_dbg(sm->dev, "setting power to %d\n", on);
+
+		pd->set_power(sm->dev, on);
+		sm501_mdelay(sm, 10);
+	}
+}
+
 static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct sm501_devdata *sm = platform_get_drvdata(pdev);
@@ -1148,6 +1171,12 @@ static int sm501_plat_suspend(struct pla
 	sm->pm_misc = readl(sm->regs + SM501_MISC_CONTROL);
 
 	sm501_dump_regs(sm);
+
+	if (sm->platdata) {
+		if (sm->platdata->flags & SM501_FLAG_SUSPEND_OFF)
+			sm501_set_power(sm, 0);
+	}
+
 	return 0;
 }
 
@@ -1155,6 +1184,8 @@ static int sm501_plat_resume(struct plat
 {
 	struct sm501_devdata *sm = platform_get_drvdata(pdev);
 
+	sm501_set_power(sm, 1);
+
 	sm501_dump_regs(sm);
 	sm501_dump_gate(sm);
 	sm501_dump_clk(sm);
diff -puN include/linux/sm501.h~sm501-add-power-control-callback include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-add-power-control-callback
+++ a/include/linux/sm501.h
@@ -157,6 +157,8 @@ struct sm501_init_gpio {
 	struct sm501_reg_init	gpio_ddr_high;
 };
 
+#define SM501_FLAG_SUSPEND_OFF		(1<<4)
+
 /* sm501_platdata
  *
  * This is passed with the platform device to allow the board
@@ -170,6 +172,11 @@ struct sm501_platdata {
 	struct sm501_init_gpio		*init_gpiop;
 	struct sm501_platdata_fb	*fb;
 
+	int				 flags;
+
+	int	(*get_power)(struct device *dev);
+	int	(*set_power)(struct device *dev, unsigned int on);
+
 	struct sm501_platdata_gpio_i2c	*gpio_i2c;
 	unsigned int			 gpio_i2c_nr;
 };
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

