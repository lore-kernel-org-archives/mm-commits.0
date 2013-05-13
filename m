From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-rv3029c2c-fix-disabling-aie-irq.patch added to -mm tree
Date: Mon, 13 May 2013 16:25:46 -0700
Message-ID: <20130513232546.7175131C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:42927 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3EMXZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:25:47 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so669678yen.4
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:25:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@ingics.com, hs@denx.de, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-rv3029c2c-fix-disabling-aie-irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

In the disable AIE irq code path, current code passes "1" to enable
parameter of rv3029c2_rtc_i2c_alarm_set_irq().  Thus it does not disable
AIE irq.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Heiko Schocher <hs@denx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rv3029c2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rv3029c2.c~drivers-rtc-rtc-rv3029c2c-fix-disabling-aie-irq drivers/rtc/rtc-rv3029c2.c
--- a/drivers/rtc/rtc-rv3029c2.c~drivers-rtc-rtc-rv3029c2c-fix-disabling-aie-irq
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -310,7 +310,7 @@ static int rv3029c2_rtc_i2c_set_alarm(st
 		dev_dbg(&client->dev, "alarm IRQ armed\n");
 	} else {
 		/* disable AIE irq */
-		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		ret = rv3029c2_rtc_i2c_alarm_set_irq(client, 0);
 		if (ret)
 			return ret;
 
_

Patches currently in -mm which might be from axel.lin@ingics.com are

linux-next.patch
drivers-rtc-rtc-rv3029c2c-fix-disabling-aie-irq.patch

