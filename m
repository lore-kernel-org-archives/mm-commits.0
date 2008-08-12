From: akpm@linux-foundation.org
Subject: - x86_64-restore-the-proper-nr_irqs-define-so-larger-systems-work.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:34:07 -0700
Message-ID: <200808122034.m7CKY79T011927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYHLUtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dhaval@linux.vnet.ibm.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: restore the proper NR_IRQS define so larger systems work
has been removed from the -mm tree.  Its filename was
     x86_64-restore-the-proper-nr_irqs-define-so-larger-systems-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_64: restore the proper NR_IRQS define so larger systems work
From: "Eric W. Biederman" <ebiederm@xmission.com>

As pointed out and tracked by Yinghai Lu <yhlu.kernel@gmail.com>:

Dhaval Giani got:
kernel BUG at arch/x86/kernel/io_apic_64.c:357!
invalid opcode: 0000 [1] SMP
CPU 24
...

his system (x3950) has 8 ioapic, irq > 256

This was caused by:
        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
        Author: Thomas Gleixner <tglx@linutronix.de>
        Date:   Fri May 2 20:10:09 2008 +0200

           x86: unify interrupt vector defines

           The interrupt vector defines are copied 4 times around with minimal
           differences. Move them all into asm-x86/irq_vectors.h

It appears that Thomas did not notice that x86_64 does something
completely different when he merge irq_vectors.h

We can solve this for 2.6.27 by simply reintroducing the old heuristic
for setting NR_IRQS on x86_64 to a usable value, which trivially removes
the regression.

Long term it would be nice to harmonize the handling of ioapic interrupts
of x86_32 and x86_64 so we don't have this kind of confusion.

Dhaval Giani tested an earlier version of this patch by YH which confirms
simply increasing NR_IRQS fixes the problem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com> 
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/irq_vectors.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN include/asm-x86/irq_vectors.h~x86_64-restore-the-proper-nr_irqs-define-so-larger-systems-work include/asm-x86/irq_vectors.h
--- a/include/asm-x86/irq_vectors.h~x86_64-restore-the-proper-nr_irqs-define-so-larger-systems-work
+++ a/include/asm-x86/irq_vectors.h
@@ -109,7 +109,15 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#if !defined(CONFIG_X86_VOYAGER)
+#ifdef CONFIG_X86_64
+# if NR_CPUS < MAX_IO_APICS
+#  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
+# else
+#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS ))
+# endif
+# define NR_IRQ_VECTORS NR_IRQS
+
+#elif !defined(CONFIG_X86_VOYAGER)
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

