From: akpm@linux-foundation.org
Subject: + pps-return-ptr_err-on-error-in-device_create.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:32:41 -0700
Message-ID: <20120716213242.81DF45C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50735 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2GPVcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:32:45 -0400
Received: by bkcjc3 with SMTP id jc3so328777bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:32:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: emilgoode@gmail.com, devendra.aaru@gmail.com, giometti@enneenne.com, lasaine@lvk.cs.msu.su


The patch titled
     Subject: pps: return PTR_ERR on error in device_create
has been added to the -mm tree.  Its filename is
     pps-return-ptr_err-on-error-in-device_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Emil Goode <emilgoode@gmail.com>
Subject: pps: return PTR_ERR on error in device_create

We should return PTR_ERR if the call to the device_create function fails. 
Without this patch we instead return the value from a successful call to
cdev_add if the call to device_create fails.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Acked-By: Devendra Naga <devendra.aaru@gmail.com>
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
Subject: Subject: pps: return PTR_ERR on error in device_create

Patches currently in -mm which might be from emilgoode@gmail.com are

linux-next.patch
pps-return-ptr_err-on-error-in-device_create.patch

