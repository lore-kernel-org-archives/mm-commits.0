From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch removed from
 -mm tree
Date: Tue, 28 May 2013 12:37:07 -0700
Message-ID: <51a50763.sCjzmqth46SyigqA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3E1ThI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org, lars@metafoo.de

Subject: [merged] drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch removed from -mm tree
To: lars@metafoo.de,linus.walleij@linaro.org,srinidhi.kasagar@stericsson.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:37:07 -0700


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: pass correct pointer to free_irq()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pl031c-pass-correct-pointer-to-free_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
rtc-rtc-ab3100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

