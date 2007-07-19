From: akpm@linux-foundation.org
Subject: - make-alt-sysrq-p-display-the-debug-register-contents.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:51 -0700
Message-ID: <200707192008.l6JK8p1b020512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761421AbXGSUQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, ak@suse.de, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Make Alt-SysRq-p display the debug register contents
has been removed from the -mm tree.  Its filename was
     make-alt-sysrq-p-display-the-debug-register-contents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make Alt-SysRq-p display the debug register contents
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as921) adds code to the show_regs() routine in i386 and x86_64
to print the contents of the debug registers along with all the others.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/process.c   |   12 ++++++++++++
 arch/x86_64/kernel/process.c |   10 ++++++++++
 2 files changed, 22 insertions(+)

diff -puN arch/i386/kernel/process.c~make-alt-sysrq-p-display-the-debug-register-contents arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~make-alt-sysrq-p-display-the-debug-register-contents
+++ a/arch/i386/kernel/process.c
@@ -302,6 +302,7 @@ early_param("idle", idle_setup);
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
+	unsigned long d0, d1, d2, d3, d6, d7;
 
 	printk("\n");
 	printk("Pid: %d, comm: %20s\n", current->pid, current->comm);
@@ -326,6 +327,17 @@ void show_regs(struct pt_regs * regs)
 	cr3 = read_cr3();
 	cr4 = read_cr4_safe();
 	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n", cr0, cr2, cr3, cr4);
+
+	get_debugreg(d0, 0);
+	get_debugreg(d1, 1);
+	get_debugreg(d2, 2);
+	get_debugreg(d3, 3);
+	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+			d0, d1, d2, d3);
+	get_debugreg(d6, 6);
+	get_debugreg(d7, 7);
+	printk("DR6: %08lx DR7: %08lx\n", d6, d7);
+
 	show_trace(NULL, regs, &regs->esp);
 }
 
diff -puN arch/x86_64/kernel/process.c~make-alt-sysrq-p-display-the-debug-register-contents arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~make-alt-sysrq-p-display-the-debug-register-contents
+++ a/arch/x86_64/kernel/process.c
@@ -306,6 +306,7 @@ early_param("idle", idle_setup);
 void __show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
+	unsigned long d0, d1, d2, d3, d6, d7;
 	unsigned int fsindex,gsindex;
 	unsigned int ds,cs,es; 
 
@@ -350,6 +351,15 @@ void __show_regs(struct pt_regs * regs)
 	       fs,fsindex,gs,gsindex,shadowgs); 
 	printk("CS:  %04x DS: %04x ES: %04x CR0: %016lx\n", cs, ds, es, cr0); 
 	printk("CR2: %016lx CR3: %016lx CR4: %016lx\n", cr2, cr3, cr4);
+
+	get_debugreg(d0, 0);
+	get_debugreg(d1, 1);
+	get_debugreg(d2, 2);
+	printk("DR0: %016lx DR1: %016lx DR2: %016lx\n", d0, d1, d2);
+	get_debugreg(d3, 3);
+	get_debugreg(d6, 6);
+	get_debugreg(d7, 7);
+	printk("DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
 }
 
 void show_regs(struct pt_regs *regs)
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
