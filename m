Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE6625
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738934; cv=none; b=BB6ZPI1Jm3FqqOmaduMuXMUNq87xba+Do8FX85Vzv5ZCzd6UB/K3gNfUHTeczxbqKqAeLwqj4WXzA2jqo1MDbc1bzOFcf7hq2SRyxqh1JgDwbel8XbrXBLT4EONrz5goJZoEh1z8uoa2zVmL44keGx577FL0FnvuQwSpS/Y/4Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738934; c=relaxed/simple;
	bh=I0Nnraltuz1fZu1IW9YPvDjgzXHrVJvMTi7moQE0vvM=;
	h=Date:To:From:Subject:Message-Id; b=Mrn9LEbgGhwRontmgn7sV2NhnMMG0BtO8k89YC7fEAn+6GbmgptjmwwvQoozpA5bHbO13B/S62eozZAYzzjHNCT29EmB7VfLG3IeHJxUcIoTV7SWYRylITkdYpQbzvoRdFe2TNBgWxkVPXcjFHV/YDzAA4b7erPl6E/YYJCMm6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QQwHuFmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QQwHuFmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C10C433C7;
	Sat, 24 Feb 2024 01:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738933;
	bh=I0Nnraltuz1fZu1IW9YPvDjgzXHrVJvMTi7moQE0vvM=;
	h=Date:To:From:Subject:From;
	b=QQwHuFmT3v9g1LyUFFV35mW+bX17a15y/kBu95U7pwcgO/pyRuGJMqu5AYFeQaIwh
	 zi6Tu23mPYSq5UC8NX4vwnZnMgbpqUobgn9Klo0BC+mWsvmRc0qtcsmK4f4tEsSaAm
	 +kGXbwBINaFcahzg2/HyzU5QZbSnaRs8srL43OLE=
Date: Fri, 23 Feb 2024 17:42:12 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch removed from -mm tree
Message-Id: <20240224014213.B7C10C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86, crash: don't nest CONFIG_CRASH_DUMP ifdef inside CONFIG_KEXEC_CODE ifdef scope
has been removed from the -mm tree.  Its filename was
     x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch

This patch was dropped because it was folded into x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: x86, crash: don't nest CONFIG_CRASH_DUMP ifdef inside CONFIG_KEXEC_CODE ifdef scope
Date: Tue, 30 Jan 2024 10:59:59 +0800

Michael pointed out that the CONFIG_CRASH_DUMP ifdef is nested inside
CONFIG_KEXEC_CODE ifdef scope in some XEN, Hyper-V codes.

Although the nesting works well too since CONFIG_CRASH_DUMP has
dependency on CONFIG_KEXEC_CORE, it may cause confusion because there
are places where it's not nested, and people may think it needs to be
nested even though it doesn't have to.

Fix that by moving  CONFIG_CRASH_DUMP ifdeffery of codes out of
CONFIG_KEXEC_CODE ifdeffery scope.

And also put function machine_crash_shutdown() definition inside
CONFIG_CRASH_DUMP ifdef scope instead of CONFIG_KEXEC_CORE ifdef.

And also fix a building error Nathan reported as below by replacing
CONFIG_KEXEC_CORE ifdef with CONFIG_VMCORE_INFO ifdef.

====
$ curl -LSso .config https://git.alpinelinux.org/aports/plain/community/linux-edge/config-edge.x86_64
$ make -skj"$(nproc)" ARCH=x86_64 CROSS_COMPILE=x86_64-linux- olddefconfig all
..
x86_64-linux-ld: arch/x86/xen/mmu_pv.o: in function `paddr_vmcoreinfo_note':
mmu_pv.c:(.text+0x3af3): undefined reference to `vmcoreinfo_note'
====

Link: https://lore.kernel.org/all/SN6PR02MB4157931105FA68D72E3D3DB8D47B2@SN6PR02MB4157.namprd02.prod.outlook.com/T/#u
Link: https://lore.kernel.org/all/20240126045551.GA126645@dev-arch.thelio-3990X/T/#u
Link: https://lkml.kernel.org/r/ZbhmL/jQtZ7TFZqV@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mshyperv.c |   10 ++++++----
 arch/x86/kernel/reboot.c       |    2 +-
 arch/x86/xen/enlighten_hvm.c   |    4 ++--
 arch/x86/xen/mmu_pv.c          |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/mshyperv.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix
+++ a/arch/x86/kernel/cpu/mshyperv.c
@@ -209,6 +209,7 @@ static void hv_machine_shutdown(void)
 	if (kexec_in_progress)
 		hyperv_cleanup();
 }
+#endif /* CONFIG_KEXEC_CORE */
 
 #ifdef CONFIG_CRASH_DUMP
 static void hv_machine_crash_shutdown(struct pt_regs *regs)
@@ -222,8 +223,7 @@ static void hv_machine_crash_shutdown(st
 	/* Disable the hypercall page when there is only 1 active CPU. */
 	hyperv_cleanup();
 }
-#endif
-#endif /* CONFIG_KEXEC_CORE */
+#endif /* CONFIG_CRASH_DUMP */
 #endif /* CONFIG_HYPERV */
 
 static uint32_t  __init ms_hyperv_platform(void)
@@ -497,9 +497,11 @@ static void __init ms_hyperv_init_platfo
 	no_timer_check = 1;
 #endif
 
-#if IS_ENABLED(CONFIG_HYPERV) && defined(CONFIG_KEXEC_CORE)
+#if IS_ENABLED(CONFIG_HYPERV)
+#if defined(CONFIG_KEXEC_CORE)
 	machine_ops.shutdown = hv_machine_shutdown;
-#ifdef CONFIG_CRASH_DUMP
+#endif
+#if defined(CONFIG_CRASH_DUMP)
 	machine_ops.crash_shutdown = hv_machine_crash_shutdown;
 #endif
 #endif
--- a/arch/x86/kernel/reboot.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix
+++ a/arch/x86/kernel/reboot.c
@@ -826,7 +826,7 @@ void machine_halt(void)
 	machine_ops.halt();
 }
 
-#ifdef CONFIG_KEXEC_CORE
+#ifdef CONFIG_CRASH_DUMP
 void machine_crash_shutdown(struct pt_regs *regs)
 {
 	machine_ops.crash_shutdown(regs);
--- a/arch/x86/xen/enlighten_hvm.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix
+++ a/arch/x86/xen/enlighten_hvm.c
@@ -148,6 +148,7 @@ static void xen_hvm_shutdown(void)
 	if (kexec_in_progress)
 		xen_reboot(SHUTDOWN_soft_reset);
 }
+#endif
 
 #ifdef CONFIG_CRASH_DUMP
 static void xen_hvm_crash_shutdown(struct pt_regs *regs)
@@ -156,7 +157,6 @@ static void xen_hvm_crash_shutdown(struc
 	xen_reboot(SHUTDOWN_soft_reset);
 }
 #endif
-#endif
 
 static int xen_cpu_up_prepare_hvm(unsigned int cpu)
 {
@@ -238,10 +238,10 @@ static void __init xen_hvm_guest_init(vo
 
 #ifdef CONFIG_KEXEC_CORE
 	machine_ops.shutdown = xen_hvm_shutdown;
+#endif
 #ifdef CONFIG_CRASH_DUMP
 	machine_ops.crash_shutdown = xen_hvm_crash_shutdown;
 #endif
-#endif
 }
 
 static __init int xen_parse_nopv(char *arg)
--- a/arch/x86/xen/mmu_pv.c~x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix
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

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
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

