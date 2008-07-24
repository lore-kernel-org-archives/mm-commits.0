From: akpm@linux-foundation.org
Subject: - firmware-convert-ambassador-atm-driver-to-request_firmware.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:38 -0700
Message-ID: <200807242333.m6ONXcs5011945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860AbYGXXds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chas@cmf.nrl.navy.mil, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     atm: convert Ambassador ATM driver to request_firmware()
has been removed from the -mm tree.  Its filename was
     firmware-convert-ambassador-atm-driver-to-request_firmware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atm: convert Ambassador ATM driver to request_firmware()
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>

Use MODULE_FIRMWARE() and other suggested cleanups

Signed-off-by: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/fore200e.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/atm/fore200e.c~firmware-convert-ambassador-atm-driver-to-request_firmware drivers/atm/fore200e.c
--- a/drivers/atm/fore200e.c~firmware-convert-ambassador-atm-driver-to-request_firmware
+++ a/drivers/atm/fore200e.c
@@ -2562,7 +2562,8 @@ fore200e_load_and_start_fw(struct fore20
     const struct firmware *firmware;
     struct device *device;
     struct fw_header *fw_header;
-    u32 *fw_data, fw_size;
+    const __le32 *fw_data;
+    u32 fw_size;
     u32 __iomem *load_addr;
     char buf[48];
     int err = -ENODEV;
@@ -2582,7 +2583,7 @@ fore200e_load_and_start_fw(struct fore20
 	return err;
     }
 
-    fw_data = (u32 *) firmware->data;
+    fw_data = (__le32 *) firmware->data;
     fw_size = firmware->size / sizeof(u32);
     fw_header = (struct fw_header *) firmware->data;
     load_addr = fore200e->virt_base + le32_to_cpu(fw_header->load_offset);
@@ -3199,6 +3200,14 @@ static const struct fore200e_bus fore200
     {}
 };
 
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL");
+#ifdef CONFIG_PCI
+#ifdef __LITTLE_ENDIAN__
+MODULE_FIRMWARE("pca200e.bin");
+#else
+MODULE_FIRMWARE("pca200e_ecd.bin2");
+#endif
+#endif /* CONFIG_PCI */
+#ifdef CONFIG_SBUS
+MODULE_FIRMWARE("sba200e_ecd.bin2");
 #endif
_

Patches currently in -mm which might be from chas@cmf.nrl.navy.mil are

origin.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch

