From: akpm@linux-foundation.org
Subject: - m32r-remove-dead-config-symbols-from-m32r-code.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:56 -0800
Message-ID: <200802052226.m15MQbl2011637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726AbYBEW0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: remove dead config symbols from M32R code
has been removed from the -mm tree.  Its filename was
     m32r-remove-dead-config-symbols-from-m32r-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
