From: akpm@linux-foundation.org
Subject: + add-buswidth-to-ssb-mips-core-flash-driver.patch added to -mm tree
Date: Tue, 07 Aug 2007 17:32:20 -0700
Message-ID: <200708080032.l780WK4r012472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbXHHAdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 20:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, mb@bu3sch.de, nbd@openwrt.org


The patch titled
     Add buswidth to SSB MIPS core flash driver
has been added to the -mm tree.  Its filename is
     add-buswidth-to-ssb-mips-core-flash-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add buswidth to SSB MIPS core flash driver
From: Aurelien Jarno <aurelien@aurel32.net>

Fix the size of the flash window and detect the width of the flash bus (8 or
16 bits).

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_mipscore.c       |    8 ++++++--
 include/linux/ssb/ssb_driver_mips.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/ssb/driver_mipscore.c~add-buswidth-to-ssb-mips-core-flash-driver drivers/ssb/driver_mipscore.c
--- a/drivers/ssb/driver_mipscore.c~add-buswidth-to-ssb-mips-core-flash-driver
+++ a/drivers/ssb/driver_mipscore.c
@@ -133,12 +133,16 @@ static void ssb_mips_flash_detect(struct
 {
 	struct ssb_bus *bus = mcore->dev->bus;
 
+	mcore->flash_buswidth = 2;
 	if (bus->chipco.dev) {
 		mcore->flash_window = 0x1c000000;
-		mcore->flash_window_size = 0x800000;
+		mcore->flash_window_size = 0x02000000;
+		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
+		               & SSB_CHIPCO_CFG_DS16) == 0)
+			mcore->flash_buswidth = 1;
 	} else {
 		mcore->flash_window = 0x1fc00000;
-		mcore->flash_window_size = 0x400000;
+		mcore->flash_window_size = 0x00400000;
 	}
 }
 
diff -puN include/linux/ssb/ssb_driver_mips.h~add-buswidth-to-ssb-mips-core-flash-driver include/linux/ssb/ssb_driver_mips.h
--- a/include/linux/ssb/ssb_driver_mips.h~add-buswidth-to-ssb-mips-core-flash-driver
+++ a/include/linux/ssb/ssb_driver_mips.h
@@ -20,6 +20,7 @@ struct ssb_mipscore {
 	int nr_serial_ports;
 	struct ssb_serial_port serial_ports[4];
 
+	u8 flash_buswidth;
 	u32 flash_window;
 	u32 flash_window_size;
 };
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-wireless.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-chipcommon-add-function-to-get-processor-clock.patch
ssb-chipcommon-add-function-to-get-processor-clock-fix.patch
ssb-extif-timing-serial-port-initialization.patch
use-ssb-extif-in-ssb-mips-core-driver.patch
add-buswidth-to-ssb-mips-core-flash-driver.patch
