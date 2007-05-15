From: akpm@linux-foundation.org
Subject: + arm-fix-hard_smp_processor_id-compile-error.patch added to -mm tree
Date: Mon, 14 May 2007 19:24:30 -0700
Message-ID: <200705150224.l4F2OUa9032154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595AbXEOCYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 22:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, fernando@oss.ntt.co.jp, rmk@arm.linux.org.uk


The patch titled
     arm: fix hard_smp_processor_id compile error
has been added to the -mm tree.  Its filename is
     arm-fix-hard_smp_processor_id-compile-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm: fix hard_smp_processor_id compile error
From: Simon Horman <horms@verge.net.au>

"Remove hardcoding of hard_smp_processor_id on UP systems",
2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved the
definition of hard_smp_processor_id linux/smp.h to asm/smp.h for UP
systems.  This causes a regression on ARM as the definition was not added
to asm-arm/smp.h.

Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-integrator/core.c |    1 +
 include/asm-arm/smp.h           |   10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/arm/mach-integrator/core.c~arm-fix-hard_smp_processor_id-compile-error arch/arm/mach-integrator/core.c
--- a/arch/arm/mach-integrator/core.c~arm-fix-hard_smp_processor_id-compile-error
+++ a/arch/arm/mach-integrator/core.c
@@ -28,6 +28,7 @@
 #include <asm/system.h>
 #include <asm/leds.h>
 #include <asm/mach/time.h>
+#include <asm/smp.h>
 
 #include "common.h"
 
diff -puN include/asm-arm/smp.h~arm-fix-hard_smp_processor_id-compile-error include/asm-arm/smp.h
--- a/include/asm-arm/smp.h~arm-fix-hard_smp_processor_id-compile-error
+++ a/include/asm-arm/smp.h
@@ -10,16 +10,16 @@
 #ifndef __ASM_ARM_SMP_H
 #define __ASM_ARM_SMP_H
 
+#ifndef CONFIG_SMP
+#define hard_smp_processor_id()		0
+#else
+
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/thread_info.h>
 
 #include <asm/arch/smp.h>
 
-#ifndef CONFIG_SMP
-# error "<asm-arm/smp.h> included in non-SMP build"
-#endif
-
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 /*
@@ -134,4 +134,6 @@ extern void show_local_irqs(struct seq_f
  */
 asmlinkage void do_local_timer(struct pt_regs *);
 
+#endif /* CONFIG_SMP */
+
 #endif /* ifndef __ASM_ARM_SMP_H */
_

Patches currently in -mm which might be from horms@verge.net.au are

alpha-fix-hard_smp_processor_id-compile-error.patch
arm-fix-hard_smp_processor_id-compile-error.patch
git-ia64.patch
use-menuconfig-objects-ipvs.patch
