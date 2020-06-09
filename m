From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 19/93] microblaze: add loglvl to
 microblaze_unwind()
Date: Mon, 08 Jun 2020 21:30:53 -0700
Message-ID: <20200609043053.MuEy3p4G9%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgFIEay (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:54 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, monstr@monstr.eu, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: microblaze: add loglvl to microblaze_unwind()

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

Add log level parameter to microblaze_unwind() as a preparation to add
show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-20-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/unwind.h |    3 ++-
 arch/microblaze/kernel/stacktrace.c  |    4 ++--
 arch/microblaze/kernel/traps.c       |    2 +-
 arch/microblaze/kernel/unwind.c      |    6 +++---
 4 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/microblaze/include/asm/unwind.h~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/include/asm/unwind.h
@@ -20,7 +20,8 @@ extern struct trap_handler_info microbla
 extern const char _hw_exception_handler;
 extern const char ex_handler_unhandled;
 
-void microblaze_unwind(struct task_struct *task, struct stack_trace *trace);
+void microblaze_unwind(struct task_struct *task, struct stack_trace *trace,
+		       const char *loglvl);
 
 #endif	/* __MICROBLAZE_UNWIND_H */
 
--- a/arch/microblaze/kernel/stacktrace.c~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/kernel/stacktrace.c
@@ -20,12 +20,12 @@ void save_stack_trace(struct stack_trace
 {
 	/* Exclude our helper functions from the trace*/
 	trace->skip += 2;
-	microblaze_unwind(NULL, trace);
+	microblaze_unwind(NULL, trace, "");
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	microblaze_unwind(tsk, trace);
+	microblaze_unwind(tsk, trace, "");
 }
 EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
--- a/arch/microblaze/kernel/traps.c~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/kernel/traps.c
@@ -68,7 +68,7 @@ void show_stack(struct task_struct *task
 	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 32, 4, (void *)fp,
 		       words_to_show << 2, 0);
 	pr_info("\n\nCall Trace:\n");
-	microblaze_unwind(task, NULL);
+	microblaze_unwind(task, NULL, KERN_INFO);
 	pr_info("\n");
 
 	if (!task)
--- a/arch/microblaze/kernel/unwind.c~microblaze-add-loglvl-to-microblaze_unwind
+++ a/arch/microblaze/kernel/unwind.c
@@ -287,11 +287,11 @@ static void microblaze_unwind_inner(stru
  * @task  : Task whose stack we are to unwind (NULL == current)
  * @trace : Where to store stack backtrace (PC values).
  *	    NULL == print backtrace to kernel log
+ * @loglvl : Used for printk log level if (trace == NULL).
  */
-void microblaze_unwind(struct task_struct *task, struct stack_trace *trace)
+void microblaze_unwind(struct task_struct *task, struct stack_trace *trace,
+		       const char *loglvl)
 {
-	const char *loglvl = KERN_INFO;
