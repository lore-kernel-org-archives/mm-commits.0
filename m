From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:30 -0700
Message-ID: <20130507175030.821F431C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:35870 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:31 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so86371vbg.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, greg@kroah.com, neilb@suse.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/slaves/w1_bq27000.c: fix the error handling in w1_bq27000_add_slave()
has been removed from the -mm tree.  Its filename was
     drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/w1/slaves/w1_bq27000.c: fix the error handling in w1_bq27000_add_slave()

Use platform_device_put() instead of platform_device_unregister() if
platform_device_add() fails, and also add the return value check of
platform_device_add_data().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_bq27000.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_bq27000.c~drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave drivers/w1/slaves/w1_bq27000.c
--- a/drivers/w1/slaves/w1_bq27000.c~drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave
+++ a/drivers/w1/slaves/w1_bq27000.c
@@ -57,6 +57,8 @@ static int w1_bq27000_add_slave(struct w
 	ret = platform_device_add_data(pdev,
 				       &bq27000_battery_info,
 				       sizeof(bq27000_battery_info));
+	if (ret)
+		goto pdev_add_failed;
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);
@@ -68,7 +70,7 @@ static int w1_bq27000_add_slave(struct w
 	goto success;
 
 pdev_add_failed:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 success:
 	return ret;
 }
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

