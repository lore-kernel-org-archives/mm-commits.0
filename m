From: akpm@linux-foundation.org
Subject: - generic-bug-use-show_regs-instead-of-dump_stack.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:40 -0700
Message-ID: <200707162058.l6GKwe29002361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999AbXGPVjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ak@suse.de, hskinnemoen@atmel.com, jeremy@goop.org, kyle@parisc-linux.org, lethal@linux-sh.org, paulus@samba.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     generic bug: use show_regs() instead of dump_stack()
has been removed from the -mm tree.  Its filename was
     generic-bug-use-show_regs-instead-of-dump_stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: generic bug: use show_regs() instead of dump_stack()
From: Heiko Carstens <heiko.carstens@de.ibm.com>

The current generic bug implementation has a call to dump_stack() in case a
WARN_ON(whatever) gets hit.  Since report_bug(), which calls dump_stack(),
gets called from an exception handler we can do better: just pass the
pt_regs structure to report_bug() and pass it to show_regs() in case of a
warning.  This will give more debug informations like register contents,
etc...  In addition this avoids some pointless lines that dump_stack()
emits, since it includes a stack backtrace of the exception handler which
is of no interest in case of a warning.  E.g.  on s390 the following lines
are currently always present in a stack backtrace if dump_stack() gets
called from report_bug():

 [<000000000001517a>] show_trace+0x92/0xe8)
 [<0000000000015270>] show_stack+0xa0/0xd0
 [<00000000000152ce>] dump_stack+0x2e/0x3c
 [<0000000000195450>] report_bug+0x98/0xf8
 [<0000000000016cc8>] illegal_op+0x1fc/0x21c
 [<00000000000227d6>] sysc_return+0x0/0x10

Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/traps.c   |    2 +-
 arch/i386/kernel/traps.c    |    2 +-
 arch/parisc/kernel/traps.c  |    2 +-
 arch/powerpc/kernel/traps.c |    2 +-
 arch/ppc/kernel/traps.c     |    2 +-
 arch/s390/kernel/traps.c    |    2 +-
 arch/sh/kernel/traps.c      |    2 +-
 arch/x86_64/kernel/traps.c  |    2 +-
 include/linux/bug.h         |    7 +++++--
 lib/bug.c                   |    5 +++--
 10 files changed, 16 insertions(+), 12 deletions(-)

diff -puN arch/avr32/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/avr32/kernel/traps.c
@@ -184,7 +184,7 @@ asmlinkage void do_illegal_opcode(unsign
 	if (!user_mode(regs) && (ecr == ECR_ILLEGAL_OPCODE)) {
 		enum bug_trap_type type;
 
-		type = report_bug(regs->pc);
+		type = report_bug(regs->pc, regs);
 		switch (type) {
 		case BUG_TRAP_TYPE_NONE:
 			break;
diff -puN arch/i386/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/i386/kernel/traps.c
@@ -390,7 +390,7 @@ void die(const char * str, struct pt_reg
 		unsigned long esp;
 		unsigned short ss;
 
-		report_bug(regs->eip);
+		report_bug(regs->eip, regs);
 
 		printk(KERN_EMERG "%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
diff -puN arch/parisc/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/parisc/kernel/traps.c
@@ -302,7 +302,7 @@ static void handle_break(struct pt_regs 
 	if (unlikely(iir == PARISC_BUG_BREAK_INSN && !user_mode(regs))) {
 		/* check if a BUG() or WARN() trapped here.  */
 		enum bug_trap_type tt;
-		tt = report_bug(regs->iaoq[0] & ~3);
+		tt = report_bug(regs->iaoq[0] & ~3, regs);
 		if (tt == BUG_TRAP_TYPE_WARN) {
 			regs->iaoq[0] += 4;
 			regs->iaoq[1] += 4;
diff -puN arch/powerpc/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/powerpc/kernel/traps.c
@@ -777,7 +777,7 @@ void __kprobes program_check_exception(s
 			return;
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
-		    report_bug(regs->nip) == BUG_TRAP_TYPE_WARN) {
+		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
 			return;
 		}
diff -puN arch/ppc/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/ppc/kernel/traps.c
--- a/arch/ppc/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/ppc/kernel/traps.c
@@ -619,7 +619,7 @@ void program_check_exception(struct pt_r
 			return;
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
-		    report_bug(regs->nip) == BUG_TRAP_TYPE_WARN) {
+		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
 			return;
 		}
diff -puN arch/s390/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/s390/kernel/traps.c
@@ -319,7 +319,7 @@ static void __kprobes inline do_trap(lon
 		else {
 			enum bug_trap_type btt;
 
-			btt = report_bug(regs->psw.addr & PSW_ADDR_INSN);
+			btt = report_bug(regs->psw.addr & PSW_ADDR_INSN, regs);
 			if (btt == BUG_TRAP_TYPE_WARN)
 				return;
 			die(str, regs, interruption_code);
diff -puN arch/sh/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/sh/kernel/traps.c
--- a/arch/sh/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/sh/kernel/traps.c
@@ -874,7 +874,7 @@ void __init trap_init(void)
 void handle_BUG(struct pt_regs *regs)
 {
 	enum bug_trap_type tt;
-	tt = report_bug(regs->pc);
+	tt = report_bug(regs->pc, regs);
 	if (tt == BUG_TRAP_TYPE_WARN) {
 		regs->pc += 2;
 		return;
diff -puN arch/x86_64/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/arch/x86_64/kernel/traps.c
@@ -531,7 +531,7 @@ void die(const char * str, struct pt_reg
 	unsigned long flags = oops_begin();
 
 	if (!user_mode(regs))
-		report_bug(regs->rip);
+		report_bug(regs->rip, regs);
 
 	__die(str, regs, err);
 	oops_end(flags);
diff -puN include/linux/bug.h~generic-bug-use-show_regs-instead-of-dump_stack include/linux/bug.h
--- a/include/linux/bug.h~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/include/linux/bug.h
@@ -10,6 +10,8 @@ enum bug_trap_type {
 	BUG_TRAP_TYPE_BUG = 2,
 };
 
+struct pt_regs;
+
 #ifdef CONFIG_GENERIC_BUG
 #include <asm-generic/bug.h>
 
@@ -20,7 +22,7 @@ static inline int is_warning_bug(const s
 
 const struct bug_entry *find_bug(unsigned long bugaddr);
 
-enum bug_trap_type report_bug(unsigned long bug_addr);
+enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);
 
 int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
 			 struct module *);
@@ -31,7 +33,8 @@ int is_valid_bugaddr(unsigned long addr)
 
 #else	/* !CONFIG_GENERIC_BUG */
 
-static inline enum bug_trap_type report_bug(unsigned long bug_addr)
+static inline enum bug_trap_type report_bug(unsigned long bug_addr,
+					    struct pt_regs *regs)
 {
 	return BUG_TRAP_TYPE_BUG;
 }
diff -puN lib/bug.c~generic-bug-use-show_regs-instead-of-dump_stack lib/bug.c
--- a/lib/bug.c~generic-bug-use-show_regs-instead-of-dump_stack
+++ a/lib/bug.c
@@ -38,6 +38,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/bug.h>
+#include <linux/sched.h>
 
 extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
 
@@ -112,7 +113,7 @@ const struct bug_entry *find_bug(unsigne
 	return module_find_bug(bugaddr);
 }
 
-enum bug_trap_type report_bug(unsigned long bugaddr)
+enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
 	const struct bug_entry *bug;
 	const char *file;
@@ -147,7 +148,7 @@ enum bug_trap_type report_bug(unsigned l
 			       "[verbose debug info unavailable]\n",
 			       (void *)bugaddr);
 
-		dump_stack();
+		show_regs(regs);
 		return BUG_TRAP_TYPE_WARN;
 	}
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
