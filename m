From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:49 -0700
Message-ID: <20120731185249.AEA35100081@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab2GaSwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:50 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nbowler@elliptictech.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: set owner field in driver struct
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf8563c-set-owner-field-in-driver-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from nbowler@elliptictech.com are

origin.patch

