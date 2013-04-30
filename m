From: akpm@linux-foundation.org
Subject: [merged] drivers-block-mg_diskc-add-config_pm_sleep-to-suspend-resume-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:11 -0700
Message-ID: <20130430190311.7C6CA5A42DA@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34579 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3TDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:12 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so87613ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, axboe@kernel.dk, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/mg_disk.c: add CONFIG_PM_SLEEP to suspend/resume functions
has been removed from the -mm tree.  Its filename was
     drivers-block-mg_diskc-add-config_pm_sleep-to-suspend-resume-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/mg_disk.c: add CONFIG_PM_SLEEP to suspend/resume functions

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following build
warning when CONFIG_PM_SLEEP is not selected.  This is because sleep PM
callbacks defined by SIMPLE_DEV_PM_OPS are only used when the
CONFIG_PM_SLEEP is enabled.

drivers/block/mg_disk.c:783:12: warning: 'mg_suspend' defined but not used [-Wunused-function]
drivers/block/mg_disk.c:807:12: warning: 'mg_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/mg_disk.c~drivers-block-mg_diskc-add-config_pm_sleep-to-suspend-resume-functions drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~drivers-block-mg_diskc-add-config_pm_sleep-to-suspend-resume-functions
+++ a/drivers/block/mg_disk.c
@@ -780,6 +780,7 @@ static const struct block_device_operati
 	.getgeo = mg_getgeo
 };
 
+#ifdef CONFIG_PM_SLEEP
 static int mg_suspend(struct device *dev)
 {
 	struct mg_drv_data *prv_data = dev->platform_data;
@@ -824,6 +825,7 @@ static int mg_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(mg_pm, mg_suspend, mg_resume);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

