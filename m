From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-rtc-pcf8563-add-alarm-support-fix.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 13:56:05 -0700
Message-ID: <53e53965.l9aTN0nIdMe+A5ml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:55875 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbaHHU4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:56:07 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1102423iec.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:56:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdonnefort@gmail.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: fix irq request
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8563-add-alarm-support-fix.patch

This patch was dropped because it was folded into rtc-rtc-pcf8563-add-alarm-support.patch

------------------------------------------------------
From: Vincent Donnefort <vdonnefort@gmail.com>
Subject: drivers/rtc/rtc-pcf8563.c: fix irq request

pcf8563_probe() failed to check the devm_rtc_device_register() return value.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-add-alarm-support-fix drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-add-alarm-support-fix
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -419,7 +419,8 @@ static int pcf8563_probe(struct i2c_clie
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
 
-	return PTR_ERR_OR_ZERO(pcf8563->rtc);
+	if (IS_ERR(pcf8563->rtc))
+		return PTR_ERR(pcf8563->rtc);
 
 	if (client->irq > 0) {
 		err = devm_request_threaded_irq(&client->dev, client->irq,
_

Patches currently in -mm which might be from vdonnefort@gmail.com are

rtc-rtc-pcf8563-introducing-readwrite_block_data.patch
rtc-rtc-pcf8563-add-alarm-support.patch

