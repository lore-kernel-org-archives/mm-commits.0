Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9E2572
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 05:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721799453; cv=none; b=Yj1yo4g4i5GB6mM3viZplYrtxbwcbKJzHsJdokQ/Ftfkylce/Ko46x6lTVHyex3ngYcqY4uYXHl4ocU0qYVDvuspCUGxT4cXb1/QrrWqcBsvbG/w+P8YYZenBkdMP3qMGG6cM/rskeRDlmrY9TIH9ZfEg/bcNJuW/wfiXYwLDIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721799453; c=relaxed/simple;
	bh=VYeH1Bo/j8Sh1Ri52ayGaoQDtAvp/vU0J5bZY92Yv9Q=;
	h=Date:To:From:Subject:Message-Id; b=Ewd0ErtPzt0zHWIutIzt5j9lxU+JdwgsOh4vfRgtVCBmw2YN615E1itVx73A6rdubZ9UrzNmCdxLRzikegVkCQZnwkrSBiIeYmz83azn6POW7W9h0+SfiiATwY2NbRGMAsmZ84Uiuypz/DRyPfBl3wxzgoLtlKC8X7qr/sNZfOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G17LXm7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G17LXm7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A3C32782;
	Wed, 24 Jul 2024 05:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721799452;
	bh=VYeH1Bo/j8Sh1Ri52ayGaoQDtAvp/vU0J5bZY92Yv9Q=;
	h=Date:To:From:Subject:From;
	b=G17LXm7zTcB9MjYMUy8MpEExae7eLUy2CXhJvY7GaIEC9ZndoEPv4o3TG3RnQ3bfi
	 ZzN+scI6NUE8L2+LGBtlnHFoySIzrr8Juca54ulsQSXz3v5yE92TvqUyTiPFTHBLsF
	 VBCuHP8kS0qbzZO+XllLBhlREg9Yv0SHhup/Zw6o=
Date: Tue, 23 Jul 2024 22:37:32 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,tglx@linutronix.de,robh@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,linus.walleij@linaro.org,javierm@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,gregkh@linuxfoundation.org,eric.devolder@oracle.com,dyoung@redhat.com,deller@gmx.de,dave.hansen@linux.intel.com,chenjiahao16@huawei.com,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,aou@eecs.berkeley.edu,afd@ti.com,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-use-generic-interface-to-simplify-crashkernel-reservation.patch added to mm-nonmm-unstable branch
Message-Id: <20240724053732.A34A3C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ARM: use generic interface to simplify crashkernel reservation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arm-use-generic-interface-to-simplify-crashkernel-reservation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-use-generic-interface-to-simplify-crashkernel-reservation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: ARM: use generic interface to simplify crashkernel reservation
Date: Thu, 18 Jul 2024 11:54:44 +0800

Currently, x86, arm64, riscv and loongarch has been switched to generic
crashkernel reservation, which is also ready for 32bit system.  So with
the help of function parse_crashkernel() and generic
reserve_crashkernel_generic(), arm32 crashkernel reservation can also be
simplified by steps:

1) Add a new header file <asm/crash_reserve.h>, and define CRASH_ALIGN,
   CRASH_ADDR_LOW_MAX, CRASH_ADDR_HIGH_MAX in it;

2) Add arch_reserve_crashkernel() to call parse_crashkernel() and
   reserve_crashkernel_generic();

3) Add ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION Kconfig in
   arch/arm/Kconfig.

The old reserve_crashkernel() can be removed.

Following test cases have been performed as expected on QEMU vexpress-a9
(1GB system memory):

1) crashkernel=4G,high				// invalid
2) crashkernel=1G,high				// invalid
3) crashkernel=1G,high crashkernel=0M,low	// invalid
4) crashkernel=256M,high			// invalid
5) crashkernel=256M,low				// invalid
6) crashkernel=256M crashkernel=256M,high	// high is ignored, ok
7) crashkernel=256M crashkernel=256M,low	// low is ignored, ok
8) crashkernel=256M,high crashkernel=256M,low	// invalid
9) crashkernel=256M,high crashkernel=4G,low	// invalid
10) crashkernel=256M				// ok
11) crashkernel=512M				// ok
12) crashkernel=256M@0x88000000			// ok
13) crashkernel=256M@0x78000000			// ok
14) crashkernel=512M@0x78000000			// ok

Link: https://lkml.kernel.org/r/20240718035444.2977105-4-ruanjinjie@huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Tested-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andrew Davis <afd@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                     |    3 +
 arch/arm/include/asm/crash_reserve.h |   24 +++++++++
 arch/arm/kernel/setup.c              |   63 +++----------------------
 3 files changed, 36 insertions(+), 54 deletions(-)

--- /dev/null
+++ a/arch/arm/include/asm/crash_reserve.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ARM_CRASH_RESERVE_H
+#define _ARM_CRASH_RESERVE_H
+
+/*
+ * The crash region must be aligned to 128MB to avoid
+ * zImage relocating below the reserved region.
+ */
+#define CRASH_ALIGN			(128 << 20)
+
+#define CRASH_ADDR_LOW_MAX		crash_addr_low_max()
+#define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
+
+static inline unsigned long crash_addr_low_max(void)
+{
+	unsigned long long crash_max = idmap_to_phys((u32)~0);
+	unsigned long long lowmem_max = __pa(high_memory - 1) + 1;
+
+	return (crash_max > lowmem_max) ? lowmem_max : crash_max;
+}
+
+
+#define HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
+#endif
--- a/arch/arm/Kconfig~arm-use-generic-interface-to-simplify-crashkernel-reservation
+++ a/arch/arm/Kconfig
@@ -1593,6 +1593,9 @@ config ATAGS_PROC
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
+config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+	def_bool CRASH_RESERVE
+
 config AUTO_ZRELADDR
 	bool "Auto calculation of the decompressed kernel image address" if !ARCH_MULTIPLATFORM
 	default !(ARCH_FOOTBRIDGE || ARCH_RPC || ARCH_SA1100)
--- a/arch/arm/kernel/setup.c~arm-use-generic-interface-to-simplify-crashkernel-reservation
+++ a/arch/arm/kernel/setup.c
@@ -979,13 +979,6 @@ static int __init init_machine_late(void
 }
 late_initcall(init_machine_late);
 
-#ifdef CONFIG_CRASH_RESERVE
-/*
- * The crash region must be aligned to 128MB to avoid
- * zImage relocating below the reserved region.
- */
-#define CRASH_ALIGN	(128 << 20)
-
 static inline unsigned long long get_total_mem(void)
 {
 	unsigned long total;
@@ -994,60 +987,25 @@ static inline unsigned long long get_tot
 	return total << PAGE_SHIFT;
 }
 
-/**
- * reserve_crashkernel() - reserves memory are for crash kernel
- *
- * This function reserves memory area given in "crashkernel=" kernel command
- * line parameter. The memory reserved is used by a dump capture kernel when
- * primary kernel is crashing.
- */
-static void __init reserve_crashkernel(void)
+static void __init arch_reserve_crashkernel(void)
 {
-	unsigned long long crash_size, crash_base;
+	unsigned long long crash_size, crash_base, low_size = 0;
 	unsigned long long total_mem;
+	bool high = false;
 	int ret;
 
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
+		return;
+
 	total_mem = get_total_mem();
 	ret = parse_crashkernel(boot_command_line, total_mem,
 				&crash_size, &crash_base,
-				NULL, NULL);
+				&low_size, &high);
 	/* invalid value specified or crashkernel=0 */
 	if (ret || !crash_size)
 		return;
 
-	if (crash_base <= 0) {
-		unsigned long long crash_max = idmap_to_phys((u32)~0);
-		unsigned long long lowmem_max = __pa(high_memory - 1) + 1;
-		if (crash_max > lowmem_max)
-			crash_max = lowmem_max;
-
-		crash_base = memblock_phys_alloc_range(crash_size, CRASH_ALIGN,
-						       CRASH_ALIGN, crash_max);
-		if (!crash_base) {
-			pr_err("crashkernel reservation failed - No suitable area found.\n");
-			return;
-		}
-	} else {
-		unsigned long long crash_max = crash_base + crash_size;
-		unsigned long long start;
-
-		start = memblock_phys_alloc_range(crash_size, SECTION_SIZE,
-						  crash_base, crash_max);
-		if (!start) {
-			pr_err("crashkernel reservation failed - memory is in use.\n");
-			return;
-		}
-	}
-
-	pr_info("Reserving %ldMB of memory at %ldMB for crashkernel (System RAM: %ldMB)\n",
-		(unsigned long)(crash_size >> 20),
-		(unsigned long)(crash_base >> 20),
-		(unsigned long)(total_mem >> 20));
-
-	/* The crashk resource must always be located in normal mem */
-	crashk_res.start = crash_base;
-	crashk_res.end = crash_base + crash_size - 1;
-	insert_resource(&iomem_resource, &crashk_res);
+	reserve_crashkernel_generic(boot_command_line, crash_size, crash_base, low_size, high);
 
 	if (arm_has_idmap_alias()) {
 		/*
@@ -1064,9 +1022,6 @@ static void __init reserve_crashkernel(v
 		insert_resource(&iomem_resource, &crashk_boot_res);
 	}
 }
-#else
-static inline void reserve_crashkernel(void) {}
-#endif /* CONFIG_CRASH_RESERVE*/
 
 void __init hyp_mode_check(void)
 {
@@ -1189,7 +1144,7 @@ void __init setup_arch(char **cmdline_p)
 	if (!is_smp())
 		hyp_mode_check();
 
-	reserve_crashkernel();
+	arch_reserve_crashkernel();
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
crash-fix-x86_32-crash-memory-reserve-dead-loop-bug-at-high.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch

