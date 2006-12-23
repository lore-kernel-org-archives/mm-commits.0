From: akpm@osdl.org
Subject: - ptrace-fix-efl_offset-value-according-to-i386-pda-changes.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:54 -0800
Message-ID: <200612230754.kBN7ssqO010251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbWLWHzU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, deweerdt@free.fr, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: Fix EFL_OFFSET value according to i386 pda changes
has been removed from the -mm tree.  Its filename was
     ptrace-fix-efl_offset-value-according-to-i386-pda-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ptrace: Fix EFL_OFFSET value according to i386 pda changes
From: Jeremy Fitzhardinge <jeremy@goop.org>

The PDA patches introduced a bug in ptrace: it reads eflags from the wrong
place on the target's stack, but writes it back to the correct place.  The
result is a corrupted eflags, which is most visible when it turns interrupts
off unexpectedly.

This patch fixes this by making the ptrace code a little less fragile.  It
changes [gs]et_stack_long to take a straightforward byte offset into struct
pt_regs, rather than requiring all callers to do a sizeof(struct pt_regs)
offset adjustment.  This means that the eflag's offset (EFL_OFFSET) on the
target stack can be simply computed with offsetof().

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Frederik Deweerdt <deweerdt@free.fr>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/ptrace.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/ptrace.c~ptrace-fix-efl_offset-value-according-to-i386-pda-changes arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~ptrace-fix-efl_offset-value-according-to-i386-pda-changes
+++ a/arch/i386/kernel/ptrace.c
@@ -45,7 +45,7 @@
 /*
  * Offset of eflags on child stack..
  */
-#define EFL_OFFSET ((EFL-2)*4-sizeof(struct pt_regs))
+#define EFL_OFFSET offsetof(struct pt_regs, eflags)
 
 static inline struct pt_regs *get_child_regs(struct task_struct *task)
 {
@@ -54,24 +54,24 @@ static inline struct pt_regs *get_child_
 }
 
 /*
- * this routine will get a word off of the processes privileged stack. 
- * the offset is how far from the base addr as stored in the TSS.  
- * this routine assumes that all the privileged stacks are in our
+ * This routine will get a word off of the processes privileged stack.
+ * the offset is bytes into the pt_regs structure on the stack.
+ * This routine assumes that all the privileged stacks are in our
  * data space.
  */   
 static inline int get_stack_long(struct task_struct *task, int offset)
 {
 	unsigned char *stack;
 
-	stack = (unsigned char *)task->thread.esp0;
+	stack = (unsigned char *)task->thread.esp0 - sizeof(struct pt_regs);
 	stack += offset;
 	return (*((int *)stack));
 }
 
 /*
- * this routine will put a word on the processes privileged stack. 
- * the offset is how far from the base addr as stored in the TSS.  
- * this routine assumes that all the privileged stacks are in our
+ * This routine will put a word on the processes privileged stack.
+ * the offset is bytes into the pt_regs structure on the stack.
+ * This routine assumes that all the privileged stacks are in our
  * data space.
  */
 static inline int put_stack_long(struct task_struct *task, int offset,
@@ -79,7 +79,7 @@ static inline int put_stack_long(struct 
 {
 	unsigned char * stack;
 
-	stack = (unsigned char *) task->thread.esp0;
+	stack = (unsigned char *)task->thread.esp0 - sizeof(struct pt_regs);
 	stack += offset;
 	*(unsigned long *) stack = data;
 	return 0;
@@ -114,7 +114,7 @@ static int putreg(struct task_struct *ch
 	}
 	if (regno > ES*4)
 		regno -= 1*4;
-	put_stack_long(child, regno - sizeof(struct pt_regs), value);
+	put_stack_long(child, regno, value);
 	return 0;
 }
 
@@ -137,7 +137,6 @@ static unsigned long getreg(struct task_
 		default:
 			if (regno > ES*4)
 				regno -= 1*4;
-			regno = regno - sizeof(struct pt_regs);
 			retval &= get_stack_long(child, regno);
 	}
 	return retval;
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-ptrace-make-putgetreg-work-again-for-gs-and-fs.patch
gtod-uninline-jiffiesh.patch

