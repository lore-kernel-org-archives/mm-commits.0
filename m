From: akpm@linux-foundation.org
Subject: +
 powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch added to -mm tree
Date: Thu, 25 Aug 2016 14:30:46 -0700
Message-ID: <57bf6386.mwGoTUA1fHP+zcul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753374AbcHYVhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes

WARNING: do not add new typedefs
#86: FILE: arch/powerpc/include/asm/elf_util.h:35:
+typedef unsigned long func_desc_t;

WARNING: do not add new typedefs
#90: FILE: arch/powerpc/include/asm/elf_util.h:39:
+typedef struct ppc64_opd_entry func_desc_t;

WARNING: Block comments use * on subsequent lines
#94: FILE: arch/powerpc/include/asm/elf_util.h:43:
+/* Like PPC32, we need little trampolines to do > 24-bit jumps (into
+   the kernel itself).  But on PPC64, these need to be used for every

WARNING: Block comments use a trailing */ on a separate line
#95: FILE: arch/powerpc/include/asm/elf_util.h:44:
+   jump, actually, to reset r2 (TOC+0x8000). */

ERROR: open brace '{' following struct go on the same line
#97: FILE: arch/powerpc/include/asm/elf_util.h:46:
+struct ppc64_stub_entry
+{

WARNING: Block comments use a trailing */ on a separate line
#100: FILE: arch/powerpc/include/asm/elf_util.h:49:
+	 * so we don't have to modify the trampoline load instruction. */

WARNING: Block comments use * on subsequent lines
#110: FILE: arch/powerpc/include/asm/elf_util.h:59:
+/* r2 is the TOC pointer: it actually points 0x8000 into the TOC (this
+   gives the value maximum span in an instruction which uses a signed

WARNING: Block comments use a trailing */ on a separate line
#111: FILE: arch/powerpc/include/asm/elf_util.h:60:
+   offset) */

WARNING: Block comments use * on subsequent lines
#132: FILE: arch/powerpc/include/asm/module.h:18:
+/* Both low and high 16 bits are added as SIGNED additions, so if low
+   16 bits has high bit set, high 16 bits must be adjusted.  These

WARNING: Block comments use a trailing */ on a separate line
#133: FILE: arch/powerpc/include/asm/module.h:19:
+   macros do that (stolen from binutils). */

WARNING: space prohibited between function name and open parenthesis '('
#136: FILE: arch/powerpc/include/asm/module.h:22:
+#define PPC_HA(v) PPC_HI ((v) + 0x8000)

ERROR: Macros with complex values should be enclosed in parentheses
#136: FILE: arch/powerpc/include/asm/module.h:22:
+#define PPC_HA(v) PPC_HI ((v) + 0x8000)

WARNING: please, no spaces at the start of a line
#210: FILE: arch/powerpc/kernel/elf_util_64.c:32:
+ (((1 << (((other) & STO_PPC64_LOCAL_MASK) >> STO_PPC64_LOCAL_BIT)) >> 2) << 2)$

WARNING: Block comments use a trailing */ on a separate line
#216: FILE: arch/powerpc/kernel/elf_util_64.c:38:
+	 * of function and try to derive r2 from it). */

WARNING: line over 80 characters
#357: FILE: arch/powerpc/kernel/elf_util_64.c:179:
+				value = stub_for_addr(elf_info, value, obj_name);

WARNING: line over 80 characters
#363: FILE: arch/powerpc/kernel/elf_util_64.c:185:
+				squash_toc_save_inst(strtab + sym->st_name, value);

ERROR: space required before the open brace '{'
#369: FILE: arch/powerpc/kernel/elf_util_64.c:191:
+			if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0){

WARNING: line over 80 characters
#560: FILE: arch/powerpc/kernel/module_64.c:341:
+	sechdrs[me->arch.elf_info.stubs_section].sh_size = get_stubs_size(hdr, sechdrs);

WARNING: line over 80 characters
#613: FILE: arch/powerpc/kernel/module_64.c:380:
+	struct elf_shdr *stubs_sec = &elf_info->sechdrs[elf_info->stubs_section];

WARNING: line over 80 characters
#889: FILE: arch/powerpc/kernel/module_64.c:498:
+	num_stubs = sechdrs[me->arch.elf_info.stubs_section].sh_size / sizeof(*entry);

total: 3 errors, 17 warnings, 830 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/elf_util.h |   11 ++++++-----
 arch/powerpc/include/asm/module.h   |   10 ++++++----
 arch/powerpc/kernel/elf_util_64.c   |   14 +++++++++-----
 arch/powerpc/kernel/module_64.c     |    3 ++-
 4 files changed, 23 insertions(+), 15 deletions(-)

diff -puN arch/powerpc/include/asm/elf_util.h~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes arch/powerpc/include/asm/elf_util.h
--- a/arch/powerpc/include/asm/elf_util.h~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes
+++ a/arch/powerpc/include/asm/elf_util.h
@@ -39,11 +39,12 @@ typedef unsigned long func_desc_t;
 typedef struct ppc64_opd_entry func_desc_t;
 #endif /* PPC64_ELF_ABI_v2 */
 
-/* Like PPC32, we need little trampolines to do > 24-bit jumps (into
-   the kernel itself).  But on PPC64, these need to be used for every
-   jump, actually, to reset r2 (TOC+0x8000). */
-struct ppc64_stub_entry
-{
+/*
+ * Like PPC32, we need little trampolines to do > 24-bit jumps (into
+ * the kernel itself).  But on PPC64, these need to be used for every
+ * jump, actually, to reset r2 (TOC+0x8000).
+ */
+struct ppc64_stub_entry {
 	/* 28 byte jump instruction sequence (7 instructions). We only
 	 * need 6 instructions on ABIv2 but we always allocate 7 so
 	 * so we don't have to modify the trampoline load instruction. */
diff -puN arch/powerpc/include/asm/module.h~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes arch/powerpc/include/asm/module.h
--- a/arch/powerpc/include/asm/module.h~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes
+++ a/arch/powerpc/include/asm/module.h
@@ -14,12 +14,14 @@
 #include <asm-generic/module.h>
 #include <asm/elf_util.h>
 
-/* Both low and high 16 bits are added as SIGNED additions, so if low
-   16 bits has high bit set, high 16 bits must be adjusted.  These
-   macros do that (stolen from binutils). */
+/*
+ * Both low and high 16 bits are added as SIGNED additions, so if low 16 bits
+ * has high bit set, high 16 bits must be adjusted.  These macros do that
+ * (stolen from binutils).
+ */
 #define PPC_LO(v) ((v) & 0xffff)
 #define PPC_HI(v) (((v) >> 16) & 0xffff)
-#define PPC_HA(v) PPC_HI ((v) + 0x8000)
+#define PPC_HA(v) PPC_HI((v) + 0x8000)
 
 #ifndef __powerpc64__
 /*
diff -puN arch/powerpc/kernel/Makefile~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes arch/powerpc/kernel/Makefile
diff -puN arch/powerpc/kernel/elf_util_64.c~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes arch/powerpc/kernel/elf_util_64.c
--- a/arch/powerpc/kernel/elf_util_64.c~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes
+++ a/arch/powerpc/kernel/elf_util_64.c
@@ -33,9 +33,11 @@ struct module;
 
 static unsigned int local_entry_offset(const Elf64_Sym *sym)
 {
-	/* sym->st_other indicates offset to local entry point
+	/*
+	 * sym->st_other indicates offset to local entry point
 	 * (otherwise it will assume r12 is the address of the start
-	 * of function and try to derive r2 from it). */
+	 * of function and try to derive r2 from it).
+	 */
 	return PPC64_LOCAL_ENTRY_OFFSET(sym->st_other);
 }
 #else
@@ -176,19 +178,21 @@ int elf64_apply_relocate_add(const struc
 			/* FIXME: Handle weak symbols here --RR */
 			if (sym->st_shndx == SHN_UNDEF) {
 				/* External: go via stub */
-				value = stub_for_addr(elf_info, value, obj_name);
+				value = stub_for_addr(elf_info, value,
+						      obj_name);
 				if (!value)
 					return -ENOENT;
 				if (!restore_r2((u32 *)location + 1, obj_name))
 					return -ENOEXEC;
 
-				squash_toc_save_inst(strtab + sym->st_name, value);
+				squash_toc_save_inst(strtab + sym->st_name,
+						     value);
 			} else
 				value += local_entry_offset(sym);
 
 			/* Convert value to relative */
 			value -= (unsigned long)location;
-			if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0){
+			if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0) {
 				pr_err("%s: REL24 %li out of range!\n",
 				       obj_name, (long int)value);
 				return -ENOEXEC;
diff -puN arch/powerpc/kernel/module_64.c~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes arch/powerpc/kernel/module_64.c
--- a/arch/powerpc/kernel/module_64.c~powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes
+++ a/arch/powerpc/kernel/module_64.c
@@ -377,10 +377,11 @@ static inline int create_stub(const stru
 unsigned long stub_for_addr(const struct elf_info *elf_info, unsigned long addr,
 			    const char *obj_name)
 {
-	struct elf_shdr *stubs_sec = &elf_info->sechdrs[elf_info->stubs_section];
+	struct elf_shdr *stubs_sec;
 	struct ppc64_stub_entry *stubs;
 	unsigned int i, num_stubs;
 
+	stubs_sec = &elf_info->sechdrs[elf_info->stubs_section];
 	num_stubs = stubs_sec->sh_size / sizeof(*stubs);
 
 	/* Find this stub, or if that fails, the next avail. entry */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch
ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

