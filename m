From: akpm@linux-foundation.org
Subject: + i2o-destroy-event-queue-only-when-drv-event-is-set.patch added to -mm tree
Date: Sun, 20 May 2007 21:13:34 -0700
Message-ID: <200705210413.l4L4DXBW002089@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbXEUEPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, Markus.Lidel@shadowconnect.com


The patch titled
     i2o: destroy event queue only when drv->event is set
has been added to the -mm tree.  Its filename is
     i2o-destroy-event-queue-only-when-drv-event-is-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o: destroy event queue only when drv->event is set
From: Akinobu Mita <akinobu.mita@gmail.com>

i2o_driver_register() initalizes event queue for driver only when
drv->event is set.  So similarly the event queue should be destroyed only
when drv->event is set in the error path.  Otherwise destroy_workqueue()
will called with NULL.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/driver.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/message/i2o/driver.c~i2o-destroy-event-queue-only-when-drv-event-is-set drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~i2o-destroy-event-queue-only-when-drv-event-is-set
+++ a/drivers/message/i2o/driver.c
@@ -123,8 +123,12 @@ int i2o_driver_register(struct i2o_drive
 	}
 
 	rc = driver_register(&drv->driver);
-	if (rc)
-		destroy_workqueue(drv->event_queue);
+	if (rc) {
+		if (drv->event) {
+			destroy_workqueue(drv->event_queue);
+			drv->event_queue = NULL;
+		}
+	}
 
 	return rc;
 };
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

auth_gss-unregister-gss_domain-when-unloading-module.patch
i2o-destroy-event-queue-only-when-drv-event-is-set.patch
add-kstrndup.patch
