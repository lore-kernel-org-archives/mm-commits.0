From: akpm@linux-foundation.org
Subject: - kprobes-support-kretprobe-blacklist.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:54 -0700
Message-ID: <200710162039.l9GKdsgf015602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965056AbXJPVdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: support kretprobe blacklist
has been removed from the -mm tree.  Its filename was
     kprobes-support-kretprobe-blacklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kprobes: support kretprobe blacklist
From: Masami Hiramatsu <mhiramat@redhat.com>

Introduce architecture dependent kretprobe blacklists to prohibit users
from inserting return probes on the function in which kprobes can be
inserted but kretprobes can not.

This patch also removes "__kprobes" mark from "__switch_to" on x86_64 and
registers "__switch_to" to the blacklist on x86-64, because that mark is to
prohibit user from inserting only kretprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/kprobes.c   |    2 ++
 arch/ia64/kernel/kprobes.c    |    2 ++
 arch/powerpc/kernel/kprobes.c |    2 ++
 arch/s390/kernel/kprobes.c    |    2 ++
 arch/sparc64/kernel/kprobes.c |    2 ++
 arch/x86/kernel/kprobes_32.c  |    7 +++++++
 arch/x86/kernel/kprobes_64.c  |    7 +++++++
 arch/x86/kernel/process_64.c  |    2 +-
 include/asm-avr32/kprobes.h   |    2 ++
 include/asm-ia64/kprobes.h    |    1 +
 include/asm-powerpc/kprobes.h |    1 +
 include/asm-s390/kprobes.h    |    1 +
 include/asm-sparc64/kprobes.h |    2 ++
 include/asm-x86/kprobes_32.h  |    2 ++
 include/asm-x86/kprobes_64.h  |    1 +
 include/linux/kprobes.h       |    6 ++++++
 kernel/kprobes.c              |   23 +++++++++++++++++++++++
 17 files changed, 64 insertions(+), 1 deletion(-)

diff -puN arch/avr32/kernel/kprobes.c~kprobes-support-kretprobe-blacklist arch/avr32/kernel/kprobes.c
--- a/arch/avr32/kernel/kprobes.c~kprobes-support-kretprobe-blacklist
+++ a/arch/avr32/kernel/kprobes.c
@@ -22,6 +22,8 @@ DEFINE_PER_CPU(struct kprobe *, current_
 static unsigned long kprobe_status;
 static struct pt_regs jprobe_saved_regs;
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
diff -puN arch/ia64/kernel/kprobes.c~kprobes-support-kretprobe-blacklist arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-support-kretprobe-blacklist
+++ a/arch/ia64/kernel/kprobes.c
@@ -40,6 +40,8 @@ extern void jprobe_inst_return(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 enum instruction_type {A, I, M, F, B, L, X, u};
 static enum instruction_type bundle_encoding[32][3] = {
   { M, I, I },				/* 00 */
diff -puN arch/powerpc/kernel/kprobes.c~kprobes-support-kretprobe-blacklist arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~kprobes-support-kretprobe-blacklist
+++ a/arch/powerpc/kernel/kprobes.c
@@ -38,6 +38,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
diff -puN arch/s390/kernel/kprobes.c~kprobes-support-kretprobe-blacklist arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-support-kretprobe-blacklist
+++ a/arch/s390/kernel/kprobes.c
@@ -33,6 +33,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	/* Make sure the probe isn't going on a difficult instruction */
diff -puN arch/sparc64/kernel/kprobes.c~kprobes-support-kretprobe-blacklist arch/sparc64/kernel/kprobes.c
--- a/arch/sparc64/kernel/kprobes.c~kprobes-support-kretprobe-blacklist
+++ a/arch/sparc64/kernel/kprobes.c
@@ -42,6 +42,8 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {{NULL, NULL}};
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	p->ainsn.insn[0] = *p->addr;
diff -puN arch/x86/kernel/kprobes_32.c~kprobes-support-kretprobe-blacklist arch/x86/kernel/kprobes_32.c
--- a/arch/x86/kernel/kprobes_32.c~kprobes-support-kretprobe-blacklist
+++ a/arch/x86/kernel/kprobes_32.c
@@ -41,6 +41,13 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			     doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
 /* insert a jmp code */
 static __always_inline void set_jmp_op(void *from, void *to)
 {
diff -puN arch/x86/kernel/kprobes_64.c~kprobes-support-kretprobe-blacklist arch/x86/kernel/kprobes_64.c
--- a/arch/x86/kernel/kprobes_64.c~kprobes-support-kretprobe-blacklist
+++ a/arch/x86/kernel/kprobes_64.c
@@ -48,6 +48,13 @@ static void __kprobes arch_copy_kprobe(s
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
diff -puN arch/x86/kernel/process_64.c~kprobes-support-kretprobe-blacklist arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~kprobes-support-kretprobe-blacklist
+++ a/arch/x86/kernel/process_64.c
@@ -581,7 +581,7 @@ static inline void __switch_to_xtra(stru
  *
  * Kprobes not supported here. Set the probe on schedule instead.
  */
-__kprobes struct task_struct *
+struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
diff -puN include/asm-avr32/kprobes.h~kprobes-support-kretprobe-blacklist include/asm-avr32/kprobes.h
--- a/include/asm-avr32/kprobes.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-avr32/kprobes.h
@@ -17,6 +17,8 @@ typedef u16	kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xd673	/* breakpoint */
 #define MAX_INSN_SIZE		2
 
+#define kretprobe_blacklist_size 0
+
 #define arch_remove_kprobe(p)	do { } while (0)
 
 /* Architecture specific copy of original instruction */
diff -puN include/asm-ia64/kprobes.h~kprobes-support-kretprobe-blacklist include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-ia64/kprobes.h
@@ -83,6 +83,7 @@ struct kprobe_ctlblk {
 };
 
 #define ARCH_SUPPORTS_KRETPROBES
+#define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
 #define SLOT1_p1_OPCODE_SHIFT	(37 - (64-46))
diff -puN include/asm-powerpc/kprobes.h~kprobes-support-kretprobe-blacklist include/asm-powerpc/kprobes.h
--- a/include/asm-powerpc/kprobes.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-powerpc/kprobes.h
@@ -82,6 +82,7 @@ typedef unsigned int kprobe_opcode_t;
 
 #define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
+#define kretprobe_blacklist_size 0
 
 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);
diff -puN include/asm-s390/kprobes.h~kprobes-support-kretprobe-blacklist include/asm-s390/kprobes.h
--- a/include/asm-s390/kprobes.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-s390/kprobes.h
@@ -47,6 +47,7 @@ typedef u16 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
+#define kretprobe_blacklist_size 0
 
 #define KPROBE_SWAP_INST	0x10
 
diff -puN include/asm-sparc64/kprobes.h~kprobes-support-kretprobe-blacklist include/asm-sparc64/kprobes.h
--- a/include/asm-sparc64/kprobes.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-sparc64/kprobes.h
@@ -10,6 +10,8 @@ typedef u32 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION_2 0x91d02071 /* ta 0x71 */
 #define MAX_INSN_SIZE 2
 
+#define kretprobe_blacklist_size 0
+
 #define arch_remove_kprobe(p)	do {} while (0)
 
 #define flush_insn_slot(p)		\
diff -puN include/asm-x86/kprobes_32.h~kprobes-support-kretprobe-blacklist include/asm-x86/kprobes_32.h
--- a/include/asm-x86/kprobes_32.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-x86/kprobes_32.h
@@ -45,6 +45,8 @@ typedef u8 kprobe_opcode_t;
 #define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
+extern const int kretprobe_blacklist_size;
+
 void arch_remove_kprobe(struct kprobe *p);
 void kretprobe_trampoline(void);
 
diff -puN include/asm-x86/kprobes_64.h~kprobes-support-kretprobe-blacklist include/asm-x86/kprobes_64.h
--- a/include/asm-x86/kprobes_64.h~kprobes-support-kretprobe-blacklist
+++ a/include/asm-x86/kprobes_64.h
@@ -42,6 +42,7 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE - (ADDR)))
 
 #define ARCH_SUPPORTS_KRETPROBES
+extern const int kretprobe_blacklist_size;
 
 void kretprobe_trampoline(void);
 extern void arch_remove_kprobe(struct kprobe *p);
diff -puN include/linux/kprobes.h~kprobes-support-kretprobe-blacklist include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-support-kretprobe-blacklist
+++ a/include/linux/kprobes.h
@@ -166,6 +166,12 @@ struct kretprobe_instance {
 	struct task_struct *task;
 };
 
+struct kretprobe_blackpoint {
+	const char *name;
+	void *addr;
+};
+extern struct kretprobe_blackpoint kretprobe_blacklist[];
+
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
 	unsigned long orig_ret_address, unsigned long trampoline_address)
 {
diff -puN kernel/kprobes.c~kprobes-support-kretprobe-blacklist kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-support-kretprobe-blacklist
+++ a/kernel/kprobes.c
@@ -716,6 +716,18 @@ int __kprobes register_kretprobe(struct 
 	int ret = 0;
 	struct kretprobe_instance *inst;
 	int i;
+	void *addr = rp->kp.addr;
+
+	if (kretprobe_blacklist_size) {
+		if (addr == NULL)
+			kprobe_lookup_name(rp->kp.symbol_name, addr);
+		addr += rp->kp.offset;
+
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			if (kretprobe_blacklist[i].addr == addr)
+				return -EINVAL;
+		}
+	}
 
 	rp->kp.pre_handler = pre_handler_kretprobe;
 	rp->kp.post_handler = NULL;
@@ -794,6 +806,17 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}
 
+	if (kretprobe_blacklist_size) {
+		/* lookup the function address from its name */
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			kprobe_lookup_name(kretprobe_blacklist[i].name,
+					   kretprobe_blacklist[i].addr);
+			if (!kretprobe_blacklist[i].addr)
+				printk("kretprobe: lookup failed: %s\n",
+				       kretprobe_blacklist[i].name);
+		}
+	}
+
 	/* By default, kprobes are enabled */
 	kprobe_enabled = true;
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
