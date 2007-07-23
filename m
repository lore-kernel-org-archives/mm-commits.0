From: akpm@linux-foundation.org
Subject: + during-vm-oom-condition-kill-all-threads-in-process-group.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:16:52 -0700
Message-ID: <200707232116.l6NLGqx1012209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbXGWVTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will_schmidt@vnet.ibm.com, ak@suse.de, benh@kernel.crashing.org, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, kkojima@rr.iij4u.or.jp, kyle@mcmartin.ca, lethal@linux-sh.org, paulus@samba.org, ralf@linux-mips.org, rc@rc0.org.uk, rmk@arm.linux.org.uk, rth@twiddle.net, schwidefsky@de.ibm.com, spyro@f2s.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, willy@debian.org, wli@holomorphy.com, zippel@linux-m68k.org


The patch titled
     During VM oom condition, kill all threads in process group
has been added to the -mm tree.  Its filename is
     during-vm-oom-condition-kill-all-threads-in-process-group.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: During VM oom condition, kill all threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>

We have had complaints where a threaded application is left in a bad state
after one of it's threads is killed when we hit a VM: out_of_memory
condition.

Killing just one of the process threads can leave the application in a bad
state, whereas killing the entire process group would allow for the
application to restart, or be otherwise handled, and makes it very obvious
that something has gone wrong.

This change allows the entire process group to be taken down, rather
than just the one thread.

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ian Molton <spyro@f2s.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Richard Curnow <rc@rc0.org.uk>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c   |    2 +-
 arch/arm/mm/fault.c     |    2 +-
 arch/arm26/mm/fault.c   |    2 +-
 arch/avr32/mm/fault.c   |    2 +-
 arch/cris/mm/fault.c    |    2 +-
 arch/frv/mm/fault.c     |    2 +-
 arch/i386/mm/fault.c    |    2 +-
 arch/ia64/mm/fault.c    |    2 +-
 arch/m32r/mm/fault.c    |    2 +-
 arch/m68k/mm/fault.c    |    2 +-
 arch/mips/mm/fault.c    |    2 +-
 arch/parisc/mm/fault.c  |    2 +-
 arch/ppc/mm/fault.c     |    2 +-
 arch/s390/mm/fault.c    |    2 +-
 arch/sh/mm/fault.c      |    2 +-
 arch/sh64/mm/fault.c    |    2 +-
 arch/sparc/mm/fault.c   |    2 +-
 arch/sparc64/mm/fault.c |    2 +-
 arch/xtensa/mm/fault.c  |    2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)

diff -puN arch/alpha/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/alpha/mm/fault.c
--- a/arch/alpha/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/alpha/mm/fault.c
@@ -197,7 +197,7 @@ do_page_fault(unsigned long address, uns
 	       current->comm, current->pid);
 	if (!user_mode(regs))
 		goto no_context;
-	do_exit(SIGKILL);
+	do_group_exit(SIGKILL);
 
  do_sigbus:
 	/* Send a sigbus, regardless of whether we were in kernel
diff -puN arch/arm/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/arm/mm/fault.c
@@ -266,7 +266,7 @@ do_page_fault(unsigned long addr, unsign
 		 * the page fault gracefully.
 		 */
 		printk("VM: killing process %s\n", tsk->comm);
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 		return 0;
 	}
 	if (fault & VM_FAULT_SIGBUS) {
diff -puN arch/arm26/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/arm26/mm/fault.c
--- a/arch/arm26/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/arm26/mm/fault.c
@@ -246,7 +246,7 @@ int do_page_fault(unsigned long addr, un
 		 * us that made us unable to handle the page fault gracefully.
 		 */
 		printk("VM: killing process %s\n", tsk->comm);
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	}
 	else{
 		__do_user_fault(tsk, addr, fsr, fault == -1 ? SEGV_ACCERR : SEGV_MAPERR, regs);
diff -puN arch/avr32/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/avr32/mm/fault.c
@@ -216,7 +216,7 @@ out_of_memory:
 	}
 	printk("VM: Killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/cris/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/cris/mm/fault.c
--- a/arch/cris/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/cris/mm/fault.c
@@ -360,7 +360,7 @@ do_page_fault(unsigned long address, str
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
  do_sigbus:
diff -puN arch/frv/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/frv/mm/fault.c
--- a/arch/frv/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/frv/mm/fault.c
@@ -259,7 +259,7 @@ asmlinkage void do_page_fault(int datamm
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(__frame))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
  do_sigbus:
diff -puN arch/i386/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/i386/mm/fault.c
@@ -601,7 +601,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/ia64/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/ia64/mm/fault.c
@@ -277,6 +277,6 @@ ia64_do_page_fault (unsigned long addres
 	}
 	printk(KERN_CRIT "VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 }
diff -puN arch/m32r/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/m32r/mm/fault.c
--- a/arch/m32r/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/m32r/mm/fault.c
@@ -278,7 +278,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & ACE_USERMODE)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/m68k/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/m68k/mm/fault.c
--- a/arch/m68k/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/m68k/mm/fault.c
@@ -188,7 +188,7 @@ out_of_memory:
 
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 
 no_context:
 	current->thread.signo = SIGBUS;
diff -puN arch/mips/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/mips/mm/fault.c
@@ -180,7 +180,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/parisc/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/parisc/mm/fault.c
--- a/arch/parisc/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/parisc/mm/fault.c
@@ -263,6 +263,6 @@ no_context:
 	up_read(&mm->mmap_sem);
 	printk(KERN_CRIT "VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 }
diff -puN arch/ppc/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/ppc/mm/fault.c
--- a/arch/ppc/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/ppc/mm/fault.c
@@ -298,7 +298,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	return SIGKILL;
 
 do_sigbus:
diff -puN arch/s390/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/s390/mm/fault.c
@@ -218,7 +218,7 @@ static int do_out_of_memory(struct pt_re
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (regs->psw.mask & PSW_MASK_PSTATE)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	do_no_context(regs, error_code, address);
 	return 0;
 }
diff -puN arch/sh/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/sh/mm/fault.c
@@ -210,7 +210,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/sh64/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/sh64/mm/fault.c
--- a/arch/sh64/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/sh64/mm/fault.c
@@ -334,7 +334,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/sparc/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/sparc/mm/fault.c
--- a/arch/sparc/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/sparc/mm/fault.c
@@ -369,7 +369,7 @@ out_of_memory:
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", tsk->comm);
 	if (from_user)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:
diff -puN arch/sparc64/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/sparc64/mm/fault.c
--- a/arch/sparc64/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/sparc64/mm/fault.c
@@ -466,7 +466,7 @@ out_of_memory:
 	up_read(&mm->mmap_sem);
 	printk("VM: killing process %s\n", current->comm);
 	if (!(regs->tstate & TSTATE_PRIV))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto handle_kernel_fault;
 
 intr_or_no_mm:
diff -puN arch/xtensa/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~during-vm-oom-condition-kill-all-threads-in-process-group
+++ a/arch/xtensa/mm/fault.c
@@ -150,7 +150,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	bad_page_fault(regs, address, SIGKILL);
 	return;
 
_

Patches currently in -mm which might be from will_schmidt@vnet.ibm.com are

during-vm-oom-condition-kill-all-threads-in-process-group.patch
