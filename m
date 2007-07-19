From: akpm@linux-foundation.org
Subject: - i386-remove-support-for-the-rise-cpu.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:00 -0700
Message-ID: <200707192009.l6JK90vi020525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761108AbXGSUQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ak@suse.de, davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     i386: remove support for the Rise CPU
has been removed from the -mm tree.  Its filename was
     i386-remove-support-for-the-rise-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: remove support for the Rise CPU
From: Adrian Bunk <bunk@stusta.de>

The Rise CPUs were only very short-lived, and there are no reports of
anyone both owning one and running Linux on it.

Googling for the printk string "CPU: Rise iDragon" didn't find any dmesg
available online.

If it turns out that against all expectations there are actually users
reverting this patch would be easy.

This patch will make the kernel images smaller by a few bytes for all
i386 users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/Makefile  |    1 
 arch/i386/kernel/cpu/common.c  |    2 -
 arch/i386/kernel/cpu/rise.c    |   52 -------------------------------
 include/asm-i386/processor.h   |    1 
 include/asm-x86_64/processor.h |    1 
 5 files changed, 57 deletions(-)

diff -puN arch/i386/kernel/cpu/Makefile~i386-remove-support-for-the-rise-cpu arch/i386/kernel/cpu/Makefile
--- a/arch/i386/kernel/cpu/Makefile~i386-remove-support-for-the-rise-cpu
+++ a/arch/i386/kernel/cpu/Makefile
@@ -9,7 +9,6 @@ obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
 obj-y	+=	intel.o intel_cacheinfo.o addon_cpuid_features.o
-obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
 
diff -puN arch/i386/kernel/cpu/common.c~i386-remove-support-for-the-rise-cpu arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c~i386-remove-support-for-the-rise-cpu
+++ a/arch/i386/kernel/cpu/common.c
@@ -606,7 +606,6 @@ extern int nsc_init_cpu(void);
 extern int amd_init_cpu(void);
 extern int centaur_init_cpu(void);
 extern int transmeta_init_cpu(void);
-extern int rise_init_cpu(void);
 extern int nexgen_init_cpu(void);
 extern int umc_init_cpu(void);
 
@@ -618,7 +617,6 @@ void __init early_cpu_init(void)
 	amd_init_cpu();
 	centaur_init_cpu();
 	transmeta_init_cpu();
-	rise_init_cpu();
 	nexgen_init_cpu();
 	umc_init_cpu();
 	early_cpu_detect();
diff -puN arch/i386/kernel/cpu/rise.c~i386-remove-support-for-the-rise-cpu /dev/null
--- a/arch/i386/kernel/cpu/rise.c
+++ /dev/null
@@ -1,52 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-static void __cpuinit init_rise(struct cpuinfo_x86 *c)
-{
-	printk("CPU: Rise iDragon");
-	if (c->x86_model > 2)
-		printk(" II");
-	printk("\n");
-
-	/* Unhide possibly hidden capability flags
-	   The mp6 iDragon family don't have MSRs.
-	   We switch on extra features with this cpuid weirdness: */
-	__asm__ (
-		"movl $0x6363452a, %%eax\n\t"
-		"movl $0x3231206c, %%ecx\n\t"
-		"movl $0x2a32313a, %%edx\n\t"
-		"cpuid\n\t"
-		"movl $0x63634523, %%eax\n\t"
-		"movl $0x32315f6c, %%ecx\n\t"
-		"movl $0x2333313a, %%edx\n\t"
-		"cpuid\n\t" : : : "eax", "ebx", "ecx", "edx"
-	);
-	set_bit(X86_FEATURE_CX8, c->x86_capability);
-}
-
-static struct cpu_dev rise_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Rise",
-	.c_ident	= { "RiseRiseRise" },
-	.c_models = {
-		{ .vendor = X86_VENDOR_RISE, .family = 5, .model_names = 
-		  { 
-			  [0] = "iDragon", 
-			  [2] = "iDragon", 
-			  [8] = "iDragon II", 
-			  [9] = "iDragon II"
-		  }
-		},
-	},
-	.c_init		= init_rise,
-};
-
-int __init rise_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_RISE] = &rise_cpu_dev;
-	return 0;
-}
-
diff -puN include/asm-i386/processor.h~i386-remove-support-for-the-rise-cpu include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~i386-remove-support-for-the-rise-cpu
+++ a/include/asm-i386/processor.h
@@ -88,7 +88,6 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_UMC 3
 #define X86_VENDOR_NEXGEN 4
 #define X86_VENDOR_CENTAUR 5
-#define X86_VENDOR_RISE 6
 #define X86_VENDOR_TRANSMETA 7
 #define X86_VENDOR_NSC 8
 #define X86_VENDOR_NUM 9
diff -puN include/asm-x86_64/processor.h~i386-remove-support-for-the-rise-cpu include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h~i386-remove-support-for-the-rise-cpu
+++ a/include/asm-x86_64/processor.h
@@ -83,7 +83,6 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_UMC 3
 #define X86_VENDOR_NEXGEN 4
 #define X86_VENDOR_CENTAUR 5
-#define X86_VENDOR_RISE 6
 #define X86_VENDOR_TRANSMETA 7
 #define X86_VENDOR_NUM 8
 #define X86_VENDOR_UNKNOWN 0xff
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
