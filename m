From: akpm@linux-foundation.org
Subject: [merged] mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:48:06 -0700
Message-ID: <200903182248.n2IMm6qh020282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbZCRWuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: use the value of the final spin when reading the AUXADC
has been removed from the -mm tree.  Its filename was
     mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

