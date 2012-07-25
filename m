From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct.patch added to -mm tree
Date: Wed, 25 Jul 2012 13:56:29 -0700
Message-ID: <20120725205629.99AD01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:52094 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2GYU4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 16:56:30 -0400
Received: by vcqp1 with SMTP id p1so134354vcq.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 13:56:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nbowler@elliptictech.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: set owner field in driver struct
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Bowler <nbowler@elliptictech.com>
Subject: drivers/rtc/rtc-pcf8563.c: set owner field in driver struct

The owner member is supposed to be set to the module implementing the
device driver, i.e., THIS_MODULE.  This enables the appropriate module
link in sysfs.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -288,6 +288,7 @@ MODULE_DEVICE_TABLE(i2c, pcf8563_id);
 static struct i2c_driver pcf8563_driver = {
 	.driver		= {
 		.name	= "rtc-pcf8563",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= pcf8563_probe,
 	.remove		= pcf8563_remove,
_
Subject: Subject: drivers/rtc/rtc-pcf8563.c: set owner field in driver struct

Patches currently in -mm which might be from nbowler@elliptictech.com are

drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct.patch
drivers-rtc-rtc-pcf8563c-add-device-tree-support.patch

