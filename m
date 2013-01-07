From: akpm@linux-foundation.org
Subject: + revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:54:21 -0800
Message-ID: <20130107215422.3A490820059@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49234 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3AGVyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:54:23 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so2140475qcq.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:54:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, andi@firstfloor.org, hpa@linux.intel.com, hughd@google.com, mgorman@suse.de, mingo@elte.hu, shaohua.li@intel.com, tglx@linutronix.de


The patch titled
     Subject: Revert "x86, mm: Make spurious_fault check explicitly check the PRESENT bit"
has been added to the -mm tree.  Its filename is
     revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Revert "x86, mm: Make spurious_fault check explicitly check the PRESENT bit"

I got a report for a minor regression introduced by commit 027ef6c87853b
("mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP").

So the problem is, pageattr creates kernel pagetables (pte and pmds) that
breaks pte_present/pmd_present and the patch above exposed this invariant
breakage for pmd_present.

The same problem already existed for the pte and pte_present and it was
fixed by commit 660a293ea9be709 ("x86, mm: Make spurious_fault check
explicitly check the PRESENT bit") (if it wasn't for that commit, it
wouldn't even be a regression).  That fix avoids the pagefault to use
pte_present.  I could follow through by stopping using
pmd_present/pmd_huge too.

However I think it's more robust to fix pageattr and to clear the
PSE/GLOBAL bitflags too in addition to the present bitflag.  So the kernel
page fault can keep using the regular pte_present/pmd_present/pmd_huge.

The confusion arises because _PAGE_GLOBAL and _PAGE_PROTNONE are sharing
the same bit, and in the pmd case we pretend _PAGE_PSE to be set only in
present pmds (to facilitate split_huge_page final tlb flush).


This patch:

Revert commit 660a293ea9be709 ("x86, mm: Make spurious_fault check
explicitly check the PRESENT bit").


Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/x86/mm/fault.c~revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit
+++ a/arch/x86/mm/fault.c
@@ -937,14 +937,8 @@ spurious_fault(unsigned long error_code,
 	if (pmd_large(*pmd))
 		return spurious_fault_check(error_code, (pte_t *) pmd);
 
-	/*
-	 * Note: don't use pte_present() here, since it returns true
-	 * if the _PAGE_PROTNONE bit is set.  However, this aliases the
-	 * _PAGE_GLOBAL bit, which for kernel pages give false positives
-	 * when CONFIG_DEBUG_PAGEALLOC is used.
-	 */
 	pte = pte_offset_kernel(pmd, address);
-	if (!(pte_flags(*pte) & _PAGE_PRESENT))
+	if (!pte_present(*pte))
 		return 0;
 
 	ret = spurious_fault_check(error_code, pte);
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
mm-migrate-check-page_count-of-thp-before-migrating.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
audit-create-explicit-audit_seccomp-event-type.patch
audit-catch-possible-null-audit-buffers.patch
mm-huge_memory-use-new-hashtable-implementation.patch

