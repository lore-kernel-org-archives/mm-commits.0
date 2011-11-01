From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:11 -0700
Message-ID: <201111012115.pA1LFBt7007386@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1KAVPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, khali@linux-fr.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lm3530.c: remove obsolete cleanup for clientdata
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: drivers/leds/leds-lm3530.c: remove obsolete cleanup for clientdata

A few new i2c-drivers came into the kernel which clear the
clientdata-pointer on exit or error.  This is obsolete meanwhile, the core
will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-remove-obsolete-cleanup-for-clientdata
+++ a/drivers/leds/leds-lm3530.c
@@ -421,7 +421,6 @@ err_class_register:
 err_reg_init:
 	regulator_put(drvdata->regulator);
 err_regulator_get:
-	i2c_set_clientdata(client, NULL);
 	kfree(drvdata);
 err_out:
 	return err;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
rtc-add-initial-support-for-mcp7941x-parts.patch

