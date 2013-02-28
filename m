From: akpm@linux-foundation.org
Subject: [folded-merged] ib-ipath-convert-to-idr_alloc-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:45:11 -0800
Message-ID: <20130228004511.A81965A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:38249 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1ApN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:45:13 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so139108vea.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:45:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, mike.marciniszyn@intel.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/ipath: use GFP_NOWAIT under spin lock
has been removed from the -mm tree.  Its filename was
     ib-ipath-convert-to-idr_alloc-fix.patch

This patch was dropped because it was folded into ib-ipath-convert-to-idr_alloc.patch

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: IB/ipath: use GFP_NOWAIT under spin lock

A spin lock is taken here so we should use GFP_NOWAIT like other case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/ipath/ipath_driver.c~ib-ipath-convert-to-idr_alloc-fix drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c~ib-ipath-convert-to-idr_alloc-fix
+++ a/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -204,7 +204,7 @@ static struct ipath_devdata *ipath_alloc
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&ipath_devs_lock, flags);
 
-	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_KERNEL);
+	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_NOWAIT);
 	if (ret < 0) {
 		printk(KERN_ERR IPATH_DRV_NAME
 		       ": Could not allocate unit ID: error %d\n", -ret);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
ib-ipath-convert-to-idr_alloc.patch
memstick-move-the-dereference-below-the-null-test.patch

