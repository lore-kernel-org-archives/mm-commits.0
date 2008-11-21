From: akpm@linux-foundation.org
Subject: + parisc-fix-kernel-crash-when-unwinding-a-userspace-process-v2.patch added to -mm tree
Date: Fri, 21 Nov 2008 11:17:38 -0800
Message-ID: <200811211917.mALJHcxN021039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815AbYKUTTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 14:19:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, stable@kernel.org


The patch titled
     parisc: fix kernel crash when unwinding a userspace process
has been added to the -mm tree.  Its filename is
     parisc-fix-kernel-crash-when-unwinding-a-userspace-process-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: fix kernel crash when unwinding a userspace process
From: Helge Deller <deller@gmx.de>

Any user on existing parisc 32- and 64bit-kernels can easily crash
the kernel and as such enforce a DSO.
A simple testcase is available here:
        http://gsyprf10.external.hp.com/~deller/crash.tgz

The problem is introduced by the fact, that the handle_interruption()
crash handler calls the show_regs() function, which in turn tries to
unwind the stack by calling parisc_show_stack().  Since the stack contains
userspace addresses, a try to unwind the stack is dangerous and useless
and leads to the crash.

The fix is trivial: For userspace processes
a) avoid to unwind the stack, and
b) avoid to resolve userspace addresses to kernel symbol names.

While touching this code, I converted print_symbol() to %pS
printk formats and made parisc_show_stack() static.

An initial patch for this was written by Kyle McMartin back in August:
http://marc.info/?l=linux-parisc&m=121805168830283&w=2

Compile and run-tested with a 64bit parisc kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, earlier...]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/traps.c |   41 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff -puN arch/parisc/kernel/traps.c~parisc-fix-kernel-crash-when-unwinding-a-userspace-process-v2 arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c~parisc-fix-kernel-crash-when-unwinding-a-userspace-process-v2
+++ a/arch/parisc/kernel/traps.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
-#include <linux/kallsyms.h>
 #include <linux/bug.h>
 
 #include <asm/assembly.h>
@@ -51,7 +50,7 @@
 DEFINE_SPINLOCK(pa_dbit_lock);
 #endif
 
-void parisc_show_stack(struct task_struct *t, unsigned long *sp,
+static void parisc_show_stack(struct task_struct *task, unsigned long *sp,
 	struct pt_regs *regs);
 
 static int printbinary(char *buf, unsigned long x, int nbits)
@@ -121,18 +120,19 @@ static void print_fr(char *level, struct
 
 void show_regs(struct pt_regs *regs)
 {
-	int i;
+	int i, user;
 	char *level;
 	unsigned long cr30, cr31;
 
-	level = user_mode(regs) ? KERN_DEBUG : KERN_CRIT;
+	user = user_mode(regs);
+	level = user ? KERN_DEBUG : KERN_CRIT;
 
 	print_gr(level, regs);
 
 	for (i = 0; i < 8; i += 4)
 		PRINTREGS(level, regs->sr, "sr", RFMT, i);
 
-	if (user_mode(regs))
+	if (user)
 		print_fr(level, regs);
 
 	cr30 = mfctl(30);
@@ -145,14 +145,18 @@ void show_regs(struct pt_regs *regs)
 	printk("%s CPU: %8d   CR30: " RFMT " CR31: " RFMT "\n",
 	       level, current_thread_info()->cpu, cr30, cr31);
 	printk("%s ORIG_R28: " RFMT "\n", level, regs->orig_r28);
-	printk(level);
-	print_symbol(" IAOQ[0]: %s\n", regs->iaoq[0]);
-	printk(level);
-	print_symbol(" IAOQ[1]: %s\n", regs->iaoq[1]);
-	printk(level);
-	print_symbol(" RP(r2): %s\n", regs->gr[2]);
 
-	parisc_show_stack(current, NULL, regs);
+	if (user) {
+		printk("%s IAOQ[0]: " RFMT "\n", level, regs->iaoq[0]);
+		printk("%s IAOQ[1]: " RFMT "\n", level, regs->iaoq[1]);
+		printk("%s RP(r2): " RFMT "\n", level, regs->gr[2]);
+	} else {
+		printk("%s IAOQ[0]: %pS\n", level, (void *) regs->iaoq[0]);
+		printk("%s IAOQ[1]: %pS\n", level, (void *) regs->iaoq[1]);
+		printk("%s RP(r2): %pS\n", level, (void *) regs->gr[2]);
+
+		parisc_show_stack(current, NULL, regs);
+	}
 }
 
 
@@ -173,20 +177,15 @@ static void do_show_stack(struct unwind_
 			break;
 
 		if (__kernel_text_address(info->ip)) {
-			printk("%s [<" RFMT ">] ", (i&0x3)==1 ? KERN_CRIT : "", info->ip);
-#ifdef CONFIG_KALLSYMS
-			print_symbol("%s\n", info->ip);
-#else
-			if ((i & 0x03) == 0)
-				printk("\n");
-#endif
+			printk(KERN_CRIT " [<" RFMT ">] %pS\n",
+				info->ip, (void *) info->ip);
 			i++;
 		}
 	}
-	printk("\n");
+	printk(KERN_CRIT "\n");
 }
 
-void parisc_show_stack(struct task_struct *task, unsigned long *sp,
+static void parisc_show_stack(struct task_struct *task, unsigned long *sp,
 	struct pt_regs *regs)
 {
 	struct unwind_frame_info info;
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
parisc-fix-kernel-crash-when-unwinding-a-userspace-process-v2.patch

