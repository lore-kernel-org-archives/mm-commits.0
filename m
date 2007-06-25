From: akpm@linux-foundation.org
Subject: - sm501-check-sm501-id-register-on-initialisation.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:46 -0700
Message-ID: <200706250920.l5P9Kk8g031046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbXFYJV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     SM501: Check SM501 ID register on initialisation
has been removed from the -mm tree.  Its filename was
     sm501-check-sm501-id-register-on-initialisation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SM501: Check SM501 ID register on initialisation
From: Ben Dooks <ben-linux@fluff.org>

When binding the driver, check the ID register for a valid identity, in case
the SM501 is not functioning correctly.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c        |   14 ++++++++++----
 include/linux/sm501-regs.h |    3 +++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-check-sm501-id-register-on-initialisation drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-check-sm501-id-register-on-initialisation
+++ a/drivers/mfd/sm501.c
@@ -893,6 +893,7 @@ static int sm501_init_dev(struct sm501_d
 {
 	resource_size_t mem_avail;
 	unsigned long dramctrl;
+	unsigned long devid;
 	int ret;
 
 	mutex_init(&sm->clock_lock);
@@ -900,13 +901,18 @@ static int sm501_init_dev(struct sm501_d
 
 	INIT_LIST_HEAD(&sm->devices);
 
-	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
+	devid = readl(sm->regs + SM501_DEVICEID);
 
+	if ((devid & SM501_DEVICEID_IDMASK) != SM501_DEVICEID_SM501) {
+		dev_err(sm->dev, "incorrect device id %08lx\n", devid);
+		return -EINVAL;
+	}
+
+	dramctrl = readl(sm->regs + SM501_DRAM_CONTROL);
 	mem_avail = sm501_mem_local[(dramctrl >> 13) & 0x7];
 
-	dev_info(sm->dev, "SM501 At %p: Version %08x, %ld Mb, IRQ %d\n",
-		 sm->regs, readl(sm->regs + SM501_DEVICEID),
-		 (unsigned long)mem_avail >> 20, sm->irq);
+	dev_info(sm->dev, "SM501 At %p: Version %08lx, %ld Mb, IRQ %d\n",
+		 sm->regs, devid, (unsigned long)mem_avail >> 20, sm->irq);
 
 	sm501_dump_gate(sm);
 
diff -puN include/linux/sm501-regs.h~sm501-check-sm501-id-register-on-initialisation include/linux/sm501-regs.h
--- a/include/linux/sm501-regs.h~sm501-check-sm501-id-register-on-initialisation
+++ a/include/linux/sm501-regs.h
@@ -109,6 +109,9 @@
 #define SM501_DEVICEID			(0x000060)
 /* 0x050100A0 */
 
+#define SM501_DEVICEID_SM501		(0x05010000)
+#define SM501_DEVICEID_IDMASK		(0xffff0000)
+
 #define SM501_PLLCLOCK_COUNT		(0x000064)
 #define SM501_MISC_TIMING		(0x000068)
 #define SM501_CURRENT_SDRAM_CLOCK	(0x00006C)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-watchdog.patch
spi-tle620x-power-switch-driver.patch
