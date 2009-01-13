From: akpm@linux-foundation.org
Subject: [merged] x86-avoid-theoretical-vmalloc-fault-loop.patch removed from -mm tree
Date: Tue, 13 Jan 2009 12:13:02 -0800
Message-ID: <200901132013.n0DKD2h6012223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbZAMUNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 15:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, nickpiggin@yahoo.com.au, stable@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: avoid theoretical vmalloc fault loop
has been removed from the -mm tree.  Its filename was
     x86-avoid-theoretical-vmalloc-fault-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: avoid theoretical vmalloc fault loop
From: Andi Kleen <andi@firstfloor.org>

Ajith Kumar noticed:

I was going through the vmalloc fault handling for x86_64 and am unclear
about the following lines in the vmalloc_fault() function.

pgd = pgd_offset(current->mm ?: &init_mm, address);
pgd_ref = pgd_offset_k(address);

Here the intention is to get the pgd corresponding to the current process
and sync it up with the pgd in init_mm(obtained from pgd_offset_k). 
However, for kernel threads current->mm is NULL and hence pgd =
pgd_offset(init_mm, address) = pgd_ref which means the fault handler
returns without setting the pgd entry in the MM structure in the context
of which the kernel thread has faulted.  This could lead to never-ending
faults and busy looping of kernel threads like pdflush.  So, shouldn't the
pgd = pgd_offset(current->mm ?: &init_mm, address); be pgd =
pgd_offset(current->active_mm ?: &init_mm, address);

AK: We can use active_mm unconditionally because it should be always set. 
Do that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/fault.c~x86-avoid-theoretical-vmalloc-fault-loop arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~x86-avoid-theoretical-vmalloc-fault-loop
+++ a/arch/x86/mm/fault.c
@@ -536,7 +536,7 @@ static int vmalloc_fault(unsigned long a
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd = pgd_offset(current->active_mm, address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
x86-hpet-allow-force-enable-on-ich10-hpet.patch
x86-mark-complex-bitopsh-inlines-as-__always_inline.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch

