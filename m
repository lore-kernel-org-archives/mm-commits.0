From: akpm@linux-foundation.org
Subject: +
 drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
Date: Thu, 22 Aug 2013 14:20:34 -0700
Message-ID: <521680a2.kHjPxbTYSVth8ztM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3HVVUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 17:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, giometti@enneenne.com, jg1.han@samsung.com

Subject: + drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
To: jg1.han@samsung.com,giometti@enneenne.com
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 14:20:34 -0700


The patch titled
     Subject: drivers/pps/clients/pps-gpio.c: remove unnecessary platform_set_drvdata()
has been added to the -mm tree.  Its filename is
     drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch

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
Subject: drivers/pps/clients/pps-gpio.c: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata
+++ a/drivers/pps/clients/pps-gpio.c
@@ -184,7 +184,6 @@ static int pps_gpio_remove(struct platfo
 {
 	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	pps_unregister_source(data->pps);
 	dev_info(&pdev->dev, "removed IRQ %d as PPS source\n", data->irq);
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-iommu-remove-unnecessary-platform_set_drvdata.patch
block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
drivers-block-mg_diskc-make-mg_times_out-static.patch
drivers-block-swimc-remove-unnecessary-platform_set_drvdata.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
rtc-rtc-nuc900-use-null-instead-of-0.patch
drivers-pps-clients-pps-gpioc-remove-unnecessary-platform_set_drvdata.patch
drivers-memstick-host-rtsx_pci_msc-remove-unnecessary-platform_set_drvdata.patch
w1-replace-strict_strtol-with-kstrtol.patch
linux-next.patch
kernel-replace-strict_strto-with-kstrto.patch

