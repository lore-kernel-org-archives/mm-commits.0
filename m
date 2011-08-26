From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:08:21 -0700
Message-ID: <201108260008.p7Q08L93021629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab1HZAJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lm3530.c: remove obsolete cleanup for clientdata
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata.patch

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
Subject: drivers/leds/leds-lm3530.c: remove obsolete cleanup for clientdata
From: Wolfram Sang <w.sang@pengutronix.de>

A few new i2c-drivers came into the kernel which clear the
clientdata-pointer on exit or error.  This is obsolete meanwhile, the core
will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata
+++ a/drivers/leds/leds-lm3530.c
@@ -422,7 +422,6 @@ err_class_register:
 err_reg_init:
 	regulator_put(drvdata->regulator);
 err_regulator_get:
-	i2c_set_clientdata(client, NULL);
 	kfree(drvdata);
 err_out:
 	return err;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
video-backlight-remove-obsolete-cleanup-for-clientdata.patch
drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata.patch

