From: akpm@linux-foundation.org
Subject: - x86-constify-stacktrace_ops.patch removed from -mm tree
Date: Sun, 16 Sep 2007 03:12:47 -0700
Message-ID: <200709161018.l8GAIRgs010975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614AbXIPKSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 06:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     x86: constify stacktrace_ops
has been removed from the -mm tree.  Its filename was
     x86-constify-stacktrace_ops.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: x86: constify stacktrace_ops
From: "Jan Beulich" <jbeulich@novell.com>

.. as they're never written to.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c        |    6 +++---
 arch/x86_64/kernel/stacktrace.c |    2 +-
 arch/x86_64/kernel/traps.c      |    4 ++--
 include/asm-x86_64/stacktrace.h |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/traps.c~x86-constify-stacktrace_ops arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~x86-constify-stacktrace_ops
+++ a/arch/i386/kernel/traps.c
@@ -119,7 +119,7 @@ struct stack_frame {
 
 static inline unsigned long print_context_stack(struct thread_info *tinfo,
 				unsigned long *stack, unsigned long ebp,
-				struct stacktrace_ops *ops, void *data)
+				const struct stacktrace_ops *ops, void *data)
 {
 #ifdef	CONFIG_FRAME_POINTER
 	struct stack_frame *frame = (struct stack_frame *)ebp;
@@ -184,7 +184,7 @@ dump_trace_unwind(struct unwind_frame_in
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	        unsigned long *stack,
-		struct stacktrace_ops *ops, void *data)
+		const struct stacktrace_ops *ops, void *data)
 {
 	unsigned long ebp = 0;
 
@@ -291,7 +291,7 @@ static void print_trace_address(void *da
 	touch_nmi_watchdog();
 }
 
-static struct stacktrace_ops print_trace_ops = {
+static const struct stacktrace_ops print_trace_ops = {
 	.warning = print_trace_warning,
 	.warning_symbol = print_trace_warning_symbol,
 	.stack = print_trace_stack,
diff -puN arch/x86_64/kernel/stacktrace.c~x86-constify-stacktrace_ops arch/x86_64/kernel/stacktrace.c
--- a/arch/x86_64/kernel/stacktrace.c~x86-constify-stacktrace_ops
+++ a/arch/x86_64/kernel/stacktrace.c
@@ -35,7 +35,7 @@ static void save_stack_address(void *dat
 		trace->entries[trace->nr_entries++] = addr;
 }
 
-static struct stacktrace_ops save_stack_ops = {
+static const struct stacktrace_ops save_stack_ops = {
 	.warning = save_stack_warning,
 	.warning_symbol = save_stack_warning_symbol,
 	.stack = save_stack_stack,
diff -puN arch/x86_64/kernel/traps.c~x86-constify-stacktrace_ops arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~x86-constify-stacktrace_ops
+++ a/arch/x86_64/kernel/traps.c
@@ -248,7 +248,7 @@ static inline int valid_stack_ptr(struct
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 		unsigned long *stack,
-		struct stacktrace_ops *ops, void *data)
+		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
 	unsigned long *irqstack_end = (unsigned long*)cpu_pda(cpu)->irqstackptr;
@@ -404,7 +404,7 @@ static void print_trace_address(void *da
 	printk_address(addr);
 }
 
-static struct stacktrace_ops print_trace_ops = {
+static const struct stacktrace_ops print_trace_ops = {
 	.warning = print_trace_warning,
 	.warning_symbol = print_trace_warning_symbol,
 	.stack = print_trace_stack,
diff -puN include/asm-x86_64/stacktrace.h~x86-constify-stacktrace_ops include/asm-x86_64/stacktrace.h
--- a/include/asm-x86_64/stacktrace.h~x86-constify-stacktrace_ops
+++ a/include/asm-x86_64/stacktrace.h
@@ -15,6 +15,6 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
-		struct stacktrace_ops *ops, void *data);
+		const struct stacktrace_ops *ops, void *data);
 
 #endif
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
tristate-choices-with-mixed-tristate-and-boolean.patch
fix-x86_64-mm-unwinder.patch
x86-misc-constifications.patch
x86-constify-stacktrace_ops.patch
x86-constify-wd_ops.patch
x86-multi-byte-single-instruction-nops.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
