From: akpm@osdl.org
Subject: + m32r-support-a-synthesizable-m32700-core.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:20:22 -0800
Message-ID: <200612070520.kB75KMGX031252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968798AbWLGFVB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org


The patch titled
     m32r: support a synthesizable M32700 core
has been added to the -mm tree.  Its filename is
     m32r-support-a-synthesizable-m32700-core.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: support a synthesizable M32700 core
From: Hirokazu Takata <takata@linux-m32r.org>

This patch is for supporting a synthesizable M32700 core for the Mappi-II FPGA
board.

On the core, location of MFT (Multi-Function Timer) registers is slightly
different from the M32700 chip.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-m32r/m32102.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/asm-m32r/m32102.h~m32r-support-a-synthesizable-m32700-core include/asm-m32r/m32102.h
--- a/include/asm-m32r/m32102.h~m32r-support-a-synthesizable-m32700-core
+++ a/include/asm-m32r/m32102.h
@@ -104,7 +104,8 @@
 #define M32R_MFT5RLD_PORTL     (0x0C+M32R_MFT5_OFFSET)  /* MFT4 reload */
 #define M32R_MFT5CMPRLD_PORTL  (0x10+M32R_MFT5_OFFSET)  /* MFT4 compare reload */
 
-#if defined(CONFIG_CHIP_M32700) || defined(CONFIG_CHIP_M32104)
+#if (defined(CONFIG_CHIP_M32700) && !defined(CONFIG_PLAT_MAPPI2)) \
+	|| defined(CONFIG_CHIP_M32104)
 #define M32R_MFTCR_MFT0MSK  (1UL<<31)  /* b0 */
 #define M32R_MFTCR_MFT1MSK  (1UL<<30)  /* b1 */
 #define M32R_MFTCR_MFT2MSK  (1UL<<29)  /* b2 */
@@ -117,7 +118,7 @@
 #define M32R_MFTCR_MFT3EN   (1UL<<20)  /* b11 */
 #define M32R_MFTCR_MFT4EN   (1UL<<19)  /* b12 */
 #define M32R_MFTCR_MFT5EN   (1UL<<18)  /* b13 */
-#else	/* not CONFIG_CHIP_M32700 && not CONFIG_CHIP_M32104 */
+#else
 #define M32R_MFTCR_MFT0MSK  (1UL<<15)  /* b16 */
 #define M32R_MFTCR_MFT1MSK  (1UL<<14)  /* b17 */
 #define M32R_MFTCR_MFT2MSK  (1UL<<13)  /* b18 */
@@ -130,7 +131,7 @@
 #define M32R_MFTCR_MFT3EN   (1UL<<4)   /* b27 */
 #define M32R_MFTCR_MFT4EN   (1UL<<3)   /* b28 */
 #define M32R_MFTCR_MFT5EN   (1UL<<2)   /* b29 */
-#endif	/* not CONFIG_CHIP_M32700 && not CONFIG_CHIP_M32104 */
+#endif
 
 #define M32R_MFTMOD_CC_MASK    (1UL<<15)  /* b16 */
 #define M32R_MFTMOD_TCCR       (1UL<<13)  /* b18 */
_

Patches currently in -mm which might be from takata@linux-m32r.org are

m32r-make-userspace-headers-platform-independent.patch
m32r-support-a-synthesizable-m32700-core.patch
m32r-fix-ace_handler-to-pass-full-32-bit-address.patch
m32r-bootloader-support-for-opsput-platform.patch

