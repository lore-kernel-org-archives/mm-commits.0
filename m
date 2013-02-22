From: akpm@linux-foundation.org
Subject: + ib-ipath-convert-to-idr_alloc-fix.patch added to -mm tree
Date: Fri, 22 Feb 2013 14:17:05 -0800
Message-ID: <20130222221705.C79C05A420F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62133 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab3BVWRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 17:17:07 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so113398ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 14:17:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, mike.marciniszyn@intel.com, tj@kernel.org


The patch titled
     Subject: IB/ipath: use GFP_NOWAIT under spin lock
has been added to the -mm tree.  Its filename is
     ib-ipath-convert-to-idr_alloc-fix.patch

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
linux-next.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch
ib-ipath-convert-to-idr_alloc-fix.patch
memstick-move-the-dereference-below-the-null-test.patch

