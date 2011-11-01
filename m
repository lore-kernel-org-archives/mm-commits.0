From: akpm@linux-foundation.org
Subject: [merged] video-backlight-remove-obsolete-cleanup-for-clientdata.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:46 -0700
Message-ID: <201111012114.pA1LEkUm008368@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1KAVPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, khali@linux-fr.org, lethal@linux-sh.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: video/backlight: remove obsolete cleanup for clientdata
has been removed from the -mm tree.  Its filename was
     video-backlight-remove-obsolete-cleanup-for-clientdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: video/backlight: remove obsolete cleanup for clientdata

A few new i2c-drivers came into the kernel which clear the
clientdata-pointer on exit or error.  This is obsolete meanwhile, the core
will do it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Jean Delvare <khali@linux-fr.org>
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

origin.patch
linux-next.patch
rtc-add-initial-support-for-mcp7941x-parts.patch

