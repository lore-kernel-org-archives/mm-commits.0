From: akpm@linux-foundation.org
Subject: [merged] x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch removed from -mm tree
Date: Mon, 16 May 2011 12:37:05 -0700
Message-ID: <201105161936.p4GJaoFE014244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab1EPTg7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 May 2011 15:36:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     x86: remove warning and warning_symbol from struct stacktrace_ops
has been removed from the -mm tree.  Its filename was
     x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove warning and warning_symbol from struct stacktrace_ops
From: Richard Weinberger <richard@nod.at>

Both warning and warning_symbol are nowhere used.  Let's get rid of them.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/stacktrace.h |    3 ---
 arch/x86/kernel/cpu/perf_event.c  |   13 -------------
 arch/x86/kernel/dumpstack.c       |   16 ----------------
 arch/x86/kernel/stacktrace.c      |   13 -------------
 arch/x86/oprofile/backtrace.c     |   13 -------------
 5 files changed, 58 deletions(-)

diff -puN arch/x86/include/asm/stacktrace.h~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/x86/include/asm/stacktrace.h
--- a/arch/x86/include/asm/stacktrace.h~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/x86/include/asm/stacktrace.h
@@ -37,9 +37,6 @@ print_context_stack_bp(struct thread_inf
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
-	void (*warning)(void *data, char *msg);
-	/* msg must contain %s for the symbol */
-	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
diff -puN arch/x86/kernel/cpu/perf_event.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/x86/kernel/cpu/perf_event.c
--- a/arch/x86/kernel/cpu/perf_event.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/x86/kernel/cpu/perf_event.c
@@ -1773,17 +1773,6 @@ static struct pmu pmu = {
  * callchain support
  */
 
-static void
-backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	return 0;
@@ -1797,8 +1786,6 @@ static void backtrace_address(void *data
 }
 
 static const struct stacktrace_ops backtrace_ops = {
-	.warning		= backtrace_warning,
-	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
 	.walk_stack		= print_context_stack_bp,
diff -puN arch/x86/kernel/dumpstack.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/x86/kernel/dumpstack.c
--- a/arch/x86/kernel/dumpstack.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/x86/kernel/dumpstack.c
@@ -135,20 +135,6 @@ print_context_stack_bp(struct thread_inf
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
 
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
 static int print_trace_stack(void *data, char *name)
 {
 	printk("%s <%s> ", (char *)data, name);
@@ -166,8 +152,6 @@ static void print_trace_address(void *da
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning		= print_trace_warning,
-	.warning_symbol		= print_trace_warning_symbol,
 	.stack			= print_trace_stack,
 	.address		= print_trace_address,
 	.walk_stack		= print_context_stack,
diff -puN arch/x86/kernel/stacktrace.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/x86/kernel/stacktrace.c
--- a/arch/x86/kernel/stacktrace.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/x86/kernel/stacktrace.c
@@ -9,15 +9,6 @@
 #include <linux/uaccess.h>
 #include <asm/stacktrace.h>
 
-static void save_stack_warning(void *data, char *msg)
-{
-}
-
-static void
-save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-}
-
 static int save_stack_stack(void *data, char *name)
 {
 	return 0;
@@ -53,16 +44,12 @@ save_stack_address_nosched(void *data, u
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address,
 	.walk_stack	= print_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address_nosched,
 	.walk_stack	= print_context_stack,
diff -puN arch/x86/oprofile/backtrace.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/x86/oprofile/backtrace.c
--- a/arch/x86/oprofile/backtrace.c~x86-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/x86/oprofile/backtrace.c
@@ -16,17 +16,6 @@
 #include <asm/stacktrace.h>
 #include <linux/compat.h>
 
-static void backtrace_warning_symbol(void *data, char *msg,
-				     unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	/* Yes, we want all stacks */
@@ -42,8 +31,6 @@ static void backtrace_address(void *data
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning	= backtrace_warning,
-	.warning_symbol	= backtrace_warning_symbol,
 	.stack		= backtrace_stack,
 	.address	= backtrace_address,
 	.walk_stack	= print_context_stack,
_

Patches currently in -mm which might be from richard@nod.at are

um-fix-abort.patch
linux-next.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch
sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch
um-os_dump_core-cleanup.patch
um-fix-uml_lib_path.patch
um-remove-sighup-handler.patch
lib-consolidate-debug_stack_usage-option.patch

