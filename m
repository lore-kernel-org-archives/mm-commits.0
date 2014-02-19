From: akpm@linux-foundation.org
Subject: + sh-dont-pass-saved-userspace-state-to-exception-handlers.patch
 added to -mm tree
Date: Wed, 19 Feb 2014 13:01:58 -0800
Message-ID: <53051bc6.EkbKGMHQTGqD6g8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaBSVB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 16:01:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.mundt@gmail.com, koorogi@koorogi.info

Subject: + sh-dont-pass-saved-userspace-state-to-exception-handlers.patch added to -mm tree
To: koorogi@koorogi.info,paul.mundt@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 13:01:58 -0800


The patch titled
     Subject: sh: don't pass saved userspace state to exception handlers
has been added to the -mm tree.  Its filename is
     sh-dont-pass-saved-userspace-state-to-exception-handlers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-dont-pass-saved-userspace-state-to-exception-handlers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-dont-pass-saved-userspace-state-to-exception-handlers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-push-extra-copy-of-r0-r2-for-syscall-parameters.patch
sh-remove-unused-do_fpu_error.patch
sh-dont-pass-saved-userspace-state-to-exception-handlers.patch

