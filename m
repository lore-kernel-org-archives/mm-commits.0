From: akpm@linux-foundation.org
Subject: + leds-tca6507-remove-obsolete-cleanup-for-clientdata.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:49:20 -0800
Message-ID: <20120224204920.95EBEA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:54748 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab2BXUtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:49:21 -0500
Received: by qadb12 with SMTP id b12so95726qad.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:49:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, neilb@suse.de, rpurdie@linux.intel.com


The patch titled
     Subject: drivers/leds/leds-tca6507.c: remove obsolete cleanup for clientdata
has been added to the -mm tree.  Its filename is
     leds-tca6507-remove-obsolete-cleanup-for-clientdata.patch

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
Subject: Subject: drivers/leds/leds-tca6507.c: remove obsolete cleanup for clientdata

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
leds-tca6507-remove-obsolete-cleanup-for-clientdata.patch
rtc-ds1307-refactor-chip_desc-table.patch
rtc-ds1307-simplify-irq-setup-code.patch
rtc-ds1307-comment-and-format-cleanup.patch
rtc-ds1307-generalise-ram-size-and-offset.patch

