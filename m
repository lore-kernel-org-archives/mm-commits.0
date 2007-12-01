From: akpm@linux-foundation.org
Subject: - lockdep-show-held-locks-when-showing-a-stackdump.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:34 -0800
Message-ID: <200712010024.lB10OYSR032081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbXLAA1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: show held locks when showing a stackdump
has been removed from the -mm tree.  Its filename was
     lockdep-show-held-locks-when-showing-a-stackdump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: show held locks when showing a stackdump
From: Ingo Molnar <mingo@elte.hu>

show held locks when printing a backtrace.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps_32.c |    1 +
 arch/x86/kernel/traps_64.c |    1 +
 kernel/lockdep.c           |   11 +++++++----
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/traps_32.c~lockdep-show-held-locks-when-showing-a-stackdump arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~lockdep-show-held-locks-when-showing-a-stackdump
+++ a/arch/x86/kernel/traps_32.c
@@ -268,6 +268,7 @@ static void show_stack_log_lvl(struct ta
 	}
 	printk("\n%sCall Trace:\n", log_lvl);
 	show_trace_log_lvl(task, regs, esp, log_lvl);
+	debug_show_held_locks(task);
 }
 
 void show_stack(struct task_struct *task, unsigned long *esp)
diff -puN arch/x86/kernel/traps_64.c~lockdep-show-held-locks-when-showing-a-stackdump arch/x86/kernel/traps_64.c
--- a/arch/x86/kernel/traps_64.c~lockdep-show-held-locks-when-showing-a-stackdump
+++ a/arch/x86/kernel/traps_64.c
@@ -350,6 +350,7 @@ show_trace(struct task_struct *tsk, stru
 	printk("\nCall Trace:\n");
 	dump_trace(tsk, regs, stack, &print_trace_ops, NULL);
 	printk("\n");
+	debug_show_held_locks(tsk);
 }
 
 static void
diff -puN kernel/lockdep.c~lockdep-show-held-locks-when-showing-a-stackdump kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-show-held-locks-when-showing-a-stackdump
+++ a/kernel/lockdep.c
@@ -508,7 +508,11 @@ static void print_lock(struct held_lock 
 
 static void lockdep_print_held_locks(struct task_struct *curr)
 {
-	int i, depth = curr->lockdep_depth;
+	int i, depth;
+
+	if (!curr)
+		curr = current;
+	depth = curr->lockdep_depth;
 
 	if (!depth) {
 		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
@@ -3186,7 +3190,6 @@ retry:
 	if (unlock)
 		read_unlock(&tasklist_lock);
 }
-
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
 void debug_show_held_locks(struct task_struct *task)
@@ -3195,9 +3198,9 @@ void debug_show_held_locks(struct task_s
 		printk("INFO: lockdep is turned off.\n");
 		return;
 	}
-	lockdep_print_held_locks(task);
+	if (task == current)
+		lockdep_print_held_locks(task);
 }
-
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
 void lockdep_sys_exit(void)
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
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
uml-add-asm-um-asmh.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
git-cryptodev-fixup.patch
fix-proc-net-breakage.patch
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
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
