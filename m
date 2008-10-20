From: akpm@linux-foundation.org
Subject: - hwmon-pc87360-separate-alarm-files-add-dev_dbg-help.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:58 -0700
Message-ID: <200810202034.m9KKYwAL010977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbYJTUfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon/pc87360 separate alarm files: add dev_dbg help
has been removed from the -mm tree.  Its filename was
     hwmon-pc87360-separate-alarm-files-add-dev_dbg-help.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon/pc87360 separate alarm files: add dev_dbg help
From: Jim Cromie <jim.cromie@gmail.com>

temp and vin status register values may be set by chip specifications, set
again by bios, or by this previously loaded driver.  Debug output nicely
displays modprobe init=\d actions.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-dev_dbg-help drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-dev_dbg-help
+++ a/drivers/hwmon/pc87360.c
@@ -1290,10 +1290,11 @@ static void pc87360_init_device(struct p
 
 	nr = data->innr < 11 ? data->innr : 11;
 	for (i = 0; i < nr; i++) {
+		reg = pc87360_read_value(data, LD_IN, i,
+					 PC87365_REG_IN_STATUS);
+		dev_dbg(&pdev->dev, "bios in%d status:0x%02x\n", i, reg);
 		if (init >= init_in[i]) {
 			/* Forcibly enable voltage channel */
-			reg = pc87360_read_value(data, LD_IN, i,
-						 PC87365_REG_IN_STATUS);
 			if (!(reg & CHAN_ENA)) {
 				dev_dbg(&pdev->dev, "Forcibly "
 					"enabling in%d\n", i);
@@ -1306,18 +1307,23 @@ static void pc87360_init_device(struct p
 
 	/* We can't blindly trust the Super-I/O space configuration bit,
 	   most BIOS won't set it properly */
+	dev_dbg(&pdev->dev, "bios thermistors:%d\n", use_thermistors);
 	for (i = 11; i < data->innr; i++) {
 		reg = pc87360_read_value(data, LD_IN, i,
 					 PC87365_REG_TEMP_STATUS);
 		use_thermistors = use_thermistors || (reg & CHAN_ENA);
+		/* thermistors are temp[4-6], measured on vin[11-14] */
+		dev_dbg(&pdev->dev, "bios temp%d_status:0x%02x\n", i-7, reg);
 	}
+	dev_dbg(&pdev->dev, "using thermistors:%d\n", use_thermistors);
 
 	i = use_thermistors ? 2 : 0;
 	for (; i < data->tempnr; i++) {
+		reg = pc87360_read_value(data, LD_TEMP, i,
+					 PC87365_REG_TEMP_STATUS);
+		dev_dbg(&pdev->dev, "bios temp%d_status:0x%02x\n", i+1, reg);
 		if (init >= init_temp[i]) {
 			/* Forcibly enable temperature channel */
-			reg = pc87360_read_value(data, LD_TEMP, i,
-						 PC87365_REG_TEMP_STATUS);
 			if (!(reg & CHAN_ENA)) {
 				dev_dbg(&pdev->dev, "Forcibly "
 					"enabling temp%d\n", i+1);
@@ -1359,6 +1365,7 @@ static void pc87360_init_device(struct p
 	if (data->innr) {
 		reg = pc87360_read_value(data, LD_IN, NO_BANK,
 					 PC87365_REG_IN_CONFIG);
+		dev_dbg(&pdev->dev, "bios vin-cfg:0x%02x\n", reg);
 		if (reg & CHAN_ENA) {
 			dev_dbg(&pdev->dev, "Forcibly "
 				"enabling monitoring (VLM)\n");
@@ -1371,6 +1378,7 @@ static void pc87360_init_device(struct p
 	if (data->tempnr) {
 		reg = pc87360_read_value(data, LD_TEMP, NO_BANK,
 					 PC87365_REG_TEMP_CONFIG);
+		dev_dbg(&pdev->dev, "bios temp-cfg:0x%02x\n", reg);
 		if (reg & CHAN_ENA) {
 			dev_dbg(&pdev->dev, "Forcibly enabling "
 				"monitoring (TMS)\n");
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

origin.patch

