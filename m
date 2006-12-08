From: akpm@osdl.org
Subject: - isdn-hisax-use-bitrev8.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:12 -0800
Message-ID: <200612082001.kB8K1C5c001821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426192AbWLHUB1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, fisaksen@bewan.com, kai.germaschewski@gmx.de, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn/hisax: use bitrev8
has been removed from the -mm tree.  Its filename was
     isdn-hisax-use-bitrev8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn/hisax: use bitrev8
From: Akinobu Mita <akinobu.mita@gmail.com>

Use bitrev8 for hisax_st5481 driver.

Acked-by: Karsten Keil <kkeil@suse.de>
Cc: Kai Germaschewski <kai.germaschewski@gmx.de>
Cc: Frode Isaksen <fisaksen@bewan.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/Kconfig    |    1 +
 drivers/isdn/hisax/isdnhdlc.c |   25 -------------------------
 drivers/isdn/hisax/isdnhdlc.h |    2 --
 drivers/isdn/hisax/st5481_b.c |    3 ++-
 4 files changed, 3 insertions(+), 28 deletions(-)

diff -puN drivers/isdn/hisax/Kconfig~isdn-hisax-use-bitrev8 drivers/isdn/hisax/Kconfig
--- a/drivers/isdn/hisax/Kconfig~isdn-hisax-use-bitrev8
+++ a/drivers/isdn/hisax/Kconfig
@@ -402,6 +402,7 @@ config HISAX_ST5481
 	tristate "ST5481 USB ISDN modem (EXPERIMENTAL)"
 	depends on USB && EXPERIMENTAL
 	select CRC_CCITT
+	select BITREVERSE
 	help
 	  This enables the driver for ST5481 based USB ISDN adapters,
 	  e.g. the BeWan Gazel 128 USB
diff -puN drivers/isdn/hisax/isdnhdlc.c~isdn-hisax-use-bitrev8 drivers/isdn/hisax/isdnhdlc.c
--- a/drivers/isdn/hisax/isdnhdlc.c~isdn-hisax-use-bitrev8
+++ a/drivers/isdn/hisax/isdnhdlc.c
@@ -35,30 +35,6 @@ MODULE_LICENSE("GPL");
 
 /*-------------------------------------------------------------------*/
 
-/* bit swap table.
- * Very handy for devices with different bit order,
- * and neccessary for each transparent B-channel access for all
- * devices which works with this HDLC decoder without bit reversal.
- */
-const unsigned char isdnhdlc_bit_rev_tab[256] = {
-	0x00,0x80,0x40,0xC0,0x20,0xA0,0x60,0xE0,0x10,0x90,0x50,0xD0,0x30,0xB0,0x70,0xF0,
-	0x08,0x88,0x48,0xC8,0x28,0xA8,0x68,0xE8,0x18,0x98,0x58,0xD8,0x38,0xB8,0x78,0xF8,
-	0x04,0x84,0x44,0xC4,0x24,0xA4,0x64,0xE4,0x14,0x94,0x54,0xD4,0x34,0xB4,0x74,0xF4,
-	0x0C,0x8C,0x4C,0xCC,0x2C,0xAC,0x6C,0xEC,0x1C,0x9C,0x5C,0xDC,0x3C,0xBC,0x7C,0xFC,
-	0x02,0x82,0x42,0xC2,0x22,0xA2,0x62,0xE2,0x12,0x92,0x52,0xD2,0x32,0xB2,0x72,0xF2,
-	0x0A,0x8A,0x4A,0xCA,0x2A,0xAA,0x6A,0xEA,0x1A,0x9A,0x5A,0xDA,0x3A,0xBA,0x7A,0xFA,
-	0x06,0x86,0x46,0xC6,0x26,0xA6,0x66,0xE6,0x16,0x96,0x56,0xD6,0x36,0xB6,0x76,0xF6,
-	0x0E,0x8E,0x4E,0xCE,0x2E,0xAE,0x6E,0xEE,0x1E,0x9E,0x5E,0xDE,0x3E,0xBE,0x7E,0xFE,
-	0x01,0x81,0x41,0xC1,0x21,0xA1,0x61,0xE1,0x11,0x91,0x51,0xD1,0x31,0xB1,0x71,0xF1,
-	0x09,0x89,0x49,0xC9,0x29,0xA9,0x69,0xE9,0x19,0x99,0x59,0xD9,0x39,0xB9,0x79,0xF9,
-	0x05,0x85,0x45,0xC5,0x25,0xA5,0x65,0xE5,0x15,0x95,0x55,0xD5,0x35,0xB5,0x75,0xF5,
-	0x0D,0x8D,0x4D,0xCD,0x2D,0xAD,0x6D,0xED,0x1D,0x9D,0x5D,0xDD,0x3D,0xBD,0x7D,0xFD,
-	0x03,0x83,0x43,0xC3,0x23,0xA3,0x63,0xE3,0x13,0x93,0x53,0xD3,0x33,0xB3,0x73,0xF3,
-	0x0B,0x8B,0x4B,0xCB,0x2B,0xAB,0x6B,0xEB,0x1B,0x9B,0x5B,0xDB,0x3B,0xBB,0x7B,0xFB,
-	0x07,0x87,0x47,0xC7,0x27,0xA7,0x67,0xE7,0x17,0x97,0x57,0xD7,0x37,0xB7,0x77,0xF7,
-	0x0F,0x8F,0x4F,0xCF,0x2F,0xAF,0x6F,0xEF,0x1F,0x9F,0x5F,0xDF,0x3F,0xBF,0x7F,0xFF
-};
-
 enum {
 	HDLC_FAST_IDLE,HDLC_GET_FLAG_B0,HDLC_GETFLAG_B1A6,HDLC_GETFLAG_B7,
 	HDLC_GET_DATA,HDLC_FAST_FLAG
@@ -621,7 +597,6 @@ int isdnhdlc_encode(struct isdnhdlc_vars
 	return len;
 }
 
-EXPORT_SYMBOL(isdnhdlc_bit_rev_tab);
 EXPORT_SYMBOL(isdnhdlc_rcv_init);
 EXPORT_SYMBOL(isdnhdlc_decode);
 EXPORT_SYMBOL(isdnhdlc_out_init);
diff -puN drivers/isdn/hisax/isdnhdlc.h~isdn-hisax-use-bitrev8 drivers/isdn/hisax/isdnhdlc.h
--- a/drivers/isdn/hisax/isdnhdlc.h~isdn-hisax-use-bitrev8
+++ a/drivers/isdn/hisax/isdnhdlc.h
@@ -57,8 +57,6 @@ struct isdnhdlc_vars {
 #define HDLC_CRC_ERROR         2
 #define HDLC_LENGTH_ERROR      3
 
-extern const unsigned char isdnhdlc_bit_rev_tab[256];
-
 extern void isdnhdlc_rcv_init (struct isdnhdlc_vars *hdlc, int do_adapt56);
 
 extern int isdnhdlc_decode (struct isdnhdlc_vars *hdlc, const unsigned char *src, int slen,int *count,
diff -puN drivers/isdn/hisax/st5481_b.c~isdn-hisax-use-bitrev8 drivers/isdn/hisax/st5481_b.c
--- a/drivers/isdn/hisax/st5481_b.c~isdn-hisax-use-bitrev8
+++ a/drivers/isdn/hisax/st5481_b.c
@@ -14,6 +14,7 @@
 #include <linux/usb.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/bitrev.h>
 #include "st5481.h"
 
 static inline void B_L1L2(struct st5481_bcs *bcs, int pr, void *arg)
@@ -72,7 +73,7 @@ static void usb_b_out(struct st5481_bcs 
 					register unsigned char *dest = urb->transfer_buffer+len;
 					register unsigned int count;
 					for (count = 0; count < bytes_sent; count++)
-						*dest++ = isdnhdlc_bit_rev_tab[*src++];
+						*dest++ = bitrev8(*src++);
 				}
 				len += bytes_sent;
 			} else {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
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

