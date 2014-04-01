From: akpm@linux-foundation.org
Subject: + rtc-rv3029c2-fix-potential-race-condition.patch added to -mm
 tree
Date: Tue, 01 Apr 2014 15:48:35 -0700
Message-ID: <533b4243.mV6uN5D4OgdfD17w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaDAWsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2014 18:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, gregory.hermant@calao-systems.com

Subject: + rtc-rv3029c2-fix-potential-race-condition.patch added to -mm tree
To: gregory.hermant@calao-systems.com,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 15:48:35 -0700


The patch titled
     Subject: drivers/rtc/rtc-rv3029c2.c: fix potential race condition
has been added to the -mm tree.  Its filename is
     rtc-rv3029c2-fix-potential-race-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rv3029c2-fix-potential-race-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rv3029c2-fix-potential-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gregory Hermant <gregory.hermant@calao-systems.com>
Subject: drivers/rtc/rtc-rv3029c2.c: fix potential race condition

RTC drivers must not return an error after device registration.

Signed-off-by: Gregory Hermant <gregory.hermant@calao-systems.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rv3029c2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-rv3029c2.c~rtc-rv3029c2-fix-potential-race-condition drivers/rtc/rtc-rv3029c2.c
--- a/drivers/rtc/rtc-rv3029c2.c~rtc-rv3029c2-fix-potential-race-condition
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -395,6 +395,12 @@ static int rv3029c2_probe(struct i2c_cli
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_EMUL))
 		return -ENODEV;
 
+	rc = rv3029c2_i2c_get_sr(client, buf);
+	if (rc < 0) {
+		dev_err(&client->dev, "reading status failed\n");
+		return rc;
+	}
+
 	rtc = devm_rtc_device_register(&client->dev, client->name,
 					&rv3029c2_rtc_ops, THIS_MODULE);
 
@@ -403,12 +409,6 @@ static int rv3029c2_probe(struct i2c_cli
 
 	i2c_set_clientdata(client, rtc);
 
-	rc = rv3029c2_i2c_get_sr(client, buf);
-	if (rc < 0) {
-		dev_err(&client->dev, "reading status failed\n");
-		return rc;
-	}
