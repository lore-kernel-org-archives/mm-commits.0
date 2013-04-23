From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id.patch added to -mm tree
Date: Tue, 23 Apr 2013 15:22:54 -0700
Message-ID: <20130423222254.CE26631C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:41667 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3DWWWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 18:22:55 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so127322yen.4
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 15:22:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@ingics.com, jonsmirl@gmail.com, roman.fietze@telemotive.de


The patch titled
     Subject: drivers/rtc/rtc-isl12022.c: Remove rtc8564 from isl12022_id
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@ingics.com>
Subject: drivers/rtc/rtc-isl12022.c: Remove rtc8564 from isl12022_id

rtc8564 appears in i2c_device_id table of both rtc-isl12022.c and
rtc-pcf8563.c.  commit 8ea9212c "rtc-pcf8563: add chip id" adds rtc8564
chip entry to pcf8563.  isl12022 driver is modified from pcf8563 driver,
so this looks like a copy-paste bug.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Roman Fietze <roman.fietze@telemotive.de>
Cc: Jon Smirl <jonsmirl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12022.c~drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id
+++ a/drivers/rtc/rtc-isl12022.c
@@ -280,7 +280,6 @@ static int isl12022_remove(struct i2c_cl
 
 static const struct i2c_device_id isl12022_id[] = {
 	{ "isl12022", 0 },
-	{ "rtc8564", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, isl12022_id);
_

Patches currently in -mm which might be from axel.lin@ingics.com are

linux-next.patch
drivers-rtc-rtc-max6902c-use-register-defines-instead-of-magic-numbers.patch
drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id.patch

