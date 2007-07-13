From: akpm@linux-foundation.org
Subject: + print-utsname-on-oops-on-all-architectures.patch added to -mm tree
Date: Fri, 13 Jul 2007 01:23:38 -0700
Message-ID: <200707130823.l6D8NcN4008157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757882AbXGMIYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 04:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwise@google.com, ak@suse.de, benh@kernel.crashing.org, ink@jurassic.park.msu.ru, linux-arch@vger.kernel.org, paulus@samba.org, rmk@arm.linux.org.uk, rth@twiddle.net


The patch titled
     Print utsname on Oops on all architectures
has been added to the -mm tree.  Its filename is
     print-utsname-on-oops-on-all-architectures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Print utsname on Oops on all architectures
From: Joshua Wise <jwise@google.com>

Background:
 This patch is a follow-on to "Info dump on Oops or panic()" [1].

 On some architectures, the kernel printed some information on the running
 kernel, but not on all architectures. The information printed was generally
 the version and build number, but it was not located in a consistant place,
 and some architectures did not print it at all.

Description:
 This patch uses the already-existing die_chain to print utsname information
 on Oops. This patch also removes the architecture-specific utsname
 printers. To avoid crashing the system further (and hence not printing the
 Oops) in the case where the system is so hopelessly smashed that utsname
 might be destroyed, we vsprintf the utsname data into a static buffer
 first, and then just print that on crash.

Testing:
 I wrote a module that does a *(int*)0 = 0; and observed that I got my
 utsname data printed.

Potential impact:
 This adds another line to the Oops output, causing the first few lines to
 potentially scroll off the screen. This also adds a few more pointer
 dereferences in the Oops path, because it adds to the die_chain notifier
 chain, reducing the likelihood that the Oops will be printed if there is
 very bad memory corruption.

Signed-off-by: Joshua Wise <jwise@google.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/process.c   |    1 -
 arch/arm/kernel/process.c     |    7 ++-----
 arch/i386/kernel/process.c    |    7 ++-----
 arch/powerpc/kernel/process.c |    5 ++---
 arch/x86_64/kernel/process.c  |    8 ++------
 kernel/sys.c                  |   31 +++++++++++++++++++++++++++++++
 6 files changed, 39 insertions(+), 20 deletions(-)

diff -puN arch/alpha/kernel/process.c~print-utsname-on-oops-on-all-architectures arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c~print-utsname-on-oops-on-all-architectures
+++ a/arch/alpha/kernel/process.c
@@ -20,7 +20,6 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
-#include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/major.h>
 #include <linux/stat.h>
diff -puN arch/arm/kernel/process.c~print-utsname-on-oops-on-all-architectures arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~print-utsname-on-oops-on-all-architectures
+++ a/arch/arm/kernel/process.c
@@ -28,7 +28,6 @@
 #include <linux/elfcore.h>
 #include <linux/pm.h>
 #include <linux/tick.h>
-#include <linux/utsname.h>
 
 #include <asm/leds.h>
 #include <asm/processor.h>
@@ -207,10 +206,8 @@ void __show_regs(struct pt_regs *regs)
 	unsigned long flags;
 	char buf[64];
 
-	printk("CPU: %d    %s  (%s %.*s)\n",
-		smp_processor_id(), print_tainted(), init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	printk("CPU: %d    %s\n",
+		smp_processor_id(), print_tainted());
 	print_symbol("PC is at %s\n", instruction_pointer(regs));
 	print_symbol("LR is at %s\n", regs->ARM_lr);
 	printk("pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
diff -puN arch/i386/kernel/process.c~print-utsname-on-oops-on-all-architectures arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~print-utsname-on-oops-on-all-architectures
+++ a/arch/i386/kernel/process.c
@@ -27,7 +27,6 @@
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
@@ -311,10 +310,8 @@ void show_regs(struct pt_regs * regs)
 
 	if (user_mode_vm(regs))
 		printk(" ESP: %04x:%08lx",0xffff & regs->xss,regs->esp);
-	printk(" EFLAGS: %08lx    %s  (%s %.*s)\n",
-	       regs->eflags, print_tainted(), init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
+	printk(" EFLAGS: %08lx    %s\n",
+	       regs->eflags, print_tainted());
 	printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
 		regs->eax,regs->ebx,regs->ecx,regs->edx);
 	printk("ESI: %08lx EDI: %08lx EBP: %08lx",
diff -puN arch/powerpc/kernel/process.c~print-utsname-on-oops-on-all-architectures arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~print-utsname-on-oops-on-all-architectures
+++ a/arch/powerpc/kernel/process.c
@@ -32,7 +32,6 @@
 #include <linux/kallsyms.h>
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
-#include <linux/utsname.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -416,8 +415,8 @@ void show_regs(struct pt_regs * regs)
 
 	printk("NIP: "REG" LR: "REG" CTR: "REG"\n",
 	       regs->nip, regs->link, regs->ctr);
-	printk("REGS: %p TRAP: %04lx   %s  (%s)\n",
-	       regs, regs->trap, print_tainted(), init_utsname()->release);
+	printk("REGS: %p TRAP: %04lx   %s\n",
+	       regs, regs->trap, print_tainted());
 	printk("MSR: "REG" ", regs->msr);
 	printbits(regs->msr, msr_bits);
 	printk("  CR: %08lx  XER: %08lx\n", regs->ccr, regs->xer);
diff -puN arch/x86_64/kernel/process.c~print-utsname-on-oops-on-all-architectures arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~print-utsname-on-oops-on-all-architectures
+++ a/arch/x86_64/kernel/process.c
@@ -32,7 +32,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/ptrace.h>
-#include <linux/utsname.h>
 #include <linux/random.h>
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
@@ -316,11 +315,8 @@ void __show_regs(struct pt_regs * regs)
 
 	printk("\n");
 	print_modules();
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+	printk("Pid: %d, comm: %.20s %s\n",
+		current->pid, current->comm, print_tainted());
 	printk("RIP: %04lx:[<%016lx>] ", regs->cs & 0xffff, regs->rip);
 	printk_address(regs->rip); 
 	printk("RSP: %04lx:%016lx  EFLAGS: %08lx\n", regs->ss, regs->rsp,
diff -puN kernel/sys.c~print-utsname-on-oops-on-all-architectures kernel/sys.c
--- a/kernel/sys.c~print-utsname-on-oops-on-all-architectures
+++ a/kernel/sys.c
@@ -27,6 +27,7 @@
 #include <linux/dcookies.h>
 #include <linux/suspend.h>
 #include <linux/tty.h>
+#include <linux/kdebug.h>
 #include <linux/signal.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
@@ -107,6 +108,36 @@ void (*pm_power_off_prepare)(void);
 EXPORT_SYMBOL(pm_power_off_prepare);
 
 /*
+ * Dump out UTS info on oops / panic.  We pregenerate utsname_info so that
+ * we don't access utsname() if the machine is in a potentially bad state.
+ */
+
+static char *utsname_info;
+
+static int dump_utsname(struct notifier_block *self, unsigned long diecode,
+		void *p)
+{
+	printk(KERN_EMERG "%s\n", utsname_info);
+	return 0;
+}
+
+static struct notifier_block utsname_notifier = {
+	.notifier_call = dump_utsname
+};
+
+static int __init register_utsname_dump(void)
+{
+	utsname_info = kasprintf(GFP_KERNEL, "%s %s %s %s",
+		utsname()->sysname,
+		utsname()->release,
+		utsname()->version,
+		utsname()->machine);
+	register_die_notifier(&utsname_notifier);
+	return 0;
+}
+module_init(register_utsname_dump);
+
+/*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
  *	and the like. 
_

Patches currently in -mm which might be from jwise@google.com are

print-utsname-on-oops-on-all-architectures.patch
print-utsname-on-oops-on-all-architectures-fix.patch
