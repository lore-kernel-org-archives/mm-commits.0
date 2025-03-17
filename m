Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE40140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189499; cv=none; b=TzWgdiveDRa2V5nOAOg8siIULYEvcDolZLYRH+NTDw341WulIQ9rF1CD43Ujvl7A+rhSb4YWi8Nom6ckB3eyU4/rCJkh1cs2UENTSVA/fgTLCzqnjKd1UB6qfTbsn2U5a5ZlOkVfD/A9SzSo8CIh6YhifW1NxpQSxGZ5B5w20MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189499; c=relaxed/simple;
	bh=Kva+nJcSpTkqCzgFG9vLxxIsPYDUdLJxUnZmxKJCfSY=;
	h=Date:To:From:Subject:Message-Id; b=AzlTht+SFkAwncz4lPpw7V/49DSES7L9DgLXdyfPrNQY4jGgaW5bSYUm7W4ZeyR9q+6r/M+stY4WdY71mqJijeHUzIh/zpBy9VB8cM/GGKjoGF75ymUs0K8wZmgwje4tupQ74Oj8LXgd3NLSzq4bZ/YF8ADzM0WCHiSsR9UVtMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDHotRev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDHotRev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CD0C4CEEC;
	Mon, 17 Mar 2025 05:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189499;
	bh=Kva+nJcSpTkqCzgFG9vLxxIsPYDUdLJxUnZmxKJCfSY=;
	h=Date:To:From:Subject:From;
	b=IDHotRevH9GlF8BVpzGkcOMtnCZQjCYs0cQHn94zcdUi2ve7Xv4Okn/oNhSPmIPLV
	 SrjJfu+tm47v9brw46xJRJX3xZhq44PcZ9uwu9qIafkgrhc26Tb9zVZb1ic2CuyT3C
	 sl8Z76qB780e7G7TM9kUtIgVOAXWy4ml/2iHHr98=
Date: Sun, 16 Mar 2025 22:31:38 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-crash-use-generic-crashkernel-reservation.patch removed from -mm tree
Message-Id: <20250317053138.E5CD0C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/crash: use generic crashkernel reservation
has been removed from the -mm tree.  Its filename was
     powerpc-crash-use-generic-crashkernel-reservation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: powerpc/crash: use generic crashkernel reservation
Date: Fri, 31 Jan 2025 17:08:30 +0530

Commit 0ab97169aa05 ("crash_core: add generic function to do reservation")
added a generic function to reserve crashkernel memory.  So let's use the
same function on powerpc and remove the architecture-specific code that
essentially does the same thing.

The generic crashkernel reservation also provides a way to split the
crashkernel reservation into high and low memory reservations, which can
be enabled for powerpc in the future.

Along with moving to the generic crashkernel reservation, the code related
to finding the base address for the crashkernel has been separated into
its own function name get_crash_base() for better readability and
maintainability.

Link: https://lkml.kernel.org/r/20250131113830.925179-8-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                     |    3 
 arch/powerpc/include/asm/crash_reserve.h |    8 +
 arch/powerpc/include/asm/kexec.h         |    4 
 arch/powerpc/kernel/prom.c               |    2 
 arch/powerpc/kexec/core.c                |   92 +++++++++------------
 5 files changed, 54 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/include/asm/crash_reserve.h a/arch/powerpc/include/asm/crash_reserve.h
new file mode 100644
--- /dev/null
+++ a/arch/powerpc/include/asm/crash_reserve.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_CRASH_RESERVE_H
+#define _ASM_POWERPC_CRASH_RESERVE_H
+
+/* crash kernel regions are Page size agliged */
+#define CRASH_ALIGN             PAGE_SIZE
+
+#endif /* _ASM_POWERPC_CRASH_RESERVE_H */
--- a/arch/powerpc/include/asm/kexec.h~powerpc-crash-use-generic-crashkernel-reservation
+++ a/arch/powerpc/include/asm/kexec.h
@@ -114,9 +114,9 @@ int setup_new_fdt_ppc64(const struct kim
 
 #ifdef CONFIG_CRASH_RESERVE
 int __init overlaps_crashkernel(unsigned long start, unsigned long size);
-extern void reserve_crashkernel(void);
+extern void arch_reserve_crashkernel(void);
 #else
-static inline void reserve_crashkernel(void) {}
+static inline void arch_reserve_crashkernel(void) {}
 static inline int overlaps_crashkernel(unsigned long start, unsigned long size) { return 0; }
 #endif
 
--- a/arch/powerpc/Kconfig~powerpc-crash-use-generic-crashkernel-reservation
+++ a/arch/powerpc/Kconfig
@@ -721,6 +721,9 @@ config ARCH_SUPPORTS_CRASH_HOTPLUG
 	def_bool y
 	depends on PPC64
 
+config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+	def_bool CRASH_RESERVE
+
 config FA_DUMP
 	bool "Firmware-assisted dump"
 	depends on CRASH_DUMP && PPC64 && (PPC_RTAS || PPC_POWERNV)
--- a/arch/powerpc/kernel/prom.c~powerpc-crash-use-generic-crashkernel-reservation
+++ a/arch/powerpc/kernel/prom.c
@@ -860,7 +860,7 @@ void __init early_init_devtree(void *par
 	 */
 	if (fadump_reserve_mem() == 0)
 #endif
-		reserve_crashkernel();
+		arch_reserve_crashkernel();
 	early_reserve_mem();
 
 	if (memory_limit > memblock_phys_mem_size())
--- a/arch/powerpc/kexec/core.c~powerpc-crash-use-generic-crashkernel-reservation
+++ a/arch/powerpc/kexec/core.c
@@ -58,38 +58,20 @@ void machine_kexec(struct kimage *image)
 }
 
 #ifdef CONFIG_CRASH_RESERVE
-void __init reserve_crashkernel(void)
-{
-	unsigned long long crash_size, crash_base, total_mem_sz;
-	int ret;
-
-	total_mem_sz = memory_limit ? memory_limit : memblock_phys_mem_size();
-	/* use common parsing */
-	ret = parse_crashkernel(boot_command_line, total_mem_sz,
-			&crash_size, &crash_base, NULL, NULL);
-	if (ret == 0 && crash_size > 0) {
-		crashk_res.start = crash_base;
-		crashk_res.end = crash_base + crash_size - 1;
-	}
-
-	if (crashk_res.end == crashk_res.start) {
-		crashk_res.start = crashk_res.end = 0;
-		return;
-	}
 
-	/* We might have got these values via the command line or the
-	 * device tree, either way sanitise them now. */
-
-	crash_size = resource_size(&crashk_res);
+static unsigned long long __init get_crash_base(unsigned long long crash_base)
+{
 
 #ifndef CONFIG_NONSTATIC_KERNEL
-	if (crashk_res.start != KDUMP_KERNELBASE)
+	if (crash_base != KDUMP_KERNELBASE)
 		printk("Crash kernel location must be 0x%x\n",
 				KDUMP_KERNELBASE);
 
-	crashk_res.start = KDUMP_KERNELBASE;
+	return KDUMP_KERNELBASE;
 #else
-	if (!crashk_res.start) {
+	unsigned long long crash_base_align;
+
+	if (!crash_base) {
 #ifdef CONFIG_PPC64
 		/*
 		 * On the LPAR platform place the crash kernel to mid of
@@ -101,45 +83,51 @@ void __init reserve_crashkernel(void)
 		 * kernel starts at 128MB offset on other platforms.
 		 */
 		if (firmware_has_feature(FW_FEATURE_LPAR))
-			crashk_res.start = min_t(u64, ppc64_rma_size / 2, SZ_512M);
+			crash_base = min_t(u64, ppc64_rma_size / 2, SZ_512M);
 		else
-			crashk_res.start = min_t(u64, ppc64_rma_size / 2, SZ_128M);
+			crash_base = min_t(u64, ppc64_rma_size / 2, SZ_128M);
 #else
-		crashk_res.start = KDUMP_KERNELBASE;
+		crash_base = KDUMP_KERNELBASE;
 #endif
 	}
 
-	crash_base = PAGE_ALIGN(crashk_res.start);
-	if (crash_base != crashk_res.start) {
-		printk("Crash kernel base must be aligned to 0x%lx\n",
-				PAGE_SIZE);
-		crashk_res.start = crash_base;
-	}
+	crash_base_align = PAGE_ALIGN(crash_base);
+	if (crash_base != crash_base_align)
+		pr_warn("Crash kernel base must be aligned to 0x%lx\n", PAGE_SIZE);
 
+	return crash_base_align;
 #endif
-	crash_size = PAGE_ALIGN(crash_size);
-	crashk_res.end = crashk_res.start + crash_size - 1;
+}
 
-	/* The crash region must not overlap the current kernel */
-	if (overlaps_crashkernel(__pa(_stext), _end - _stext)) {
-		printk(KERN_WARNING
-			"Crash kernel can not overlap current kernel\n");
-		crashk_res.start = crashk_res.end = 0;
+void __init arch_reserve_crashkernel(void)
+{
+	unsigned long long crash_size, crash_base, crash_end;
+	unsigned long long kernel_start, kernel_size;
+	unsigned long long total_mem_sz;
+	int ret;
+
+	total_mem_sz = memory_limit ? memory_limit : memblock_phys_mem_size();
+
+	/* use common parsing */
+	ret = parse_crashkernel(boot_command_line, total_mem_sz, &crash_size,
+				&crash_base, NULL, NULL);
+
+	if (ret)
 		return;
-	}
 
-	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-			"for crashkernel (System RAM: %ldMB)\n",
-			(unsigned long)(crash_size >> 20),
-			(unsigned long)(crashk_res.start >> 20),
-			(unsigned long)(total_mem_sz >> 20));
-
-	if (!memblock_is_region_memory(crashk_res.start, crash_size) ||
-	    memblock_reserve(crashk_res.start, crash_size)) {
-		pr_err("Failed to reserve memory for crashkernel!\n");
-		crashk_res.start = crashk_res.end = 0;
+	crash_base = get_crash_base(crash_base);
+	crash_end = crash_base + crash_size - 1;
+
+	kernel_start = __pa(_stext);
+	kernel_size = _end - _stext;
+
+	/* The crash region must not overlap the current kernel */
+	if ((kernel_start + kernel_size > crash_base) && (kernel_start <= crash_end)) {
+		pr_warn("Crash kernel can not overlap current kernel\n");
 		return;
 	}
+
+	reserve_crashkernel_generic(crash_size, crash_base, 0, false);
 }
 
 int __init overlaps_crashkernel(unsigned long start, unsigned long size)
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are


