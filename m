From: akpm@osdl.org
Subject: - atm-ambassador-use-bitrev8.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:15 -0800
Message-ID: <200612082001.kB8K1FYO001824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426200AbWLHUBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gprocida@madge.com, linux-atm-general@lists.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     atm/ambassador: use bitrev8
has been removed from the -mm tree.  Its filename was
     atm-ambassador-use-bitrev8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atm/ambassador: use bitrev8
From: Akinobu Mita <akinobu.mita@gmail.com>

Use bitrev8 for ambassador driver.

Cc: Chas Williams <linux-atm-general@lists.sourceforge.net>
Cc: Giuliano Procida at Madge Networks <gprocida@madge.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/atm/Kconfig      |    1 +
 drivers/atm/ambassador.c |   17 +++--------------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff -puN drivers/atm/Kconfig~atm-ambassador-use-bitrev8 drivers/atm/Kconfig
--- a/drivers/atm/Kconfig~atm-ambassador-use-bitrev8
+++ a/drivers/atm/Kconfig
@@ -242,6 +242,7 @@ config ATM_IDT77252_USE_SUNI
 config ATM_AMBASSADOR
 	tristate "Madge Ambassador (Collage PCI 155 Server)"
 	depends on PCI && ATM
+	select BITREVERSE
 	help
 	  This is a driver for ATMizer based ATM card produced by Madge
 	  Networks Ltd. Say Y (or M to compile as a module named ambassador)
diff -puN drivers/atm/ambassador.c~atm-ambassador-use-bitrev8 drivers/atm/ambassador.c
--- a/drivers/atm/ambassador.c~atm-ambassador-use-bitrev8
+++ a/drivers/atm/ambassador.c
@@ -32,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/poison.h>
+#include <linux/bitrev.h>
 
 #include <asm/atomic.h>
 #include <asm/io.h>
@@ -2068,18 +2069,6 @@ static void __devinit amb_ucode_version 
   PRINTK (KERN_INFO, "microcode version is %u.%u", major, minor);
 }
   
-// swap bits within byte to get Ethernet ordering
-static u8 bit_swap (u8 byte)
-{
-    const u8 swap[] = {
-      0x0, 0x8, 0x4, 0xc,
-      0x2, 0xa, 0x6, 0xe,
-      0x1, 0x9, 0x5, 0xd,
-      0x3, 0xb, 0x7, 0xf
-    };
-    return ((swap[byte & 0xf]<<4) | swap[byte>>4]);
-}
-
 // get end station address
 static void __devinit amb_esi (amb_dev * dev, u8 * esi) {
   u32 lower4;
@@ -2101,9 +2090,9 @@ static void __devinit amb_esi (amb_dev *
     PRINTDB (DBG_INIT, "ESI:");
     for (i = 0; i < ESI_LEN; ++i) {
       if (i < 4)
-	  esi[i] = bit_swap (lower4>>(8*i));
+	  esi[i] = bitrev8(lower4>>(8*i));
       else
-	  esi[i] = bit_swap (upper2>>(8*(i-4)));
+	  esi[i] = bitrev8(upper2>>(8*(i-4)));
       PRINTDM (DBG_INIT, " %02x", esi[i]);
     }
     
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
atm-ambassador-use-bitrev8.patch
isdn-gigaset-use-bitrev8.patch
isdn-fix-missing-unregister_capi_driver.patch
fault-injection-documentation-and-scripts.patch
fault-injection-capabilities-infrastructure.patch
fault-injection-capability-for-kmalloc.patch
fault-injection-capability-for-alloc_pages.patch
fault-injection-capability-for-disk-io.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

