From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 42/93] xtensa: add loglvl to show_trace()
Date: Mon, 08 Jun 2020 21:32:04 -0700
Message-ID: <20200609043204.qC3vhvCzc%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:05 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@zankel.net, dima@arista.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@kernel.org, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: xtensa: add loglvl to show_trace()

Currently, the log-level of show_stack() depends on a platform
realization.  It creates situations where the headers are printed with
lower log level or higher than the stacktrace (depending on a platform or
user).

Furthermore, it forces the logic decision from user to an architecture
side.  In result, some users as sysrq/kdb/etc are doing tricks with
temporary rising console_loglevel while printing their messages.  And in
result it not only may print unwanted messages from other CPUs, but also
omit printing at all in the unlucky case where the printk() was deferred.

Introducing log-level parameter and KERN_UNSUPPRESSED [1] seems an easier
approach than introducing more printk buffers.  Also, it will consolidate
printings with headers.

Add log level argument to show_trace() as a preparation for introducing
show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

[rppt@kernel.org: build fix]
  Link: http://lkml.kernel.org/r/20200511194534.GA1018386@kernel.org
Link: http://lkml.kernel.org/r/20200418201944.482088-43-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/xtensa/kernel/traps.c~xtensa-add-loglvl-to-show_trace
+++ a/arch/xtensa/kernel/traps.c
@@ -479,18 +479,22 @@ void show_regs(struct pt_regs * regs)
 
 static int show_trace_cb(struct stackframe *frame, void *data)
 {
+	const char *loglvl = data;
+
 	if (kernel_text_address(frame->pc))
-		pr_cont(" [<%08lx>] %pB\n", frame->pc, (void *)frame->pc);
+		printk("%s [<%08lx>] %pB\n",
+			loglvl, frame->pc, (void *)frame->pc);
 	return 0;
 }
 
-void show_trace(struct task_struct *task, unsigned long *sp)
+static void show_trace(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
 {
 	if (!sp)
 		sp = stack_pointer(task);
 
-	pr_info("Call Trace:\n");
-	walk_stackframe(sp, show_trace_cb, NULL);
+	printk("%sCall Trace:\n", loglvl);
+	walk_stackframe(sp, show_trace_cb, (void *)loglvl);
 }
 
 #define STACK_DUMP_ENTRY_SIZE 4
@@ -511,7 +515,7 @@ void show_stack(struct task_struct *task
 	print_hex_dump(KERN_INFO, " ", DUMP_PREFIX_NONE,
 		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
 		       sp, len, false);
-	show_trace(task, sp);
+	show_trace(task, sp, KERN_INFO);
 }
 
 DEFINE_SPINLOCK(die_lock);
_
