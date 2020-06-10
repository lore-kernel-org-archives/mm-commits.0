From: akpm@linux-foundation.org
Subject: [merged] microblaze-add-show_stack_loglvl.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:37:36 -0700
Message-ID: <20200610003736.iJA2tNFta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFJAhi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, monstr@monstr.eu


The patch titled
     Subject: microblaze: add show_stack_loglvl()
has been removed from the -mm tree.  Its filename was
     microblaze-add-show_stack_loglvl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: microblaze: add show_stack_loglvl()

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

Link: http://lkml.kernel.org/r/20200418201944.482088-21-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/traps.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/microblaze/kernel/traps.c~microblaze-add-show_stack_loglvl
+++ a/arch/microblaze/kernel/traps.c
@@ -31,7 +31,8 @@ static int __init kstack_setup(char *s)
 }
 __setup("kstack=", kstack_setup);
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+void show_stack_loglvl(struct task_struct *task, unsigned long *sp,
+		       const char *loglvl)
 {
 	unsigned long words_to_show;
 	u32 fp = (u32) sp;
@@ -50,7 +51,7 @@ void show_stack(struct task_struct *task
 	if (kstack_depth_to_print && (words_to_show > kstack_depth_to_print))
 		words_to_show = kstack_depth_to_print;
 
-	pr_info("Kernel Stack:\n");
+	printk("%sKernel Stack:\n", loglvl);
 
 	/*
 	 * Make the first line an 'odd' size if necessary to get
@@ -65,14 +66,19 @@ void show_stack(struct task_struct *task
 			words_to_show -= line1_words;
 		}
 	}
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 32, 4, (void *)fp,
+	print_hex_dump(loglvl, "", DUMP_PREFIX_ADDRESS, 32, 4, (void *)fp,
 		       words_to_show << 2, 0);
-	pr_info("\n\nCall Trace:\n");
-	microblaze_unwind(task, NULL, KERN_INFO);
-	pr_info("\n");
+	printk("%s\n\nCall Trace:\n", loglvl);
+	microblaze_unwind(task, NULL, loglvl);
+	printk("%s\n", loglvl);
 
 	if (!task)
 		task = current;
 
 	debug_show_held_locks(task);
 }
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_loglvl(task, sp, KERN_INFO);
+}
_

Patches currently in -mm which might be from dima@arista.com are
