From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch
 added to -mm tree
Date: Mon, 20 May 2013 15:41:07 -0700
Message-ID: <519aa683.MVA5GmrnLp7rdKqz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab3ETWlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 18:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org, lars@metafoo.de

Subject: + drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch added to -mm tree
To: lars@metafoo.de,linus.walleij@linaro.org,srinidhi.kasagar@stericsson.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 15:41:07 -0700


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: pass correct pointer to free_irq()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: drivers/rtc/rtc-pl031.c: pass correct pointer to free_irq()

free_irq() expects the same pointer that was passed to request_irq(), otherwise
the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq
+++ a/drivers/rtc/rtc-pl031.c
@@ -306,7 +306,7 @@ static int pl031_remove(struct amba_devi
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);
 
 	amba_set_drvdata(adev, NULL);
-	free_irq(adev->irq[0], ldata->rtc);
+	free_irq(adev->irq[0], ldata);
 	rtc_device_unregister(ldata->rtc);
 	iounmap(ldata->base);
 	kfree(ldata);
_

Patches currently in -mm which might be from lars@metafoo.de are

linux-next.patch
drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch
rtc-rtc-ab3100-remove-unnecessary-platform_set_drvdata.patch

