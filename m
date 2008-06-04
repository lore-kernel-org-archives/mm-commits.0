From: akpm@linux-foundation.org
Subject: + rtc-ds1374-rename-device-to-just-ds1374.patch added to -mm tree
Date: Wed, 04 Jun 2008 11:41:36 -0700
Message-ID: <200806041841.m54IfaYR003233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbYFDSmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 14:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, a.zummo@towertech.it, benh@kernel.crashing.org, david-b@pacbell.net, galak@kernel.crashing.org, paulus@samba.org


The patch titled
     rtc-ds1374: rename device to just "ds1374"
has been added to the -mm tree.  Its filename is
     rtc-ds1374-rename-device-to-just-ds1374.patch

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

rtc-ds1374-rename-device-to-just-ds1374.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch

