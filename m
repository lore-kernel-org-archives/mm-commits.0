From: akpm@linux-foundation.org
Subject: + mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix.patch added to -mm tree
Date: Tue, 29 Jul 2008 22:22:42 -0700
Message-ID: <200807300522.m6U5MgBi008950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730AbYG3FXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 01:23:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, cooloney@kernel.org, dwmw2@infradead.org, michael.hennerich@analog.com


The patch titled
     mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix
has been added to the -mm tree.  Its filename is
     mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix
From: David Brownell <dbrownell@users.sourceforge.net>

Cc: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/mtd_dataflash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/devices/mtd_dataflash.c~mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -609,7 +609,7 @@ static struct flash_info *__devinit jede
 			tmp++, info++) {
 		if (info->jedec_id == jedec) {
 			DEBUG(MTD_DEBUG_LEVEL1, "%s: OTP, sector protect%s\n",
-				dev_name(spi->dev),
+				dev_name(&spi->dev),
 				(info->flags & SUP_POW2PS)
 					? ", binary pagesize" : ""
 				);
@@ -618,7 +618,7 @@ static struct flash_info *__devinit jede
 				if (status < 0) {
 					DEBUG(MTD_DEBUG_LEVEL1,
 						"%s: status error %d\n",
-						dev_name(spi->dev), status);
+						dev_name(&spi->dev), status);
 					return ERR_PTR(status);
 				}
 				if (status & 0x1) {
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-dont-return-ebusy-when-mutex_lock_interruptible-fails.patch
rtc-dev-stop-periodic-interrupts-on-device-release.patch
linux-next.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3.patch
mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

