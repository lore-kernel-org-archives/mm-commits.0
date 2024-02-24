Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20EF6FB0
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739393; cv=none; b=TvTCY5w7KWWSfDoqhuDqoAPxL1F05jYL0fKfA3yZYerc1f+7fMXj6e8gmuDf0d7FyWZ9Z1HVc6GrcKUKSUKFEoVtb6hW+q6JuQwj8wrWzDWaOA2Fz34gk8cZRHzN6RZoEeTFc1DxCYGfIpmUkS1EDjXaGNmGbR5Yt2Q8euLk/ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739393; c=relaxed/simple;
	bh=CzifkecR8PH9QKUcN3dUDAUbj1yGKEzkyzp+kB3XuBY=;
	h=Date:To:From:Subject:Message-Id; b=hEawTxFetZQcZBJxjiiKZollKq2CXWWv22+jM+75IBkozSX2NbwuQleMZp+T+/j7CaKq/Ym/AJyNHYzuvtSmOaIPdNzlna1qz6zlWfzlPxOYJOLICHKzFszjPiLQ/VjUENIRvXRzT4ANCaR+HvBGItYaoP6WUCYa4Z6oAjIFBeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aLjXhlCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aLjXhlCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D9DC433C7;
	Sat, 24 Feb 2024 01:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739393;
	bh=CzifkecR8PH9QKUcN3dUDAUbj1yGKEzkyzp+kB3XuBY=;
	h=Date:To:From:Subject:From;
	b=aLjXhlCm92w3eb1Nfd9igf9WqE5suQfkgjPcpFuB0utkTxuNWOf+ivlQCfpxQwZko
	 JRcacKtr+lw3NXphaMqR4FYP8/X8DcZRhNbFqqBqt8kbNV8hWa55BQjStW2w1KUh5z
	 Mp0neDnZtUN0Y/2f+Eh6q3YQAxDD5hP3xQC0jaaU=
Date: Fri, 23 Feb 2024 17:49:53 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224014953.A5D9DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: x86, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:46 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on x86 with some adjustments.

Here, also change some ifdefs or IS_ENABLED() check to more appropriate
ones, e,g
 - #ifdef CONFIG_KEXEC_CORE -> #ifdef CONFIG_CRASH_DUMP
 - (!IS_ENABLED(CONFIG_KEXEC_CORE)) - > (!IS_ENABLED(CONFIG_CRASH_RESERVE))

[bhe@redhat.com: don't nest CONFIG_CRASH_DUMP ifdef inside CONFIG_KEXEC_CODE ifdef scope]
  Link: https://lore.kernel.org/all/SN6PR02MB4157931105FA68D72E3D3DB8D47B2@SN6PR02MB4157.namprd02.prod.outlook.com/T/#u
Link: https://lkml.kernel.org/r/20240124051254.67105-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile           |    4 ++--
 arch/x86/kernel/cpu/mshyperv.c     |   10 ++++++++--
 arch/x86/kernel/kexec-bzimage64.c  |    4 ++++
 arch/x86/kernel/kvm.c              |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    3 +++
 arch/x86/kernel/reboot.c           |    4 ++--
 arch/x86/kernel/setup.c            |    2 +-
 arch/x86/kernel/smp.c              |    2 +-
 arch/x86/xen/enlighten_hvm.c       |    4 ++++
 arch/x86/xen/mmu_pv.c              |    2 +-
 10 files changed, 28 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/mshyperv.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/kernel/cpu/mshyperv.c
@@ -209,7 +209,9 @@ static void hv_machine_shutdown(void)
 	if (kexec_in_progress)
 		hyperv_cleanup();
 }
+#endif /* CONFIG_KEXEC_CORE */
 
+#ifdef CONFIG_CRASH_DUMP
 static void hv_machine_crash_shutdown(struct pt_regs *regs)
 {
 	if (hv_crash_handler)
@@ -221,7 +223,7 @@ static void hv_machine_crash_shutdown(st
 	/* Disable the hypercall page when there is only 1 active CPU. */
 	hyperv_cleanup();
 }
-#endif /* CONFIG_KEXEC_CORE */
+#endif /* CONFIG_CRASH_DUMP */
 #endif /* CONFIG_HYPERV */
 
 static uint32_t  __init ms_hyperv_platform(void)
@@ -495,10 +497,14 @@ static void __init ms_hyperv_init_platfo
 	no_timer_check = 1;
 #endif
 
-#if IS_ENABLED(CONFIG_HYPERV) && defined(CONFIG_KEXEC_CORE)
+#if IS_ENABLED(CONFIG_HYPERV)
+#if defined(CONFIG_KEXEC_CORE)
 	machine_ops.shutdown = hv_machine_shutdown;
+#endif
+#if defined(CONFIG_CRASH_DUMP)
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
@@ -770,7 +770,7 @@ static struct notifier_block kvm_pv_rebo
  * won't be valid. In cases like kexec, in which you install a new kernel, this
  * means a random memory location will be kept being written.
  */
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_DUMP
 static void kvm_crash_shutdown(struct pt_regs *regs)
 {
 	kvm_guest_cpu_offline(true);
@@ -853,7 +853,7 @@ static void __init kvm_guest_init(void)
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
@@ -826,7 +826,7 @@ void machine_halt(void)
 	machine_ops.halt();
 }
 
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
 {
 	machine_ops.crash_shutdown(regs);
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
@@ -148,7 +148,9 @@ static void xen_hvm_shutdown(void)
 	if (kexec_in_progress)
 		xen_reboot(SHUTDOWN_soft_reset);
 }
+#endif
 
+#ifdef CONFIG_CRASH_DUMP
 static void xen_hvm_crash_shutdown(struct pt_regs *regs)
 {
 	native_machine_crash_shutdown(regs);
@@ -236,6 +238,8 @@ static void __init xen_hvm_guest_init(vo
 
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.shutdown = xen_hvm_shutdown;
+#endif
+#ifdef CONFIG_CRASH_DUMP
 	machine_ops.crash_shutdown = xen_hvm_crash_shutdown;
 #endif
 }
--- a/arch/x86/xen/mmu_pv.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/x86/xen/mmu_pv.c
@@ -2520,7 +2520,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(xen_remap_pfn);
 
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_VMCORE_INFO
 phys_addr_t paddr_vmcoreinfo_note(void)
 {
 	if (xen_pv_domain())
_

Patches currently in -mm which might be from bhe@redhat.com are


