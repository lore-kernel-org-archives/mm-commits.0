From: akpm@linux-foundation.org
Subject: + x86-avoid-theoretical-vmalloc-fault-loop.patch added to -mm tree
Date: Mon, 05 Jan 2009 16:05:31 -0800
Message-ID: <200901060005.n0605WLR008305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbZAFAGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 19:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, nickpiggin@yahoo.com.au, stable@kernel.org, tglx@linutronix.de


The patch titled
     x86: avoid theoretical vmalloc fault loop
has been added to the -mm tree.  Its filename is
     x86-avoid-theoretical-vmalloc-fault-loop.patch

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
x86-only-scan-the-root-bus-in-early-pci-quirks.patch
x86-hpet-allow-force-enable-on-ich10-hpet.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
x86-avoid-theoretical-vmalloc-fault-loop.patch
remove-remaining-unwinder-code.patch
elf-implement-at_random-for-glibc-prng-seeding.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch

