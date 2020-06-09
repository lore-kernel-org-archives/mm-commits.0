From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 44/93] sysrq: use show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:32:10 -0700
Message-ID: <20200609043210.HNqw4CU_1%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:11 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, gregkh@linuxfoundation.org, jslaby@suse.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
