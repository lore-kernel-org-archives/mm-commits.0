From: akpm@linux-foundation.org
Subject: + rtc-ds1307-remove-superfluous-initialization.patch added to -mm tree
Date: Thu, 19 Apr 2012 13:23:06 -0700
Message-ID: <20120419202307.72729A0353@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55166 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2DSUXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 16:23:14 -0400
Received: by eekc41 with SMTP id c41so430954eek.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 13:23:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, Joakim.Tjernlund@transmode.se


The patch titled
     Subject: rtc: ds1307: remove superfluous initialization
has been added to the -mm tree.  Its filename is
     rtc-ds1307-remove-superfluous-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: rtc: ds1307: remove superfluous initialization

ds1307 was kzalloced, so no need to zero members of the struct.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-remove-superfluous-initialization drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-remove-superfluous-initialization
+++ a/drivers/rtc/rtc-ds1307.c
@@ -637,7 +637,6 @@ static int __devinit ds1307_probe(struct
 
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
-	ds1307->offset	= 0;
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
_
Subject: Subject: rtc: ds1307: remove superfluous initialization

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
include-linux-spinlockh-add-a-kerneldoc-comment-to-spin_is_locked-that-discourages-its-use.patch
leds-add-led-driver-for-lm3556-chip.patch
rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
rtc-ds1307-remove-superfluous-initialization.patch
rtc-ds1307-add-trickle-charger-support.patch

