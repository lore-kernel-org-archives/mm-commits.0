From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:20:31 -0700
Message-ID: <200807292220.m6TMKVL4024672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYG2WU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     blackfin RTC driver: if we dont define irq_set_freq, the common rtc-dev layer will give us the same behavior of returning ENOTTY
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
