From: akpm@linux-foundation.org
Subject: [merged] sysrq-use-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:38:24 -0700
Message-ID: <20200610003824.hdig7TECl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgFJAiZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, gregkh@linuxfoundation.org, jslaby@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysrq: use show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     sysrq-use-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: sysrq: use show_stack_loglvl()

Show the stack trace on a CPU with the same log level as "CPU%d" header.

Link: http://lkml.kernel.org/r/20200418201944.482088-45-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c         |    2 +-
 include/linux/sched/debug.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/sysrq.c~sysrq-use-show_stack_loglvl
+++ a/drivers/tty/sysrq.c
@@ -235,7 +235,7 @@ static void showacpu(void *dummy)
 
 	raw_spin_lock_irqsave(&show_lock, flags);
 	pr_info("CPU%d:\n", smp_processor_id());
-	show_stack(NULL, NULL);
+	show_stack_loglvl(NULL, NULL, KERN_INFO);
 	raw_spin_unlock_irqrestore(&show_lock, flags);
 }
 
--- a/include/linux/sched/debug.h~sysrq-use-show_stack_loglvl
+++ a/include/linux/sched/debug.h
@@ -31,6 +31,8 @@ extern void show_regs(struct pt_regs *);
  * trace (or NULL if the entire call-chain of the task should be shown).
  */
 extern void show_stack(struct task_struct *task, unsigned long *sp);
+extern void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+			      const char *loglvl);
 
 extern void sched_show_task(struct task_struct *p);
 
_

Patches currently in -mm which might be from dima@arista.com are
