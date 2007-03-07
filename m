From: akpm@linux-foundation.org
Subject: + blackfin-blackfin-i2c-driver-update.patch added to -mm tree
Date: Tue, 06 Mar 2007 23:10:11 -0800
Message-ID: <200703070710.l277ABxG022320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXCGHKR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 02:10:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com


The patch titled
     Blackfin: blackfin i2c driver (update)
has been added to the -mm tree.  Its filename is
     blackfin-blackfin-i2c-driver-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin: blackfin i2c driver (update)
From: "Wu, Bryan" <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-bfin-twi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/i2c/busses/i2c-bfin-twi.c~blackfin-blackfin-i2c-driver-update drivers/i2c/busses/i2c-bfin-twi.c
--- a/drivers/i2c/busses/i2c-bfin-twi.c~blackfin-blackfin-i2c-driver-update
+++ a/drivers/i2c/busses/i2c-bfin-twi.c
@@ -223,7 +223,7 @@ static int bfin_twi_master_xfer(struct i
 
 	while (bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
 		mutex_unlock(&iface->twi_lock);
-		yield();
+		cond_resched();
 		mutex_lock(&iface->twi_lock);
 	}
 
@@ -325,7 +325,7 @@ int bfin_twi_smbus_xfer(struct i2c_adapt
 
 	while(bfin_read_TWI_MASTER_STAT() & BUSBUSY) {
 		mutex_unlock(&iface->twi_lock);
-		yield();
+		cond_resched();
 		mutex_lock(&iface->twi_lock);
 	}
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver.patch
blackfin-blackfin-i2c-driver-update.patch
blackfin-blackfin-i2c-driver-fix.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
