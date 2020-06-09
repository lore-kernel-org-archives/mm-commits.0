From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 38/93] unicore32: add loglvl to c_backtrace()
Date: Mon, 08 Jun 2020 21:31:51 -0700
Message-ID: <20200609043151.S7dGPUDM2%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEbx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:53 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, gxt@pku.edu.cn, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
