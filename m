From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 35/93] um/sysrq: remove needless variable sp
Date: Mon, 08 Jun 2020 21:31:42 -0700
Message-ID: <20200609043142.wKYnnLVHq%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEbo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:44 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton.ivanov@cambridgegreys.com, dima@arista.com, jdike@addtoit.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, richard@nod.at, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: um/sysrq: remove needless variable sp

`sp' is a needless excercise here.

Link: http://lkml.kernel.org/r/20200418201944.482088-36-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/sysrq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/um/kernel/sysrq.c~um-sysrq-remove-needless-variable-sp
+++ a/arch/um/kernel/sysrq.c
@@ -27,7 +27,6 @@ static const struct stacktrace_ops stack
 
 void show_stack(struct task_struct *task, unsigned long *stack)
 {
-	unsigned long *sp = stack;
 	struct pt_regs *segv_regs = current->thread.segv_regs;
 	int i;
 
@@ -38,10 +37,9 @@ void show_stack(struct task_struct *task
 	}
 
 	if (!stack)
-		sp = get_stack_pointer(task, segv_regs);
+		stack = get_stack_pointer(task, segv_regs);
 
 	pr_info("Stack:\n");
-	stack = sp;
 	for (i = 0; i < 3 * STACKSLOTS_PER_LINE; i++) {
 		if (kstack_end(stack))
 			break;
_
