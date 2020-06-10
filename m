From: akpm@linux-foundation.org
Subject: [merged] xtensa-add-show_stack_loglvl.patch removed from
 -mm tree
Date: Tue, 09 Jun 2020 17:38:22 -0700
Message-ID: <20200610003822.Ov2OMc8tV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgFJAiY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@zankel.net, dima@arista.com, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     xtensa-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: xtensa: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-44-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/xtensa/kernel/traps.c~xtensa-add-show_stack_loglvl
+++ a/arch/xtensa/kernel/traps.c
@@ -501,7 +501,8 @@ static void show_trace(struct task_struc
 #define STACK_DUMP_LINE_SIZE 32
 static size_t kstack_depth_to_print = CONFIG_PRINT_STACK_DEPTH;
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
 {
 	size_t len;
 
@@ -511,11 +512,16 @@ void show_stack(struct task_struct *task
 	len = min((-(size_t)sp) & (THREAD_SIZE - STACK_DUMP_ENTRY_SIZE),
 		  kstack_depth_to_print * STACK_DUMP_ENTRY_SIZE);
 
-	pr_info("Stack:\n");
-	print_hex_dump(KERN_INFO, " ", DUMP_PREFIX_NONE,
+	printk("%sStack:\n", loglvl);
+	print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
 		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
 		       sp, len, false);
-	show_trace(task, sp, KERN_INFO);
+	show_trace(task, sp, loglvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_INFO);
 }
 
 DEFINE_SPINLOCK(die_lock);
_

Patches currently in -mm which might be from dima@arista.com are
