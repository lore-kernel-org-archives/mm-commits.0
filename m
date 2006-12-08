From: akpm@osdl.org
Subject: - crc32-replace-bitreverse-by-bitrev32.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:05 -0800
Message-ID: <200612082001.kB8K15mF001808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426235AbWLHUCC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Matt_Domsch@dell.com, jgarzik@pobox.com, mm-commits@vger.kernel.org


The patch titled
     crc32: replace bitreverse by bitrev32
has been removed from the -mm tree.  Its filename was
     crc32-replace-bitreverse-by-bitrev32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: crc32: replace bitreverse by bitrev32
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch replaces bitreverse() by bitrev32.  The only users of bitreverse()
are crc32 itself and via-velocity.

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/via-velocity.c |    2 +-
 include/linux/crc32.h      |    4 ++--
 lib/Kconfig                |    1 +
 lib/crc32.c                |   28 +++++-----------------------
 4 files changed, 9 insertions(+), 26 deletions(-)

diff -puN drivers/net/via-velocity.c~crc32-replace-bitreverse-by-bitrev32 drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~crc32-replace-bitreverse-by-bitrev32
+++ a/drivers/net/via-velocity.c
@@ -3132,7 +3132,7 @@ static u16 wol_calc_crc(int size, u8 * p
 	}
 	/*	Finally, invert the result once to get the correct data */
 	crc = ~crc;
-	return bitreverse(crc) >> 16;
+	return bitrev32(crc) >> 16;
 }
 
 /**
diff -puN include/linux/crc32.h~crc32-replace-bitreverse-by-bitrev32 include/linux/crc32.h
--- a/include/linux/crc32.h~crc32-replace-bitreverse-by-bitrev32
+++ a/include/linux/crc32.h
@@ -6,10 +6,10 @@
 #define _LINUX_CRC32_H
 
 #include <linux/types.h>
+#include <linux/bitrev.h>
 
 extern u32  crc32_le(u32 crc, unsigned char const *p, size_t len);
 extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
-extern u32  bitreverse(u32 in);
 
 #define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)data, length)
 
@@ -21,7 +21,7 @@ extern u32  bitreverse(u32 in);
  * is in bit nr 0], thus it must be reversed before use. Except for
  * nics that bit swap the result internally...
  */
-#define ether_crc(length, data)    bitreverse(crc32_le(~0, data, length))
+#define ether_crc(length, data)    bitrev32(crc32_le(~0, data, length))
 #define ether_crc_le(length, data) crc32_le(~0, data, length)
 
 #endif /* _LINUX_CRC32_H */
diff -puN lib/Kconfig~crc32-replace-bitreverse-by-bitrev32 lib/Kconfig
--- a/lib/Kconfig~crc32-replace-bitreverse-by-bitrev32
+++ a/lib/Kconfig
@@ -26,6 +26,7 @@ config CRC16
 config CRC32
 	tristate "CRC32 functions"
 	default y
+	select BITREVERSE
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC32 functions, but a module built outside the
diff -puN lib/crc32.c~crc32-replace-bitreverse-by-bitrev32 lib/crc32.c
--- a/lib/crc32.c~crc32-replace-bitreverse-by-bitrev32
+++ a/lib/crc32.c
@@ -235,23 +235,8 @@ u32 __attribute_pure__ crc32_be(u32 crc,
 }
 #endif
 
-/**
- * bitreverse - reverse the order of bits in a u32 value
- * @x: value to be bit-reversed
- */
-u32 bitreverse(u32 x)
-{
-	x = (x >> 16) | (x << 16);
-	x = (x >> 8 & 0x00ff00ff) | (x << 8 & 0xff00ff00);
-	x = (x >> 4 & 0x0f0f0f0f) | (x << 4 & 0xf0f0f0f0);
-	x = (x >> 2 & 0x33333333) | (x << 2 & 0xcccccccc);
-	x = (x >> 1 & 0x55555555) | (x << 1 & 0xaaaaaaaa);
-	return x;
-}
-
 EXPORT_SYMBOL(crc32_le);
 EXPORT_SYMBOL(crc32_be);
-EXPORT_SYMBOL(bitreverse);
 
 /*
  * A brief CRC tutorial.
@@ -400,10 +385,7 @@ buf_dump(char const *prefix, unsigned ch
 static void bytereverse(unsigned char *buf, size_t len)
 {
 	while (len--) {
-		unsigned char x = *buf;
-		x = (x >> 4) | (x << 4);
-		x = (x >> 2 & 0x33) | (x << 2 & 0xcc);
-		x = (x >> 1 & 0x55) | (x << 1 & 0xaa);
+		unsigned char x = bitrev8(*buf);
 		*buf++ = x;
 	}
 }
@@ -460,11 +442,11 @@ static u32 test_step(u32 init, unsigned 
 	/* Now swap it around for the other test */
 
 	bytereverse(buf, len + 4);
-	init = bitreverse(init);
-	crc2 = bitreverse(crc1);
-	if (crc1 != bitreverse(crc2))
+	init = bitrev32(init);
+	crc2 = bitrev32(crc1);
+	if (crc1 != bitrev32(crc2))
 		printf("\nBit reversal fail: 0x%08x -> 0x%08x -> 0x%08x\n",
-		       crc1, crc2, bitreverse(crc2));
+		       crc1, crc2, bitrev32(crc2));
 	crc1 = crc32_le(init, buf, len);
 	if (crc1 != crc2)
 		printf("\nCRC endianness fail: 0x%08x != 0x%08x\n", crc1,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
crc32-replace-bitreverse-by-bitrev32.patch
video-use-bitrev8.patch
isdn-hisax-use-bitrev8.patch
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

