From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block.patch added to -mm tree
Date: Mon, 08 Jul 2013 13:48:01 -0700
Message-ID: <51db2581.0+qUAHqYUoRQ0+XB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3GHUsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 16:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shawn.guo@linaro.org, fabio.estevam@freescale.com

Subject: + drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block.patch added to -mm tree
To: fabio.estevam@freescale.com,shawn.guo@linaro.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 13:48:01 -0700


The patch titled
     Subject: drivers/rtc/rtc-stmp3xxx.c: check the return value from stmp_reset_block()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/rtc/rtc-stmp3xxx.c: check the return value from stmp_reset_block()

stmp_reset_block() may fail, so let's check its return value and propagate
it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -261,7 +261,12 @@ static int stmp3xxx_rtc_probe(struct pla
 
 	platform_set_drvdata(pdev, rtc_data);
 
-	stmp_reset_block(rtc_data->io);
+	err = stmp_reset_block(rtc_data->io);
+	if (err) {
+		dev_err(&pdev->dev, "stmp_reset_block failed: %d\n", err);
+		return err;
+	}
+
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-stmp3xxxc-check-the-return-value-from-stmp_reset_block.patch

