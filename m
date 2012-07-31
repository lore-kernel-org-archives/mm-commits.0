From: akpm@linux-foundation.org
Subject: [merged] pps-return-ptr_err-on-error-in-device_create.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:25 -0700
Message-ID: <20120731185425.C4BDC100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47711 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2GaSy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:29 -0400
Received: by qabg24 with SMTP id g24so389214qab.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emilgoode@gmail.com, devendra.aaru@gmail.com, giometti@enneenne.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: return PTR_ERR on error in device_create
has been removed from the -mm tree.  Its filename was
     pps-return-ptr_err-on-error-in-device_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Emil Goode <emilgoode@gmail.com>
Subject: pps: return PTR_ERR on error in device_create

We should return PTR_ERR if the call to the device_create function fails. 
Without this patch we instead return the value from a successful call to
cdev_add if the call to device_create fails.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Acked-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pps/pps.c~pps-return-ptr_err-on-error-in-device_create drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-return-ptr_err-on-error-in-device_create
+++ a/drivers/pps/pps.c
@@ -327,8 +327,10 @@ int pps_register_cdev(struct pps_device 
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, devt, pps,
 							"pps%d", pps->id);
-	if (IS_ERR(pps->dev))
+	if (IS_ERR(pps->dev)) {
+		err = PTR_ERR(pps->dev);
 		goto del_cdev;
+	}
 
 	pps->dev->release = pps_device_destruct;
 
_

Patches currently in -mm which might be from emilgoode@gmail.com are

origin.patch
linux-next.patch

