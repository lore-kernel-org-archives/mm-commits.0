From: akpm@linux-foundation.org
Subject: + video-backlight-remove-obsolete-cleanup-for-clientdata.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:07:03 -0700
Message-ID: <201108260007.p7Q073ha021594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073Ab1HZAH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, lethal@linux-sh.org, rpurdie@rpsys.net


The patch titled
     video/backlight: remove obsolete cleanup for clientdata
has been added to the -mm tree.  Its filename is
     video-backlight-remove-obsolete-cleanup-for-clientdata.patch

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
Subject: video/backlight: remove obsolete cleanup for clientdata
From: Wolfram Sang <w.sang@pengutronix.de>

A few new i2c-drivers came into the kernel which clear the
clientdata-pointer on exit or error.  This is obsolete meanwhile, the core
will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~video-backlight-remove-obsolete-cleanup-for-clientdata drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~video-backlight-remove-obsolete-cleanup-for-clientdata
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -931,7 +931,6 @@ out:
 out1:
 	backlight_device_unregister(bl);
 out2:
-	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return ret;
@@ -951,7 +950,6 @@ static int __devexit adp8870_remove(stru
 			&adp8870_bl_attr_group);
 
 	backlight_device_unregister(data->bl);
-	i2c_set_clientdata(client, NULL);
 	kfree(data);
 
 	return 0;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
video-backlight-remove-obsolete-cleanup-for-clientdata.patch

