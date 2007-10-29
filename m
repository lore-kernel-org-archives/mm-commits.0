From: akpm@linux-foundation.org
Subject: + tle62x0-driver-stops-ignoring-read-errors.patch added to -mm tree
Date: Mon, 29 Oct 2007 00:51:38 -0700
Message-ID: <200710290751.l9T7pc7G026206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbXJ2HwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 03:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     tle62x0 driver stops ignoring read errors
has been added to the -mm tree.  Its filename is
     tle62x0-driver-stops-ignoring-read-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tle62x0 driver stops ignoring read errors
From: David Brownell <david-b@pacbell.net>

The tle62x0 driver was ignoring all read errors.  This patch makes it
pass such errors up the stack, instead of returning bogus data.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/tle62x0.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/spi/tle62x0.c~tle62x0-driver-stops-ignoring-read-errors drivers/spi/tle62x0.c
--- a/drivers/spi/tle62x0.c~tle62x0-driver-stops-ignoring-read-errors
+++ a/drivers/spi/tle62x0.c
@@ -107,8 +107,11 @@ static ssize_t tle62x0_status_show(struc
 
 	mutex_lock(&st->lock);
 	ret = tle62x0_read(st);
-
 	dev_dbg(dev, "tle62x0_read() returned %d\n", ret);
+	if (ret < 0) {
+		mutex_unlock(&st->lock);
+		return ret;
+	}
 
 	for (ptr = 0; ptr < (st->nr_gpio * 2)/8; ptr += 1) {
 		fault <<= 8;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
add-generic-gpio-support-to-x86.patch
pci-add-pci-identifiers-for-the-rdc-devices.patch
x86-add-support-for-the-rdc-r-321x-soc.patch
add-the-rdc-machine-specific-reboot-fixup.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
tle62x0-driver-stops-ignoring-read-errors.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
