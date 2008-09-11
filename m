From: akpm@linux-foundation.org
Subject: + hwmon-pc87360-separate-alarm-files-define-some-constants.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:03:20 -0700
Message-ID: <200809110003.m8B03LIO001211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYIKADg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:03:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     hwmon/pc87360 separate alarm files: define some constants
has been added to the -mm tree.  Its filename is
     hwmon-pc87360-separate-alarm-files-define-some-constants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon/pc87360 separate alarm files: define some constants
From: Jim Cromie <jim.cromie@gmail.com>

Bring hwmon/pc87360 into agreement with
Documentation/hwmon/sysfs-interface.

Patchset adds separate limit alarms for voltages and temps, it also adds
temp[123]_fault files.  On my Soekris, temps 1,2 are unused/unconnected,
so temp[123]_fault = 1,1,0 respectively.  This agrees with
/usr/bin/sensors, which has always shown them as OPEN.  Temps 4,5,6 are
thermistor based, and dont have a fault bit in their status register.


This patch:

2 different kinds of constants added:
- CHAN_ALM_* constants for (later) vin, temp alarm callbacks.
- CHAN_* conversion constants, used in _init_device, partly for RW1C bits

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-define-some-constants drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-define-some-constants
+++ a/drivers/hwmon/pc87360.c
@@ -489,6 +489,11 @@ static struct sensor_device_attribute in
 	SENSOR_ATTR(in10_max, S_IWUSR | S_IRUGO, show_in_max, set_in_max, 10),
 };
 
+/* (temp & vin) channel status register alarm bits (pdf sec.11.5.12) */
+#define CHAN_ALM_MIN	0x02	/* min limit crossed */
+#define CHAN_ALM_MAX	0x04	/* max limit exceeded */
+#define TEMP_ALM_CRIT	0x08	/* temp crit exceeded (temp only) */
+
 #define VIN_UNIT_ATTRS(X) \
 	&in_input[X].dev_attr.attr,	\
 	&in_status[X].dev_attr.attr,	\
@@ -1131,6 +1136,12 @@ static void pc87360_write_value(struct p
 	mutex_unlock(&(data->lock));
 }
 
+/* (temp & vin) channel conversion status register flags (pdf sec.11.5.12) */
+#define CHAN_CNVRTD	0x80	/* new data ready */
+#define CHAN_ENA	0x01	/* enabled channel (temp or vin) */
+#define CHAN_ALM_ENA	0x10	/* propagate to alarms-reg ?? (chk val!) */
+#define CHAN_READY	(CHAN_ENA|CHAN_CNVRTD) /* sample ready mask */
+
 static void pc87360_init_device(struct platform_device *pdev,
 				int use_thermistors)
 {
@@ -1156,7 +1167,7 @@ static void pc87360_init_device(struct p
 			/* Forcibly enable voltage channel */
 			reg = pc87360_read_value(data, LD_IN, i,
 						 PC87365_REG_IN_STATUS);
-			if (!(reg & 0x01)) {
+			if (!(reg & CHAN_ENA)) {
 				dev_dbg(&pdev->dev, "Forcibly "
 					"enabling in%d\n", i);
 				pc87360_write_value(data, LD_IN, i,
@@ -1171,7 +1182,7 @@ static void pc87360_init_device(struct p
 	for (i = 11; i < data->innr; i++) {
 		reg = pc87360_read_value(data, LD_IN, i,
 					 PC87365_REG_TEMP_STATUS);
-		use_thermistors = use_thermistors || (reg & 0x01);
+		use_thermistors = use_thermistors || (reg & CHAN_ENA);
 	}
 
 	i = use_thermistors ? 2 : 0;
@@ -1180,7 +1191,7 @@ static void pc87360_init_device(struct p
 			/* Forcibly enable temperature channel */
 			reg = pc87360_read_value(data, LD_TEMP, i,
 						 PC87365_REG_TEMP_STATUS);
-			if (!(reg & 0x01)) {
+			if (!(reg & CHAN_ENA)) {
 				dev_dbg(&pdev->dev, "Forcibly "
 					"enabling temp%d\n", i+1);
 				pc87360_write_value(data, LD_TEMP, i,
@@ -1197,7 +1208,7 @@ static void pc87360_init_device(struct p
 				   diodes */
 				reg = pc87360_read_value(data, LD_TEMP,
 				      (i-11)/2, PC87365_REG_TEMP_STATUS);
-				if (reg & 0x01) {
+				if (reg & CHAN_ENA) {
 					dev_dbg(&pdev->dev, "Skipping "
 						"temp%d, pin already in use "
 						"by temp%d\n", i-7, (i-11)/2);
@@ -1207,7 +1218,7 @@ static void pc87360_init_device(struct p
 				/* Forcibly enable thermistor channel */
 				reg = pc87360_read_value(data, LD_IN, i,
 							 PC87365_REG_IN_STATUS);
-				if (!(reg & 0x01)) {
+				if (!(reg & CHAN_ENA)) {
 					dev_dbg(&pdev->dev, "Forcibly "
 						"enabling temp%d\n", i-7);
 					pc87360_write_value(data, LD_IN, i,
@@ -1221,7 +1232,7 @@ static void pc87360_init_device(struct p
 	if (data->innr) {
 		reg = pc87360_read_value(data, LD_IN, NO_BANK,
 					 PC87365_REG_IN_CONFIG);
-		if (reg & 0x01) {
+		if (reg & CHAN_ENA) {
 			dev_dbg(&pdev->dev, "Forcibly "
 				"enabling monitoring (VLM)\n");
 			pc87360_write_value(data, LD_IN, NO_BANK,
@@ -1233,7 +1244,7 @@ static void pc87360_init_device(struct p
 	if (data->tempnr) {
 		reg = pc87360_read_value(data, LD_TEMP, NO_BANK,
 					 PC87365_REG_TEMP_CONFIG);
-		if (reg & 0x01) {
+		if (reg & CHAN_ENA) {
 			dev_dbg(&pdev->dev, "Forcibly enabling "
 				"monitoring (TMS)\n");
 			pc87360_write_value(data, LD_TEMP, NO_BANK,
@@ -1336,11 +1347,11 @@ static struct pc87360_data *pc87360_upda
 			pc87360_write_value(data, LD_IN, i,
 					    PC87365_REG_IN_STATUS,
 					    data->in_status[i]);
-			if ((data->in_status[i] & 0x81) == 0x81) {
+			if ((data->in_status[i] & CHAN_READY) == CHAN_READY) {
 				data->in[i] = pc87360_read_value(data, LD_IN,
 					      i, PC87365_REG_IN);
 			}
-			if (data->in_status[i] & 0x01) {
+			if (data->in_status[i] & CHAN_ENA) {
 				data->in_min[i] = pc87360_read_value(data,
 						  LD_IN, i,
 						  PC87365_REG_IN_MIN);
@@ -1373,12 +1384,12 @@ static struct pc87360_data *pc87360_upda
 			pc87360_write_value(data, LD_TEMP, i,
 					    PC87365_REG_TEMP_STATUS,
 					    data->temp_status[i]);
-			if ((data->temp_status[i] & 0x81) == 0x81) {
+			if ((data->temp_status[i] & CHAN_READY) == CHAN_READY) {
 				data->temp[i] = pc87360_read_value(data,
 						LD_TEMP, i,
 						PC87365_REG_TEMP);
 			}
-			if (data->temp_status[i] & 0x01) {
+			if (data->temp_status[i] & CHAN_ENA) {
 				data->temp_min[i] = pc87360_read_value(data,
 						    LD_TEMP, i,
 						    PC87365_REG_TEMP_MIN);
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

hwmon-pc87360-separate-alarm-files-define-some-constants.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch
hwmon-pc87360-separate-alarm-files-add-dev_dbg-help.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch

