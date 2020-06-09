From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 10/93] arm64: add show_stack_loglvl()
Date: Mon, 08 Jun 2020 21:30:26 -0700
Message-ID: <20200609043026.J8WcMRNQ3%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgFIEa1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:30:27 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, dima@arista.com, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, will@kernel.org

From: Dmitry Safonov <dima@arista.com>
Subject: arm64: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-11-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/traps.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/traps.c~arm64-add-show_stack_loglvl
+++ a/arch/arm64/kernel/traps.c
@@ -137,12 +137,18 @@ void dump_backtrace(struct pt_regs *regs
 	put_task_stack(tsk);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *tsk, unsigned long *sp,
+		       const char *loglvl)
 {
-	dump_backtrace(NULL, tsk, KERN_DEFAULT);
+	dump_backtrace(NULL, tsk, loglvl);
 	barrier();
 }
 
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	show_stack_loglvl(tsk, sp, KERN_DEFAULT);
+}
+
 #ifdef CONFIG_PREEMPT
 #define S_PREEMPT " PREEMPT"
 #elif defined(CONFIG_PREEMPT_RT)
_
