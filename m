From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8563-remove-leftover-code.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 11:07:06 -0800
Message-ID: <5489eb5a.Bc4zy1RkW0m75iM4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbaLKTHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: remove leftover code
has been removed from the -mm tree.  Its filename was
     rtc-pcf8563-remove-leftover-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kardell <jan.kardell@telliq.com>
Subject: rtc: pcf8563: remove leftover code

Remove some code that was left from before block read/write was used.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-remove-leftover-code drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-remove-leftover-code
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -118,22 +118,21 @@ static int pcf8563_write_block_data(stru
 
 static int pcf8563_set_alarm_mode(struct i2c_client *client, bool on)
 {
-	unsigned char buf[2];
+	unsigned char buf;
 	int err;
 
-	err = pcf8563_read_block_data(client, PCF8563_REG_ST2, 1, buf + 1);
+	err = pcf8563_read_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0)
 		return err;
 
 	if (on)
-		buf[1] |= PCF8563_BIT_AIE;
+		buf |= PCF8563_BIT_AIE;
 	else
-		buf[1] &= ~PCF8563_BIT_AIE;
+		buf &= ~PCF8563_BIT_AIE;
 
-	buf[1] &= ~PCF8563_BIT_AF;
-	buf[0] = PCF8563_REG_ST2;
+	buf &= ~PCF8563_BIT_AF;
 
-	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, buf + 1);
+	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0) {
 		dev_err(&client->dev, "%s: write error\n", __func__);
 		return -EIO;
_

Patches currently in -mm which might be from jan.kardell@telliq.com are

origin.patch

