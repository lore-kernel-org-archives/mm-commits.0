From: akpm@linux-foundation.org
Subject: + mips-implement-save_stack_trace_tsk.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:41:50 -0800
Message-ID: <200811212041.mALKforH001138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbYKUUmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:42:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ralf@linux-mips.org


The patch titled
     mips: implement save_stack_trace_tsk()
has been added to the -mm tree.  Its filename is
     mips-implement-save_stack_trace_tsk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: implement save_stack_trace_tsk()
From: Alexey Dobriyan <adobriyan@gmail.com>

fs/built-in.o(.text.proc_pid_stack+0xc8): In function `proc_pid_stack':
: undefined reference to `save_stack_trace_tsk'

Partially revert ab1b6f03a10ba1f5638188ab06bf46e33ac3a160 aka "simplify
the stacktrace code" for /proc/*/stack et al.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/stacktrace.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN arch/mips/kernel/stacktrace.c~mips-implement-save_stack_trace_tsk arch/mips/kernel/stacktrace.c
--- a/arch/mips/kernel/stacktrace.c~mips-implement-save_stack_trace_tsk
+++ a/arch/mips/kernel/stacktrace.c
@@ -32,7 +32,8 @@ static void save_raw_context_stack(struc
 	}
 }
 
-static void save_context_stack(struct stack_trace *trace, struct pt_regs *regs)
+static void save_context_stack(struct stack_trace *trace,
+	struct task_struct *tsk, struct pt_regs *regs)
 {
 	unsigned long sp = regs->regs[29];
 #ifdef CONFIG_KALLSYMS
@@ -41,7 +42,7 @@ static void save_context_stack(struct st
 
 	if (raw_show_trace || !__kernel_text_address(pc)) {
 		unsigned long stack_page =
-			(unsigned long)task_stack_page(current);
+			(unsigned long)task_stack_page(tsk);
 		if (stack_page && sp >= stack_page &&
 		    sp <= stack_page + THREAD_SIZE - 32)
 			save_raw_context_stack(trace, sp);
@@ -54,7 +55,7 @@ static void save_context_stack(struct st
 			trace->entries[trace->nr_entries++] = pc;
 		if (trace->nr_entries >= trace->max_entries)
 			break;
-		pc = unwind_stack(current, &sp, pc, &ra);
+		pc = unwind_stack(tsk, &sp, pc, &ra);
 	} while (pc);
 #else
 	save_raw_context_stack(trace, sp);
@@ -66,12 +67,23 @@ static void save_context_stack(struct st
  */
 void save_stack_trace(struct stack_trace *trace)
 {
+	save_stack_trace_tsk(current, trace);
+}
+EXPORT_SYMBOL_GPL(save_stack_trace);
+
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
 	struct pt_regs dummyregs;
 	struct pt_regs *regs = &dummyregs;
 
 	WARN_ON(trace->nr_entries || !trace->max_entries);
 
-	prepare_frametrace(regs);
-	save_context_stack(trace, regs);
+	if (tsk != current) {
+		regs->regs[29] = tsk->thread.reg29;
+		regs->regs[31] = 0;
+		regs->cp0_epc = tsk->thread.reg31;
+	} else
+		prepare_frametrace(regs);
+	save_context_stack(trace, tsk, regs);
 }
-EXPORT_SYMBOL_GPL(save_stack_trace);
+EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
tags-skip-in-filenames.patch
kconfig-add-module_name-shortcut.patch
tags-link-from-config_x-to-config-x-as-well.patch
mips-implement-save_stack_trace_tsk.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch
profile-likely-unlikely-macros.patch

