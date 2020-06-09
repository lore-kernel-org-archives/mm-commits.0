From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 41/93] x86: add show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:32:00 -0700
Message-ID: <20200609043200.MguA09knV%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:02 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, dima@arista.com, hpa@zytor.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: x86: add show_stack_loglvl()

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

Introduce show_stack_loglvl(), that eventually will substitute
show_stack().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-42-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/dumpstack.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/dumpstack.c~x86-add-show_stack_loglvl
+++ a/arch/x86/kernel/dumpstack.c
@@ -279,7 +279,8 @@ next:
 	}
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
 {
 	task = task ? : current;
 
@@ -290,7 +291,12 @@ void show_stack(struct task_struct *task
 	if (!sp && task == current)
 		sp = get_stack_pointer(current, NULL);
 
-	show_trace_log_lvl(task, NULL, sp, KERN_DEFAULT);
+	show_trace_log_lvl(task, NULL, sp, loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_DEFAULT);
 }
 
 void show_stack_regs(struct pt_regs *regs)
_
