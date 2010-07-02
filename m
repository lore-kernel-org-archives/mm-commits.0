From: akpm@linux-foundation.org
Subject: + hwmon-add-support-for-w83667hg-b-and-w83667hg-i-to-w83627ehf-driver.patch added to -mm tree
Date: Fri, 02 Jul 2010 15:26:51 -0700
Message-ID: <201007022226.o62MQpl6030342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995Ab0GBW1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 18:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org


The patch titled
     hwmon: add support for W83667HG-B and W83667HG-I to w83627ehf driver
has been added to the -mm tree.  Its filename is
     hwmon-add-support-for-w83667hg-b-and-w83667hg-i-to-w83627ehf-driver.patch

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
Subject: hwmon: add support for W83667HG-B and W83667HG-I to w83627ehf driver
From: Guenter Roeck <guenter.roeck@ericsson.com>

Key relevant difference between W83667HG and W83667HG-B are the Chip ID as
well as the fan output and step output register addresses.  Those
differences are addressed with this patch.

There are other relevant changes in the mapping of input sensors to fan
control (W83667HG datasheet chapter 8.7, W83667HG-B datasheet chapter
8.5).  However, control of those mappings is not implemented in the
driver, thus the respective changes should not have an impact on driver
operation.

Changes made in this patch are based on information from datasheets only. 
The patch has not yet been tested with real hardware.  The patch will have
to be tested with real hardware before it is integrated, and is thus
submitted as RFC.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/w83627ehf.c |   57 ++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 8 deletions(-)

diff -puN drivers/hwmon/w83627ehf.c~hwmon-add-support-for-w83667hg-b-and-w83667hg-i-to-w83627ehf-driver drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~hwmon-add-support-for-w83667hg-b-and-w83667hg-i-to-w83627ehf-driver
+++ a/drivers/hwmon/w83627ehf.c
@@ -39,6 +39,8 @@
     w83627dhg    9      5       4       3      0xa020 0xc1    0x5ca3
     w83627dhg-p  9      5       4       3      0xb070 0xc1    0x5ca3
     w83667hg     9      5       3       3      0xa510 0xc1    0x5ca3
+    w83667hg-i   9      5       3       3      0xb340 0xc1    0x5ca3
+    w83667hg-b   9      5       3       3      0xb350 0xc1    0x5ca3
 */
 
 #include <linux/module.h>
@@ -55,7 +57,7 @@
 #include <linux/io.h>
 #include "lm75.h"
 
-enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg };
+enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg, w83667hg_b };
 
 /* used to set data->name = w83627ehf_device_names[data->sio_kind] */
 static const char * w83627ehf_device_names[] = {
@@ -63,6 +65,7 @@ static const char * w83627ehf_device_nam
 	"w83627dhg",
 	"w83627dhg",
 	"w83667hg",
+	"w83667hg",
 };
 
 static unsigned short force_id;
@@ -91,6 +94,8 @@ MODULE_PARM_DESC(force_id, "Override the
 #define SIO_W83627DHG_ID	0xa020
 #define SIO_W83627DHG_P_ID	0xb070
 #define SIO_W83667HG_ID 	0xa510
+#define SIO_W83667HG_I_ID	0xb340
+#define SIO_W83667HG_B_ID	0xb350
 #define SIO_ID_MASK		0xFFF0
 
 static inline void
@@ -201,8 +206,14 @@ static const u8 W83627EHF_REG_TOLERANCE[
 static const u8 W83627EHF_REG_FAN_START_OUTPUT[] = { 0x0a, 0x0b, 0x16, 0x65 };
 static const u8 W83627EHF_REG_FAN_STOP_OUTPUT[] = { 0x08, 0x09, 0x15, 0x64 };
 static const u8 W83627EHF_REG_FAN_STOP_TIME[] = { 0x0c, 0x0d, 0x17, 0x66 };
-static const u8 W83627EHF_REG_FAN_MAX_OUTPUT[] = { 0xff, 0x67, 0xff, 0x69 };
-static const u8 W83627EHF_REG_FAN_STEP_OUTPUT[] = { 0xff, 0x68, 0xff, 0x6a };
+
+static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_COMMON[]
+						= { 0xff, 0x67, 0xff, 0x69 };
+static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_COMMON[]
+						= { 0xff, 0x68, 0xff, 0x6a };
+
+static const u8 W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B[] = { 0x67, 0x69, 0x6b };
+static const u8 W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B[] = { 0x68, 0x6a, 0x6c };
 
 /*
  * Conversions
@@ -277,6 +288,11 @@ struct w83627ehf_data {
 	struct device *hwmon_dev;
 	struct mutex lock;
 
+	const u8 *REG_FAN_START_OUTPUT;
+	const u8 *REG_FAN_STOP_OUTPUT;
+	const u8 *REG_FAN_MAX_OUTPUT;
+	const u8 *REG_FAN_STEP_OUTPUT;
+
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -1126,7 +1142,7 @@ store_##reg(struct device *dev, struct d
 	u32 val = SENSORS_LIMIT(simple_strtoul(buf, NULL, 10), 1, 255); \
 	mutex_lock(&data->update_lock); \
 	data->reg[nr] = val; \
-	w83627ehf_write_value(data, W83627EHF_REG_##REG[nr], val); \
+	w83627ehf_write_value(data, data->REG_##REG[nr], val); \
 	mutex_unlock(&data->update_lock); \
 	return count; \
 }
@@ -1343,22 +1359,37 @@ static int __devinit w83627ehf_probe(str
 	/* 627EHG and 627EHF have 10 voltage inputs; 627DHG and 667HG have 9 */
 	data->in_num = (sio_data->kind == w83627ehf) ? 10 : 9;
 	/* 667HG has 3 pwms */
-	data->pwm_num = (sio_data->kind == w83667hg) ? 3 : 4;
+	data->pwm_num = (sio_data->kind == w83667hg
+			 || sio_data->kind == w83667hg_b) ? 3 : 4;
 
 	/* Check temp3 configuration bit for 667HG */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		data->temp3_disable = w83627ehf_read_value(data,
 					W83627EHF_REG_TEMP_CONFIG[1]) & 0x01;
 		data->in6_skip = !data->temp3_disable;
 	}
 
+	data->REG_FAN_START_OUTPUT = W83627EHF_REG_FAN_START_OUTPUT;
+	data->REG_FAN_STOP_OUTPUT = W83627EHF_REG_FAN_STOP_OUTPUT;
+	if (sio_data->kind == w83667hg_b) {
+		data->REG_FAN_MAX_OUTPUT
+		  = W83627EHF_REG_FAN_MAX_OUTPUT_W83667_B;
+		data->REG_FAN_STEP_OUTPUT
+		  = W83627EHF_REG_FAN_STEP_OUTPUT_W83667_B;
+	} else {
+		data->REG_FAN_MAX_OUTPUT
+		  = W83627EHF_REG_FAN_MAX_OUTPUT_COMMON;
+		data->REG_FAN_STEP_OUTPUT
+		  = W83627EHF_REG_FAN_STEP_OUTPUT_COMMON;
+	}
+
 	/* Initialize the chip */
 	w83627ehf_init_device(data);
 
 	data->vrm = vid_which_vrm();
 	superio_enter(sio_data->sioreg);
 	/* Read VID value */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		/* W83667HG has different pins for VID input and output, so
 		we can get the VID input values directly at logical device D
 		0xe3. */
@@ -1409,7 +1440,7 @@ static int __devinit w83627ehf_probe(str
 	}
 
 	/* fan4 and fan5 share some pins with the GPIO and serial flash */
-	if (sio_data->kind == w83667hg) {
+	if (sio_data->kind == w83667hg || sio_data->kind == w83667hg_b) {
 		fan5pin = superio_inb(sio_data->sioreg, 0x27) & 0x20;
 		fan4pin = superio_inb(sio_data->sioreg, 0x27) & 0x40;
 	} else {
@@ -1556,6 +1587,8 @@ static int __init w83627ehf_find(int sio
 	static const char __initdata sio_name_W83627DHG[] = "W83627DHG";
 	static const char __initdata sio_name_W83627DHG_P[] = "W83627DHG-P";
 	static const char __initdata sio_name_W83667HG[] = "W83667HG";
+	static const char __initdata sio_name_W83667HG_I[] = "W83667HG-I";
+	static const char __initdata sio_name_W83667HG_B[] = "W83667HG-B";
 
 	u16 val;
 	const char *sio_name;
@@ -1588,6 +1621,14 @@ static int __init w83627ehf_find(int sio
 		sio_data->kind = w83667hg;
 		sio_name = sio_name_W83667HG;
 		break;
+	case SIO_W83667HG_I_ID:
+		sio_data->kind = w83667hg;
+		sio_name = sio_name_W83667HG_I;
+		break;
+	case SIO_W83667HG_B_ID:
+		sio_data->kind = w83667hg_b;
+		sio_name = sio_name_W83667HG_B;
+		break;
 	default:
 		if (val != 0xffff)
 			pr_debug(DRVNAME ": unsupported chip ID: 0x%04x\n",
_

Patches currently in -mm which might be from guenter.roeck@ericsson.com are

linux-next.patch
hwmon-driver-for-smm665-six-channel-active-dc-output-controller-monitor.patch
hwmon-smm665-driver-documentation.patch
hwmon-update-maintainers-for-smm665-driver.patch
hwmon-add-support-for-w83667hg-b-and-w83667hg-i-to-w83627ehf-driver.patch
hwmon-add-support-for-w83667hg-b-and-w83667hg-i-to-w83627ehf-driver-fix.patch

