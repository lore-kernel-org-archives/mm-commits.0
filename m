From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:34 -0700
Message-ID: <20130430190134.787C031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62687 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3D3TBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:35 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87696vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@ingics.com, jonsmirl@gmail.com, roman.fietze@telemotive.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12022.c: Remove rtc8564 from isl12022_id
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-isl12022c-remove-rtc8564-from-isl12022_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

