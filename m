From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 40/93] x86: add missing const qualifiers for
 log_lvl
Date: Mon, 08 Jun 2020 21:31:57 -0700
Message-ID: <20200609043157.IJpJcnNBO%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEb7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:59 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, dima@arista.com, hpa@zytor.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: x86: add missing const qualifiers for log_lvl

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

Keep log_lvl const show_trace_log_lvl() and printk_stack_address() as the
new generic show_stack_loglvl() wants to have a proper const qualifier.

And gcc rightfully produces warnings in case it's not keept:
arch/x86/kernel/dumpstack.c: In function `show_stack':
arch/x86/kernel/dumpstack.c:294:37: warning: passing argument 4 of `show_trace_log_lv ' discards `const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  294 |  show_trace_log_lvl(task, NULL, sp, loglvl);
      |                                     ^~~~~~
arch/x86/kernel/dumpstack.c:163:32: note: expected `char *' but argument is of type `const char *'
  163 |    unsigned long *stack, char *log_lvl)
      |                          ~~~~~~^~~~~~~

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-41-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/stacktrace.h |    2 +-
 arch/x86/kernel/dumpstack.c       |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/stacktrace.h~x86-add-missing-const-qualifiers-for-log_lvl
+++ a/arch/x86/include/asm/stacktrace.h
@@ -87,7 +87,7 @@ get_stack_pointer(struct task_struct *ta
 }
 
 void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			unsigned long *stack, char *log_lvl);
+			unsigned long *stack, const char *log_lvl);
 
 /* The form of the top of the frame on the stack */
 struct stack_frame {
--- a/arch/x86/kernel/dumpstack.c~x86-add-missing-const-qualifiers-for-log_lvl
+++ a/arch/x86/kernel/dumpstack.c
@@ -65,7 +65,7 @@ bool in_entry_stack(unsigned long *stack
 }
 
 static void printk_stack_address(unsigned long address, int reliable,
-				 char *log_lvl)
+				 const char *log_lvl)
 {
 	touch_nmi_watchdog();
 	printk("%s %s%pB\n", log_lvl, reliable ? "" : "? ", (void *)address);
@@ -160,7 +160,7 @@ static void show_regs_if_on_stack(struct
 }
 
 void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-			unsigned long *stack, char *log_lvl)
+			unsigned long *stack, const char *log_lvl)
 {
 	struct unwind_state state;
 	struct stack_info stack_info = {0};
_
