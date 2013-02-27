From: akpm@linux-foundation.org
Subject: [merged] revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:50:51 -0800
Message-ID: <20130227205052.579F031C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:42708 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3B0Uuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:50:55 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so111267ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:50:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andi@firstfloor.org, hpa@linux.intel.com, hughd@google.com, mgorman@suse.de, mingo@elte.hu, shaohua.li@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "x86, mm: Make spurious_fault check explicitly check the PRESENT bit"
has been removed from the -mm tree.  Its filename was
     revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -939,14 +939,8 @@ spurious_fault(unsigned long error_code,
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

origin.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

