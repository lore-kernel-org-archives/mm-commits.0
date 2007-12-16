From: akpm@linux-foundation.org
Subject: - mips-remove-dead-config-symbols-from-mips-code.patch removed from -mm tree
Date: Sun, 16 Dec 2007 15:25:07 -0800
Message-ID: <200712162325.lBGNP707017603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35622 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760162AbXLPXZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Dec 2007 18:25:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: remove dead config symbols from MIPS code
has been removed from the -mm tree.  Its filename was
     mips-remove-dead-config-symbols-from-mips-code.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: mips: remove dead config symbols from MIPS code
From: Jiri Olsa <olsajiri@gmail.com>

remove dead config symbols from MIPS code

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/pmc-sierra/msp71xx/msp_regs.h |    4 ---
 include/asm-mips/sn/addrs.h                    |    2 -
 include/asm-mips/sn/agent.h                    |    4 ---
 include/asm-mips/sn/klconfig.h                 |   18 ---------------
 4 files changed, 2 insertions(+), 26 deletions(-)

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
diff -puN include/asm-mips/sibyte/swarm.h~mips-remove-dead-config-symbols-from-mips-code include/asm-mips/sibyte/swarm.h
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

git-alsa.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
mips-remove-dead-config-symbols-from-mips-code.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
frv-remove-dead-config-symbol-from-frv-code.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
