From: akpm@linux-foundation.org
Subject: + rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch added to
 -mm tree
Date: Mon, 25 Nov 2013 14:30:53 -0800
Message-ID: <5293cf9d.coz15Ge+iAl2YTVN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3KYWax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Nov 2013 17:30:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 25 Nov 2013 14:30:53 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1305.c: remove unnecessary spi_set_drvdata()
has been added to the -mm tree.  Its filename is
     rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch

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
Subject: drivers/rtc/rtc-ds1305.c: remove unnecessary spi_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure.  Thus, it is not needed to manually clear the device driver
data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1305.c~rtc-ds1305-remove-unnecessary-spi_set_drvdata drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-ds1305-remove-unnecessary-spi_set_drvdata
+++ a/drivers/rtc/rtc-ds1305.c
@@ -787,7 +787,6 @@ static int ds1305_remove(struct spi_devi
 		cancel_work_sync(&ds1305->work);
 	}
 
-	spi_set_drvdata(spi, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
linux-next.patch

