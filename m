From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-remove-leftover-code.patch added to -mm tree
Date: Tue, 28 Oct 2014 14:26:09 -0700
Message-ID: <545009f1.tvtR6ekrLzK/pWti%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaJ1V0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:26:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kardell@telliq.com, a.zummo@towertech.it, dan.carpenter@oracle.com, grant.likely@linaro.org, robh+dt@kernel.org, vdonnefort@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: pcf8563: remove leftover code
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-remove-leftover-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pcf8563-remove-leftover-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pcf8563-remove-leftover-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch

