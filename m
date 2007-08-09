From: akpm@linux-foundation.org
Subject: + i386-clean-up-oops-bug-reports.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:15:48 -0700
Message-ID: <200708092015.l79KFmf9017412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755797AbXHIUQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org


The patch titled
     i386: clean up oops/bug reports
has been added to the -mm tree.  Its filename is
     i386-clean-up-oops-bug-reports.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: clean up oops/bug reports
From: Pavel Emelyanov <xemul@openvz.org>

Typically the oops first lines look like this:

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
c049dfbd
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
...

Such output is gained with some ugly if (!nl) printk("\n"); code and
besides being a waste of lines, this is also annoying to read. The
following output looks better (and it is how it looks on x86_64):

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
printing eip: c049dfbd *pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
...

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c |   16 ++++------------
 arch/i386/mm/fault.c     |   13 +++++++------
 2 files changed, 11 insertions(+), 18 deletions(-)

diff -puN arch/i386/kernel/traps.c~i386-clean-up-oops-bug-reports arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~i386-clean-up-oops-bug-reports
+++ a/arch/i386/kernel/traps.c
@@ -367,31 +367,23 @@ void die(const char * str, struct pt_reg
 		local_save_flags(flags);
 
 	if (++die.lock_owner_depth < 3) {
-		int nl = 0;
 		unsigned long esp;
 		unsigned short ss;
 
 		report_bug(regs->eip, regs);
 
-		printk(KERN_EMERG "%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
+		printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
-		printk(KERN_EMERG "PREEMPT ");
-		nl = 1;
+		printk("PREEMPT ");
 #endif
 #ifdef CONFIG_SMP
-		if (!nl)
-			printk(KERN_EMERG);
 		printk("SMP ");
-		nl = 1;
 #endif
 #ifdef CONFIG_DEBUG_PAGEALLOC
-		if (!nl)
-			printk(KERN_EMERG);
 		printk("DEBUG_PAGEALLOC");
-		nl = 1;
 #endif
-		if (nl)
-			printk("\n");
+		printk("\n");
+
 		if (notify_die(DIE_OOPS, str, regs, err,
 					current->thread.trap_no, SIGSEGV) !=
 				NOTIFY_STOP) {
diff -puN arch/i386/mm/fault.c~i386-clean-up-oops-bug-reports arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-clean-up-oops-bug-reports
+++ a/arch/i386/mm/fault.c
@@ -528,23 +528,22 @@ no_context:
 			printk(KERN_ALERT "BUG: unable to handle kernel paging"
 					" request");
 		printk(" at virtual address %08lx\n",address);
-		printk(KERN_ALERT " printing eip:\n");
-		printk("%08lx\n", regs->eip);
+		printk(KERN_ALERT "printing eip: %08lx ", regs->eip);
 
 		page = read_cr3();
 		page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
 #ifdef CONFIG_X86_PAE
-		printk(KERN_ALERT "*pdpt = %016Lx\n", page);
+		printk("*pdpt = %016Lx ", page);
 		if ((page >> PAGE_SHIFT) < max_low_pfn
 		    && page & _PAGE_PRESENT) {
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
 			                                         & (PTRS_PER_PMD - 1)];
-			printk(KERN_ALERT "*pde = %016Lx\n", page);
+			printk(KERN_ALERT "*pde = %016Lx ", page);
 			page &= ~_PAGE_NX;
 		}
 #else
-		printk(KERN_ALERT "*pde = %08lx\n", page);
+		printk("*pde = %08lx ", page);
 #endif
 
 		/*
@@ -558,8 +557,10 @@ no_context:
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
 			                                         & (PTRS_PER_PTE - 1)];
-			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*2, (u64)page);
+			printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
 		}
+
+		printk("\n");
 	}
 
 	tsk->thread.cr2 = address;
_

Patches currently in -mm which might be from xemul@openvz.org are

consolidate-show_regs-and-show_registers-for-i386.patch
i386-clean-up-oops-bug-reports.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
