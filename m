From: akpm@linux-foundation.org
Subject: [merged]
 kprobes-move-kprobe-declarations-to-asm-generic-kprobesh.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:49:39 -0800
Message-ID: <58b5e263.lIh86+67bRbs81Ri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdB1XhM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@kernel.org, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, luto@kernel.org, mhiramat@kernel.org, mingo@kernel.org, rostedt@goodmis.org, sfr@canb.auug.org.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: move kprobe declarations to asm-generic/kprobes.h
has been removed from the -mm tree.  Its filename was
     kprobes-move-kprobe-declarations-to-asm-generic-kprobesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: kprobes: move kprobe declarations to asm-generic/kprobes.h

Often all is needed is these small helpers, instead of compiler.h or a
full kprobes.h.  This is important for asm helpers, in fact even some
asm/kprobes.h make use of these helpers...  instead just keep a generic
asm file with helpers useful for asm code with the least amount of clutter
as possible.

Likewise we need now to also address what to do about this file for both
when architectures have CONFIG_HAVE_KPROBES, and when they do not.  Then
for when architectures have CONFIG_HAVE_KPROBES but have disabled
CONFIG_KPROBES.

Right now most asm/kprobes.h do not have guards against CONFIG_KPROBES,
this means most architecture code cannot include asm/kprobes.h safely. 
Correct this and add guards for architectures missing them.  Additionally
provide architectures that not have kprobes support with the default
asm-generic solution.  This lets us force asm/kprobes.h on the header
include/linux/kprobes.h always, but most importantly we can now safely
include just asm/kprobes.h on architecture code without bringing the full
kitchen sink of header files.

Two architectures already provided a guard against CONFIG_KPROBES on its
kprobes.h: sh, arch.  The rest of the architectures needed gaurds added. 
We avoid including any not-needed headers on asm/kprobes.h unless kprobes
have been enabled.

In a subsequent atomic change we can try now to remove compiler.h from
include/linux/kprobes.h.

During this sweep I've also identified a few architectures defining a
common macro needed for both kprobes and ftrace, that of the definition of
the breakput instruction up.  Some refer to this as
BREAKPOINT_INSTRUCTION.  This must be kept outside of the #ifdef
CONFIG_KPROBES guard.

[mcgrof@kernel.org: fix arm64 build]
  Link: http://lkml.kernel.org/r/CAB=NE6X1WMByuARS4mZ1g9+W=LuVBnMDnh_5zyN0CLADaVh=Jw@mail.gmail.com
[sfr@canb.auug.org.au: fixup for kprobes declarations moving]
  Link: http://lkml.kernel.org/r/20170214165933.13ebd4f4@canb.auug.org.au
Link: http://lkml.kernel.org/r/20170203233139.32682-1-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                            |    1 
 arch/alpha/include/asm/Kbuild          |    1 
 arch/arc/include/asm/kprobes.h         |    6 +++--
 arch/arm/include/asm/kprobes.h         |    4 +++
 arch/arm/probes/decode.h               |    1 
 arch/arm64/include/asm/kprobes.h       |    4 +++
 arch/arm64/kernel/armv8_deprecated.c   |    1 
 arch/arm64/kernel/insn.c               |    1 
 arch/arm64/kernel/probes/decode-insn.h |    2 +
 arch/avr32/include/asm/kprobes.h       |    7 +++++-
 arch/blackfin/include/asm/Kbuild       |    1 
 arch/c6x/include/asm/Kbuild            |    1 
 arch/cris/include/asm/Kbuild           |    1 
 arch/frv/include/asm/Kbuild            |    1 
 arch/h8300/include/asm/Kbuild          |    1 
 arch/hexagon/include/asm/Kbuild        |    1 
 arch/ia64/include/asm/kprobes.h        |   12 ++++++++---
 arch/m32r/include/asm/Kbuild           |    1 
 arch/m68k/include/asm/Kbuild           |    1 
 arch/metag/include/asm/Kbuild          |    1 
 arch/microblaze/include/asm/Kbuild     |    1 
 arch/mips/include/asm/kprobes.h        |    6 ++++-
 arch/mn10300/include/asm/kprobes.h     |    7 +++++-
 arch/nios2/include/asm/Kbuild          |    1 
 arch/openrisc/include/asm/Kbuild       |    1 
 arch/parisc/include/asm/Kbuild         |    1 
 arch/powerpc/include/asm/kprobes.h     |    3 ++
 arch/powerpc/lib/code-patching.c       |    1 
 arch/s390/include/asm/kprobes.h        |    7 +++++-
 arch/score/include/asm/Kbuild          |    1 
 arch/sh/include/asm/kprobes.h          |    5 +++-
 arch/sparc/include/asm/kprobes.h       |   10 +++++++--
 arch/tile/include/asm/kprobes.h        |    6 ++++-
 arch/um/include/asm/Kbuild             |    1 
 arch/unicore32/include/asm/Kbuild      |    1 
 arch/x86/include/asm/kprobes.h         |    9 +++++++-
 arch/xtensa/include/asm/Kbuild         |    1 
 include/asm-generic/kprobes.h          |   25 +++++++++++++++++++++++
 include/linux/compiler.h               |    8 -------
 include/linux/kprobes.h                |   19 ++---------------
 40 files changed, 125 insertions(+), 38 deletions(-)

diff -puN MAINTAINERS~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh MAINTAINERS
--- a/MAINTAINERS~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/MAINTAINERS
@@ -7286,6 +7286,7 @@ M:	Masami Hiramatsu <mhiramat@kernel.org
 S:	Maintained
 F:	Documentation/kprobes.txt
 F:	include/linux/kprobes.h
+F:	include/asm-generic/kprobes.h
 F:	kernel/kprobes.c
 
 KS0108 LCD CONTROLLER DRIVER
diff -puN arch/alpha/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/alpha/include/asm/Kbuild
--- a/arch/alpha/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/alpha/include/asm/Kbuild
@@ -10,3 +10,4 @@ generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += current.h
+generic-y += kprobes.h
diff -puN arch/arc/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arc/include/asm/kprobes.h
--- a/arch/arc/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arc/include/asm/kprobes.h
@@ -9,6 +9,8 @@
 #ifndef _ARC_KPROBES_H
 #define _ARC_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
 #ifdef CONFIG_KPROBES
 
 typedef u16 kprobe_opcode_t;
@@ -55,6 +57,6 @@ void trap_is_kprobe(unsigned long addres
 static void trap_is_kprobe(unsigned long address, struct pt_regs *regs)
 {
 }
-#endif
+#endif /* CONFIG_KPROBES */
 
-#endif
+#endif /* _ARC_KPROBES_H */
diff -puN arch/arm/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arm/include/asm/kprobes.h
--- a/arch/arm/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arm/include/asm/kprobes.h
@@ -16,6 +16,9 @@
 #ifndef _ARM_KPROBES_H
 #define _ARM_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/notifier.h>
@@ -83,4 +86,5 @@ struct arch_optimized_insn {
 	 */
 };
 
+#endif /* CONFIG_KPROBES */
 #endif /* _ARM_KPROBES_H */
diff -puN arch/arm/probes/decode.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arm/probes/decode.h
--- a/arch/arm/probes/decode.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arm/probes/decode.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <asm/probes.h>
+#include <asm/kprobes.h>
 
 void __init arm_probes_decode_init(void);
 
diff -puN arch/arm64/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arm64/include/asm/kprobes.h
--- a/arch/arm64/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arm64/include/asm/kprobes.h
@@ -16,6 +16,9 @@
 #ifndef _ARM_KPROBES_H
 #define _ARM_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
@@ -57,4 +60,5 @@ int kprobe_single_step_handler(struct pt
 void kretprobe_trampoline(void);
 void __kprobes *trampoline_probe_handler(struct pt_regs *regs);
 
+#endif /* CONFIG_KPROBES */
 #endif /* _ARM_KPROBES_H */
diff -puN arch/arm64/kernel/armv8_deprecated.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arm64/kernel/armv8_deprecated.c
--- a/arch/arm64/kernel/armv8_deprecated.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arm64/kernel/armv8_deprecated.c
@@ -19,6 +19,7 @@
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
 #include <asm/traps.h>
+#include <asm/kprobes.h>
 #include <linux/uaccess.h>
 #include <asm/cpufeature.h>
 
diff -puN arch/arm64/kernel/insn.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arm64/kernel/insn.c
--- a/arch/arm64/kernel/insn.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arm64/kernel/insn.c
@@ -31,6 +31,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/fixmap.h>
 #include <asm/insn.h>
+#include <asm/kprobes.h>
 
 #define AARCH64_INSN_SF_BIT	BIT(31)
 #define AARCH64_INSN_N_BIT	BIT(22)
diff -puN arch/arm64/kernel/probes/decode-insn.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/arm64/kernel/probes/decode-insn.h
--- a/arch/arm64/kernel/probes/decode-insn.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/arm64/kernel/probes/decode-insn.h
@@ -16,6 +16,8 @@
 #ifndef _ARM_KERNEL_KPROBES_ARM64_H
 #define _ARM_KERNEL_KPROBES_ARM64_H
 
+#include <asm/kprobes.h>
+
 /*
  * ARM strongly recommends a limit of 128 bytes between LoadExcl and
  * StoreExcl instructions in a single thread of execution. So keep the
diff -puN arch/avr32/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/avr32/include/asm/kprobes.h
--- a/arch/avr32/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/avr32/include/asm/kprobes.h
@@ -11,10 +11,14 @@
 #ifndef __ASM_AVR32_KPROBES_H
 #define __ASM_AVR32_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#define BREAKPOINT_INSTRUCTION	0xd673	/* breakpoint */
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 
 typedef u16	kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0xd673	/* breakpoint */
 #define MAX_INSN_SIZE		2
 #define MAX_STACK_SIZE		64	/* 32 would probably be OK */
 
@@ -46,4 +50,5 @@ extern int kprobe_exceptions_notify(stru
 
 #define flush_insn_slot(p)	do { } while (0)
 
+#endif /* CONFIG_KPROBES */
 #endif /* __ASM_AVR32_KPROBES_H */
diff -puN arch/blackfin/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/blackfin/include/asm/Kbuild
--- a/arch/blackfin/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/blackfin/include/asm/Kbuild
@@ -46,3 +46,4 @@ generic-y += unaligned.h
 generic-y += user.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/c6x/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/c6x/include/asm/Kbuild
--- a/arch/c6x/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/c6x/include/asm/Kbuild
@@ -61,3 +61,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/cris/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/cris/include/asm/Kbuild
--- a/arch/cris/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/cris/include/asm/Kbuild
@@ -45,3 +45,4 @@ generic-y += types.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/frv/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/frv/include/asm/Kbuild
@@ -7,3 +7,4 @@ generic-y += mm-arch-hooks.h
 generic-y += preempt.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
+generic-y += kprobes.h
diff -puN arch/h8300/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/h8300/include/asm/Kbuild
--- a/arch/h8300/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/h8300/include/asm/Kbuild
@@ -74,3 +74,4 @@ generic-y += unaligned.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/hexagon/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/hexagon/include/asm/Kbuild
--- a/arch/hexagon/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/hexagon/include/asm/Kbuild
@@ -59,3 +59,4 @@ generic-y += unaligned.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/ia64/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/ia64/include/asm/kprobes.h
--- a/arch/ia64/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/ia64/include/asm/kprobes.h
@@ -23,14 +23,19 @@
  * 2005-Apr     Rusty Lynch <rusty.lynch@intel.com> and Anil S Keshavamurthy
  *              <anil.s.keshavamurthy@intel.com> adapted from i386
  */
+#include <asm-generic/kprobes.h>
+#include <asm/break.h>
+
+#define BREAK_INST	(long)(__IA64_BREAK_KPROBE << 6)
+
+#ifdef CONFIG_KPROBES
+
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
-#include <asm/break.h>
 
 #define __ARCH_WANT_KPROBES_INSN_SLOT
 #define MAX_INSN_SIZE   2	/* last half is for kprobe-booster */
-#define BREAK_INST	(long)(__IA64_BREAK_KPROBE << 6)
 #define NOP_M_INST	(long)(1<<27)
 #define BRL_INST(i1, i2) ((long)((0xcL << 37) |	/* brl */ \
 				(0x1L << 12) |	/* many */ \
@@ -124,4 +129,5 @@ extern void invalidate_stacked_regs(void
 extern void flush_register_stack(void);
 extern void arch_remove_kprobe(struct kprobe *p);
 
-#endif				/* _ASM_KPROBES_H */
+#endif /* CONFIG_KPROBES */
+#endif /* _ASM_KPROBES_H */
diff -puN arch/m32r/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/m32r/include/asm/Kbuild
@@ -11,3 +11,4 @@ generic-y += preempt.h
 generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
+generic-y += kprobes.h
diff -puN arch/m68k/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/m68k/include/asm/Kbuild
--- a/arch/m68k/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/m68k/include/asm/Kbuild
@@ -33,3 +33,4 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/metag/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/metag/include/asm/Kbuild
--- a/arch/metag/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/metag/include/asm/Kbuild
@@ -54,3 +54,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/microblaze/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/microblaze/include/asm/Kbuild
--- a/arch/microblaze/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/microblaze/include/asm/Kbuild
@@ -10,3 +10,4 @@ generic-y += preempt.h
 generic-y += syscalls.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
+generic-y += kprobes.h
diff -puN arch/mips/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/mips/include/asm/kprobes.h
--- a/arch/mips/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/mips/include/asm/kprobes.h
@@ -22,6 +22,9 @@
 #ifndef _ASM_KPROBES_H
 #define _ASM_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#ifdef CONFIG_KPROBES
 #include <linux/ptrace.h>
 #include <linux/types.h>
 
@@ -94,4 +97,5 @@ struct kprobe_ctlblk {
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 
-#endif				/* _ASM_KPROBES_H */
+#endif /* CONFIG_KPROBES */
+#endif /* _ASM_KPROBES_H */
diff -puN arch/mn10300/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/mn10300/include/asm/kprobes.h
--- a/arch/mn10300/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/mn10300/include/asm/kprobes.h
@@ -21,13 +21,17 @@
 #ifndef _ASM_KPROBES_H
 #define _ASM_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#define BREAKPOINT_INSTRUCTION	0xff
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 #include <linux/ptrace.h>
 
 struct kprobe;
 
 typedef unsigned char kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0xff
 #define MAX_INSN_SIZE 8
 #define MAX_STACK_SIZE 128
 
@@ -47,4 +51,5 @@ extern int kprobe_exceptions_notify(stru
 
 extern void arch_remove_kprobe(struct kprobe *p);
 
+#endif /* CONFIG_KPROBES */
 #endif /* _ASM_KPROBES_H */
diff -puN arch/nios2/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/nios2/include/asm/Kbuild
--- a/arch/nios2/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/nios2/include/asm/Kbuild
@@ -62,3 +62,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/openrisc/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/openrisc/include/asm/Kbuild
--- a/arch/openrisc/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/openrisc/include/asm/Kbuild
@@ -67,3 +67,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/parisc/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/parisc/include/asm/Kbuild
--- a/arch/parisc/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/parisc/include/asm/Kbuild
@@ -28,3 +28,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/powerpc/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/powerpc/include/asm/kprobes.h
--- a/arch/powerpc/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/powerpc/include/asm/kprobes.h
@@ -1,5 +1,8 @@
 #ifndef _ASM_POWERPC_KPROBES_H
 #define _ASM_POWERPC_KPROBES_H
+
+#include <asm-generic/kprobes.h>
+
 #ifdef __KERNEL__
 /*
  *  Kernel Probes (KProbes)
diff -puN arch/powerpc/lib/code-patching.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/powerpc/lib/code-patching.c
--- a/arch/powerpc/lib/code-patching.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/powerpc/lib/code-patching.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/code-patching.h>
 #include <linux/uaccess.h>
+#include <linux/kprobes.h>
 
 
 int patch_instruction(unsigned int *addr, unsigned int instr)
diff -puN arch/s390/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/s390/include/asm/kprobes.h
--- a/arch/s390/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/s390/include/asm/kprobes.h
@@ -27,6 +27,11 @@
  * 2005-Dec	Used as a template for s390 by Mike Grundy
  *		<grundym@us.ibm.com>
  */
+#include <asm-generic/kprobes.h>
+
+#define BREAKPOINT_INSTRUCTION	0x0002
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
@@ -37,7 +42,6 @@ struct pt_regs;
 struct kprobe;
 
 typedef u16 kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0x0002
 
 /* Maximum instruction size is 3 (16bit) halfwords: */
 #define MAX_INSN_SIZE		0x0003
@@ -91,4 +95,5 @@ int probe_is_insn_relative_long(u16 *ins
 
 #define flush_insn_slot(p)	do { } while (0)
 
+#endif /* CONFIG_KPROBES */
 #endif	/* _ASM_S390_KPROBES_H */
diff -puN arch/score/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/score/include/asm/Kbuild
@@ -13,3 +13,4 @@ generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += serial.h
 generic-y += word-at-a-time.h
+generic-y += kprobes.h
diff -puN arch/sh/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/sh/include/asm/kprobes.h
--- a/arch/sh/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/sh/include/asm/kprobes.h
@@ -1,13 +1,16 @@
 #ifndef __ASM_SH_KPROBES_H
 #define __ASM_SH_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#define BREAKPOINT_INSTRUCTION	0xc33a
+
 #ifdef CONFIG_KPROBES
 
 #include <linux/types.h>
 #include <linux/ptrace.h>
 
 typedef insn_size_t kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0xc33a
 
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
diff -puN arch/sparc/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/sparc/include/asm/kprobes.h
--- a/arch/sparc/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/sparc/include/asm/kprobes.h
@@ -1,13 +1,17 @@
 #ifndef _SPARC64_KPROBES_H
 #define _SPARC64_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#define BREAKPOINT_INSTRUCTION   0x91d02070 /* ta 0x70 */
+#define BREAKPOINT_INSTRUCTION_2 0x91d02071 /* ta 0x71 */
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 #include <linux/percpu.h>
 
 typedef u32 kprobe_opcode_t;
 
-#define BREAKPOINT_INSTRUCTION   0x91d02070 /* ta 0x70 */
-#define BREAKPOINT_INSTRUCTION_2 0x91d02071 /* ta 0x71 */
 #define MAX_INSN_SIZE 2
 
 #define kretprobe_blacklist_size 0
@@ -48,4 +52,6 @@ int kprobe_exceptions_notify(struct noti
 int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 asmlinkage void __kprobes kprobe_trap(unsigned long trap_level,
 				      struct pt_regs *regs);
+
+#endif /* CONFIG_KPROBES */
 #endif /* _SPARC64_KPROBES_H */
diff -puN arch/tile/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/tile/include/asm/kprobes.h
--- a/arch/tile/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/tile/include/asm/kprobes.h
@@ -17,10 +17,13 @@
 #ifndef _ASM_TILE_KPROBES_H
 #define _ASM_TILE_KPROBES_H
 
+#include <asm-generic/kprobes.h>
+
+#ifdef CONFIG_KPROBES
+
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
-
 #include <arch/opcode.h>
 
 #define __ARCH_WANT_KPROBES_INSN_SLOT
@@ -76,4 +79,5 @@ void arch_remove_kprobe(struct kprobe *)
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 			     unsigned long val, void *data);
 
+#endif /* CONFIG_KPROBES */
 #endif /* _ASM_TILE_KPROBES_H */
diff -puN arch/um/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/um/include/asm/Kbuild
--- a/arch/um/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/um/include/asm/Kbuild
@@ -25,3 +25,4 @@ generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/unicore32/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/unicore32/include/asm/Kbuild
--- a/arch/unicore32/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/unicore32/include/asm/Kbuild
@@ -63,3 +63,4 @@ generic-y += user.h
 generic-y += vga.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN arch/x86/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/x86/include/asm/kprobes.h
--- a/arch/x86/include/asm/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/x86/include/asm/kprobes.h
@@ -21,6 +21,12 @@
  *
  * See arch/x86/kernel/kprobes.c for x86 kprobes history.
  */
+
+#include <asm-generic/kprobes.h>
+
+#define BREAKPOINT_INSTRUCTION	0xcc
+
+#ifdef CONFIG_KPROBES
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
@@ -32,7 +38,6 @@ struct pt_regs;
 struct kprobe;
 
 typedef u8 kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0xcc
 #define RELATIVEJUMP_OPCODE 0xe9
 #define RELATIVEJUMP_SIZE 5
 #define RELATIVECALL_OPCODE 0xe8
@@ -116,4 +121,6 @@ extern int kprobe_exceptions_notify(stru
 				    unsigned long val, void *data);
 extern int kprobe_int3_handler(struct pt_regs *regs);
 extern int kprobe_debug_handler(struct pt_regs *regs);
+
+#endif /* CONFIG_KPROBES */
 #endif /* _ASM_X86_KPROBES_H */
diff -puN arch/xtensa/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh arch/xtensa/include/asm/Kbuild
--- a/arch/xtensa/include/asm/Kbuild~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/arch/xtensa/include/asm/Kbuild
@@ -31,3 +31,4 @@ generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
+generic-y += kprobes.h
diff -puN /dev/null include/asm-generic/kprobes.h
--- /dev/null
+++ a/include/asm-generic/kprobes.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_GENERIC_KPROBES_H
+#define _ASM_GENERIC_KPROBES_H
+
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#ifdef CONFIG_KPROBES
+/*
+ * Blacklist ganerating macro. Specify functions which is not probed
+ * by using this macro.
+ */
+# define __NOKPROBE_SYMBOL(fname)				\
+static unsigned long __used					\
+	__attribute__((__section__("_kprobe_blacklist")))	\
+	_kbl_addr_##fname = (unsigned long)fname;
+# define NOKPROBE_SYMBOL(fname)	__NOKPROBE_SYMBOL(fname)
+/* Use this to forbid a kprobes attach on very low level functions */
+# define __kprobes	__attribute__((__section__(".kprobes.text")))
+# define nokprobe_inline	__always_inline
+#else
+# define NOKPROBE_SYMBOL(fname)
+# define __kprobes
+# define nokprobe_inline	inline
+#endif
+#endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
+
+#endif /* _ASM_GENERIC_KPROBES_H */
diff -puN include/linux/compiler.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh include/linux/compiler.h
--- a/include/linux/compiler.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/include/linux/compiler.h
@@ -570,12 +570,4 @@ static __always_inline void __write_once
 	(_________p1); \
 })
 
-/* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
-#ifdef CONFIG_KPROBES
-# define __kprobes	__attribute__((__section__(".kprobes.text")))
-# define nokprobe_inline	__always_inline
-#else
-# define __kprobes
-# define nokprobe_inline	inline
-#endif
 #endif /* __LINUX_COMPILER_H */
diff -puN include/linux/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh
+++ a/include/linux/kprobes.h
@@ -29,7 +29,7 @@
  *		<jkenisto@us.ibm.com>  and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  */
-#include <linux/compiler.h>	/* for __kprobes */
+#include <linux/compiler.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 #include <linux/notifier.h>
@@ -40,9 +40,9 @@
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
 #include <linux/ftrace.h>
+#include <asm/kprobes.h>
 
 #ifdef CONFIG_KPROBES
-#include <asm/kprobes.h>
 
 /* kprobe_status settings */
 #define KPROBE_HIT_ACTIVE	0x00000001
@@ -51,6 +51,7 @@
 #define KPROBE_HIT_SSDONE	0x00000008
 
 #else /* CONFIG_KPROBES */
+#include <asm-generic/kprobes.h>
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
 	int dummy;
@@ -509,18 +510,4 @@ static inline bool is_kprobe_optinsn_slo
 }
 #endif
 
-#ifdef CONFIG_KPROBES
-/*
- * Blacklist ganerating macro. Specify functions which is not probed
- * by using this macro.
- */
-#define __NOKPROBE_SYMBOL(fname)			\
-static unsigned long __used				\
-	__attribute__((section("_kprobe_blacklist")))	\
-	_kbl_addr_##fname = (unsigned long)fname;
-#define NOKPROBE_SYMBOL(fname)	__NOKPROBE_SYMBOL(fname)
-#else
-#define NOKPROBE_SYMBOL(fname)
-#endif
