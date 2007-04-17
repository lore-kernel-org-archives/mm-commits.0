From: akpm@linux-foundation.org
Subject: + hwmon-w83627ehf-fix-fan5-div-selection.patch added to -mm tree
Date: Tue, 17 Apr 2007 00:31:27 -0700
Message-ID: <200704170731.l3H7VRt0023335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXDQHbp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 03:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org


The patch titled
     hwmon/w83627ehf: Fix the fan5 clock divider write
has been added to the -mm tree.  Its filename is
     hwmon-w83627ehf-fix-fan5-div-selection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hwmon/w83627ehf: Fix the fan5 clock divider write
From: Jean Delvare <khali@linux-fr.org>

Users have been complaining about the w83627ehf driver flooding their logs
with debug messages like:

w83627ehf 9191-0a10: Increasing fan 4 clock divider from 64 to 128

or:

w83627ehf 9191-0290: Increasing fan 4 clock divider from 4 to 8

The reason is that we failed to actually write the LSB of the encoded clock
divider value for that fan, causing the next read to report the same old value
again and again.

Additionally, the fan number was improperly reported, making the bug harder to
find.

Signed-off-by: Jean Delvare <khali@linux-fr.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/w83627ehf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-fix-fan5-div-selection drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-fix-fan5-div-selection
+++ a/drivers/hwmon/w83627ehf.c
@@ -407,7 +407,7 @@ static void w83627ehf_write_fan_div(stru
 		break;
 	case 4:
 		reg = (w83627ehf_read_value(client, W83627EHF_REG_DIODE) & 0x73)
-		    | ((data->fan_div[4] & 0x03) << 3)
+		    | ((data->fan_div[4] & 0x03) << 2)
 		    | ((data->fan_div[4] & 0x04) << 5);
 		w83627ehf_write_value(client, W83627EHF_REG_DIODE, reg);
 		break;
@@ -471,9 +471,9 @@ static struct w83627ehf_data *w83627ehf_
 			   time */
 			if (data->fan[i] == 0xff
 			 && data->fan_div[i] < 0x07) {
-			 	dev_dbg(&client->dev, "Increasing fan %d "
+			 	dev_dbg(&client->dev, "Increasing fan%d "
 					"clock divider from %u to %u\n",
-					i, div_from_reg(data->fan_div[i]),
+					i + 1, div_from_reg(data->fan_div[i]),
 					div_from_reg(data->fan_div[i] + 1));
 				data->fan_div[i]++;
 				w83627ehf_write_fan_div(client, i);
_

Patches currently in -mm which might be from khali@linux-fr.org are

hwmon-w83627ehf-fix-fan5-div-selection.patch
i2c-pasemi-fix-Kconfig-dependencies.patch
i2c-pasemi-fixes.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
ams-driver-do-not-print-error-on-systems-without-apple-motion-sensor.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
