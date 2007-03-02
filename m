From: akpm@linux-foundation.org
Subject: - change-sysenter_setup-to-__cpuinit-improve-__init-fix.patch removed from -mm tree
Date: Thu, 01 Mar 2007 22:24:35 -0800
Message-ID: <200703020626.l226QAdS002237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45018 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422958AbXCBG01 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 01:26:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     change-sysenter_setup-to-__cpuinit-improve-__init fix
has been removed from the -mm tree.  Its filename was
     change-sysenter_setup-to-__cpuinit-improve-__init-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: change-sysenter_setup-to-__cpuinit-improve-__init fix
From: Prarit Bhargava <prarit@redhat.com>

I missed a chunk to arch/i386/kernel/vsyscall.S.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vsyscall.S |    2 +-
 arch/x86_64/kernel/head.S   |    4 +---
 include/linux/init.h        |   13 ++++++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/vsyscall.S~change-sysenter_setup-to-__cpuinit-improve-__init-fix arch/i386/kernel/vsyscall.S
--- a/arch/i386/kernel/vsyscall.S~change-sysenter_setup-to-__cpuinit-improve-__init-fix
+++ a/arch/i386/kernel/vsyscall.S
@@ -1,6 +1,6 @@
 #include <linux/init.h>
 
-__INITDATA
+__CPUINITDATA
 
 	.globl vsyscall_int80_start, vsyscall_int80_end
 vsyscall_int80_start:
diff -puN arch/x86_64/kernel/head.S~change-sysenter_setup-to-__cpuinit-improve-__init-fix arch/x86_64/kernel/head.S
--- a/arch/x86_64/kernel/head.S~change-sysenter_setup-to-__cpuinit-improve-__init-fix
+++ a/arch/x86_64/kernel/head.S
@@ -324,9 +324,7 @@ ENTRY(wakeup_level4_pgt)
 	.quad	phys_level3_kernel_pgt | 0x007
 #endif
 
-#ifndef CONFIG_HOTPLUG_CPU
-	__INITDATA
-#endif
+	__CPUINITDATA
 	/*
 	 * This default setting generates an ident mapping at address 0x100000
 	 * and a mapping for the kernel that precisely maps virtual address
diff -puN include/linux/init.h~change-sysenter_setup-to-__cpuinit-improve-__init-fix include/linux/init.h
--- a/include/linux/init.h~change-sysenter_setup-to-__cpuinit-improve-__init-fix
+++ a/include/linux/init.h
@@ -52,14 +52,17 @@
 #endif
 
 /* For assembly routines */
-#ifdef CONFIG_HOTPLUG_CPU
-#define __INIT		.section	".text","ax"
-#define __INITDATA	.section	".data","aw"
-#else
 #define __INIT		.section	".init.text","ax"
+#define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
+
+#ifdef CONFIG_HOTPLUG_CPU
+#define __CPUINIT	.section	".text","ax"
+#define __CPUINITDATA	.section	".data","ax"
+#else
+#define __CPUINIT	__INIT
+#define __CPUINITDATA	__INITDATA
 #endif
-#define __FINIT		.previous
 
 #ifndef __ASSEMBLY__
 /*
_

Patches currently in -mm which might be from prarit@redhat.com are

__devinit-__devexit-cleanups-for-de2104x-driver.patch
change-sysenter_setup-to-__cpuinit-improve-__init-fix.patch
use-stop_machine_run-in-the-intel-rng-driver.patch
change-rivafb_remove-to-__devexit.patch
