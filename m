From: akpm@linux-foundation.org
Subject: - mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:30 -0700
Message-ID: <200807301917.m6UJHUGo011215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbYG3T3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, cooloney@kernel.org, dwmw2@infradead.org, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix
has been removed from the -mm tree.  Its filename was
     mtd-dataflash-bugfix-binary-page-sizes-now-handled-v3-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
git-mtd.patch
mtd-dataflash-otp-support.patch
spi-new-orion_spi-driver.patch
spi-new-orion_spi-driver-fixes.patch
genirq-better-warning-on-irqchip-set_type-failure.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch

