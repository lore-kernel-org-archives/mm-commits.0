From: akpm@linux-foundation.org
Subject: [merged]
 printk-when-dumping-regs-show-the-stack-not-thread_info.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:56:44 -0700
Message-ID: <579ba6ec.TCIeIxMAi9HF++xn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbcG2S4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: when dumping regs, show the stack, not thread_info
has been removed from the -mm tree.  Its filename was
     printk-when-dumping-regs-show-the-stack-not-thread_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: printk: when dumping regs, show the stack, not thread_info

We currently show:

  task: <current> ti: <current_thread_info()> task.ti: <task_thread_info(current)>"

"ti" and "task.ti" are redundant, and neither is actually what we
want to show, which the the base of the thread stack.  Change the
display to show the stack pointer explicitly.

Link: http://lkml.kernel.org/r/543ac5bd66ff94000a57a02e11af7239571a3055.1468523549.git.luto@kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/printk/printk.c~printk-when-dumping-regs-show-the-stack-not-thread_info kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-when-dumping-regs-show-the-stack-not-thread_info
+++ a/kernel/printk/printk.c
@@ -3177,9 +3177,8 @@ void show_regs_print_info(const char *lo
 {
 	dump_stack_print_info(log_lvl);
 
-	printk("%stask: %p ti: %p task.ti: %p\n",
-	       log_lvl, current, current_thread_info(),
-	       task_thread_info(current));
+	printk("%stask: %p task.stack: %p\n",
+	       log_lvl, current, task_stack_page(current));
 }
 
 #endif
_

Patches currently in -mm which might be from luto@kernel.org are

signal-consolidate-tstlf_restore_sigmask-code.patch

