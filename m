From: akpm@linux-foundation.org
Subject: [merged] leds-tca6507-remove-obsolete-cleanup-for-clientdata.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:28 -0700
Message-ID: <20120326192928.5C38BA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40916 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:30 -0400
Received: by lbbgj3 with SMTP id gj3so288108lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, neilb@suse.de, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-tca6507.c: remove obsolete cleanup for clientdata
has been removed from the -mm tree.  Its filename was
     leds-tca6507-remove-obsolete-cleanup-for-clientdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: drivers/leds/leds-tca6507.c: remove obsolete cleanup for clientdata

A few new i2c-drivers came into the kernel which clear the
clientdata-pointer on exit or error.  This is obsolete meanwhile, the core
will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: NeilBrown <neilb@suse.de>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/leds/leds-tca6507.c~leds-tca6507-remove-obsolete-cleanup-for-clientdata drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-tca6507-remove-obsolete-cleanup-for-clientdata
+++ a/drivers/leds/leds-tca6507.c
@@ -743,7 +743,6 @@ static int __devexit tca6507_remove(stru
 	}
 	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
-	i2c_set_clientdata(client, NULL);
 	kfree(tca);
 
 	return 0;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch

