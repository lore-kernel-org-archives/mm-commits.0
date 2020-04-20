From: akpm@linux-foundation.org
Subject: + unicore32-add-loglvl-to-c_backtrace.patch added to -mm
 tree
Date: Mon, 20 Apr 2020 16:13:49 -0700
Message-ID: <20200420231349.Tni2OHUKW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgDTXNw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 19:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, gxt@pku.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: unicore32: add loglvl to c_backtrace()
has been added to the -mm tree.  Its filename is
     unicore32-add-loglvl-to-c_backtrace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/unicore32-add-loglvl-to-c_backtrace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/unicore32-add-loglvl-to-c_backtrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: unicore32: add loglvl to c_backtrace()

Currently, the log-level of show_stack() depends on a platform
realization.  It creates situations where the headers are printed with
lower log level or higher than the stacktrace (depending on a platform or
user).

Furthermore, it forces the logic decision from user to an architecture
side.  In result, some users as sysrq/kdb/etc are doing tricks with
temporary rising console_loglevel while printing their messages.  And in
result it not only may print unwanted messages from other CPUs, but also
omit printing at all in the unlucky case where the printk() was deferred.

Introducing log-level parameter and KERN_UNSUPPRESSED [1] seems an easier
approach than introducing more printk buffers.  Also, it will consolidate
printings with headers.

Add log level parameter to c_backtrace() as a preparation for introducing
show_stack_loglvl()

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-39-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/setup.h  |    2 +-
 arch/unicore32/kernel/traps.c  |    2 +-
 arch/unicore32/lib/backtrace.S |   24 ++++++++++++++++--------
 3 files changed, 18 insertions(+), 10 deletions(-)

--- a/arch/unicore32/kernel/setup.h~unicore32-add-loglvl-to-c_backtrace
+++ a/arch/unicore32/kernel/setup.h
@@ -29,7 +29,7 @@ extern void kernel_thread_helper(void);
 extern void __init early_signal_init(void);
 
 extern asmlinkage void __backtrace(void);
-extern asmlinkage void c_backtrace(unsigned long fp);
+extern asmlinkage void c_backtrace(unsigned long fp, const char *loglvl);
 
 extern void __show_regs(struct pt_regs *);
 
--- a/arch/unicore32/kernel/traps.c~unicore32-add-loglvl-to-c_backtrace
+++ a/arch/unicore32/kernel/traps.c
@@ -163,7 +163,7 @@ static void dump_backtrace(struct pt_reg
 	printk("\n");
 
 	if (ok)
-		c_backtrace(fp);
+		c_backtrace(fp, KERN_DEFAULT);
 }
 
 void show_stack(struct task_struct *tsk, unsigned long *sp)
--- a/arch/unicore32/lib/backtrace.S~unicore32-add-loglvl-to-c_backtrace
+++ a/arch/unicore32/lib/backtrace.S
@@ -16,6 +16,7 @@
 #define sv_fp	v5
 #define sv_pc	v6
 #define offset	v8
+#define loglvl	v9
 
 ENTRY(__backtrace)
 		mov	r0, fp
@@ -27,10 +28,11 @@ ENTRY(c_backtrace)
 ENDPROC(__backtrace)
 ENDPROC(c_backtrace)
 #else
-		stm.w	(v4 - v8, lr), [sp-]	@ Save an extra register
+		stm.w	(v4 - v10, lr), [sp-]	@ Save an extra register
 						@ so we have a location...
 		mov.a	frame, r0		@ if frame pointer is zero
 		beq	no_frame		@ we have no stack frames
+		mov	loglvl, r1
 
 1:		stm.w	(pc), [sp-]		@ calculate offset of PC stored
 		ldw.w	r0, [sp]+, #4		@ by stmfd for this CPU
@@ -95,9 +97,10 @@ for_each_frame:
 		bua	for_each_frame
 
 1006:		adr	r0, .Lbad
-		mov	r1, frame
+		mov	r1, loglvl
+		mov	r2, frame
 		b.l	printk
-no_frame:	ldm.w	(v4 - v8, pc), [sp]+
+no_frame:	ldm.w	(v4 - v10, pc), [sp]+
 ENDPROC(__backtrace)
 ENDPROC(c_backtrace)
 
@@ -128,8 +131,11 @@ ENDPROC(c_backtrace)
 		add	v7, v7, #1
 		cxor.a	v7, #6
 		cmoveq	v7, #1
-		cmoveq	r1, #'\n'
-		cmovne	r1, #' '
+		bne	201f
+		adr	r0, .Lcr
+		mov	r1, loglvl
+		b.l	printk
+201:
 		ldw.w	r3, [stack]+, #-4
 		mov	r2, reg
 		csub.a	r2, #8
@@ -141,18 +147,20 @@ ENDPROC(c_backtrace)
 		add	r2, r2, #0x10		@ so r2 need add 16
 201:
 		adr	r0, .Lfp
+		mov	r1, loglvl
 		b.l	printk
 2:		sub.a	reg, reg, #1
 		bns	1b
 		cxor.a	v7, #0
 		beq	201f
 		adr	r0, .Lcr
+		mov	r1, loglvl
 		b.l	printk
 201:		ldm.w	(instr, reg, stack, v7, pc), [sp]+
 
-.Lfp:		.asciz	"%cr%d:%08x"
-.Lcr:		.asciz	"\n"
-.Lbad:		.asciz	"Backtrace aborted due to bad frame pointer <%p>\n"
+.Lfp:		.asciz	"%sr%d:%08x "
+.Lcr:		.asciz	"%s\n"
+.Lbad:		.asciz	"%sBacktrace aborted due to bad frame pointer <%p>\n"
 		.align
 .Ldsi:		.word	0x92eec000 >> 14	@ stm.w sp, (... fp, ip, lr, pc)
 		.word	0x92e10000 >> 14	@ stm.w sp, ()
_

Patches currently in -mm which might be from dima@arista.com are

kallsyms-printk-add-loglvl-to-print_ip_sym.patch
alpha-add-show_stack_loglvl.patch
arc-add-show_stack_loglvl.patch
arm-asm-add-loglvl-to-c_backtrace.patch
arm-add-loglvl-to-unwind_backtrace.patch
arm-add-loglvl-to-dump_backtrace.patch
arm-wire-up-dump_backtrace_entrystm.patch
arm-add-show_stack_loglvl.patch
arm64-add-loglvl-to-dump_backtrace.patch
arm64-add-show_stack_loglvl.patch
c6x-add-show_stack_loglvl.patch
csky-add-show_stack_loglvl.patch
h8300-add-show_stack_loglvl.patch
hexagon-add-show_stack_loglvl.patch
ia64-pass-log-level-as-arg-into-ia64_do_show_stack.patch
ia64-add-show_stack_loglvl.patch
m68k-add-show_stack_loglvl.patch
microblaze-add-loglvl-to-microblaze_unwind_inner.patch
microblaze-add-loglvl-to-microblaze_unwind.patch
microblaze-add-show_stack_loglvl.patch
mips-add-show_stack_loglvl.patch
nds32-add-show_stack_loglvl.patch
nios2-add-show_stack_loglvl.patch
openrisc-add-show_stack_loglvl.patch
parisc-add-show_stack_loglvl.patch
powerpc-add-show_stack_loglvl.patch
riscv-add-show_stack_loglvl.patch
s390-add-show_stack_loglvl.patch
sh-add-loglvl-to-dump_mem.patch
sh-remove-needless-printk.patch
sh-add-loglvl-to-printk_address.patch
sh-add-loglvl-to-show_trace.patch
sh-add-show_stack_loglvl.patch
sparc-add-show_stack_loglvl.patch
um-sysrq-remove-needless-variable-sp.patch
um-add-show_stack_loglvl.patch
unicore32-remove-unused-pmode-argument-in-c_backtrace.patch
unicore32-add-loglvl-to-c_backtrace.patch
unicore32-add-show_stack_loglvl.patch
x86-add-missing-const-qualifiers-for-log_lvl.patch
x86-add-show_stack_loglvl.patch
xtensa-add-loglvl-to-show_trace.patch
xtensa-add-show_stack_loglvl.patch
sysrq-use-show_stack_loglvl.patch
x86-amd_gart-print-stacktrace-for-a-leak-with-kern_err.patch
power-use-show_stack_loglvl.patch
kdb-dont-play-with-console_loglevel.patch
sched-print-stack-trace-with-kern_info.patch
kernel-use-show_stack_loglvl.patch
kernel-rename-show_stack_loglvl-=-show_stack.patch
