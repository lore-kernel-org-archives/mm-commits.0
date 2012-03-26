From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-refactor-chip_desc-table.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:46 -0700
Message-ID: <20120326193146.8EC37A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58674 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab2CZTbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:48 -0400
Received: by wgbdt11 with SMTP id dt11so210371wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, Austin.Boyle@aviatnet.com, alessandro.zummo@towertech.it, danders.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: refactor chip_desc table
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-refactor-chip_desc-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: rtc: ds1307: refactor chip_desc table

The chip_desc table is suboptimal.  Currently it requires an entry for
every new chip type, even if it is empty.  This has already been forgotten
for the ds1388.  Refactor the code, so new entries are only needed, when
they chip type really needs a (non-empty) description.  Also make the
table visually more appealing.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: David Anders <danders.dev@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   48 ++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-refactor-chip_desc-table drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-refactor-chip_desc-table
+++ a/drivers/rtc/rtc-ds1307.c
@@ -36,6 +36,7 @@ enum ds_type {
 	m41t00,
 	mcp7941x,
 	rx_8025,
+	last_ds_type /* always last */
 	// rs5c372 too?  different address...
 };
 
@@ -120,30 +121,23 @@ struct chip_desc {
 	unsigned		alarm:1;
 };
 
-static const struct chip_desc chips[] = {
-[ds_1307] = {
-	.nvram56	= 1,
-},
-[ds_1337] = {
-	.alarm		= 1,
-},
-[ds_1338] = {
-	.nvram56	= 1,
-},
-[ds_1339] = {
-	.alarm		= 1,
-},
-[ds_1340] = {
-},
-[ds_3231] = {
-	.alarm		= 1,
-},
-[m41t00] = {
-},
-[mcp7941x] = {
-},
-[rx_8025] = {
-}, };
+static const struct chip_desc chips[last_ds_type] = {
+	[ds_1307] = {
+		.nvram56	= 1,
+	},
+	[ds_1337] = {
+		.alarm		= 1,
+	},
+	[ds_1338] = {
+		.nvram56	= 1,
+	},
+	[ds_1339] = {
+		.alarm		= 1,
+	},
+	[ds_3231] = {
+		.alarm		= 1,
+	},
+};
 
 static const struct i2c_device_id ds1307_id[] = {
 	{ "ds1307", ds_1307 },
@@ -836,11 +830,7 @@ read_rtc:
 		}
 
 		break;
-	case rx_8025:
-	case ds_1337:
-	case ds_1339:
-	case ds_1388:
-	case ds_3231:
+	default:
 		break;
 	}
 
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch

