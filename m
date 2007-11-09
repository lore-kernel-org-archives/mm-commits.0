From: akpm@linux-foundation.org
Subject: + m32r-remove-dead-config-symbols-from-m32r-code.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:41:51 -0800
Message-ID: <200711092341.lA9NfpKx005283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759770AbXKIXmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:42:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, takata@linux-m32r.org


The patch titled
     m32r: remove dead config symbols from M32R code
has been added to the -mm tree.  Its filename is
     m32r-remove-dead-config-symbols-from-m32r-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: remove dead config symbols from M32R code
From: Jiri Olsa <olsajiri@gmail.com>

remove dead config symbols from M32R code

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/boot/compressed/m32r_sio.c     |    4 ++--
 include/asm-m32r/irq.h                   |    2 +-
 include/asm-m32r/m32700ut/m32700ut_pld.h |    4 +---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/m32r/boot/compressed/m32r_sio.c~m32r-remove-dead-config-symbols-from-m32r-code arch/m32r/boot/compressed/m32r_sio.c
--- a/arch/m32r/boot/compressed/m32r_sio.c~m32r-remove-dead-config-symbols-from-m32r-code
+++ a/arch/m32r/boot/compressed/m32r_sio.c
@@ -17,7 +17,7 @@ static int puts(const char *s)
 	return 0;
 }
 
-#if defined(CONFIG_PLAT_M32700UT_Alpha) || defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_OPSPUT)
+#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_OPSPUT)
 #include <asm/m32r.h>
 #include <asm/io.h>
 
@@ -52,7 +52,7 @@ static void putc(char c)
 	}
 	*BOOT_SIO0TXB = c;
 }
-#else /* !(CONFIG_PLAT_M32700UT_Alpha) && !(CONFIG_PLAT_M32700UT) */
+#else /* !(CONFIG_PLAT_M32700UT) */
 #if defined(CONFIG_PLAT_MAPPI2)
 #define SIO0STS	(volatile unsigned short *)(0xa0efd000 + 14)
 #define SIO0TXB	(volatile unsigned short *)(0xa0efd000 + 30)
diff -puN include/asm-m32r/irq.h~m32r-remove-dead-config-symbols-from-m32r-code include/asm-m32r/irq.h
--- a/include/asm-m32r/irq.h~m32r-remove-dead-config-symbols-from-m32r-code
+++ a/include/asm-m32r/irq.h
@@ -3,7 +3,7 @@
 #define _ASM_M32R_IRQ_H
 
 
-#if defined(CONFIG_PLAT_M32700UT_Alpha) || defined(CONFIG_PLAT_USRV)
+#if defined(CONFIG_PLAT_USRV)
 /*
  * IRQ definitions for M32700UT
  *  M32700 Chip: 64 interrupts
diff -puN include/asm-m32r/m32700ut/m32700ut_pld.h~m32r-remove-dead-config-symbols-from-m32r-code include/asm-m32r/m32700ut/m32700ut_pld.h
--- a/include/asm-m32r/m32700ut/m32700ut_pld.h~m32r-remove-dead-config-symbols-from-m32r-code
+++ a/include/asm-m32r/m32700ut/m32700ut_pld.h
@@ -13,9 +13,7 @@
  * this archive for more details.
  */
 
-#if defined(CONFIG_PLAT_M32700UT_Alpha)
-#define PLD_PLAT_BASE		0x08c00000
-#elif defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_USRV)
+#if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_USRV)
 #define PLD_PLAT_BASE		0x04c00000
 #else
 #error "no platform configuration"
_

Patches currently in -mm which might be from olsajiri@gmail.com are

arm-remove-dead-config-symbols-from-arm-code.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
git-net.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
git-sh.patch
frv-remove-dead-config-symbol-from-frv-code.patch
