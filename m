Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1B5811B
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970647; cv=none; b=QmeiONQres1cajVNFSmD8tcNkg4bGu191iUOE1PD/yzqLRra4FUUh/qCTfxY5lrbZobBwik9cfsrzh1IaRyeyWSsATY48T2HmF4lcw8enyGWJK699I6qx10ChrdF/BhABvpBqW+srICElaTA+XEGJXnu17oKAXLXuo8fZmfbMT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970647; c=relaxed/simple;
	bh=2NbhqpzYtxAlBCfYHWW1vr6iVfsXCVdI0mcysRiQWv0=;
	h=Date:To:From:Subject:Message-Id; b=cgtD19xIfVzBwqZUXvoKEPTPWTecuq82xP09WZ/vD0PmzjOLxmdSxGy6YXuJXqBMCQjF44Gxyy22aQ8P45oNSJhYLUl67kPlXKQA+nUKLTeIcE/xakbzPN0oE4ZFg16AAR4t/rojlF6s7chtp8p5ZQR2gipOEOLnuuKUi3KG6QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2iu2ERQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2iu2ERQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125DEC43390;
	Tue, 23 Jan 2024 00:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970647;
	bh=2NbhqpzYtxAlBCfYHWW1vr6iVfsXCVdI0mcysRiQWv0=;
	h=Date:To:From:Subject:From;
	b=2iu2ERQC904Tmp3X/xLaaxBV53nVbERwi8SYfDwjiVcz/ugM59TLu9h0SEUFpyf39
	 9j5NQvqqhtlhgL893vqAJ3gTCxUl392dcAhgK6riFyao5IIfRgFflcKAE5mQ3Pai7K
	 VjMm9MFEV+L1anPzr0y/zWDiYsT+xa3X+srdTGxU=
Date: Mon, 22 Jan 2024 16:44:04 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch added to mm-unstable branch
Message-Id: <20240123004407.125DEC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86, crash: wrap crash dumping code into crash related ifdefs
has been added to the -mm mm-unstable branch.  Its filename is
     x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

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
Subject: x86, crash: wrap crash dumping code into crash related ifdefs
Date: Fri, 19 Jan 2024 22:52:33 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on x86 with some adjustments.

Here, also change some ifdefs or IS_ENABLED() check to more appropriate
ones, e,g
 - #ifdef CONFIG_KEXEC_CORE -> #ifdef CONFIG_CRASH_DUMP
 - (!IS_ENABLED(CONFIG_KEXEC_CORE)) - > (!IS_ENABLED(CONFIG_CRASH_RESERVE))

Link: https://lkml.kernel.org/r/20240119145241.769622-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile           |    4 ++--
 arch/x86/kernel/cpu/mshyperv.c     |    4 ++++
 arch/x86/kernel/kexec-bzimage64.c  |    4 ++++
 arch/x86/kernel/kvm.c              |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    3 +++
 arch/x86/kernel/reboot.c           |    2 +-
 arch/x86/kernel/setup.c            |    2 +-
 arch/x86/kernel/smp.c              |    2 +-
 arch/x86/xen/enlighten_hvm.c       |    4 ++++
 9 files changed, 22 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/mshyperv.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/cpu/mshyperv.c
@@ -210,6 +210,7 @@ static void hv_machine_shutdown(void)
 		hyperv_cleanup();
 }
 
+#ifdef CONFIG_CRASH_DUMP
 static void hv_machine_crash_shutdown(struct pt_regs *regs)
 {
 	if (hv_crash_handler)
@@ -221,6 +222,7 @@ static void hv_machine_crash_shutdown(st
 	/* Disable the hypercall page when there is only 1 active CPU. */
 	hyperv_cleanup();
 }
+#endif
 #endif /* CONFIG_KEXEC_CORE */
 #endif /* CONFIG_HYPERV */
 
@@ -497,8 +499,10 @@ static void __init ms_hyperv_init_platfo
 
 #if IS_ENABLED(CONFIG_HYPERV) && defined(CONFIG_KEXEC_CORE)
 	machine_ops.shutdown = hv_machine_shutdown;
+#ifdef CONFIG_CRASH_DUMP
 	machine_ops.crash_shutdown = hv_machine_crash_shutdown;
 #endif
+#endif
 	if (ms_hyperv.features & HV_ACCESS_TSC_INVARIANT) {
 		/*
 		 * Writing to synthetic MSR 0x40000118 updates/changes the
--- a/arch/x86/kernel/kexec-bzimage64.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -263,11 +263,13 @@ setup_boot_parameters(struct kimage *ima
 	memset(&params->hd0_info, 0, sizeof(params->hd0_info));
 	memset(&params->hd1_info, 0, sizeof(params->hd1_info));
 
+#ifdef CONFIG_CRASH_DUMP
 	if (image->type == KEXEC_TYPE_CRASH) {
 		ret = crash_setup_memmap_entries(image, params);
 		if (ret)
 			return ret;
 	} else
+#endif
 		setup_e820_entries(params);
 
 	nr_e820_entries = params->e820_entries;
@@ -433,12 +435,14 @@ static void *bzImage64_load(struct kimag
 		return ERR_PTR(-EINVAL);
 	}
 
+#ifdef CONFIG_CRASH_DUMP
 	/* Allocate and load backup region */
 	if (image->type == KEXEC_TYPE_CRASH) {
 		ret = crash_load_segments(image);
 		if (ret)
 			return ERR_PTR(ret);
 	}
+#endif
 
 	/*
 	 * Load purgatory. For 64bit entry point, purgatory  code can be
--- a/arch/x86/kernel/kvm.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/kvm.c
@@ -769,7 +769,7 @@ static struct notifier_block kvm_pv_rebo
  * won't be valid. In cases like kexec, in which you install a new kernel, this
  * means a random memory location will be kept being written.
  */
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_DUMP
 static void kvm_crash_shutdown(struct pt_regs *regs)
 {
 	kvm_guest_cpu_offline(true);
@@ -852,7 +852,7 @@ static void __init kvm_guest_init(void)
 	kvm_guest_cpu_init();
 #endif
 
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_DUMP
 	machine_ops.crash_shutdown = kvm_crash_shutdown;
 #endif
 
--- a/arch/x86/kernel/machine_kexec_64.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -508,6 +508,8 @@ int arch_kimage_file_post_load_cleanup(s
 }
 #endif /* CONFIG_KEXEC_FILE */
 
+#ifdef CONFIG_CRASH_DUMP
+
 static int
 kexec_mark_range(unsigned long start, unsigned long end, bool protect)
 {
@@ -552,6 +554,7 @@ void arch_kexec_unprotect_crashkres(void
 {
 	kexec_mark_crashkres(false);
 }
+#endif
 
 /*
  * During a traditional boot under SME, SME will encrypt the kernel,
--- a/arch/x86/kernel/Makefile~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/Makefile
@@ -100,9 +100,9 @@ obj-$(CONFIG_TRACING)		+= trace.o
 obj-$(CONFIG_RETHOOK)		+= rethook.o
 obj-$(CONFIG_VMCORE_INFO)	+= vmcore_info_$(BITS).o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec_$(BITS).o
-obj-$(CONFIG_KEXEC_CORE)	+= relocate_kernel_$(BITS).o crash.o
+obj-$(CONFIG_KEXEC_CORE)	+= relocate_kernel_$(BITS).o
 obj-$(CONFIG_KEXEC_FILE)	+= kexec-bzimage64.o
-obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
+obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o crash.o
 obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_X86_32)		+= doublefault_32.o
--- a/arch/x86/kernel/reboot.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/reboot.c
@@ -796,7 +796,7 @@ struct machine_ops machine_ops __ro_afte
 	.emergency_restart = native_machine_emergency_restart,
 	.restart = native_machine_restart,
 	.halt = native_machine_halt,
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_DUMP
 	.crash_shutdown = native_machine_crash_shutdown,
 #endif
 };
--- a/arch/x86/kernel/setup.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/setup.c
@@ -471,7 +471,7 @@ static void __init arch_reserve_crashker
 	bool high = false;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
--- a/arch/x86/kernel/smp.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/smp.c
@@ -282,7 +282,7 @@ struct smp_ops smp_ops = {
 	.smp_cpus_done		= native_smp_cpus_done,
 
 	.stop_other_cpus	= native_stop_other_cpus,
-#if defined(CONFIG_KEXEC_CORE)
+#if defined(CONFIG_CRASH_DUMP)
 	.crash_stop_other_cpus	= kdump_nmi_shootdown_cpus,
 #endif
 	.smp_send_reschedule	= native_smp_send_reschedule,
--- a/arch/x86/xen/enlighten_hvm.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/xen/enlighten_hvm.c
@@ -149,12 +149,14 @@ static void xen_hvm_shutdown(void)
 		xen_reboot(SHUTDOWN_soft_reset);
 }
 
+#ifdef CONFIG_CRASH_DUMP
 static void xen_hvm_crash_shutdown(struct pt_regs *regs)
 {
 	native_machine_crash_shutdown(regs);
 	xen_reboot(SHUTDOWN_soft_reset);
 }
 #endif
+#endif
 
 static int xen_cpu_up_prepare_hvm(unsigned int cpu)
 {
@@ -236,8 +238,10 @@ static void __init xen_hvm_guest_init(vo
 
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.shutdown = xen_hvm_shutdown;
+#ifdef CONFIG_CRASH_DUMP
 	machine_ops.crash_shutdown = xen_hvm_crash_shutdown;
 #endif
+#endif
 }
 
 static __init int xen_parse_nopv(char *arg)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
panic-suppress-gnu_printf-warning.patch

