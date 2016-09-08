From: akpm@linux-foundation.org
Subject: + uprobes-remove-function-declarations-from-arch-mipss390.patch
 added to -mm tree
Date: Thu, 08 Sep 2016 15:32:52 -0700
Message-ID: <57d1e714.Fdzie8W2vZ9TTKD3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45685 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbcIHWcx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:32:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.nowakowski@imgtec.com, heiko.carstens@de.ibm.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uprobes: remove function declarations from arch/{mips,s390}
has been added to the -mm tree.  Its filename is
     uprobes-remove-function-declarations-from-arch-mipss390.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uprobes-remove-function-declarations-from-arch-mipss390.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uprobes-remove-function-declarations-from-arch-mipss390.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: uprobes: remove function declarations from arch/{mips,s390}

The declarations of arch-specific functions have been moved to a common
header in commit 3820b4d2789f ('uprobes: Move function declarations out of
arch'), but MIPS and S390 has added them to their own trees later.
Remove the unnecessary duplicates.

Link: http://lkml.kernel.org/r/1472804384-17830-1-git-send-email-marcin.nowakowski@imgtec.com
Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/uprobes.h |   12 ------------
 arch/s390/include/asm/uprobes.h |   10 ----------
 2 files changed, 22 deletions(-)

diff -puN arch/mips/include/asm/uprobes.h~uprobes-remove-function-declarations-from-arch-mipss390 arch/mips/include/asm/uprobes.h
--- a/arch/mips/include/asm/uprobes.h~uprobes-remove-function-declarations-from-arch-mipss390
+++ a/arch/mips/include/asm/uprobes.h
@@ -43,16 +43,4 @@ struct arch_uprobe_task {
 	unsigned long saved_trap_nr;
 };
 
-extern int arch_uprobe_analyze_insn(struct arch_uprobe *aup,
-	struct mm_struct *mm, unsigned long addr);
-extern int arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern int arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
-extern int arch_uprobe_exception_notify(struct notifier_block *self,
-	unsigned long val, void *data);
-extern void arch_uprobe_abort_xol(struct arch_uprobe *aup,
-	struct pt_regs *regs);
-extern unsigned long arch_uretprobe_hijack_return_addr(
-	unsigned long trampoline_vaddr, struct pt_regs *regs);
-
 #endif /* __ASM_UPROBES_H */
diff -puN arch/s390/include/asm/uprobes.h~uprobes-remove-function-declarations-from-arch-mipss390 arch/s390/include/asm/uprobes.h
--- a/arch/s390/include/asm/uprobes.h~uprobes-remove-function-declarations-from-arch-mipss390
+++ a/arch/s390/include/asm/uprobes.h
@@ -29,14 +29,4 @@ struct arch_uprobe {
 struct arch_uprobe_task {
 };
 
-int arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm,
-			     unsigned long addr);
-int arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-int arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
-int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val,
-				 void *data);
-void arch_uprobe_abort_xol(struct arch_uprobe *ap, struct pt_regs *regs);
-unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline,
-						struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
_

Patches currently in -mm which might be from marcin.nowakowski@imgtec.com are

uprobes-remove-function-declarations-from-arch-mipss390.patch

