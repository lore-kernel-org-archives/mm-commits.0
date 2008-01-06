From: akpm@linux-foundation.org
Subject: + suspend-latency-shorten-codec-read.patch added to -mm tree
Date: Sun, 06 Jan 2008 11:51:55 -0800
Message-ID: <200801061951.m06JpZFv023976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbYAFTwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jan 2008 14:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, perex@suse.cz, tiwai@suse.de


The patch titled
     suspend latency: shorten codec read
has been added to the -mm tree.  Its filename is
     suspend-latency-shorten-codec-read.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: suspend latency: shorten codec read
From: Ingo Molnar <mingo@elte.hu>

Not sleeping for every codec read/write but doing a short udelay and a
conditional reschedule has cut suspend+resume latency by about 1 second on
my T60.

The patch also fixes the unexpected codec-connection errors that
happen more often in the new power-save mode:
    http://lkml.org/lkml/2007/11/8/255
    http://bugzilla.kernel.org/show_bug.cgi?id=9332

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN sound/pci/hda/hda_intel.c~suspend-latency-shorten-codec-read sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~suspend-latency-shorten-codec-read
+++ a/sound/pci/hda/hda_intel.c
@@ -555,7 +555,8 @@ static unsigned int azx_rirb_get_respons
 		}
 		if (!chip->rirb.cmds)
 			return chip->rirb.res; /* the last value */
-		schedule_timeout_uninterruptible(1);
+		udelay(10);
+		cond_resched();
 	} while (time_after_eq(timeout, jiffies));
 
 	if (chip->msi) {
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
suspend-latency-shorten-codec-read.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
git-alsa.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
kvm-ist-kaput.patch
pci-disable-decoding-during-sizing-of-bars.patch
git-sched.patch
git-sched-fixup.patch
git-sched-fix-preempt-rcu-on-non-preemptible-architectures.patch
git-x86.patch
git-x86-fixup.patch
git-x86-arch-x86-math-emu-errorsc-fix-printk-warnings.patch
git-x86-drivers-pnp-pnpbios-bioscallsc-build-fix.patch
git-x86-fix-doubly-merged-patch.patch
git-x86-export-leave_mm.patch
x86-fix-system-gate-related-crash.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes-checkpatch-fixes.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-cryptodev-fixup.patch
fix-rtc_aie-with-config_hpet_emulate_rtc.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
fix-proc-dcache-deadlock-in-do_exit.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
debug_smp_processor_id-fixlets.patch
avoid-overflows-in-kernel-timec.patch
make-sys_poll-wait-at-least-timeout-ms.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-move-stack_top-to-asm-processorh-fix.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
