From: akpm@linux-foundation.org
Subject: + rtc-hym8563-return-clock-rate-even-when-clock-is-disabled.patch added to -mm tree
Date: Wed, 11 Mar 2015 15:35:46 -0700
Message-ID: <5500c342.R1L0W3Uryyhv1fh+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbCKWfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko@sntech.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: return clock rate even when clock is disabled
has been added to the -mm tree.  Its filename is
     rtc-hym8563-return-clock-rate-even-when-clock-is-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-hym8563-return-clock-rate-even-when-clock-is-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-hym8563-return-clock-rate-even-when-clock-is-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
Subject: drivers/rtc/rtc-hym8563.c: return clock rate even when clock is disabled

When the clock is disabled, do not return a rate of 0 but instead return
the rate the clock will be running at after it gets enabled.  This
prevents problems when the core clock code is trying to determine a
suitable rate, while the clock is still off.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-hym8563.c~rtc-hym8563-return-clock-rate-even-when-clock-is-disabled drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~rtc-hym8563-return-clock-rate-even-when-clock-is-disabled
+++ a/drivers/rtc/rtc-hym8563.c
@@ -309,7 +309,7 @@ static unsigned long hym8563_clkout_reca
 	struct i2c_client *client = hym8563->client;
 	int ret = i2c_smbus_read_byte_data(client, HYM8563_CLKOUT);
 
-	if (ret < 0 || ret & HYM8563_CLKOUT_DISABLE)
+	if (ret < 0)
 		return 0;
 
 	ret &= HYM8563_CLKOUT_MASK;
_

Patches currently in -mm which might be from heiko@sntech.de are

origin.patch
rtc-hym8563-return-clock-rate-even-when-clock-is-disabled.patch
linux-next.patch

