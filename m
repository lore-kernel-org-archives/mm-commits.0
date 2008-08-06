From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:25 -0700
Message-ID: <200808062056.m76KuPMl014664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758206AbYHFU5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.frysinger@analog.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: if we dont define irq_set_freq, the common rtc-dev layer will give us the same behavior of returning ENOTTY
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: if we dont define irq_set_freq, the common rtc-dev layer will give us the same behavior of returning ENOTTY
From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty
+++ a/drivers/rtc/rtc-bfin.c
@@ -381,20 +381,6 @@ static int bfin_rtc_proc(struct device *
 #undef yesno
 }
 
-/**
- *	bfin_irq_set_freq - make sure hardware supports requested freq
- *	@dev: pointer to RTC device structure
- *	@freq: requested frequency rate
- *
- *	The Blackfin RTC can only generate periodic events at 1 per
- *	second (1 Hz), so reject any attempt at changing it.
- */
-static int bfin_irq_set_freq(struct device *dev, int freq)
-{
-	dev_dbg_stamp(dev);
-	return -ENOTTY;
-}
