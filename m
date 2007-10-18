From: akpm@linux-foundation.org
Subject: - x86_64-nx-bit-handling-in-change_page_attr.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:08:05 -0700
Message-ID: <200710180708.l9I785No031832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067AbXJRHIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: NX bit handling in change_page_attr
has been removed from the -mm tree.  Its filename was
     x86_64-nx-bit-handling-in-change_page_attr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: NX bit handling in change_page_attr
From: "Huang, Ying" <ying.huang@intel.com>

This patch fixes a bug of change_page_attr/change_page_attr_addr on Intel
x86_64 CPU.  After changing page attribute to be executable with these
functions, the page remains un-executable on Intel x86_64 CPU.  Because on
Intel x86_64 CPU, only if the "NX" bits of all four level page tables are
cleared, the corresponding page is executable (refer to section 4.13.2 of
Intel 64 and IA-32 Architectures Software Developer's Manual).  So, the bug
is fixed through clearing the "NX" bit of PMD when splitting the huge PMD.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/pageattr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/mm/pageattr.c~x86_64-nx-bit-handling-in-change_page_attr arch/x86_64/mm/pageattr.c
--- a/arch/x86/mm/pageattr_64.c~x86_64-nx-bit-handling-in-change_page_attr
+++ a/arch/x86/mm/pageattr_64.c
@@ -184,6 +184,7 @@ __change_page_attr(unsigned long address
 			split = split_large_page(address, prot, ref_prot2);
 			if (!split)
 				return -ENOMEM;
+			pgprot_val(ref_prot2) &= ~_PAGE_NX;
 			set_pte(kpte, mk_pte(split, ref_prot2));
 			kpte_page = split;
 		}
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
