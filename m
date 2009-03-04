From: akpm@linux-foundation.org
Subject: + mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch added to -mm tree
Date: Wed, 04 Mar 2009 12:45:47 -0800
Message-ID: <200903042045.n24KjlXE000755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbZCDUqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 15:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, sameo@openedhand.com


The patch titled
     mfd: use the value of the final spin when reading the AUXADC
has been added to the -mm tree.  Its filename is
     mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: use the value of the final spin when reading the AUXADC
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Reverse the order of the tests for loop exit so we use a valid value
before we time out.  Vanishingly unlikely to happen since we retry for
several times the expected conversion time.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/wm8350-core.c~mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc
+++ a/drivers/mfd/wm8350-core.c
@@ -1111,7 +1111,7 @@ int wm8350_read_auxadc(struct wm8350 *wm
 	do {
 		schedule_timeout_interruptible(1);
 		reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
-	} while (--tries && (reg & WM8350_AUXADC_POLL));
+	} while ((reg & WM8350_AUXADC_POLL) && --tries);
 
 	if (!tries)
 		dev_err(wm8350->dev, "adc chn %d read timeout\n", channel);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

