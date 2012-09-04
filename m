From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 04 Sep 2012 12:20:18 -0700
Message-ID: <20120904192020.90FDC1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:53731 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab2IDTUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 15:20:22 -0400
Received: by ggnu1 with SMTP id u1so750319ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 12:20:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/mach-ath79/cpu-feature-overrides.h |    3 
 arch/mips/kernel/module.c                                |   41 -------
 arch/powerpc/include/asm/kvm_ppc.h                       |    3 
 arch/powerpc/kvm/e500_tlb.c                              |    3 
 arch/x86/kernel/microcode_amd.c                          |   53 ----------
 5 files changed, 103 deletions(-)

diff -puN arch/x86/kernel/microcode_amd.c~linux-next-git-rejects arch/x86/kernel/microcode_amd.c
--- a/arch/x86/kernel/microcode_amd.c~linux-next-git-rejects
+++ a/arch/x86/kernel/microcode_amd.c
@@ -219,26 +219,9 @@ static int apply_microcode_amd(int cpu)
 	struct ucode_patch *p;
 	u32 rev, dummy;
 
-<<<<<<< HEAD
-/*
- * we signal a good patch is found by returning its size > 0
- */
-static int get_matching_microcode(int cpu, const u8 *ucode_ptr,
-				  unsigned int leftover_size, int rev,
-				  unsigned int *current_size)
-{
-	struct microcode_header_amd *mc_hdr;
-	unsigned int actual_size, patch_size;
-	u16 equiv_cpu_id;
-
-	/* size of the current patch we're staring at */
-	patch_size = *(u32 *)(ucode_ptr + 4);
-	*current_size = patch_size + SECTION_HDR_SIZE;
-=======
 	BUG_ON(raw_smp_processor_id() != cpu);
 
 	uci = ucode_cpu_info + cpu;
->>>>>>> linux-next/akpm-base
 
 	p = find_patch(cpu);
 	if (!p)
@@ -255,42 +238,6 @@ static int get_matching_microcode(int cp
 		return 0;
 	}
 
-<<<<<<< HEAD
-	if (mc_hdr->patch_id <= rev)
-		return 0;
-
-	/*
-	 * now that the header looks sane, verify its size
-	 */
-	actual_size = verify_ucode_size(cpu, patch_size, leftover_size);
-	if (!actual_size)
-		return 0;
-
-	/* clear the patch buffer */
-	memset(patch, 0, PAGE_SIZE);
-
-	/* all looks ok, get the binary patch */
-	get_ucode_data(patch, ucode_ptr + SECTION_HDR_SIZE, actual_size);
-
-	return actual_size;
-}
-
-static int apply_microcode_amd(int cpu)
-{
-	u32 rev, dummy;
-	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
-	struct microcode_amd *mc_amd = uci->mc;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu_num != cpu);
-
-	if (mc_amd == NULL)
-		return 0;
-
-=======
->>>>>>> linux-next/akpm-base
 	wrmsrl(MSR_AMD64_PATCH_LOADER, (u64)(long)&mc_amd->hdr.data_code);
 
 	/* verify patch application was successful */
diff -puN arch/mips/include/asm/mach-ath79/cpu-feature-overrides.h~linux-next-git-rejects arch/mips/include/asm/mach-ath79/cpu-feature-overrides.h
--- a/arch/mips/include/asm/mach-ath79/cpu-feature-overrides.h~linux-next-git-rejects
+++ a/arch/mips/include/asm/mach-ath79/cpu-feature-overrides.h
@@ -42,11 +42,8 @@
 #define cpu_has_mips64r1	0
 #define cpu_has_mips64r2	0
 
-<<<<<<< HEAD
-=======
 #define cpu_has_dsp		0
 #define cpu_has_dsp2		0
->>>>>>> linux-next/akpm-base
 #define cpu_has_mipsmt		0
 
 #define cpu_has_64bits		0
diff -puN arch/mips/kernel/module.c~linux-next-git-rejects arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~linux-next-git-rejects
+++ a/arch/mips/kernel/module.c
@@ -249,47 +249,6 @@ int apply_relocate(Elf_Shdr *sechdrs, co
 	if (me->arch.r_mips_hi16_list) {
 		free_relocation_chain(me->arch.r_mips_hi16_list);
 		me->arch.r_mips_hi16_list = NULL;
-<<<<<<< HEAD
-
-		return -ENOEXEC;
-	}
-
-	return 0;
-}
-
-int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
-		       unsigned int symindex, unsigned int relsec,
-		       struct module *me)
-{
-	Elf_Mips_Rela *rel = (void *) sechdrs[relsec].sh_addr;
-	Elf_Sym *sym;
-	u32 *location;
-	unsigned int i;
-	Elf_Addr v;
-	int res;
-
-	pr_debug("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
-
-	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
-		/* This is where to make the change */
-		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
-			+ rel[i].r_offset;
-		/* This is the symbol it is referring to */
-		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
-			+ ELF_MIPS_R_SYM(rel[i]);
-		if (IS_ERR_VALUE(sym->st_value)) {
-			/* Ignore unresolved weak symbol */
-			if (ELF_ST_BIND(sym->st_info) == STB_WEAK)
-				continue;
-			printk(KERN_WARNING "%s: Unknown symbol %s\n",
-			       me->name, strtab + sym->st_name);
-			return -ENOENT;
-		}
-
-		v = sym->st_value + rel[i].r_addend;
-=======
->>>>>>> linux-next/akpm-base
 
 		return -ENOEXEC;
 	}
diff -puN arch/powerpc/include/asm/kvm_ppc.h~linux-next-git-rejects arch/powerpc/include/asm/kvm_ppc.h
--- a/arch/powerpc/include/asm/kvm_ppc.h~linux-next-git-rejects
+++ a/arch/powerpc/include/asm/kvm_ppc.h
@@ -236,8 +236,6 @@ static inline void kvmppc_mmu_flush_icac
 	}
 }
 
-<<<<<<< HEAD
-=======
 /* Please call after prepare_to_enter. This function puts the lazy ee state
    back to normal mode, without actually enabling interrupts. */
 static inline void kvmppc_lazy_ee_enable(void)
@@ -248,6 +246,5 @@ static inline void kvmppc_lazy_ee_enable
 	local_paca->soft_enabled = 1;
 #endif
 }
->>>>>>> linux-next/akpm-base
 
 #endif /* __POWERPC_KVM_PPC_H__ */
diff -puN arch/powerpc/kvm/e500_tlb.c~linux-next-git-rejects arch/powerpc/kvm/e500_tlb.c
--- a/arch/powerpc/kvm/e500_tlb.c~linux-next-git-rejects
+++ a/arch/powerpc/kvm/e500_tlb.c
@@ -544,12 +544,9 @@ static inline void kvmppc_e500_shadow_ma
 
 	/* Clear i-cache for new pages */
 	kvmppc_mmu_flush_icache(pfn);
-<<<<<<< HEAD
-=======
 
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
->>>>>>> linux-next/akpm-base
 }
 
 /* XXX only map the one-one case, for now use TLB0 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-netpoll-re-enable-irq-in-poll_napi.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

