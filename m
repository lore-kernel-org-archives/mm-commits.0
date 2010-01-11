From: akpm@linux-foundation.org
Subject: [merged] kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:22 -0800
Message-ID: <201001112018.o0BKIMIW025484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955Ab0AKUiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, mingo@elte.hu, oleg@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/signal.c: fix kernel information leak with print-fatal-signals=1
has been removed from the -mm tree.  Its filename was
     kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/signal.c: fix kernel information leak with print-fatal-signals=1
From: Andi Kleen <andi@firstfloor.org>

When print-fatal-signals is enabled it's possible to dump any memory
reachable by the kernel to the log by simply jumping to that address from
user space.

Or crash the system if there's some hardware with read side effects.

The fatal signals handler will dump 16 bytes at the execution address,
which is fully controlled by ring 3.

In addition when something jumps to a unmapped address there will be up to
16 additional useless page faults, which might be potentially slow (and at
least is not very efficient)

Fortunately this option is off by default and only there on i386.

But fix it by checking for kernel addresses and also stopping when there's
a page fault.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1 kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1
+++ a/kernel/signal.c
@@ -979,7 +979,8 @@ static void print_fatal_signal(struct pt
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
-			__get_user(insn, (unsigned char *)(regs->ip + i));
+			if (get_user(insn, (unsigned char *)(regs->ip + i)))
+				break;
 			printk("%02x ", insn);
 		}
 	}
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
mm-add-swap-slot-free-callback-to-block_device_operations.patch
ramzswap-use-slot-free-callback-to-eliminate-stale-data.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

