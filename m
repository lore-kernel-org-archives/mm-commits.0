From: akpm@linux-foundation.org
Subject: [merged] sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch removed from -mm tree
Date: Tue, 24 May 2011 11:55:12 -0700
Message-ID: <201105241853.p4OIrjE3008420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755105Ab1EXSy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 14:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: remove warning and warning_symbol from struct stacktrace_ops
has been removed from the -mm tree.  Its filename was
     sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: remove warning and warning_symbol from struct stacktrace_ops
From: Richard Weinberger <richard@nod.at>

Both warning and warning_symbol are nowhere used.  Let's get rid of them.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/stacktrace.h |    3 ---
 arch/sh/kernel/dumpstack.c       |   15 ---------------
 arch/sh/kernel/perf_callchain.c  |   12 ------------
 arch/sh/kernel/stacktrace.c      |   13 -------------
 arch/sh/oprofile/backtrace.c     |   13 -------------
 5 files changed, 56 deletions(-)

diff -puN arch/sh/include/asm/stacktrace.h~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/sh/include/asm/stacktrace.h
--- a/arch/sh/include/asm/stacktrace.h~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/sh/include/asm/stacktrace.h
@@ -10,9 +10,6 @@
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
-	void (*warning)(void *data, char *msg);
-	/* msg must contain %s for the symbol */
-	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
diff -puN arch/sh/kernel/dumpstack.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/sh/kernel/dumpstack.c
--- a/arch/sh/kernel/dumpstack.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/sh/kernel/dumpstack.c
@@ -69,19 +69,6 @@ stack_reader_dump(struct task_struct *ta
 	}
 }
 
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
@@ -98,8 +85,6 @@ static void print_trace_address(void *da
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
 	.stack = print_trace_stack,
 	.address = print_trace_address,
 };
diff -puN arch/sh/kernel/perf_callchain.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/sh/kernel/perf_callchain.c
--- a/arch/sh/kernel/perf_callchain.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/sh/kernel/perf_callchain.c
@@ -14,16 +14,6 @@
 #include <asm/unwinder.h>
 #include <asm/ptrace.h>
 
-
-static void callchain_warning(void *data, char *msg)
-{
-}
-
-static void
-callchain_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-}
-
 static int callchain_stack(void *data, char *name)
 {
 	return 0;
@@ -38,8 +28,6 @@ static void callchain_address(void *data
 }
 
 static const struct stacktrace_ops callchain_ops = {
-	.warning	= callchain_warning,
-	.warning_symbol	= callchain_warning_symbol,
 	.stack		= callchain_stack,
 	.address	= callchain_address,
 };
diff -puN arch/sh/kernel/stacktrace.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/sh/kernel/stacktrace.c
--- a/arch/sh/kernel/stacktrace.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/sh/kernel/stacktrace.c
@@ -17,15 +17,6 @@
 #include <asm/ptrace.h>
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
@@ -51,8 +42,6 @@ static void save_stack_address(void *dat
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning = save_stack_warning,
-	.warning_symbol = save_stack_warning_symbol,
 	.stack = save_stack_stack,
 	.address = save_stack_address,
 };
@@ -88,8 +77,6 @@ save_stack_address_nosched(void *data, u
 }
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning = save_stack_warning,
-	.warning_symbol = save_stack_warning_symbol,
 	.stack = save_stack_stack,
 	.address = save_stack_address_nosched,
 };
diff -puN arch/sh/oprofile/backtrace.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops arch/sh/oprofile/backtrace.c
--- a/arch/sh/oprofile/backtrace.c~sh-remove-warning-and-warning_symbol-from-struct-stacktrace_ops
+++ a/arch/sh/oprofile/backtrace.c
@@ -23,17 +23,6 @@
 #include <asm/sections.h>
 #include <asm/stacktrace.h>
 
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
@@ -49,8 +38,6 @@ static void backtrace_address(void *data
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning = backtrace_warning,
-	.warning_symbol = backtrace_warning_symbol,
 	.stack = backtrace_stack,
 	.address = backtrace_address,
 };
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
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
um-os_dump_core-cleanup.patch
um-fix-uml_lib_path.patch
um-remove-sighup-handler.patch
remove-unused-proc_change_penalty-constant.patch
lib-consolidate-debug_stack_usage-option.patch

