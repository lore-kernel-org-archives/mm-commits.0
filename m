From: akpm@linux-foundation.org
Subject: + fix-atomicity-of-tif-update-in-flush_thread-for-powerpc.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:51:43 -0800
Message-ID: <200703110751.l2B7phET007321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39162 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXCKHv4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Fix atomicity of TIF update in flush_thread() for powerpc
has been added to the -mm tree.  Its filename is
     fix-atomicity-of-tif-update-in-flush_thread-for-powerpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix atomicity of TIF update in flush_thread() for powerpc
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Fix atomicity of TIF update in flush_thread() for powerpc

Fixes it correctly with *_ti_thread_flag.

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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/process.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/process.c~fix-atomicity-of-tif-update-in-flush_thread-for-powerpc arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~fix-atomicity-of-tif-update-in-flush_thread-for-powerpc
+++ a/arch/powerpc/kernel/process.c
@@ -465,8 +465,13 @@ void flush_thread(void)
 #ifdef CONFIG_PPC64
 	struct thread_info *t = current_thread_info();
 
-	if (t->flags & _TIF_ABI_PENDING)
-		t->flags ^= (_TIF_ABI_PENDING | _TIF_32BIT);
+	if (test_ti_thread_flag(t, TIF_ABI_PENDING)) {
+		clear_ti_thread_flag(t, TIF_ABI_PENDING);
+		if (test_ti_thread_flag(t, TIF_32BIT))
+			clear_ti_thread_flag(t, TIF_32BIT);
+		else
+			set_ti_thread_flag(t, TIF_32BIT);
+	}
 #endif
 
 	discard_lazy_cpu_state();
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

fix-atomicity-of-tif-update-in-flush_thread-for-powerpc.patch
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
