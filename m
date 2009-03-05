From: akpm@linux-foundation.org
Subject: [merged] input-use-disable_irq_nosync-for-mainstone.patch removed from -mm tree
Date: Thu, 05 Mar 2009 11:56:12 -0800
Message-ID: <200903051956.n25JuChT027224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768AbZCET4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 14:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: Use disable_irq_nosync() for Mainstone
has been removed from the -mm tree.  Its filename was
     input-use-disable_irq_nosync-for-mainstone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
mfd-add-support-for-wm8351-revision-b.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

