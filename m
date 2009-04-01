From: akpm@linux-foundation.org
Subject: + xtensa-use-correct-stack-pointer-for-stack-traces.patch added to -mm tree
Date: Wed, 01 Apr 2009 13:14:38 -0700
Message-ID: <200904012014.n31KEckk004113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758253AbZDAURS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 16:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, os@emlix.com


The patch titled
     xtensa: use correct stack pointer for stack traces
has been added to the -mm tree.  Its filename is
     xtensa-use-correct-stack-pointer-for-stack-traces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use correct stack pointer for stack traces
From: Johannes Weiner <jw@emlix.com>

Right now, the xtensa stacktrace code reads the _current_ kernel stack
pointer if nothing is supplied.  With debugging facilities like sysrq this
means that the backtrace of the sysrq-handler is printed instead of a
trace of the given task's stack.

When no stack pointer is specified in show_trace() and show_stack(), use
the stack pointer that comes with the handed in task descriptor to make
stack traces more useful.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/xtensa/kernel/traps.c~xtensa-use-correct-stack-pointer-for-stack-traces arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~xtensa-use-correct-stack-pointer-for-stack-traces
+++ a/arch/xtensa/kernel/traps.c
@@ -374,11 +374,10 @@ void show_trace(struct task_struct *task
 	unsigned long a0, a1, pc;
 	unsigned long sp_start, sp_end;
 
-	a1 = (unsigned long)sp;
-
-	if (a1 == 0)
-		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(a1));
-
+	if (sp)
+		a1 = (unsigned long)sp;
+	else
+		a1 = task->thread.sp;
 
 	sp_start = a1 & ~(THREAD_SIZE-1);
 	sp_end = sp_start + THREAD_SIZE;
@@ -420,9 +419,8 @@ void show_stack(struct task_struct *task
 	int i = 0;
 	unsigned long *stack;
 
-	if (sp == 0)
-		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(sp));
-
+	if (!sp)
+		sp = (unsigned long *)task->thread.sp;
  	stack = sp;
 
 	printk("\nStack: ");
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-remove-redefinition-of-xchal_mmu_asid_bits.patch
xtensa-use-correct-stack-pointer-for-stack-traces.patch
xtensa-fix-init_bootmem_node-argument-order.patch
xtensa-dont-make-bootmem-bitmap-larger-than-required.patch
xtensa-cope-with-ram-beginning-at-higher-addresses.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

