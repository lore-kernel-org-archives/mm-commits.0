From: akpm@linux-foundation.org
Subject: + drivers-misc-isl29020c-remove-incorrect-kfree-in-isl29020_remove.patch added to -mm tree
Date: Fri, 19 Nov 2010 12:58:04 -0800
Message-ID: <201011192058.oAJKw4EA001790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755696Ab0KSU6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Nov 2010 15:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alan@linux.intel.com


The patch titled
     drivers/misc/isl29020.c: remove incorrect kfree in isl29020_remove()
has been added to the -mm tree.  Its filename is
     drivers-misc-isl29020c-remove-incorrect-kfree-in-isl29020_remove.patch

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
Subject: drivers/misc/isl29020.c: remove incorrect kfree in isl29020_remove()
From: Axel Lin <axel.lin@gmail.com>

struct als_data *data is not used in this driver at all.

Also add a missing ">" character for MODULE_AUTHOR.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29020.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/misc/isl29020.c~drivers-misc-isl29020c-remove-incorrect-kfree-in-isl29020_remove drivers/misc/isl29020.c
--- a/drivers/misc/isl29020.c~drivers-misc-isl29020c-remove-incorrect-kfree-in-isl29020_remove
+++ a/drivers/misc/isl29020.c
@@ -183,9 +183,7 @@ static int  isl29020_probe(struct i2c_cl
 
 static int isl29020_remove(struct i2c_client *client)
 {
-	struct als_data *data = i2c_get_clientdata(client);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
-	kfree(data);
 	return 0;
 }
 
@@ -245,6 +243,6 @@ static void  __exit sensor_isl29020_exit
 module_init(sensor_isl29020_init);
 module_exit(sensor_isl29020_exit);
 
-MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
+MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com>");
 MODULE_DESCRIPTION("Intersil isl29020 ALS Driver");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-misc-isl29020c-remove-incorrect-kfree-in-isl29020_remove.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

