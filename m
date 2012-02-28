From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove.patch added to -mm tree
Date: Tue, 28 Feb 2012 14:01:18 -0800
Message-ID: <20120228220120.BB369A0428@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:59727 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2B1WBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2012 17:01:23 -0500
Received: by qcsp5 with SMTP id p5so110972qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2012 14:01:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agust@denx.de, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: fix crash in r9701_remove()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anatolij Gustschin <agust@denx.de>
Subject: drivers/rtc/rtc-r9701.c: fix crash in r9701_remove()

If probing the RTC didn't succeed due to failed RTC register access, the
RTC device will be unregistered.  Then, when removing the module
r9701_remove() causes a kernel crash while trying to unregister a not
registered RTC device.  Fix this by doing RTC register access test before
RTC device registration.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove
+++ a/drivers/rtc/rtc-r9701.c
@@ -125,6 +125,13 @@ static int __devinit r9701_probe(struct 
 	unsigned char tmp;
 	int res;
 
+	tmp = R100CNT;
+	res = read_regs(&spi->dev, &tmp, 1);
+	if (res || tmp != 0x20) {
+		dev_err(&spi->dev, "cannot read RTC register\n");
+		return -ENODEV;
+	}
+
 	rtc = rtc_device_register("r9701",
 				&spi->dev, &r9701_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
@@ -132,13 +139,6 @@ static int __devinit r9701_probe(struct 
 
 	dev_set_drvdata(&spi->dev, rtc);
 
-	tmp = R100CNT;
-	res = read_regs(&spi->dev, &tmp, 1);
-	if (res || tmp != 0x20) {
-		rtc_device_unregister(rtc);
-		return res;
-	}
