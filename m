From: akpm@linux-foundation.org
Subject: + rtc-rtc-pcf8563-fix-irq-request.patch added to -mm tree
Date: Thu, 24 Jul 2014 16:04:24 -0700
Message-ID: <53d190f8.QQBjvi6dtluDkF4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49936 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934877AbaGXXEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 19:04:25 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so617546qap.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 16:04:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdonnefort@gmail.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: fix irq request
has been added to the -mm tree.  Its filename is
     rtc-rtc-pcf8563-fix-irq-request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-pcf8563-fix-irq-request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-pcf8563-fix-irq-request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-fix-irq-request drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-fix-irq-request
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
rtc-rtc-pcf8563-fix-irq-request.patch
linux-next.patch

