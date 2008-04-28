From: akpm@linux-foundation.org
Subject: - rtc-pcf8563-add-device-ids-table.patch removed from -mm tree
Date: Mon, 28 Apr 2008 01:08:45 -0700
Message-ID: <200804280808.m3S88j2r015581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763964AbYD1IJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 04:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurentp@cse-semaphore.com, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf8563: add device ids table
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-add-device-ids-table.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-pcf8563: add device ids table
From: Laurent Pinchart <laurentp@cse-semaphore.com>

This patch adds support for device tree names via the i2c mod alias mechanism
to the rtc-pcf8563 driver.

Signed-off-by: Laurent Pinchart <laurentp@cse-semaphore.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-add-device-ids-table drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-add-device-ids-table
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -299,12 +299,20 @@ static int pcf8563_remove(struct i2c_cli
 	return 0;
 }
 
+static struct i2c_device_id pcf8563_id[] = {
+	{ "pcf8563", 0 },
+	{ "rtc8564", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, pcf8563_id);
+
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
 		.name	= "rtc-pcf8563",
 	},
 	.probe		= pcf8563_probe,
 	.remove		= pcf8563_remove,
+	.id_table	= pcf8563_id,
 };
 
 static int __init pcf8563_init(void)
_

Patches currently in -mm which might be from laurentp@cse-semaphore.com are

origin.patch
rtc-pcf8563-add-device-ids-table.patch

