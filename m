From: akpm@linux-foundation.org
Subject: - mtd-esb2-check-for-closed-rom-window.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:29 -0800
Message-ID: <200703152158.l2FLwTDH027733@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXCOV6h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD: ESB2 check for closed ROM window
has been removed from the -mm tree.  Its filename was
     mtd-esb2-check-for-closed-rom-window.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MTD: ESB2 check for closed ROM window
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add checking for closed ROM window on Intel ESB2 Southbridge.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/esb2rom.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/maps/esb2rom.c~mtd-esb2-check-for-closed-rom-window drivers/mtd/maps/esb2rom.c
--- a/drivers/mtd/maps/esb2rom.c~mtd-esb2-check-for-closed-rom-window
+++ a/drivers/mtd/maps/esb2rom.c
@@ -30,7 +30,7 @@
 
 #define ROM_PROBE_STEP_SIZE (64*1024) /* 64KiB */
 
-#define BIOS_CNTL	0xDC
+#define BIOS_CNTL		0xDC
 #define BIOS_LOCK_ENABLE	0x02
 #define BIOS_WRITE_ENABLE	0x01
 
@@ -145,7 +145,7 @@ static void esb2rom_cleanup(struct esb2r
 }
 
 static int __devinit esb2rom_init_one(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+				      const struct pci_device_id *ent)
 {
 	static char *rom_probe_types[] = { "cfi_probe", "jedec_probe", NULL };
 	struct esb2rom_window *window = &esb2rom_window;
@@ -185,7 +185,7 @@ static int __devinit esb2rom_init_one(st
 	/* Find a region continuous to the end of the ROM window  */
 	window->phys = 0;
 	pci_read_config_word(pdev, FWH_DEC_EN1, &word);
-	printk(KERN_DEBUG "pci_read_config_byte : %x\n", word);
+	printk(KERN_DEBUG "pci_read_config_word : %x\n", word);
 
 	if ((word & FWH_8MiB) == FWH_8MiB)
 		window->phys = 0xff400000;
@@ -212,6 +212,11 @@ static int __devinit esb2rom_init_one(st
 	else if ((word & FWH_0_5MiB) == FWH_0_5MiB)
 		window->phys = 0xfff80000;
 
+	if (window->phys == 0) {
+		printk(KERN_ERR MOD_NAME ": Rom window is closed\n");
+		goto out;
+	}
+
 	/* reserved  0x0020 and 0x0010 */
 	window->phys -= 0x400000UL;
 	window->size = (0xffffffffUL - window->phys) + 1UL;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
