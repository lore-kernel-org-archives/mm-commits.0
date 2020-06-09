From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/93] arm/asm: add loglvl to c_backtrace()
Date: Mon, 08 Jun 2020 21:30:07 -0700
Message-ID: <20200609043007.KcV14EbSN%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEaI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:08 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, will@kernel.org

From: Dmitry Safonov <dima@arista.com>
Subject: arm/asm: add loglvl to c_backtrace()

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

Add log level argument to c_backtrace() as a preparation for introducing
show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-5-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/bug.h     |    3 ++-
 arch/arm/include/asm/traps.h   |    3 ++-
 arch/arm/kernel/traps.c        |    9 +++++----
 arch/arm/kernel/unwind.c       |    2 +-
 arch/arm/lib/backtrace-clang.S |    9 +++++++--
 arch/arm/lib/backtrace.S       |   14 ++++++++++----
 6 files changed, 27 insertions(+), 13 deletions(-)

--- a/arch/arm/include/asm/bug.h~arm-asm-add-loglvl-to-c_backtrace
+++ a/arch/arm/include/asm/bug.h
@@ -82,7 +82,8 @@ void hook_ifault_code(int nr, int (*fn)(
 				       struct pt_regs *),
 		     int sig, int code, const char *name);
 
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode,
+				   const char *loglvl);
 
 struct mm_struct;
 void show_pte(const char *lvl, struct mm_struct *mm, unsigned long addr);
--- a/arch/arm/include/asm/traps.h~arm-asm-add-loglvl-to-c_backtrace
+++ a/arch/arm/include/asm/traps.h
@@ -29,7 +29,8 @@ static inline int __in_irqentry_text(uns
 }
 
 extern void __init early_trap_init(void *);
-extern void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame);
+extern void dump_backtrace_entry(unsigned long where, unsigned long from,
+				 unsigned long frame, const char *loglvl);
 extern void ptrace_break(struct pt_regs *regs);
 
 extern void *vectors_page;
--- a/arch/arm/kernel/traps.c~arm-asm-add-loglvl-to-c_backtrace
+++ a/arch/arm/kernel/traps.c
@@ -62,7 +62,8 @@ __setup("user_debug=", user_debug_setup)
 
 static void dump_mem(const char *, const char *, unsigned long, unsigned long);
 
-void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame)
+void dump_backtrace_entry(unsigned long where, unsigned long from,
+			  unsigned long frame, const char *loglvl)
 {
 	unsigned long end = frame + 4 + sizeof(struct pt_regs);
 
@@ -76,7 +77,7 @@ void dump_backtrace_entry(unsigned long
 		dump_mem("", "Exception stack", frame + 4, end);
 }
 
-void dump_backtrace_stm(u32 *stack, u32 instruction)
+void dump_backtrace_stm(u32 *stack, u32 instruction, const char *loglvl)
 {
 	char str[80], *p;
 	unsigned int x;
@@ -238,7 +239,7 @@ static void dump_backtrace(struct pt_reg
 	pr_cont("\n");
 
 	if (ok)
-		c_backtrace(fp, mode);
+		c_backtrace(fp, mode, NULL);
 }
 #endif
 
@@ -666,7 +667,7 @@ asmlinkage int arm_syscall(int no, struc
 		dump_instr("", regs);
 		if (user_mode(regs)) {
 			__show_regs(regs);
-			c_backtrace(frame_pointer(regs), processor_mode(regs));
+			c_backtrace(frame_pointer(regs), processor_mode(regs), NULL);
 		}
 	}
 #endif
--- a/arch/arm/kernel/unwind.c~arm-asm-add-loglvl-to-c_backtrace
+++ a/arch/arm/kernel/unwind.c
@@ -493,7 +493,7 @@ void unwind_backtrace(struct pt_regs *re
 		urc = unwind_frame(&frame);
 		if (urc < 0)
 			break;
-		dump_backtrace_entry(where, frame.pc, frame.sp - 4);
+		dump_backtrace_entry(where, frame.pc, frame.sp - 4, NULL);
 	}
 }
 
--- a/arch/arm/lib/backtrace-clang.S~arm-asm-add-loglvl-to-c_backtrace
+++ a/arch/arm/lib/backtrace-clang.S
@@ -17,6 +17,7 @@
 #define sv_pc	r6
 #define mask	r7
 #define sv_lr	r8
+#define loglvl	r9
 
 ENTRY(c_backtrace)
 
@@ -99,6 +100,7 @@ ENDPROC(c_backtrace)
 						@ to ensure 8 byte alignment
 		movs	frame, r0		@ if frame pointer is zero
 		beq	no_frame		@ we have no stack frames
+		mov	loglvl, r2
 		tst	r1, #0x10		@ 26 or 32-bit mode?
 		moveq	mask, #0xfc000003
 		movne	mask, #0		@ mask for 32-bit
@@ -167,6 +169,7 @@ finished_setup:
 		mov	r1, sv_lr
 		mov	r2, frame
 		bic	r1, r1, mask		@ mask PC/LR for the mode
+		mov	r3, loglvl
 		bl	dump_backtrace_entry
 
 /*
@@ -183,6 +186,7 @@ finished_setup:
 		ldr	r0, [frame]		@ locals are stored in
 						@ the preceding frame
 		subeq	r0, r0, #4
+		mov	r2, loglvl
 		bleq	dump_backtrace_stm	@ dump saved registers
 
 /*
@@ -196,7 +200,8 @@ finished_setup:
 		bhi	for_each_frame
 
 1006:		adr	r0, .Lbad
-		mov	r1, frame
+		mov	r1, loglvl
+		mov	r2, frame
 		bl	printk
 no_frame:	ldmfd	sp!, {r4 - r9, fp, pc}
 ENDPROC(c_backtrace)
@@ -209,7 +214,7 @@ ENDPROC(c_backtrace)
 		.long   1005b, 1006b
 		.popsection
 
-.Lbad:		.asciz	"Backtrace aborted due to bad frame pointer <%p>\n"
+.Lbad:		.asciz	"%sBacktrace aborted due to bad frame pointer <%p>\n"
 		.align
 .Lopcode:	.word	0xe92d4800 >> 11	@ stmfd sp!, {... fp, lr}
 		.word	0x0b000000		@ bl if these bits are set
--- a/arch/arm/lib/backtrace.S~arm-asm-add-loglvl-to-c_backtrace
+++ a/arch/arm/lib/backtrace.S
@@ -18,6 +18,7 @@
 #define sv_pc	r6
 #define mask	r7
 #define offset	r8
+#define loglvl	r9
 
 ENTRY(c_backtrace)
 
@@ -25,9 +26,10 @@ ENTRY(c_backtrace)
 		ret	lr
 ENDPROC(c_backtrace)
 #else
-		stmfd	sp!, {r4 - r8, lr}	@ Save an extra register so we have a location...
+		stmfd	sp!, {r4 - r9, lr}	@ Save an extra register so we have a location...
 		movs	frame, r0		@ if frame pointer is zero
 		beq	no_frame		@ we have no stack frames
+		mov	loglvl, r2
 
 		tst	r1, #0x10		@ 26 or 32-bit mode?
  ARM(		moveq	mask, #0xfc000003	)
@@ -73,6 +75,7 @@ for_each_frame:	tst	frame, mask		@ Check
 		ldr	r1, [frame, #-4]	@ get saved lr
 		mov	r2, frame
 		bic	r1, r1, mask		@ mask PC/LR for the mode
+		mov	r3, loglvl
 		bl	dump_backtrace_entry
 
 		ldr	r1, [sv_pc, #-4]	@ if stmfd sp!, {args} exists,
@@ -80,12 +83,14 @@ for_each_frame:	tst	frame, mask		@ Check
 		teq	r3, r1, lsr #11
 		ldreq	r0, [frame, #-8]	@ get sp
 		subeq	r0, r0, #4		@ point at the last arg
+		mov	r2, loglvl
 		bleq	dump_backtrace_stm	@ dump saved registers
 
 1004:		ldr	r1, [sv_pc, #0]		@ if stmfd sp!, {..., fp, ip, lr, pc}
 		ldr	r3, .Ldsi		@ instruction exists,
 		teq	r3, r1, lsr #11
 		subeq	r0, frame, #16
+		mov	r2, loglvl
 		bleq	dump_backtrace_stm	@ dump saved registers
 
 		teq	sv_fp, #0		@ zero saved fp means
@@ -96,9 +101,10 @@ for_each_frame:	tst	frame, mask		@ Check
 		bhi	for_each_frame
 
 1006:		adr	r0, .Lbad
-		mov	r1, frame
+		mov	r1, loglvl
+		mov	r2, frame
 		bl	printk
-no_frame:	ldmfd	sp!, {r4 - r8, pc}
+no_frame:	ldmfd	sp!, {r4 - r9, pc}
 ENDPROC(c_backtrace)
 		
 		.pushsection __ex_table,"a"
@@ -109,7 +115,7 @@ ENDPROC(c_backtrace)
 		.long	1004b, 1006b
 		.popsection
 
-.Lbad:		.asciz	"Backtrace aborted due to bad frame pointer <%p>\n"
+.Lbad:		.asciz	"%sBacktrace aborted due to bad frame pointer <%p>\n"
 		.align
 .Ldsi:		.word	0xe92dd800 >> 11	@ stmfd sp!, {... fp, ip, lr, pc}
 		.word	0xe92d0000 >> 11	@ stmfd sp!, {}
_
