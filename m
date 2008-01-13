From: akpm@linux-foundation.org
Subject: - x86-fix-do_fork_idle-section-mismatch.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:25 -0800
Message-ID: <200801131133.m0DBX59W009814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbYAMLdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: fix do_fork_idle section mismatch
has been removed from the -mm tree.  Its filename was
     x86-fix-do_fork_idle-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix do_fork_idle section mismatch
From: Thomas Gleixner <tglx@linutronix.de>

With CPU_HOTPLUG=n:

WARNING: vmlinux.o(.text+0x104f8): Section mismatch: reference to .init.text:fork_idle (between
'do_fork_idle' and 'lapic_timer_broadcast')

do_fork_idle() needs to be __cpuinit. It can be static as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/smpboot_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/smpboot_64.c~x86-fix-do_fork_idle-section-mismatch arch/x86/kernel/smpboot_64.c
--- a/arch/x86/kernel/smpboot_64.c~x86-fix-do_fork_idle-section-mismatch
+++ a/arch/x86/kernel/smpboot_64.c
@@ -526,7 +526,7 @@ struct create_idle {
 	int cpu;
 };
 
-void do_fork_idle(struct work_struct *work)
+static void __cpuinit do_fork_idle(struct work_struct *work)
 {
 	struct create_idle *c_idle =
 		container_of(work, struct create_idle, work);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
kick-cpus-that-might-be-sleeping-in-cpus_idle_wait.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-arm.patch
git-hrt.patch
revert-git-hrt.patch
pci-disable-decoding-during-sizing-of-bars.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
serverworks-irq-routing-needs-no-_p.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-cryptodev-fixup.patch
fix-rtc_aie-with-config_hpet_emulate_rtc.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
proc-loadavg-reading-race.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
avoid-overflows-in-kernel-timec.patch
make-sys_poll-wait-at-least-timeout-ms.patch
system-timer-fix-crash-in-100hz-system-timer.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
asic3-driver.patch
asic3-driver-update.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
itimer_real-convert-to-use-struct-pid.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-fix.patch
efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
