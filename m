From: akpm@linux-foundation.org
Subject: - idle_regs-must-be-__cpuinit.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:03 -0800
Message-ID: <200802070024.m170OikZ006641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933022AbYBGAqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     idle_regs() must be __cpuinit
has been removed from the -mm tree.  Its filename was
     idle_regs-must-be-__cpuinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idle_regs() must be __cpuinit
From: Adrian Bunk <bunk@kernel.org>

Fix the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

WARNING: vmlinux.o(.text+0x399a6): Section mismatch: reference to .init.text.5:idle_regs (between 'fork_idle' and 'get_task_mm')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c   |    2 +-
 arch/x86/kernel/cpu/common.c |    2 +-
 kernel/fork.c                |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/smpboot.c~idle_regs-must-be-__cpuinit arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~idle_regs-must-be-__cpuinit
+++ a/arch/ia64/kernel/smpboot.c
@@ -476,7 +476,7 @@ start_secondary (void *unused)
 	return 0;
 }
 
-struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	return NULL;
 }
diff -puN arch/x86/kernel/cpu/common.c~idle_regs-must-be-__cpuinit arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~idle_regs-must-be-__cpuinit
+++ a/arch/x86/kernel/cpu/common.c
@@ -637,7 +637,7 @@ void __init early_cpu_init(void)
 }
 
 /* Make sure %fs is initialized properly in idle threads */
-struct pt_regs * __devinit idle_regs(struct pt_regs *regs)
+struct pt_regs * __cpuinit idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	regs->fs = __KERNEL_PERCPU;
diff -puN kernel/fork.c~idle_regs-must-be-__cpuinit kernel/fork.c
--- a/kernel/fork.c~idle_regs-must-be-__cpuinit
+++ a/kernel/fork.c
@@ -1399,7 +1399,7 @@ fork_out:
 	return ERR_PTR(retval);
 }
 
-noinline struct pt_regs * __devinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
+noinline struct pt_regs * __cpuinit __attribute__((weak)) idle_regs(struct pt_regs *regs)
 {
 	memset(regs, 0, sizeof(struct pt_regs));
 	return regs;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
powerpc-vdso_do_func_patch3264-must-be-__init.patch
powerpc-free_property-mustnt-be-__init.patch
hvc_rtas_init-must-be-__init.patch
git-dvb.patch
git-gfs2-nmw.patch
git-mtd.patch
git-ocfs2.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
git-xtensa.patch
move-edactxt-two-levels-up.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
kill-udffs_dateversion.patch
the-scheduled-time-option-removal.patch
reiser4.patch
