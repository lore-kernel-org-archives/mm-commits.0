From: akpm@linux-foundation.org
Subject: + softlockup-fix.patch added to -mm tree
Date: Thu, 07 Feb 2008 14:32:23 -0800
Message-ID: <200802072232.m17MWNmY026083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756718AbYBGWct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 17:32:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     softlockup: fix
has been added to the -mm tree.  Its filename is
     softlockup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: softlockup: fix
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/softlockup.c~softlockup-fix kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-fix
+++ a/kernel/softlockup.c
@@ -288,6 +288,7 @@ cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);
+		wake_up_process(p);
 		per_cpu(watchdog_task, hotcpu) = NULL;
 		kthread_stop(p);
 		break;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
softlockup-fix.patch
documentation-create-new-scheduler-subdirectory.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
smack-unlabeled-outgoing-ambient-packets.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
d_path-make-d_path-use-a-struct-path-fix.patch
proc-fix-the-threaded-proc-self.patch
modules-make-module_address_lookup-safe-fix.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
asm-posix_typesh-scrub-__glibc__.patch
use-find_task_by_vpid-in-posix-timers.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
