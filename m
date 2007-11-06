From: akpm@linux-foundation.org
Subject: + arch-ppc-remove-duplicate-includes.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:35:55 -0800
Message-ID: <200711060235.lA62ZtBZ032033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbXKFCgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: woodzy@gmail.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     arch/ppc: remove duplicate includes
has been added to the -mm tree.  Its filename is
     arch-ppc-remove-duplicate-includes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch/ppc: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/kernel/setup.c           |    1 -
 arch/ppc/platforms/85xx/stx_gp3.c |    1 -
 arch/ppc/syslib/gt64260_pic.c     |    1 -
 arch/ppc/syslib/mpc52xx_pic.c     |    1 -
 arch/ppc/syslib/mv64360_pic.c     |    1 -
 arch/ppc/syslib/ppc83xx_setup.c   |    1 -
 arch/ppc/xmon/start.c             |    1 -
 7 files changed, 7 deletions(-)

diff -puN arch/ppc/kernel/setup.c~arch-ppc-remove-duplicate-includes arch/ppc/kernel/setup.c
--- a/arch/ppc/kernel/setup.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/kernel/setup.c
@@ -37,7 +37,6 @@
 #include <asm/nvram.h>
 #include <asm/xmon.h>
 #include <asm/ocp.h>
-#include <asm/prom.h>
 
 #define USES_PPC_SYS (defined(CONFIG_85xx) || defined(CONFIG_83xx) || \
 		      defined(CONFIG_MPC10X_BRIDGE) || defined(CONFIG_8260) || \
diff -puN arch/ppc/platforms/85xx/stx_gp3.c~arch-ppc-remove-duplicate-includes arch/ppc/platforms/85xx/stx_gp3.c
--- a/arch/ppc/platforms/85xx/stx_gp3.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/platforms/85xx/stx_gp3.c
@@ -50,7 +50,6 @@
 #include <asm/irq.h>
 #include <asm/immap_85xx.h>
 #include <asm/cpm2.h>
-#include <asm/mpc85xx.h>
 #include <asm/ppc_sys.h>
 
 #include <syslib/cpm2_pic.h>
diff -puN arch/ppc/syslib/gt64260_pic.c~arch-ppc-remove-duplicate-includes arch/ppc/syslib/gt64260_pic.c
--- a/arch/ppc/syslib/gt64260_pic.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/syslib/gt64260_pic.c
@@ -35,7 +35,6 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
-#include <linux/stddef.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 
diff -puN arch/ppc/syslib/mpc52xx_pic.c~arch-ppc-remove-duplicate-includes arch/ppc/syslib/mpc52xx_pic.c
--- a/arch/ppc/syslib/mpc52xx_pic.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/syslib/mpc52xx_pic.c
@@ -20,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
-#include <linux/stddef.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 
diff -puN arch/ppc/syslib/mv64360_pic.c~arch-ppc-remove-duplicate-includes arch/ppc/syslib/mv64360_pic.c
--- a/arch/ppc/syslib/mv64360_pic.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/syslib/mv64360_pic.c
@@ -36,7 +36,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
-#include <linux/stddef.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
diff -puN arch/ppc/syslib/ppc83xx_setup.c~arch-ppc-remove-duplicate-includes arch/ppc/syslib/ppc83xx_setup.c
--- a/arch/ppc/syslib/ppc83xx_setup.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/syslib/ppc83xx_setup.c
@@ -41,7 +41,6 @@
 
 #include <syslib/ppc83xx_setup.h>
 #if defined(CONFIG_PCI)
-#include <asm/delay.h>
 #include <syslib/ppc83xx_pci.h>
 #endif
 
diff -puN arch/ppc/xmon/start.c~arch-ppc-remove-duplicate-includes arch/ppc/xmon/start.c
--- a/arch/ppc/xmon/start.c~arch-ppc-remove-duplicate-includes
+++ a/arch/ppc/xmon/start.c
@@ -10,7 +10,6 @@
 #include <linux/sysrq.h>
 #include <linux/bitops.h>
 #include <asm/xmon.h>
-#include <asm/machdep.h>
 #include <asm/errno.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-alpha-removed-duplicate-includes.patch
arch-arm-removed-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-sparc-remove-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
