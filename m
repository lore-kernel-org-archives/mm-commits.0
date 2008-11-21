From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-make-applesmc-load-automatically-on-startup.patch added to -mm tree
Date: Fri, 21 Nov 2008 14:40:12 -0800
Message-ID: <200811212240.mALMeCFe031372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbYKUWki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@bitmath.org, nicolas@boichat.ch, rydberg@euromail.se


The patch titled
     hwmon: applesmc: make applesmc load automatically on startup
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-make-applesmc-load-automatically-on-startup.patch

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
Subject: hwmon: applesmc: make applesmc load automatically on startup
From: Henrik Rydberg <rydberg@bitmath.org>

make use of the new dmi device loading support to automatically load the
applesmc driver based on the dmi_match table.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-make-applesmc-load-automatically-on-startup drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-make-applesmc-load-automatically-on-startup
+++ a/drivers/hwmon/applesmc.c
@@ -1564,3 +1564,4 @@ module_exit(applesmc_exit);
 MODULE_AUTHOR("Nicolas Boichat");
 MODULE_DESCRIPTION("Apple SMC");
 MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
_

Patches currently in -mm which might be from rydberg@bitmath.org are

hwmon-applesmc-make-applesmc-load-automatically-on-startup.patch

