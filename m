From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max6900-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:35 -0700
Message-ID: <20130430185735.6F36231C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36679 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab3D3S5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:36 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88318qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max6900: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max6900-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max6900: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6900.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-max6900.c~rtc-rtc-max6900-use-devm_rtc_device_register drivers/rtc/rtc-max6900.c
--- a/drivers/rtc/rtc-max6900.c~rtc-rtc-max6900-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-max6900.c
@@ -214,11 +214,6 @@ static int max6900_rtc_set_time(struct d
 
 static int max6900_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
