From: akpm@linux-foundation.org
Subject: + backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
Date: Tue, 07 May 2013 15:21:27 -0700
Message-ID: <20130507222127.C469C5A415D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:59128 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3EGWV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:21:28 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so119912qcz.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:21:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: pcf50633: remove unnecessary platform_set_drvdata()
has been added to the -mm tree.  Its filename is
     backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: pcf50633: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure, since commit 0998d063100 ("device-core: Ensure drvdata =
NULL when no driver is bound").  Thus, it is not needed to manually clear
the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pcf50633-backlight.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-pcf50633-remove-unnecessary-platform_set_drvdata drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-pcf50633-remove-unnecessary-platform_set_drvdata
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -153,8 +153,6 @@ static int pcf50633_bl_remove(struct pla
 
 	backlight_device_unregister(pcf_bl->bl);
 
-	platform_set_drvdata(pdev, NULL);
