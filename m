From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:36 -0700
Message-ID: <20130507175038.81D0631C4FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41434 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:39 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so86417qcz.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, greg@kroah.com, neilb@suse.de, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/slaves/w1_ds2781.c: fix the error handling in w1_ds2781_add_slave()
has been removed from the -mm tree.  Its filename was
     drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/w1/slaves/w1_ds2781.c: fix the error handling in w1_ds2781_add_slave()

Use platform_device_put() instead of platform_device_unregister() if
platform_device_add() fail, and platform_device_del() should be used in
the error handling case after platform_device_add() success.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2781.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_ds2781.c~drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave drivers/w1/slaves/w1_ds2781.c
--- a/drivers/w1/slaves/w1_ds2781.c~drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave
+++ a/drivers/w1/slaves/w1_ds2781.c
@@ -139,8 +139,9 @@ static int w1_ds2781_add_slave(struct w1
 	return 0;
 
 bin_attr_failed:
+	platform_device_del(pdev);
 pdev_add_failed:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 pdev_alloc_failed:
 	ida_simple_remove(&bat_ida, id);
 noid:
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

