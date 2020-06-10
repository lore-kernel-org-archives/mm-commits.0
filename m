From: akpm@linux-foundation.org
Subject: [merged] sh-add-loglvl-to-dump_mem.patch removed from -mm
 tree
Date: Tue, 09 Jun 2020 17:37:54 -0700
Message-ID: <20200610003754.m8QlVeyHS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJAhz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, dima@arista.com, mm-commits@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: add loglvl to dump_mem()
has been removed from the -mm tree.  Its filename was
     sh-add-loglvl-to-dump_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: sh: add loglvl to dump_mem()

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

Add log level argument to dump_mem() as a preparation to introduce
show_stack_loglvl().

[1]: https://lore.kernel.org/lkml/20190528002412.1625-1-dima@arista.com/T/#u

Link: http://lkml.kernel.org/r/20200418201944.482088-30-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/kdebug.h |    3 ++-
 arch/sh/kernel/dumpstack.c   |   17 +++++++++--------
 arch/sh/kernel/traps.c       |    4 ++--
 3 files changed, 13 insertions(+), 11 deletions(-)

--- a/arch/sh/include/asm/kdebug.h~sh-add-loglvl-to-dump_mem
+++ a/arch/sh/include/asm/kdebug.h
@@ -13,6 +13,7 @@ enum die_val {
 
 /* arch/sh/kernel/dumpstack.c */
 extern void printk_address(unsigned long address, int reliable);
-extern void dump_mem(const char *str, unsigned long bottom, unsigned long top);
+extern void dump_mem(const char *str, const char *loglvl,
+		     unsigned long bottom, unsigned long top);
 
 #endif /* __ASM_SH_KDEBUG_H */
--- a/arch/sh/kernel/dumpstack.c~sh-add-loglvl-to-dump_mem
+++ a/arch/sh/kernel/dumpstack.c
@@ -16,30 +16,31 @@
 #include <asm/unwinder.h>
 #include <asm/stacktrace.h>
 
-void dump_mem(const char *str, unsigned long bottom, unsigned long top)
+void dump_mem(const char *str, const char *loglvl,
+	      unsigned long bottom, unsigned long top)
 {
 	unsigned long p;
 	int i;
 
-	printk("%s(0x%08lx to 0x%08lx)\n", str, bottom, top);
+	printk("%s%s(0x%08lx to 0x%08lx)\n", loglvl, str, bottom, top);
 
 	for (p = bottom & ~31; p < top; ) {
-		printk("%04lx: ", p & 0xffff);
+		printk("%s%04lx: ", loglvl,  p & 0xffff);
 
 		for (i = 0; i < 8; i++, p += 4) {
 			unsigned int val;
 
 			if (p < bottom || p >= top)
-				printk("         ");
+				printk("%s         ", loglvl);
 			else {
 				if (__get_user(val, (unsigned int __user *)p)) {
-					printk("\n");
+					printk("%s\n", loglvl);
 					return;
 				}
-				printk("%08x ", val);
+				printk("%s%08x ", loglvl, val);
 			}
 		}
-		printk("\n");
+		printk("%s\n", loglvl);
 	}
 }
 
@@ -156,7 +157,7 @@ void show_stack(struct task_struct *tsk,
 		sp = (unsigned long *)tsk->thread.sp;
 
 	stack = (unsigned long)sp;
-	dump_mem("Stack: ", stack, THREAD_SIZE +
+	dump_mem("Stack: ", KERN_DEFAULT, stack, THREAD_SIZE +
 		 (unsigned long)task_stack_page(tsk));
 	show_trace(tsk, sp, NULL);
 }
--- a/arch/sh/kernel/traps.c~sh-add-loglvl-to-dump_mem
+++ a/arch/sh/kernel/traps.c
@@ -38,8 +38,8 @@ void die(const char *str, struct pt_regs
 			task_pid_nr(current), task_stack_page(current) + 1);
 
 	if (!user_mode(regs) || in_interrupt())
-		dump_mem("Stack: ", regs->regs[15], THREAD_SIZE +
-			 (unsigned long)task_stack_page(current));
+		dump_mem("Stack: ", KERN_DEFAULT, regs->regs[15],
+			THREAD_SIZE + (unsigned long)task_stack_page(current));
 
 	notify_die(DIE_OOPS, str, regs, err, 255, SIGSEGV);
 
_

Patches currently in -mm which might be from dima@arista.com are
