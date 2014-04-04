From: akpm@linux-foundation.org
Subject: [merged]
 sh-dont-pass-saved-userspace-state-to-exception-handlers.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:49 -0700
Message-ID: <533f082d.Hwfy2M6Hw8ewjK0X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaDDT3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.mundt@gmail.com, koorogi@koorogi.info

Subject: [merged] sh-dont-pass-saved-userspace-state-to-exception-handlers.patch removed from -mm tree
To: koorogi@koorogi.info,paul.mundt@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:49 -0700


The patch titled
     Subject: sh: don't pass saved userspace state to exception handlers
has been removed from the -mm tree.  Its filename was
     sh-dont-pass-saved-userspace-state-to-exception-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bobby Bingham <koorogi@koorogi.info>
Subject: sh: don't pass saved userspace state to exception handlers

The compiler is permitted to generate code which overwrites the parameters
to a function.  If those parameters include the only saved copy we have of
userspace's registers, we're in trouble.

Signed-off-by: Bobby Bingham <koorogi@koorogi.info>
Cc: Paul Mundt <paul.mundt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/traps_32.h |   16 ++++------------
 arch/sh/kernel/traps_32.c      |   23 +++++++----------------
 2 files changed, 11 insertions(+), 28 deletions(-)

diff -puN arch/sh/include/asm/traps_32.h~sh-dont-pass-saved-userspace-state-to-exception-handlers arch/sh/include/asm/traps_32.h
--- a/arch/sh/include/asm/traps_32.h~sh-dont-pass-saved-userspace-state-to-exception-handlers
+++ a/arch/sh/include/asm/traps_32.h
@@ -42,18 +42,10 @@ static inline void trigger_address_error
 asmlinkage void do_address_error(struct pt_regs *regs,
 				 unsigned long writeaccess,
 				 unsigned long address);
-asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
-				   unsigned long r6, unsigned long r7,
-				   struct pt_regs __regs);
+asmlinkage void do_divide_error(unsigned long r4);
+asmlinkage void do_reserved_inst(void);
+asmlinkage void do_illegal_slot_inst(void);
+asmlinkage void do_exception_error(void);
 
 #define BUILD_TRAP_HANDLER(name)					\
 asmlinkage void name##_trap_handler(unsigned long r4, unsigned long r5,	\
diff -puN arch/sh/kernel/traps_32.c~sh-dont-pass-saved-userspace-state-to-exception-handlers arch/sh/kernel/traps_32.c
--- a/arch/sh/kernel/traps_32.c~sh-dont-pass-saved-userspace-state-to-exception-handlers
+++ a/arch/sh/kernel/traps_32.c
@@ -594,9 +594,7 @@ int is_dsp_inst(struct pt_regs *regs)
 #endif /* CONFIG_SH_DSP */
 
 #ifdef CONFIG_CPU_SH2A
-asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage void do_divide_error(unsigned long r4)
 {
 	siginfo_t info;
 
@@ -613,11 +611,9 @@ asmlinkage void do_divide_error(unsigned
 }
 #endif
 
-asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage void do_reserved_inst(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	unsigned long error_code;
 	struct task_struct *tsk = current;
 
@@ -701,11 +697,9 @@ static int emulate_branch(unsigned short
 }
 #endif
 
-asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs)
+asmlinkage void do_illegal_slot_inst(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
+	struct pt_regs *regs = current_pt_regs();
 	unsigned long inst;
 	struct task_struct *tsk = current;
 
@@ -730,15 +724,12 @@ asmlinkage void do_illegal_slot_inst(uns
 	die_if_no_fixup("illegal slot instruction", regs, inst);
 }
 
-asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
-				   unsigned long r6, unsigned long r7,
-				   struct pt_regs __regs)
+asmlinkage void do_exception_error(void)
 {
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	long ex;
 
 	ex = lookup_exception_vector();
-	die_if_kernel("exception", regs, ex);
+	die_if_kernel("exception", current_pt_regs(), ex);
 }
 
 void per_cpu_trap_init(void)
_

Patches currently in -mm which might be from koorogi@koorogi.info are

origin.patch

