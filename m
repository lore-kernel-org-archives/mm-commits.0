From: akpm@linux-foundation.org
Subject: + input-use-disable_irq_nosync-for-mainstone.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:01:41 -0800
Message-ID: <200903042101.n24L1fhj002224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbZCDVCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:02:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dtor@mail.ru


The patch titled
     input: Use disable_irq_nosync() for Mainstone
has been added to the -mm tree.  Its filename is
     input-use-disable_irq_nosync-for-mainstone.patch

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
Subject: input: Use disable_irq_nosync() for Mainstone
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

This should make no practical difference since the Mainstone can't be SMP
but it is more correct.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/mainstone-wm97xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/mainstone-wm97xx.c~input-use-disable_irq_nosync-for-mainstone drivers/input/touchscreen/mainstone-wm97xx.c
--- a/drivers/input/touchscreen/mainstone-wm97xx.c~input-use-disable_irq_nosync-for-mainstone
+++ a/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -246,7 +246,7 @@ static void wm97xx_irq_enable(struct wm9
 	if (enable)
 		enable_irq(wm->pen_irq);
 	else
-		disable_irq(wm->pen_irq);
+		disable_irq_nosync(wm->pen_irq);
 }
 
 static struct wm97xx_mach_ops mainstone_mach_ops = {
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
input-wm97xx-add-btn_touch-event-to-wm97xx-to-use-it-with-android.patch
input-add-btn_touch-event.patch
input-use-disable_irq_nosync-for-mainstone.patch
input-accelerated-touchscreen-support-for-marvell-zylonite.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

