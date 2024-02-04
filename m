Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5179DF
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031237; cv=none; b=AB1bYfBdbbs3iAKWpwQl8x9dKKqowktKPuIRCtnHRsG0xiaEzfRiNwLKjLTHWYEz1yPrd/CuMp5TB3SpSLDcNHaALD4Czav1QmTITSCamL/peF3cqM1jwqa3DNDgqC2u3qMpWOHzasK8CVV61Oyj5yiZHOqjnBdaCBwp2yxHzm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031237; c=relaxed/simple;
	bh=g0o3zTGU4Dvkgmh882EsoL2/qBJPKrd7WEi3xwMpEzE=;
	h=Date:To:From:Subject:Message-Id; b=jZwDFnxyTgymYDuGWJnhW2Gz6r3zDErezi+Af5co7/in87LcbtKnV38h12QxPxL1nq3P/yBqTq6ItpX+Gxifs+ibj/jpIF2A5cx4PssWc1HvZk7knR9xhbiWliQugFmcSJAjpFF3KgvXcTgxyYbDFsDln3y23C3NqHT1pnSFZhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vmXTJMnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vmXTJMnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55BFC43399;
	Sun,  4 Feb 2024 07:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031236;
	bh=g0o3zTGU4Dvkgmh882EsoL2/qBJPKrd7WEi3xwMpEzE=;
	h=Date:To:From:Subject:From;
	b=vmXTJMnVY2tEMowU01CHgH0BV30iJm5FEtB2taaqZCCZGl1Cg7Ce201fVcFL9Ul/v
	 k61uPAFHbOAGbw3WaZa9aRlJD/OwXQLN6axT1f9BuvOx3hYwLSBxmK1L72mgyacA+p
	 K0QCm5fEyrIdCb3q7sADacpT+ETNNBfZkcM0Nj+o=
Date: Sat, 03 Feb 2024 23:20:36 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch added to mm-unstable branch
Message-Id: <20240204072036.D55BFC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch, crash: move arch_crash_save_vmcoreinfo() out to file vmcore_info.c
has been added to the -mm mm-unstable branch.  Its filename is
     arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

This patch will later appear in the mm-unstable branch at
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
From: Baoquan He <bhe@redhat.com>
Subject: arch, crash: move arch_crash_save_vmcoreinfo() out to file vmcore_info.c
Date: Mon, 29 Jan 2024 21:50:33 +0800

Nathan reported below building error:

=====
$ curl -LSso .config https://git.alpinelinux.org/aports/plain/community/linux-edge/config-edge.armv7
$ make -skj"$(nproc)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- olddefconfig all
..
arm-linux-gnueabi-ld: arch/arm/kernel/machine_kexec.o: in function `arch_crash_save_vmcoreinfo':
machine_kexec.c:(.text+0x488): undefined reference to `vmcoreinfo_append_str'
====

On architecutres, like arm, s390, ppc, sh, function
arch_crash_save_vmcoreinfo() is located in machine_kexec.c and it can
only be compiled in when CONFIG_KEXEC_CORE=y.

That's not right because arch_crash_save_vmcoreinfo() is used to export
arch specific vmcoreinfo. CONFIG_VMCORE_INFO is supposed to control its
compiling in. However, CONFIG_VMVCORE_INFO could be independent of
CONFIG_KEXEC_CORE, e.g CONFIG_PROC_KCORE=y will select CONFIG_VMVCORE_INFO.
Or CONFIG_KEXEC/CONFIG_KEXEC_FILE is set while CONFIG_CRASH_DUMP is
not set, it will report linking error.

So, on arm, s390, ppc and sh, move arch_crash_save_vmcoreinfo out to
a new file vmcore_info.c. Let CONFIG_VMCORE_INFO decide if compiling in
arch_crash_save_vmcoreinfo().

Link: https://lkml.kernel.org/r/20240129135033.157195-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20240126045551.GA126645@dev-arch.thelio-3990X/T/#u
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/Makefile         |    1 
 arch/arm/kernel/machine_kexec.c  |    7 -----
 arch/arm/kernel/vmcore_info.c    |   10 ++++++++
 arch/powerpc/kexec/Makefile      |    1 
 arch/powerpc/kexec/core.c        |   28 -----------------------
 arch/powerpc/kexec/vmcore_info.c |   34 +++++++++++++++++++++++++++++
 arch/s390/kernel/Makefile        |    1 
 arch/s390/kernel/machine_kexec.c |   15 ------------
 arch/s390/kernel/vmcore_info.c   |   23 +++++++++++++++++++
 arch/sh/kernel/Makefile          |    1 
 arch/sh/kernel/machine_kexec.c   |   11 ---------
 arch/sh/kernel/vmcore_info.c     |   17 ++++++++++++++
 12 files changed, 88 insertions(+), 61 deletions(-)

--- a/arch/arm/kernel/machine_kexec.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/arm/kernel/machine_kexec.c
@@ -198,10 +198,3 @@ void machine_kexec(struct kimage *image)
 
 	soft_restart(reboot_entry_phys);
 }
-
-void arch_crash_save_vmcoreinfo(void)
-{
-#ifdef CONFIG_ARM_LPAE
-	VMCOREINFO_CONFIG(ARM_LPAE);
-#endif
-}
--- a/arch/arm/kernel/Makefile~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/arm/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o patch.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_VMCORE_INFO)	+= vmcore_info.o
 # Main staffs in KPROBES are in arch/arm/probes/ .
 obj-$(CONFIG_KPROBES)		+= patch.o insn.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
--- /dev/null
+++ a/arch/arm/kernel/vmcore_info.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/vmcore_info.h>
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_ARM_LPAE
+	VMCOREINFO_CONFIG(ARM_LPAE);
+#endif
+}
--- a/arch/powerpc/kexec/core.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/powerpc/kexec/core.c
@@ -53,34 +53,6 @@ void machine_kexec_cleanup(struct kimage
 {
 }
 
-void arch_crash_save_vmcoreinfo(void)
-{
-
-#ifdef CONFIG_NUMA
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
-#ifndef CONFIG_NUMA
-	VMCOREINFO_SYMBOL(contig_page_data);
-#endif
-#if defined(CONFIG_PPC64) && defined(CONFIG_SPARSEMEM_VMEMMAP)
-	VMCOREINFO_SYMBOL(vmemmap_list);
-	VMCOREINFO_SYMBOL(mmu_vmemmap_psize);
-	VMCOREINFO_SYMBOL(mmu_psize_defs);
-	VMCOREINFO_STRUCT_SIZE(vmemmap_backing);
-	VMCOREINFO_OFFSET(vmemmap_backing, list);
-	VMCOREINFO_OFFSET(vmemmap_backing, phys);
-	VMCOREINFO_OFFSET(vmemmap_backing, virt_addr);
-	VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
-	VMCOREINFO_OFFSET(mmu_psize_def, shift);
-#endif
-	VMCOREINFO_SYMBOL(cur_cpu_spec);
-	VMCOREINFO_OFFSET(cpu_spec, cpu_features);
-	VMCOREINFO_OFFSET(cpu_spec, mmu_features);
-	vmcoreinfo_append_str("NUMBER(RADIX_MMU)=%d\n", early_radix_enabled());
-	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
-}
-
 /*
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
--- a/arch/powerpc/kexec/Makefile~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/powerpc/kexec/Makefile
@@ -8,6 +8,7 @@ obj-y				+= core.o crash.o core_$(BITS).
 obj-$(CONFIG_PPC32)		+= relocate_32.o
 
 obj-$(CONFIG_KEXEC_FILE)	+= file_load.o ranges.o file_load_$(BITS).o elf_$(BITS).o
+obj-$(CONFIG_VMCORE_INFO)	+= vmcore_info.o
 
 # Disable GCOV, KCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_core_$(BITS).o := n
--- /dev/null
+++ a/arch/powerpc/kexec/vmcore_info.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/vmcore_info.h>
+#include <asm/pgalloc.h>
+
+void arch_crash_save_vmcoreinfo(void)
+{
+
+#ifdef CONFIG_NUMA
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
+#ifndef CONFIG_NUMA
+	VMCOREINFO_SYMBOL(contig_page_data);
+#endif
+#if defined(CONFIG_PPC64) && defined(CONFIG_SPARSEMEM_VMEMMAP)
+	VMCOREINFO_SYMBOL(vmemmap_list);
+	VMCOREINFO_SYMBOL(mmu_vmemmap_psize);
+	VMCOREINFO_SYMBOL(mmu_psize_defs);
+	VMCOREINFO_STRUCT_SIZE(vmemmap_backing);
+	VMCOREINFO_OFFSET(vmemmap_backing, list);
+	VMCOREINFO_OFFSET(vmemmap_backing, phys);
+	VMCOREINFO_OFFSET(vmemmap_backing, virt_addr);
+	VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
+	VMCOREINFO_OFFSET(mmu_psize_def, shift);
+#endif
+	VMCOREINFO_SYMBOL(cur_cpu_spec);
+	VMCOREINFO_OFFSET(cpu_spec, cpu_features);
+	VMCOREINFO_OFFSET(cpu_spec, mmu_features);
+	vmcoreinfo_append_str("NUMBER(RADIX_MMU)=%d\n", early_radix_enabled());
+	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
+}
+
+
--- a/arch/s390/kernel/machine_kexec.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/s390/kernel/machine_kexec.c
@@ -209,21 +209,6 @@ void machine_kexec_cleanup(struct kimage
 {
 }
 
-void arch_crash_save_vmcoreinfo(void)
-{
-	struct lowcore *abs_lc;
-
-	VMCOREINFO_SYMBOL(lowcore_ptr);
-	VMCOREINFO_SYMBOL(high_memory);
-	VMCOREINFO_LENGTH(lowcore_ptr, NR_CPUS);
-	vmcoreinfo_append_str("SAMODE31=%lx\n", (unsigned long)__samode31);
-	vmcoreinfo_append_str("EAMODE31=%lx\n", (unsigned long)__eamode31);
-	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
-	abs_lc = get_abs_lowcore();
-	abs_lc->vmcore_info = paddr_vmcoreinfo_note();
-	put_abs_lowcore(abs_lc);
-}
-
 void machine_shutdown(void)
 {
 }
--- a/arch/s390/kernel/Makefile~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/s390/kernel/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_VMCORE_INFO)	+= vmcore_info.o
 obj-$(CONFIG_UPROBES)		+= uprobes.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o
 
--- /dev/null
+++ a/arch/s390/kernel/vmcore_info.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/vmcore_info.h>
+#include <asm/abs_lowcore.h>
+#include <linux/mm.h>
+#include <asm/setup.h>
+
+void arch_crash_save_vmcoreinfo(void)
+{
+	struct lowcore *abs_lc;
+
+	VMCOREINFO_SYMBOL(lowcore_ptr);
+	VMCOREINFO_SYMBOL(high_memory);
+	VMCOREINFO_LENGTH(lowcore_ptr, NR_CPUS);
+	vmcoreinfo_append_str("SAMODE31=%lx\n", (unsigned long)__samode31);
+	vmcoreinfo_append_str("EAMODE31=%lx\n", (unsigned long)__eamode31);
+	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
+	abs_lc = get_abs_lowcore();
+	abs_lc->vmcore_info = paddr_vmcoreinfo_note();
+	put_abs_lowcore(abs_lc);
+}
+
+
--- a/arch/sh/kernel/machine_kexec.c~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/sh/kernel/machine_kexec.c
@@ -137,17 +137,6 @@ void machine_kexec(struct kimage *image)
 	__ftrace_enabled_restore(save_ftrace_enabled);
 }
 
-void arch_crash_save_vmcoreinfo(void)
-{
-#ifdef CONFIG_NUMA
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
-#ifdef CONFIG_X2TLB
-	VMCOREINFO_CONFIG(X2TLB);
-#endif
-}
-
 void __init reserve_crashkernel(void)
 {
 	unsigned long long crash_size, crash_base;
--- a/arch/sh/kernel/Makefile~arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc
+++ a/arch/sh/kernel/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_SH_STANDARD_BIOS)	+= sh_bio
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_MODULES)		+= sh_ksyms_32.o module.o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_VMCORE_INFO)	+= vmcore_info.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_IO_TRAPPED)	+= io_trapped.o
--- /dev/null
+++ a/arch/sh/kernel/vmcore_info.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/vmcore_info.h>
+#include <linux/mm.h>
+
+void arch_crash_save_vmcoreinfo(void)
+{
+#ifdef CONFIG_NUMA
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
+#ifdef CONFIG_X2TLB
+	VMCOREINFO_CONFIG(X2TLB);
+#endif
+}
+
+
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch
panic-suppress-gnu_printf-warning.patch

