From: akpm@linux-foundation.org
Subject: - rtc-ds1374-rename-device-to-just-ds1374.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:53 -0700
Message-ID: <200806081947.m58Jlriv017455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbYFHTsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, a.zummo@towertech.it, benh@kernel.crashing.org, david-b@pacbell.net, galak@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1374: rename device to just "ds1374"
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-rename-device-to-just-ds1374.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1374: rename device to just "ds1374"
From: Jean Delvare <khali@linux-fr.org>

Change the name of the device from "rtc-ds1374" to just "ds1374", to match
what all other RTC drivers do.  I seem to remember that this name was
chosen to avoid possible confusion with an older ds1374 driver, but that
driver was removed 3 months ago.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_soc.c |    2 +-
 drivers/of/of_i2c.c           |    1 -
 drivers/rtc/rtc-ds1374.c      |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_soc.c~rtc-ds1374-rename-device-to-just-ds1374 arch/powerpc/sysdev/fsl_soc.c
--- a/arch/powerpc/sysdev/fsl_soc.c~rtc-ds1374-rename-device-to-just-ds1374
+++ a/arch/powerpc/sysdev/fsl_soc.c
@@ -432,7 +432,7 @@ static struct i2c_driver_device i2c_devi
 	{"dallas,ds1339",  "ds1339"},
 	{"dallas,ds1340",  "ds1340"},
 	{"stm,m41t00",     "m41t00"},
-	{"dallas,ds1374",  "rtc-ds1374"},
+	{"dallas,ds1374",  "ds1374"},
 };
 
 static int __init of_find_i2c_driver(struct device_node *node,
diff -puN drivers/of/of_i2c.c~rtc-ds1374-rename-device-to-just-ds1374 drivers/of/of_i2c.c
--- a/drivers/of/of_i2c.c~rtc-ds1374-rename-device-to-just-ds1374
+++ a/drivers/of/of_i2c.c
@@ -21,7 +21,6 @@ struct i2c_driver_device {
 };
 
 static struct i2c_driver_device i2c_devices[] = {
-	{ "dallas,ds1374", "rtc-ds1374" },
 };
 
 static int of_find_i2c_driver(struct device_node *node,
diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-rename-device-to-just-ds1374 drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-rename-device-to-just-ds1374
+++ a/drivers/rtc/rtc-ds1374.c
@@ -42,7 +42,7 @@
 #define DS1374_REG_TCR		0x09 /* Trickle Charge */
 
 static const struct i2c_device_id ds1374_id[] = {
-	{ "rtc-ds1374", 0 },
+	{ "ds1374", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ds1374_id);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch

