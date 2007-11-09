From: akpm@linux-foundation.org
Subject: + mips-remove-dead-config-symbols-from-mips-code.patch added to -mm tree
Date: Fri, 09 Nov 2007 15:43:32 -0800
Message-ID: <200711092343.lA9NhWfO005437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbXKIXnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 18:43:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, ralf@linux-mips.org


The patch titled
     mips: remove dead config symbols from MIPS code
has been added to the -mm tree.  Its filename is
     mips-remove-dead-config-symbols-from-mips-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: remove dead config symbols from MIPS code
From: Jiri Olsa <olsajiri@gmail.com>

remove dead config symbols from MIPS code

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/pmc-sierra/msp71xx/msp_regs.h |    4 ---
 include/asm-mips/sibyte/board.h                |    1 
 include/asm-mips/sibyte/swarm.h                |   12 ----------
 include/asm-mips/sn/addrs.h                    |    2 -
 include/asm-mips/sn/agent.h                    |    4 ---
 include/asm-mips/sn/klconfig.h                 |   18 ---------------
 6 files changed, 2 insertions(+), 39 deletions(-)

diff -puN include/asm-mips/pmc-sierra/msp71xx/msp_regs.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/pmc-sierra/msp71xx/msp_regs.h
--- a/include/asm-mips/pmc-sierra/msp71xx/msp_regs.h~mips-remove-dead-config-symbols-from-mips-code
+++ a/include/asm-mips/pmc-sierra/msp71xx/msp_regs.h
@@ -585,11 +585,7 @@
  * UART defines                                                            *
  ***************************************************************************
  */
-#ifndef CONFIG_MSP_FPGA
 #define MSP_BASE_BAUD		25000000
-#else
-#define MSP_BASE_BAUD		6000000
-#endif
 #define MSP_UART_REG_LEN	0x20
 
 /*
diff -puN include/asm-mips/sibyte/board.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/sibyte/board.h
--- a/include/asm-mips/sibyte/board.h~mips-remove-dead-config-symbols-from-mips-code
+++ a/include/asm-mips/sibyte/board.h
@@ -20,7 +20,6 @@
 #define _SIBYTE_BOARD_H
 
 #if defined(CONFIG_SIBYTE_SWARM) || defined(CONFIG_SIBYTE_PTSWARM) || \
-    defined(CONFIG_SIBYTE_PT1120) || defined(CONFIG_SIBYTE_PT1125) || \
     defined(CONFIG_SIBYTE_CRHONE) || defined(CONFIG_SIBYTE_CRHINE) || \
     defined(CONFIG_SIBYTE_LITTLESUR)
 #include <asm/sibyte/swarm.h>
diff -puN include/asm-mips/sibyte/swarm.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/sibyte/swarm.h
--- a/include/asm-mips/sibyte/swarm.h~mips-remove-dead-config-symbols-from-mips-code
+++ a/include/asm-mips/sibyte/swarm.h
@@ -32,18 +32,6 @@
 #define SIBYTE_HAVE_IDE    1
 #define SIBYTE_DEFAULT_CONSOLE "ttyS0,115200"
 #endif
-#ifdef CONFIG_SIBYTE_PT1120
-#define SIBYTE_BOARD_NAME "PT1120"
-#define SIBYTE_HAVE_PCMCIA 1
-#define SIBYTE_HAVE_IDE    1
-#define SIBYTE_DEFAULT_CONSOLE "ttyS0,115200"
-#endif
-#ifdef CONFIG_SIBYTE_PT1125
-#define SIBYTE_BOARD_NAME "PT1125"
-#define SIBYTE_HAVE_PCMCIA 1
-#define SIBYTE_HAVE_IDE    1
-#define SIBYTE_DEFAULT_CONSOLE "ttyS0,115200"
-#endif
 #ifdef CONFIG_SIBYTE_LITTLESUR
 #define SIBYTE_BOARD_NAME "BCM91250C2 (LittleSur)"
 #define SIBYTE_HAVE_PCMCIA 0
diff -puN include/asm-mips/sn/addrs.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/sn/addrs.h
--- a/include/asm-mips/sn/addrs.h~mips-remove-dead-config-symbols-from-mips-code
+++ a/include/asm-mips/sn/addrs.h
@@ -19,8 +19,6 @@
 
 #if defined(CONFIG_SGI_IP27)
 #include <asm/sn/sn0/addrs.h>
-#elif defined(CONFIG_SGI_IP35)
-#include <asm/sn/sn1/addrs.h>
 #endif
 
 
diff -puN include/asm-mips/sn/agent.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/sn/agent.h
--- a/include/asm-mips/sn/agent.h~mips-remove-dead-config-symbols-from-mips-code
+++ a/include/asm-mips/sn/agent.h
@@ -17,9 +17,7 @@
 
 #if defined(CONFIG_SGI_IP27)
 #include <asm/sn/sn0/hub.h>
-#elif defined(CONFIG_SGI_IP35)
-#include <asm/sn/sn1/hub.h>
-#endif	/* !CONFIG_SGI_IP27 && !CONFIG_SGI_IP35 */
+#endif	/* !CONFIG_SGI_IP27 */
 
 /*
  * NIC register macros
diff -puN include/asm-mips/sn/klconfig.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/sn/klconfig.h
--- a/include/asm-mips/sn/klconfig.h~mips-remove-dead-config-symbols-from-mips-code
+++ a/include/asm-mips/sn/klconfig.h
@@ -40,26 +40,10 @@
 //#include <sys/graph.h>
 //#include <sys/xtalk/xbow.h>
 
-#elif defined(CONFIG_SGI_IP35)
-
-#include <asm/sn/sn1/addrs.h>
-#include <sys/sn/router.h>
-#include <sys/graph.h>
-#include <asm/xtalk/xbow.h>
-
-#endif /* !CONFIG_SGI_IP27 && !CONFIG_SGI_IP35 */
-
-#if defined(CONFIG_SGI_IP27) || defined(CONFIG_SGI_IP35)
 #include <asm/sn/agent.h>
 #include <asm/fw/arc/types.h>
 #include <asm/fw/arc/hinv.h>
-#if defined(CONFIG_SGI_IP35)
-// The hack file has to be before vector and after sn0_fru....
-#include <asm/hack.h>
-#include <asm/sn/vector.h>
-#include <asm/xtalk/xtalk.h>
-#endif /* CONFIG_SGI_IP35 */
-#endif /* CONFIG_SGI_IP27 || CONFIG_SGI_IP35 */
+#endif /* CONFIG_SGI_IP27 */
 
 typedef u64  nic_t;
 
_

Patches currently in -mm which might be from olsajiri@gmail.com are

arm-remove-dead-config-symbols-from-arm-code.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
mips-remove-dead-config-symbols-from-mips-code.patch
git-net.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
git-sh.patch
frv-remove-dead-config-symbol-from-frv-code.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
