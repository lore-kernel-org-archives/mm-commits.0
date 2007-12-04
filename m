From: akpm@linux-foundation.org
Subject: + git-x86-ptrace-fix.patch added to -mm tree
Date: Tue, 04 Dec 2007 02:58:23 -0800
Message-ID: <200712041058.lB4AwND5013751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60785 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbXLDK6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 05:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     git-x86 ptrace fix
has been added to the -mm tree.  Its filename is
     git-x86-ptrace-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-x86 ptrace fix
From: Ingo Molnar <mingo@elte.hu>

> kernel/ptrace.c: In function `ptrace_resume':
> kernel/ptrace.c:406: error: implicit declaration of function `arch_has_block_step'


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ptrace.h~git-x86-ptrace-fix include/linux/ptrace.h
--- a/include/linux/ptrace.h~git-x86-ptrace-fix
+++ a/include/linux/ptrace.h
@@ -186,7 +186,7 @@ static inline void user_disable_single_s
  * supports step-until-branch for user mode.  It can be a constant or it
  * can test a CPU feature bit.
  */
-#define arch_has_single_step()		(0)
+#define arch_has_block_step()		(0)
 
 /**
  * user_enable_block_step - step until branch in user-mode task
_

Patches currently in -mm which might be from mingo@elte.hu are

get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-acpi.patch
git-alsa.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
git-sched.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
git-x86.patch
git-x86-arch-x86-kernel-ptracec-build-fix.patch
git-x86-ptrace-fix.patch
uml-add-asm-um-asmh.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
git-cryptodev-fixup.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
fix-proc-dcache-deadlock-in-do_exit.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
avoid-overflows-in-kernel-timec.patch
clean-up-drivers-char-rtcc.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
