From: akpm@linux-foundation.org
Subject: [merged] csky-add-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:37:20 -0700
Message-ID: <20200610003720.dfT0Tfn5K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgFJAhW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, guoren@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: csky: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     csky-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: csky: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-13-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/kernel/stacktrace.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/csky/kernel/stacktrace.c~csky-add-show_stack_loglvl
+++ a/arch/csky/kernel/stacktrace.c
@@ -91,14 +91,21 @@ static void notrace walk_stackframe(stru
 
 static bool print_trace_address(unsigned long pc, void *arg)
 {
-	print_ip_sym(pc);
+	print_ip_sym((const char *)arg, pc);
 	return false;
 }
 
+void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
+{
+	pr_cont("Call Trace:\n");
+	walk_stackframe(task, NULL, print_trace_address, (void *)loglvl);
+}
+
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
 	pr_cont("Call Trace:\n");
-	walk_stackframe(task, NULL, print_trace_address, NULL);
+	walk_stackframe(task, NULL, print_trace_address, KERN_INFO);
 }
 
 static bool save_wchan(unsigned long pc, void *arg)
_

Patches currently in -mm which might be from dima@arista.com are
