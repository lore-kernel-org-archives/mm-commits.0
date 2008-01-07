From: akpm@linux-foundation.org
Subject: + ds1wm-decouple-host-irq-and-intr-active-state-settings.patch added to -mm tree
Date: Mon, 07 Jan 2008 15:10:28 -0800
Message-ID: <200801072310.m07NASWN016902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbYAGX0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 18:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, johnpol@2ka.mipt.ru, mreimer@vpop.net


The patch titled
     DS1WM: decouple host IRQ and INTR active state settings
has been added to the -mm tree.  Its filename is
     ds1wm-decouple-host-irq-and-intr-active-state-settings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DS1WM: decouple host IRQ and INTR active state settings
From: Philipp Zabel <philipp.zabel@gmail.com>

The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
high) from IRQ settings.  There are devices that have IAS=0 but still need
the IRQ to trigger on a rising edge.  With this patch, machines with DS1WM
that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Acked-by: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    9 +++++----
 include/linux/ds1wm.h      |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~ds1wm-decouple-host-irq-and-intr-active-state-settings drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~ds1wm-decouple-host-irq-and-intr-active-state-settings
+++ a/drivers/w1/masters/ds1wm.c
@@ -361,11 +361,12 @@ static int ds1wm_probe(struct platform_d
 		goto err1;
 	}
 	ds1wm_data->irq = res->start;
-	ds1wm_data->active_high = (res->flags & IORESOURCE_IRQ_HIGHEDGE) ?
-		1 : 0;
+	ds1wm_data->active_high = plat->active_high;
 
-	set_irq_type(ds1wm_data->irq, ds1wm_data->active_high ?
-			IRQ_TYPE_EDGE_RISING : IRQ_TYPE_EDGE_FALLING);
+	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
+		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
+	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
+		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
 	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
 			  "ds1wm", ds1wm_data);
diff -puN include/linux/ds1wm.h~ds1wm-decouple-host-irq-and-intr-active-state-settings include/linux/ds1wm.h
--- a/include/linux/ds1wm.h~ds1wm-decouple-host-irq-and-intr-active-state-settings
+++ a/include/linux/ds1wm.h
@@ -6,6 +6,7 @@ struct ds1wm_platform_data {
 			     * e.g. on h5xxx and h2200 this is 2
 			     * (registers aligned to 4-byte boundaries),
 			     * while on hx4700 this is 1 */
+	int active_high;
 	void (*enable)(struct platform_device *pdev);
 	void (*disable)(struct platform_device *pdev);
 };
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

git-arm.patch
ds1wm-decouple-host-irq-and-intr-active-state-settings.patch
arm-pxa-gpiolib-support.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
