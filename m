From: akpm@linux-foundation.org
Subject: + lis3-add-power-management-functions.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:32:49 -0700
Message-ID: <200906262132.n5QLWnv6023526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbZFZVc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:32:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: add power management functions
has been added to the -mm tree.  Its filename is
     lis3-add-power-management-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: add power management functions
From: Daniel Mack <daniel@caiaq.de>

This enabled power management functions for the SPI transport layer of the
lis3 devices.  The device's suspend mode is only entered in case no wakeup
threshold has been given.  In this case, the device is supposed to wake up
the system and must thus not be put to deep sleep.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d_spi.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3-add-power-management-functions drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3-add-power-management-functions
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -87,6 +87,32 @@ static int __devexit lis302dl_spi_remove
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int lis3lv02d_spi_suspend(struct spi_device *spi, pm_message_t mesg)
+{
+	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweroff(&lis3_dev);
+
+	return 0;
+}
+
+static int lis3lv02d_spi_resume(struct spi_device *spi)
+{
+	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweron(lis3);
+
+	return 0;
+}
+
+#else
+#define lis3_spi_suspend	NULL
+#define lis3_spi_resume		NULL
+#endif
+
 static struct spi_driver lis302dl_spi_driver = {
 	.driver	 = {
 		.name   = DRV_NAME,
@@ -94,6 +120,8 @@ static struct spi_driver lis302dl_spi_dr
 	},
 	.probe	= lis302dl_spi_probe,
 	.remove	= __devexit_p(lis302dl_spi_remove),
+	.suspend = lis3lv02d_spi_suspend,
+	.resume  = lis3lv02d_spi_resume,
 };
 
 static int __init lis302dl_init(void)
_

Patches currently in -mm which might be from daniel@caiaq.de are

lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3_spi-code-cleanups.patch

