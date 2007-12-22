From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:01:50 -0800
Message-ID: <200712220001.lBM01ojb005679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624AbXLVADP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:03:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mzhang@mvista.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     arch/x86/kernel/cpu/mcheck/p4.c: cleanups
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/cpu/mcheck/p4.c: cleanups
From: Min Zhang <mzhang@mvista.com>

Consolidate printk and insert CPU id to cleanup SMP interleaved output.  In
SMP, the machine check exception dispatches all logical processors within a
physical package to the machine-check exception handler, so the printk
within each handler outputs concurrently and makes the output unreadable. 
Refer to Intel system programming guide Part 1 Section 7.8.5
http://developer.intel.com/design/processor/manuals/253668.pdf

Signed-off-by: Min Zhang <mzhang@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/k7.c |   11 +++++++----
 arch/x86/kernel/cpu/mcheck/p4.c |   21 ++++++++++++---------
 arch/x86/kernel/cpu/mcheck/p6.c |   11 +++++++----
 3 files changed, 26 insertions(+), 17 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/k7.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5 arch/x86/kernel/cpu/mcheck/k7.c
--- a/arch/x86/kernel/cpu/mcheck/k7.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5
+++ a/arch/x86/kernel/cpu/mcheck/k7.c
@@ -33,21 +33,24 @@ static void k7_machine_check(struct pt_r
 	for (i=1; i<nr_mce_banks; i++) {
 		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high&(1<<31)) {
+			char misc[20];
+			char addr[24];
+			misc[0] = addr[0] = '\0';
 			if (high & (1<<29))
 				recover |= 1;
 			if (high & (1<<25))
 				recover |= 2;
-			printk (KERN_EMERG "Bank %d: %08x%08x", i, high, low);
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
 				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				printk ("[%08x%08x]", ahigh, alow);
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
 				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				printk (" at %08x%08x", ahigh, alow);
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk ("\n");
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+				smp_processor_id(), i, high, low, misc, addr);
 			/* Clear it */
 			wrmsr (MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
 			/* Serialize */
diff -puN arch/x86/kernel/cpu/mcheck/p4.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5 arch/x86/kernel/cpu/mcheck/p4.c
--- a/arch/x86/kernel/cpu/mcheck/p4.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5
+++ a/arch/x86/kernel/cpu/mcheck/p4.c
@@ -158,32 +158,35 @@ static void intel_machine_check(struct p
 	if (mce_num_extended_msrs > 0) {
 		struct intel_mce_extended_msrs dbg;
 		intel_get_extended_msrs(&dbg);
-		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n",
-			smp_processor_id(), dbg.eip, dbg.eflags);
-		printk (KERN_DEBUG "\teax: %08x ebx: %08x ecx: %08x edx: %08x\n",
-			dbg.eax, dbg.ebx, dbg.ecx, dbg.edx);
-		printk (KERN_DEBUG "\tesi: %08x edi: %08x ebp: %08x esp: %08x\n",
+		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n"
+			"\teax: %08x ebx: %08x ecx: %08x edx: %08x\n"
+			"\tesi: %08x edi: %08x ebp: %08x esp: %08x\n",
+			smp_processor_id(), dbg.eip, dbg.eflags,
+			dbg.eax, dbg.ebx, dbg.ecx, dbg.edx,
 			dbg.esi, dbg.edi, dbg.ebp, dbg.esp);
 	}
 
 	for (i=0; i<nr_mce_banks; i++) {
 		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high & (1<<31)) {
+			char misc[20];
+			char addr[24];
+			misc[0] = addr[0] = '\0';
 			if (high & (1<<29))
 				recover |= 1;
 			if (high & (1<<25))
 				recover |= 2;
-			printk (KERN_EMERG "Bank %d: %08x%08x", i, high, low);
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
 				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				printk ("[%08x%08x]", ahigh, alow);
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
 				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				printk (" at %08x%08x", ahigh, alow);
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk ("\n");
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+				smp_processor_id(), i, high, low, misc, addr);
 		}
 	}
 
diff -puN arch/x86/kernel/cpu/mcheck/p6.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5 arch/x86/kernel/cpu/mcheck/p6.c
--- a/arch/x86/kernel/cpu/mcheck/p6.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5
+++ a/arch/x86/kernel/cpu/mcheck/p6.c
@@ -33,21 +33,24 @@ static void intel_machine_check(struct p
 	for (i=0; i<nr_mce_banks; i++) {
 		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high & (1<<31)) {
+			char misc[20];
+			char addr[24];
+			misc[0] = addr[0] = '\0';
 			if (high & (1<<29))
 				recover |= 1;
 			if (high & (1<<25))
 				recover |= 2;
-			printk (KERN_EMERG "Bank %d: %08x%08x", i, high, low);
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
 				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				printk ("[%08x%08x]", ahigh, alow);
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
 				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				printk (" at %08x%08x", ahigh, alow);
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk ("\n");
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+				smp_processor_id(), i, high, low, misc, addr);
 		}
 	}
 
_

Patches currently in -mm which might be from mzhang@mvista.com are

arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch
