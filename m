From: akpm@linux-foundation.org
Subject: - fix-atomicity-of-tif-update-in-flush_thread-for-x86_64.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:03:51 -0800
Message-ID: <200703192203.l2JM3pFM018908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030691AbXCSWEJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, ak@suse.de, rschultz@google.com, mm-commits@vger.kernel.org


The patch titled
     Fix atomicity of TIF update in flush_thread() for x86_64
has been removed from the -mm tree.  Its filename was
     fix-atomicity-of-tif-update-in-flush_thread-for-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix atomicity of TIF update in flush_thread() for x86_64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Fix atomicity of TIF update in flush_thread() for x86_64

Race :

parent process executing :
sys_ptrace()
 (lock_kernel())
 (ptrace_get_task_struct(pid))
 arch_ptrace()
   ptrace_detach()
     ptrace_disable(child);
       clear_singlestep(child);
         clear_tsk_thread_flag(child, TIF_SINGLESTEP);
         (which clears the TIF_SINGLESTEP flag atomically from a different
	  process)
 (put_task_struct(child))
 (unlock_kernel())

And at the same time, in the child process :
sys_execve()
 do_execve()
   search_binary_handler()
     load_elf_binary()
       flush_old_exec()
         flush_thread()
           doing a non-atomic thread flag update

Signed-off-by: Rebecca Schultz <rschultz@google.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/process.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/process.c~fix-atomicity-of-tif-update-in-flush_thread-for-x86_64 arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~fix-atomicity-of-tif-update-in-flush_thread-for-x86_64
+++ a/arch/x86_64/kernel/process.c
@@ -382,14 +382,17 @@ void exit_thread(void)
 void flush_thread(void)
 {
 	struct task_struct *tsk = current;
-	struct thread_info *t = current_thread_info();
 
-	if (t->flags & _TIF_ABI_PENDING) {
-		t->flags ^= (_TIF_ABI_PENDING | _TIF_IA32);
-		if (t->flags & _TIF_IA32)
+	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
+		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
+		if (test_tsk_thread_flag(tsk, TIF_IA32)) {
+			clear_tsk_thread_flag(tsk, TIF_IA32);
+		} else {
+			set_tsk_thread_flag(tsk, TIF_IA32);
 			current_thread_info()->status |= TS_COMPAT;
+		}
 	}
-	t->flags &= ~_TIF_DEBUG;
+	clear_tsk_thread_flag(tsk, TIF_DEBUG);
 
 	tsk->thread.debugreg0 = 0;
 	tsk->thread.debugreg1 = 0;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
