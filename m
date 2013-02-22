From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rs5c372-use-dev_dbg-dev_warn-instead-of-printk-pr_debug.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:23 -0800
Message-ID: <20130222204423.A941A31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39193 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257Ab3BVUoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:24 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so104150yhz.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rs5c372: use dev_dbg()/dev_warn() instead of printk()/pr_debug()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c372-use-dev_dbg-dev_warn-instead-of-printk-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rs5c372: use dev_dbg()/dev_warn() instead of printk()/pr_debug()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-dev_dbg-dev_warn-instead-of-printk-pr_debug drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-dev_dbg-dev_warn-instead-of-printk-pr_debug
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -311,8 +311,7 @@ static int rs5c_rtc_alarm_irq_enable(str
 		buf &= ~RS5C_CTRL1_AALE;
 
 	if (i2c_smbus_write_byte_data(client, addr, buf) < 0) {
-		printk(KERN_WARNING "%s: can't update alarm\n",
-			rs5c->rtc->name);
+		dev_warn(dev, "can't update alarm\n");
 		status = -EIO;
 	} else
 		rs5c->regs[RS5C_REG_CTRL1] = buf;
@@ -381,7 +380,7 @@ static int rs5c_set_alarm(struct device 
 		addr = RS5C_ADDR(RS5C_REG_CTRL1);
 		buf[0] = rs5c->regs[RS5C_REG_CTRL1] & ~RS5C_CTRL1_AALE;
 		if (i2c_smbus_write_byte_data(client, addr, buf[0]) < 0) {
-			pr_debug("%s: can't disable alarm\n", rs5c->rtc->name);
+			dev_dbg(dev, "can't disable alarm\n");
 			return -EIO;
 		}
 		rs5c->regs[RS5C_REG_CTRL1] = buf[0];
@@ -395,7 +394,7 @@ static int rs5c_set_alarm(struct device 
 	for (i = 0; i < sizeof(buf); i++) {
 		addr = RS5C_ADDR(RS5C_REG_ALARM_A_MIN + i);
 		if (i2c_smbus_write_byte_data(client, addr, buf[i]) < 0) {
-			pr_debug("%s: can't set alarm time\n", rs5c->rtc->name);
+			dev_dbg(dev, "can't set alarm time\n");
 			return -EIO;
 		}
 	}
@@ -405,8 +404,7 @@ static int rs5c_set_alarm(struct device 
 		addr = RS5C_ADDR(RS5C_REG_CTRL1);
 		buf[0] = rs5c->regs[RS5C_REG_CTRL1] | RS5C_CTRL1_AALE;
 		if (i2c_smbus_write_byte_data(client, addr, buf[0]) < 0)
-			printk(KERN_WARNING "%s: can't enable alarm\n",
-				rs5c->rtc->name);
+			dev_warn(dev, "can't enable alarm\n");
 		rs5c->regs[RS5C_REG_CTRL1] = buf[0];
 	}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

