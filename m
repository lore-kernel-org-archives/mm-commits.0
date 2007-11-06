From: akpm@linux-foundation.org
Subject: - prepare-kprobes-code-for-x86-unification.patch removed from -mm tree
Date: Mon, 05 Nov 2007 22:48:22 -0800
Message-ID: <200711060655.lA66tAlg011081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbXKFHBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 02:01:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mingo@elte.hu, prasanna@in.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     prepare kprobes code for x86 unification
has been removed from the -mm tree.  Its filename was
     prepare-kprobes-code-for-x86-unification.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: prepare kprobes code for x86 unification
From: Arjan van de Ven <arjan@linux.intel.com>

This patch is a first step towards unification of the kprobes
infrastructure between 32 and 64 bit x86; the patch is mostly about
removing spurious whitespace changes and about adding harmless includes and
the like to make the 32/64 files more identical.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kprobes_32.c |  179 ++++++++++++++++++++++-----------
 arch/x86/kernel/kprobes_64.c |  176 ++++++++++++++++++++------------
 arch/x86/mm/fault_32.c       |    1 
 arch/x86/mm/fault_64.c       |    1 
 include/asm-x86/kprobes_32.h |   18 +--
 include/asm-x86/kprobes_64.h |   28 +++--
 6 files changed, 258 insertions(+), 145 deletions(-)

diff -puN arch/x86/kernel/kprobes_32.c~prepare-kprobes-code-for-x86-unification arch/x86/kernel/kprobes_32.c
--- a/arch/x86/kernel/kprobes_32.c~prepare-kprobes-code-for-x86-unification
+++ a/arch/x86/kernel/kprobes_32.c
@@ -29,10 +29,15 @@
 
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/preempt.h>
+#include <linux/module.h>
 #include <linux/kdebug.h>
+
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
+#include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
 
@@ -41,30 +46,6 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-struct kretprobe_blackpoint kretprobe_blacklist[] = {
-	{"__switch_to", }, /* This function switches only current task, but
-			     doesn't switch kernel stack.*/
-	{NULL, NULL}	/* Terminator */
-};
-const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
-
-/* insert a jmp code */
-static __always_inline void set_jmp_op(void *from, void *to)
-{
-	struct __arch_jmp_op {
-		char op;
-		long raddr;
-	} __attribute__((packed)) *jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (long)(to) - ((long)(from) + 5);
-	jop->op = RELATIVEJUMP_INSTRUCTION;
-}
-
-/*
- * returns non-zero if opcodes can be boosted.
- */
-static __always_inline int can_boost(kprobe_opcode_t *opcodes)
-{
 #define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
 	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
@@ -75,7 +56,7 @@ static __always_inline int can_boost(kpr
 	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
 	 * Groups, and some special opcodes can not be boost.
 	 */
-	static const unsigned long twobyte_is_boostable[256 / 32] = {
+static const unsigned long twobyte_is_boostable[256 / 32] = {
 		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
 		/*      -------------------------------         */
 		W(0x00, 0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0)| /* 00 */
@@ -96,8 +77,85 @@ static __always_inline int can_boost(kpr
 		W(0xf0, 0,1,1,1,0,1,0,0,1,1,1,0,1,1,1,0)  /* f0 */
 		/*      -------------------------------         */
 		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
+};
 #undef W
+
+#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 64))
+static const u64 onebyte_has_modrm[256 / 64] = {
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+		/*      -------------------------------         */
+		W(0x00, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 00 */
+		W(0x10, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 10 */
+		W(0x20, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 20 */
+		W(0x30, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0), /* 30 */
+		W(0x40, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 40 */
+		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 50 */
+		W(0x60, 0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0)| /* 60 */
+		W(0x70, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 70 */
+		W(0x80, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 80 */
+		W(0x90, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 90 */
+		W(0xa0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* a0 */
+		W(0xb0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* b0 */
+		W(0xc0, 1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0)| /* c0 */
+		W(0xd0, 1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1)| /* d0 */
+		W(0xe0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* e0 */
+		W(0xf0, 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1)  /* f0 */
+		/*      -------------------------------         */
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+};
+static const u64 twobyte_has_modrm[256 / 64] = {
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+		/*      -------------------------------         */
+		W(0x00, 1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1)| /* 0f */
+		W(0x10, 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0)| /* 1f */
+		W(0x20, 1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,1)| /* 2f */
+		W(0x30, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 3f */
+		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 4f */
+		W(0x50, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 5f */
+		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 6f */
+		W(0x70, 1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1), /* 7f */
+		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 8f */
+		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 9f */
+		W(0xa0, 0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1)| /* af */
+		W(0xb0, 1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1), /* bf */
+		W(0xc0, 1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0)| /* cf */
+		W(0xd0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* df */
+		W(0xe0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* ef */
+		W(0xf0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)  /* ff */
+		/*      -------------------------------         */
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+};
+#undef	W
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
+/* insert a jmp code */
+static __always_inline void set_jmp_op(void *from, void *to)
+{
+	struct __arch_jmp_op {
+		char op;
+		long raddr;
+	} __attribute__((packed)) *jop;
+	jop = (struct __arch_jmp_op *)from;
+	jop->raddr = (long)(to) - ((long)(from) + 5);
+	jop->op = RELATIVEJUMP_INSTRUCTION;
+}
+
+/*
+ * returns non-zero if opcodes can be boosted.
+ */
+static __always_inline int can_boost(kprobe_opcode_t *opcodes)
+{
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
 retry:
@@ -145,9 +203,9 @@ retry:
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
-static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
+static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
 {
-	switch (opcode) {
+	switch (*insn) {
 	case 0xfa:		/* cli */
 	case 0xfb:		/* sti */
 	case 0xcf:		/* iret/iretd */
@@ -157,20 +215,24 @@ static int __kprobes is_IF_modifier(kpro
 	return 0;
 }
 
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
+static void __kprobes arch_copy_kprobe(struct kprobe *p)
 {
-	/* insn: must be on special executable page on i386. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn)
-		return -ENOMEM;
-
 	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
 	if (can_boost(p->addr)) {
 		p->ainsn.boostable = 0;
 	} else {
 		p->ainsn.boostable = -1;
 	}
+	p->opcode = *p->addr;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* insn: must be on special executable page on x86. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn)
+		return -ENOMEM;
+	arch_copy_kprobe(p);
 	return 0;
 }
 
@@ -195,26 +257,26 @@ static void __kprobes save_previous_kpro
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_eflags = kcb->kprobe_old_eflags;
-	kcb->prev_kprobe.saved_eflags = kcb->kprobe_saved_eflags;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
 	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_eflags = kcb->prev_kprobe.old_eflags;
-	kcb->kprobe_saved_eflags = kcb->prev_kprobe.saved_eflags;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_eflags = kcb->kprobe_old_eflags
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->eflags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->opcode))
-		kcb->kprobe_saved_eflags &= ~IF_MASK;
+	if (is_IF_modifier(p->ainsn.insn))
+		kcb->kprobe_saved_flags &= ~IF_MASK;
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
@@ -267,7 +329,7 @@ static int __kprobes kprobe_handler(stru
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
 				regs->eflags &= ~TF_MASK;
-				regs->eflags |= kcb->kprobe_saved_eflags;
+				regs->eflags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 			}
 			/* We have reentered the kprobe_handler(), since
@@ -488,7 +550,7 @@ static void __kprobes resume_execution(s
 	switch (p->ainsn.insn[0]) {
 	case 0x9c:		/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_eflags;
+		*tos |= kcb->kprobe_old_flags;
 		break;
 	case 0xc2:		/* iret/ret/lret */
 	case 0xc3:
@@ -563,10 +625,10 @@ static int __kprobes post_kprobe_handler
 	}
 
 	resume_execution(cur, regs, kcb);
-	regs->eflags |= kcb->kprobe_saved_eflags;
+	regs->eflags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->eflags);
 
-	/*Restore back the original saved kprobes variables and continue. */
+	/* Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
 		restore_previous_kprobe(kcb);
 		goto out;
@@ -602,7 +664,7 @@ int __kprobes kprobe_fault_handler(struc
 		 * normal page fault.
 		 */
 		regs->eip = (unsigned long)cur->addr;
-		regs->eflags |= kcb->kprobe_old_eflags;
+		regs->eflags |= kcb->kprobe_old_flags;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
 		else
@@ -647,7 +709,7 @@ int __kprobes kprobe_fault_handler(struc
 }
 
 /*
- * Wrapper routine to for handling exceptions.
+ * Wrapper routine for handling exceptions.
  */
 int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
@@ -688,11 +750,11 @@ int __kprobes setjmp_pre_handler(struct 
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_esp = &regs->esp;
-	addr = (unsigned long)(kcb->jprobe_saved_esp);
+	kcb->jprobe_saved_sp = &regs->esp;
+	addr = (unsigned long)(kcb->jprobe_saved_sp);
 
 	/*
-	 * TBD: As Linus pointed out, gcc assumes that the callee
+	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
 	 * tailcall optimization. So, to be absolutely safe
 	 * we also save and restore enough stack bytes to cover
@@ -715,23 +777,23 @@ void __kprobes jprobe_return(void)
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_esp):"memory");
+		      (kcb->jprobe_saved_sp):"memory");
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->eip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_esp);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->esp != kcb->jprobe_saved_esp) {
+		if (&regs->esp != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_esp,
+			    container_of(kcb->jprobe_saved_sp,
 					    struct pt_regs, esp);
 			printk("current esp %p does not match saved esp %p\n",
-			       &regs->esp, kcb->jprobe_saved_esp);
+			       &regs->esp, kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
@@ -747,12 +809,13 @@ int __kprobes longjmp_break_handler(stru
 	return 0;
 }
 
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+int __init arch_init_kprobes(void)
 {
 	return 0;
 }
 
-int __init arch_init_kprobes(void)
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
+
diff -puN arch/x86/kernel/kprobes_64.c~prepare-kprobes-code-for-x86-unification arch/x86/kernel/kprobes_64.c
--- a/arch/x86/kernel/kprobes_64.c~prepare-kprobes-code-for-x86-unification
+++ a/arch/x86/kernel/kprobes_64.c
@@ -38,66 +38,58 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 
+#include <asm/cacheflush.h>
+#include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
 
 void jprobe_return_end(void);
-static void __kprobes arch_copy_kprobe(struct kprobe *p);
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-struct kretprobe_blackpoint kretprobe_blacklist[] = {
-	{"__switch_to", }, /* This function switches only current task, but
-			      doesn't switch kernel stack.*/
-	{NULL, NULL}	/* Terminator */
+#define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+	/*
+	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
+	 * Groups, and some special opcodes can not be boost.
+	 */
+static const unsigned long twobyte_is_boostable[256 / 32] = {
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
+		/*      -------------------------------         */
+		W(0x00, 0,0,1,1,0,0,1,0,1,1,0,0,0,0,0,0)| /* 00 */
+		W(0x10, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 10 */
+		W(0x20, 1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0)| /* 20 */
+		W(0x30, 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 30 */
+		W(0x40, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)| /* 40 */
+		W(0x50, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), /* 50 */
+		W(0x60, 1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1)| /* 60 */
+		W(0x70, 0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1), /* 70 */
+		W(0x80, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)| /* 80 */
+		W(0x90, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1), /* 90 */
+		W(0xa0, 1,1,0,1,1,1,0,0,1,1,0,1,1,1,0,1)| /* a0 */
+		W(0xb0, 1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1), /* b0 */
+		W(0xc0, 1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1)| /* c0 */
+		W(0xd0, 0,1,1,1,0,1,0,0,1,1,0,1,1,1,0,1), /* d0 */
+		W(0xe0, 0,1,1,0,0,1,0,0,1,1,0,1,1,1,0,1)| /* e0 */
+		W(0xf0, 0,1,1,1,0,1,0,0,1,1,1,0,1,1,1,0)  /* f0 */
+		/*      -------------------------------         */
+		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
 };
-const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
-
-/*
- * returns non-zero if opcode modifies the interrupt flag.
- */
-static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
-{
-	switch (*insn) {
-	case 0xfa:		/* cli */
-	case 0xfb:		/* sti */
-	case 0xcf:		/* iret/iretd */
-	case 0x9d:		/* popf/popfd */
-		return 1;
-	}
-
-	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
-		return 1;
-	return 0;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* insn: must be on special executable page on x86_64. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn) {
-		return -ENOMEM;
-	}
-	arch_copy_kprobe(p);
-	return 0;
-}
+#undef W
 
-/*
- * Determine if the instruction uses the %rip-relative addressing mode.
- * If it does, return the address of the 32-bit displacement word.
- * If not, return null.
- */
-static s32 __kprobes *is_riprel(u8 *insn)
-{
 #define W(row,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,ba,bb,bc,bd,be,bf)		      \
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
 	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
 	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
 	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
 	 << (row % 64))
-	static const u64 onebyte_has_modrm[256 / 64] = {
+static const u64 onebyte_has_modrm[256 / 64] = {
 		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
 		/*      -------------------------------         */
 		W(0x00, 1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0)| /* 00 */
@@ -118,8 +110,8 @@ static s32 __kprobes *is_riprel(u8 *insn
 		W(0xf0, 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1)  /* f0 */
 		/*      -------------------------------         */
 		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
-	static const u64 twobyte_has_modrm[256 / 64] = {
+};
+static const u64 twobyte_has_modrm[256 / 64] = {
 		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
 		/*      -------------------------------         */
 		W(0x00, 1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1)| /* 0f */
@@ -140,8 +132,46 @@ static s32 __kprobes *is_riprel(u8 *insn
 		W(0xf0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0)  /* ff */
 		/*      -------------------------------         */
 		/*      0 1 2 3 4 5 6 7 8 9 a b c d e f         */
-	};
+};
 #undef	W
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
+/*
+ * returns non-zero if opcode modifies the interrupt flag.
+ */
+static __always_inline int is_IF_modifier(kprobe_opcode_t *insn)
+{
+	switch (*insn) {
+	case 0xfa:		/* cli */
+	case 0xfb:		/* sti */
+	case 0xcf:		/* iret/iretd */
+	case 0x9d:		/* popf/popfd */
+		return 1;
+	}
+
+	/*
+	 * on 64 bit x86, 0x40-0x4f are prefixes so we need to look
+	 * at the next byte instead.. but of course not recurse infinitely
+         */
+	if (*insn  >= 0x40 && *insn <= 0x4f && *insn > 0x4f)
+		return is_IF_modifier(++insn);
+	return 0;
+}
+
+
+/*
+ * Determine if the instruction uses the %rip-relative addressing mode.
+ * If it does, return the address of the 32-bit displacement word.
+ * If not, return null.
+ */
+static s32 __kprobes *is_riprel(u8 *insn)
+{
 	int need_modrm;
 
 	/* Skip legacy instruction prefixes.  */
@@ -213,6 +243,16 @@ static void __kprobes arch_copy_kprobe(s
 	p->opcode = *p->addr;
 }
 
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* insn: must be on special executable page on x86. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn)
+		return -ENOMEM;
+	arch_copy_kprobe(p);
+	return 0;
+}
+
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
 	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
@@ -234,26 +274,26 @@ static void __kprobes save_previous_kpro
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_rflags = kcb->kprobe_old_rflags;
-	kcb->prev_kprobe.saved_rflags = kcb->kprobe_saved_rflags;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
 	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_rflags = kcb->prev_kprobe.old_rflags;
-	kcb->kprobe_saved_rflags = kcb->prev_kprobe.saved_rflags;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
 	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_rflags = kcb->kprobe_old_rflags
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->eflags & (TF_MASK | IF_MASK));
 	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_rflags &= ~IF_MASK;
+		kcb->kprobe_saved_flags &= ~IF_MASK;
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
@@ -274,17 +314,20 @@ void __kprobes arch_prepare_kretprobe(st
 	unsigned long *sara = (unsigned long *)regs->rsp;
 
 	ri->ret_addr = (kprobe_opcode_t *) *sara;
+
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
-int __kprobes kprobe_handler(struct pt_regs *regs)
+static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *p;
 	int ret = 0;
-	kprobe_opcode_t *addr = (kprobe_opcode_t *)(regs->rip - sizeof(kprobe_opcode_t));
+	kprobe_opcode_t *addr;
 	struct kprobe_ctlblk *kcb;
 
+	addr = (kprobe_opcode_t *)(regs->rip - sizeof(kprobe_opcode_t));
+
 	/*
 	 * We don't want to be preempted for the entire
 	 * duration of kprobe processing
@@ -299,7 +342,7 @@ int __kprobes kprobe_handler(struct pt_r
 			if (kcb->kprobe_status == KPROBE_HIT_SS &&
 				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
 				regs->eflags &= ~TF_MASK;
-				regs->eflags |= kcb->kprobe_saved_rflags;
+				regs->eflags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
 			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 				/* TODO: Provide re-entrancy from
@@ -385,7 +428,7 @@ no_kprobe:
  * here. When a retprobed function returns, this probe is hit and
  * trampoline_probe_handler() runs, calling the kretprobe's handler.
  */
- void kretprobe_trampoline_holder(void)
+ void __kprobes kretprobe_trampoline_holder(void)
  {
  	asm volatile (  ".global kretprobe_trampoline\n"
  			"kretprobe_trampoline: \n"
@@ -497,7 +540,7 @@ static void __kprobes resume_execution(s
 	switch (*insn) {
 	case 0x9c:		/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_rflags;
+		*tos |= kcb->kprobe_old_flags;
 		break;
 	case 0xc3:		/* ret/lret */
 	case 0xcb:
@@ -550,7 +593,7 @@ int __kprobes post_kprobe_handler(struct
 	}
 
 	resume_execution(cur, regs, kcb);
-	regs->eflags |= kcb->kprobe_saved_rflags;
+	regs->eflags |= kcb->kprobe_saved_flags;
 	trace_hardirqs_fixup_flags(regs->eflags);
 
 	/* Restore the original saved kprobes variables and continue. */
@@ -590,7 +633,7 @@ int __kprobes kprobe_fault_handler(struc
 		 * normal page fault.
 		 */
 		regs->rip = (unsigned long)cur->addr;
-		regs->eflags |= kcb->kprobe_old_rflags;
+		regs->eflags |= kcb->kprobe_old_flags;
 		if (kcb->kprobe_status == KPROBE_REENTER)
 			restore_previous_kprobe(kcb);
 		else
@@ -679,8 +722,9 @@ int __kprobes setjmp_pre_handler(struct 
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_rsp = (long *) regs->rsp;
-	addr = (unsigned long)(kcb->jprobe_saved_rsp);
+	kcb->jprobe_saved_sp = (long *) regs->rsp;
+	addr = (unsigned long)(kcb->jprobe_saved_sp);
+
 	/*
 	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
@@ -705,23 +749,23 @@ void __kprobes jprobe_return(void)
 		      "       .globl jprobe_return_end	\n"
 		      "       jprobe_return_end:	\n"
 		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_rsp):"memory");
+		      (kcb->jprobe_saved_sp):"memory");
 }
 
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	u8 *addr = (u8 *) (regs->rip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_rsp);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if ((long *)regs->rsp != kcb->jprobe_saved_rsp) {
+		if ((long *)regs->rsp != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_rsp,
+			    container_of(kcb->jprobe_saved_sp,
 					    struct pt_regs, rsp);
 			printk("current rsp %p does not match saved rsp %p\n",
-			       (long *)regs->rsp, kcb->jprobe_saved_rsp);
+			       (long *)regs->rsp, kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
diff -puN arch/x86/mm/fault_32.c~prepare-kprobes-code-for-x86-unification arch/x86/mm/fault_32.c
--- a/arch/x86/mm/fault_32.c~prepare-kprobes-code-for-x86-unification
+++ a/arch/x86/mm/fault_32.c
@@ -25,7 +25,6 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
-#include <linux/kprobes.h>
 
 #include <asm/system.h>
 #include <asm/desc.h>
diff -puN arch/x86/mm/fault_64.c~prepare-kprobes-code-for-x86-unification arch/x86/mm/fault_64.c
--- a/arch/x86/mm/fault_64.c~prepare-kprobes-code-for-x86-unification
+++ a/arch/x86/mm/fault_64.c
@@ -25,7 +25,6 @@
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kdebug.h>
-#include <linux/kprobes.h>
 
 #include <asm/system.h>
 #include <asm/pgalloc.h>
diff -puN include/asm-x86/kprobes_32.h~prepare-kprobes-code-for-x86-unification include/asm-x86/kprobes_32.h
--- a/include/asm-x86/kprobes_32.h~prepare-kprobes-code-for-x86-unification
+++ a/include/asm-x86/kprobes_32.h
@@ -2,7 +2,6 @@
 #define _ASM_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
- *  include/asm-i386/kprobes.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -23,14 +22,17 @@
  * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
  *		Probes initial implementation ( includes suggestions from
  *		Rusty Russell).
+ * 2004-Oct	Prasanna S Panchamukhi <prasanna@in.ibm.com> and Jim Keniston
+ *		kenistoj@us.ibm.com adopted from i386.
  */
 #include <linux/types.h>
 #include <linux/ptrace.h>
+#include <linux/percpu.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
-struct kprobe;
 struct pt_regs;
+struct kprobe;
 
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
@@ -64,16 +66,16 @@ struct arch_specific_insn {
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
-	unsigned long old_eflags;
-	unsigned long saved_eflags;
+	unsigned long old_flags;
+	unsigned long saved_flags;
 };
 
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
-	unsigned long kprobe_old_eflags;
-	unsigned long kprobe_saved_eflags;
-	long *jprobe_saved_esp;
+	unsigned long kprobe_old_flags;
+	unsigned long kprobe_saved_flags;
+	long *jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
@@ -88,7 +90,7 @@ static inline void restore_interrupts(st
 		local_irq_enable();
 }
 
+extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
-extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 #endif				/* _ASM_KPROBES_H */
diff -puN include/asm-x86/kprobes_64.h~prepare-kprobes-code-for-x86-unification include/asm-x86/kprobes_64.h
--- a/include/asm-x86/kprobes_64.h~prepare-kprobes-code-for-x86-unification
+++ a/include/asm-x86/kprobes_64.h
@@ -2,7 +2,6 @@
 #define _ASM_KPROBES_H
 /*
  *  Kernel Probes (KProbes)
- *  include/asm-x86_64/kprobes.h
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -20,6 +19,9 @@
  *
  * Copyright (C) IBM Corporation, 2002, 2004
  *
+ * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
+ *		Probes initial implementation ( includes suggestions from
+ *		Rusty Russell).
  * 2004-Oct	Prasanna S Panchamukhi <prasanna@in.ibm.com> and Jim Keniston
  *		kenistoj@us.ibm.com adopted from i386.
  */
@@ -34,6 +36,7 @@ struct kprobe;
 
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
+#define RELATIVEJUMP_INSTRUCTION 0xe9
 #define MAX_INSN_SIZE 15
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR) (((MAX_STACK_SIZE) < \
@@ -42,31 +45,37 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
+#define flush_insn_slot(p)	do { } while (0)
+
 extern const int kretprobe_blacklist_size;
 
+void arch_remove_kprobe(struct kprobe *p);
 void kretprobe_trampoline(void);
-extern void arch_remove_kprobe(struct kprobe *p);
-#define flush_insn_slot(p)	do { } while (0)
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
 	/* copy of the original instruction */
 	kprobe_opcode_t *insn;
+	/*
+	 * If this flag is not 0, this kprobe can be boost when its
+	 * post_handler and break_handler is not set.
+	 */
+	int boostable;
 };
 
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned long status;
-	unsigned long old_rflags;
-	unsigned long saved_rflags;
+	unsigned long old_flags;
+	unsigned long saved_flags;
 };
 
 /* per-cpu kprobe control block */
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
-	unsigned long kprobe_old_rflags;
-	unsigned long kprobe_saved_rflags;
-	long *jprobe_saved_rsp;
+	unsigned long kprobe_old_flags;
+	unsigned long kprobe_saved_flags;
+	long *jprobe_saved_sp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
@@ -81,10 +90,7 @@ static inline void restore_interrupts(st
 		local_irq_enable();
 }
 
-extern int post_kprobe_handler(struct pt_regs *regs);
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
-extern int kprobe_handler(struct pt_regs *regs);
-
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 #endif				/* _ASM_KPROBES_H */
_

Patches currently in -mm which might be from arjan@linux.intel.com are

jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
prepare-kprobes-code-for-x86-unification.patch
mark-sys_open-sys_read-exports-unused.patch
drivers-edac-use-round_jiffies_relative.patch
