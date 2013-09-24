From: akpm@linux-foundation.org
Subject: +
 drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch added to -mm tree
Date: Tue, 24 Sep 2013 16:45:36 -0700
Message-ID: <52422420.0a8UyRvAk94F9KFy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3IXXph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, yongjun_wei@trendmicro.com.cn

Subject: + drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn,keescook@chromium.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:45:36 -0700


The patch titled
     Subject: drivers/message/i2o/driver.c: add missing destroy_workqueue() on error in i2o_driver_register()
has been added to the -mm tree.  Its filename is
     drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/message/i2o/driver.c: add missing destroy_workqueue() on error in i2o_driver_register()

Add the missing destroy_workqueue() before return from
i2o_driver_register() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/driver.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/message/i2o/driver.c~drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register drivers/message/i2o/driver.c
--- a/drivers/message/i2o/driver.c~drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register
+++ a/drivers/message/i2o/driver.c
@@ -105,7 +105,8 @@ int i2o_driver_register(struct i2o_drive
 			osm_err("too many drivers registered, increase "
 				"max_drivers\n");
 			spin_unlock_irqrestore(&i2o_drivers_lock, flags);
-			return -EFAULT;
+			rc = -EFAULT;
+			goto out;
 		}
 
 	drv->context = i;
@@ -124,11 +125,14 @@ int i2o_driver_register(struct i2o_drive
 	}
 
 	rc = driver_register(&drv->driver);
-	if (rc) {
-		if (drv->event) {
-			destroy_workqueue(drv->event_queue);
-			drv->event_queue = NULL;
-		}
+	if (rc)
+		goto out;
+
+	return 0;
+out:
+	if (drv->event_queue) {
+		destroy_workqueue(drv->event_queue);
+		drv->event_queue = NULL;
 	}
 
 	return rc;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

drivers-message-i2o-driverc-add-missing-destroy_workqueue-on-error-in-i2o_driver_register.patch
linux-next.patch

