From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-m41t93c-use-spi_get_drvdata-for-spi-devices.patch added to -mm tree
Date: Wed, 08 Jun 2011 13:02:11 -0700
Message-ID: <201106082002.p58K2Bhv025376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab1FHUCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 16:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, a.zummo@towertech.it, grant.likely@secretlab.ca, n.voss@weinmann.de


The patch titled
     drivers/rtc/rtc-m41t93.c: use spi_get_drvdata() for SPI devices
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-m41t93c-use-spi_get_drvdata-for-spi-devices.patch

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
Subject: drivers/rtc/rtc-m41t93.c: use spi_get_drvdata() for SPI devices
From: Geert Uytterhoeven <geert@linux-m68k.org>

One new offender detected by the recently increased type checking in
platform_get_drvdata():

drivers/rtc/rtc-m41t93.c: In function `m41t93_remove':
drivers/rtc/rtc-m41t93.c:192: warning: passing argument 1 of `platform_get_drvdata' from incompatible pointer type

Use spi_get_drvdata() instead of platform_get_drvdata(), cfr.  commit
42fea15d6dc4 ("spi/rtc-{ds1390,ds3234,m41t94}: Use spi_get_drvdata() for
SPI devices")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nikolaus Voss <n.voss@weinmann.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t93.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m41t93.c~drivers-rtc-rtc-m41t93c-use-spi_get_drvdata-for-spi-devices drivers/rtc/rtc-m41t93.c
--- a/drivers/rtc/rtc-m41t93.c~drivers-rtc-rtc-m41t93c-use-spi_get_drvdata-for-spi-devices
+++ a/drivers/rtc/rtc-m41t93.c
@@ -189,7 +189,7 @@ static int __devinit m41t93_probe(struct
 
 static int __devexit m41t93_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = spi_get_drvdata(spi);
 
 	if (rtc)
 		rtc_device_unregister(rtc);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

w1-w1_master_ds1wm-should-depend-on-generic_hardirqs.patch
drivers-rtc-rtc-m41t93c-use-spi_get_drvdata-for-spi-devices.patch
mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
staging-iio-make-iio-depend-on-generic_hardirqs.patch

