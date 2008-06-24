From: akpm@linux-foundation.org
Subject: + sm501-add-power-control-callback.patch added to -mm tree
Date: Mon, 23 Jun 2008 21:05:00 -0700
Message-ID: <200806240405.m5O450gL031871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbYFXEFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, apatard@mandriva.com


The patch titled
     sm501: add power control callback
has been added to the -mm tree.  Its filename is
     sm501-add-power-control-callback.patch

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
@@ -155,6 +155,8 @@ struct sm501_init_gpio {
 	struct sm501_reg_init	gpio_ddr_high;
 };
 
+#define SM501_FLAG_SUSPEND_OFF		(1<<4)
+
 /* sm501_platdata
  *
  * This is passed with the platform device to allow the board
@@ -168,6 +170,11 @@ struct sm501_platdata {
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

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch

