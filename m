From: akpm@linux-foundation.org
Subject: + drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch added to -mm tree
Date: Wed, 28 Jul 2010 14:59:53 -0700
Message-ID: <201007282159.o6SLxrJg004780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab0G1WBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 18:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ryan@bluewatersys.com, ben@decadent.org.uk, cbouatmailru@gmail.com, dwmw2@infradead.org, geert@linux-m68k.org, vilensky@compulab.co.il


The patch titled
     drivers/power/ds2782_battery.c: fix ds2782 battery driver units
has been added to the -mm tree.  Its filename is
     drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch

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
Subject: drivers/power/ds2782_battery.c: fix ds2782 battery driver units
From: Ryan Mallon <ryan@bluewatersys.com>

Correct the unit names in the ds2782 battery driver. Changes voltage_uA
to voltage_uV and capacity_uA to capacity.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Yulia Vilensky <vilensky@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2782_battery.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/power/ds2782_battery.c~drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units drivers/power/ds2782_battery.c
--- a/drivers/power/ds2782_battery.c~drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units
+++ a/drivers/power/ds2782_battery.c
@@ -44,8 +44,8 @@ struct ds278x_info;
 
 struct ds278x_battery_ops {
 	int (*get_battery_current)(struct ds278x_info *info, int *current_uA);
-	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uA);
-	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity_uA);
+	int (*get_battery_voltage)(struct ds278x_info *info, int *voltage_uV);
+	int (*get_battery_capacity)(struct ds278x_info *info, int *capacity);
 };
 
 #define to_ds278x_info(x) container_of(x, struct ds278x_info, battery)
@@ -137,7 +137,7 @@ static int ds2782_get_current(struct ds2
 	return 0;
 }
 
-static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uA)
+static int ds2782_get_voltage(struct ds278x_info *info, int *voltage_uV)
 {
 	s16 raw;
 	int err;
@@ -149,7 +149,7 @@ static int ds2782_get_voltage(struct ds2
 	err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
 	if (err)
 		return err;
-	*voltage_uA = (raw / 32) * 4800;
+	*voltage_uV = (raw / 32) * 4800;
 	return 0;
 }
 
@@ -177,7 +177,7 @@ static int ds2786_get_current(struct ds2
 	return 0;
 }
 
-static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uA)
+static int ds2786_get_voltage(struct ds278x_info *info, int *voltage_uV)
 {
 	s16 raw;
 	int err;
@@ -189,7 +189,7 @@ static int ds2786_get_voltage(struct ds2
 	err = ds278x_read_reg16(info, DS278x_REG_VOLT_MSB, &raw);
 	if (err)
 		return err;
-	*voltage_uA = (raw / 8) * 1220;
+	*voltage_uV = (raw / 8) * 1220;
 	return 0;
 }
 
_

Patches currently in -mm which might be from ryan@bluewatersys.com are

origin.patch
linux-next.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
gpiolib-decouple-might_sleep_if-from-debug.patch

