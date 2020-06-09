From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 18/93] microblaze: add loglvl to
 microblaze_unwind_inner()
Date: Mon, 08 Jun 2020 21:30:50 -0700
Message-ID: <20200609043050.j8s3w9QNF%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgFIEax (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:53 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dima@arista.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, monstr@monstr.eu, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: microblaze: add loglvl to microblaze_unwind_inner()

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

Add log level argument to microblaze_unwind_inner() as a preparation for
introducing show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-19-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/unwind.c |   38 ++++++++++++++++++------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/arch/microblaze/kernel/unwind.c~microblaze-add-loglvl-to-microblaze_unwind_inner
+++ a/arch/microblaze/kernel/unwind.c
@@ -154,7 +154,8 @@ static int lookup_prev_stack_frame(unsig
 static void microblaze_unwind_inner(struct task_struct *task,
 				    unsigned long pc, unsigned long fp,
 				    unsigned long leaf_return,
-				    struct stack_trace *trace);
+				    struct stack_trace *trace,
+				    const char *loglvl);
 
 /**
  * unwind_trap - Unwind through a system trap, that stored previous state
@@ -162,16 +163,18 @@ static void microblaze_unwind_inner(stru
  */
 #ifdef CONFIG_MMU
 static inline void unwind_trap(struct task_struct *task, unsigned long pc,
-				unsigned long fp, struct stack_trace *trace)
+				unsigned long fp, struct stack_trace *trace,
+				const char *loglvl)
 {
 	/* To be implemented */
 }
 #else
 static inline void unwind_trap(struct task_struct *task, unsigned long pc,
-				unsigned long fp, struct stack_trace *trace)
+				unsigned long fp, struct stack_trace *trace,
+				const char *loglvl)
 {
 	const struct pt_regs *regs = (const struct pt_regs *) fp;
-	microblaze_unwind_inner(task, regs->pc, regs->r1, regs->r15, trace);
+	microblaze_unwind_inner(task, regs->pc, regs->r1, regs->r15, trace, loglvl);
 }
 #endif
 
@@ -184,11 +187,13 @@ static inline void unwind_trap(struct ta
  *				  the caller's return address.
  * @trace : Where to store stack backtrace (PC values).
  *	    NULL == print backtrace to kernel log
+ * @loglvl : Used for printk log level if (trace == NULL).
  */
 static void microblaze_unwind_inner(struct task_struct *task,
 			     unsigned long pc, unsigned long fp,
 			     unsigned long leaf_return,
-			     struct stack_trace *trace)
+			     struct stack_trace *trace,
+			     const char *loglvl)
 {
 	int ofs = 0;
 
@@ -214,11 +219,11 @@ static void microblaze_unwind_inner(stru
 			const struct pt_regs *regs =
 				(const struct pt_regs *) fp;
 #endif
-			pr_info("HW EXCEPTION\n");
+			printk("%sHW EXCEPTION\n", loglvl);
 #ifndef CONFIG_MMU
 			microblaze_unwind_inner(task, regs->r17 - 4,
 						fp + EX_HANDLER_STACK_SIZ,
-						regs->r15, trace);
+						regs->r15, trace, loglvl);
 #endif
 			return;
 		}
@@ -228,8 +233,8 @@ static void microblaze_unwind_inner(stru
 			if ((return_to >= handler->start_addr)
 			    && (return_to <= handler->end_addr)) {
 				if (!trace)
-					pr_info("%s\n", handler->trap_name);
-				unwind_trap(task, pc, fp, trace);
+					printk("%s%s\n", loglvl, handler->trap_name);
+				unwind_trap(task, pc, fp, trace, loglvl);
 				return;
 			}
 		}
@@ -248,13 +253,13 @@ static void microblaze_unwind_inner(stru
 		} else {
 			/* Have we reached userland? */
 			if (unlikely(pc == task_pt_regs(task)->pc)) {
-				pr_info("[<%p>] PID %lu [%s]\n",
-					(void *) pc,
+				printk("%s[<%p>] PID %lu [%s]\n",
+					loglvl, (void *) pc,
 					(unsigned long) task->pid,
 					task->comm);
 				break;
 			} else
-				print_ip_sym(KERN_INFO, pc);
+				print_ip_sym(loglvl, pc);
 		}
 
 		/* Stop when we reach anything not part of the kernel */
@@ -285,11 +290,13 @@ static void microblaze_unwind_inner(stru
  */
 void microblaze_unwind(struct task_struct *task, struct stack_trace *trace)
 {
+	const char *loglvl = KERN_INFO;
+
 	if (task) {
 		if (task == current) {
 			const struct pt_regs *regs = task_pt_regs(task);
 			microblaze_unwind_inner(task, regs->pc, regs->r1,
-						regs->r15, trace);
+						regs->r15, trace, loglvl);
 		} else {
 			struct thread_info *thread_info =
 				(struct thread_info *)(task->stack);
@@ -299,7 +306,8 @@ void microblaze_unwind(struct task_struc
 			microblaze_unwind_inner(task,
 						(unsigned long) &_switch_to,
 						cpu_context->r1,
-						cpu_context->r15, trace);
+						cpu_context->r15,
+						trace, loglvl);
 		}
 	} else {
 		unsigned long pc, fp;
@@ -314,7 +322,7 @@ void microblaze_unwind(struct task_struc
 		);
 
 		/* Since we are not a leaf function, use leaf_return = 0 */
-		microblaze_unwind_inner(current, pc, fp, 0, trace);
+		microblaze_unwind_inner(current, pc, fp, 0, trace, loglvl);
 	}
 }
 
_
