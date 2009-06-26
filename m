From: akpm@linux-foundation.org
Subject: + lis3_spi-code-cleanups.patch added to -mm tree
Date: Fri, 26 Jun 2009 14:32:51 -0700
Message-ID: <200906262132.n5QLWp1N023634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbZFZVdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 17:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3_spi: code cleanups
has been added to the -mm tree.  Its filename is
     lis3_spi-code-cleanups.patch

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
Subject: lis3_spi: code cleanups
From: Daniel Mack <daniel@caiaq.de>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d_spi.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3_spi-code-cleanups drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3_spi-code-cleanups
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -66,17 +66,16 @@ static int __devinit lis302dl_spi_probe(
 	if (ret < 0)
 		return ret;
 
-	lis3_dev.bus_priv = spi;
-	lis3_dev.init = lis3_spi_init;
-	lis3_dev.read = lis3_spi_read;
-	lis3_dev.write = lis3_spi_write;
-	lis3_dev.irq = spi->irq;
-	lis3_dev.ac = lis3lv02d_axis_normal;
-	lis3_dev.pdata = spi->dev.platform_data;
+	lis3_dev.bus_priv	= spi;
+	lis3_dev.init		= lis3_spi_init;
+	lis3_dev.read		= lis3_spi_read;
+	lis3_dev.write		= lis3_spi_write;
+	lis3_dev.irq		= spi->irq;
+	lis3_dev.ac		= lis3lv02d_axis_normal;
+	lis3_dev.pdata		= spi->dev.platform_data;
 	spi_set_drvdata(spi, &lis3_dev);
 
-	ret = lis3lv02d_init_device(&lis3_dev);
-	return ret;
+	return lis3lv02d_init_device(&lis3_dev);
 }
 
 static int __devexit lis302dl_spi_remove(struct spi_device *spi)
_

Patches currently in -mm which might be from daniel@caiaq.de are

lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3_spi-code-cleanups.patch

