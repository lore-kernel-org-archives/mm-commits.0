From: akpm@linux-foundation.org
Subject: + x86_64-nx-bit-handling-in-change_page_attr.patch added to -mm tree
Date: Tue, 11 Sep 2007 20:24:03 -0700
Message-ID: <200709120324.l8C3O3Kp013993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760185AbXILDYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de


The patch titled
     x86_64: NX bit handling in change_page_attr
has been added to the -mm tree.  Its filename is
     x86_64-nx-bit-handling-in-change_page_attr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
--- a/arch/x86_64/mm/pageattr.c~x86_64-nx-bit-handling-in-change_page_attr
+++ a/arch/x86_64/mm/pageattr.c
@@ -189,6 +189,7 @@ __change_page_attr(unsigned long address
 			split = split_large_page(address, prot, ref_prot2);
 			if (!split)
 				return -ENOMEM;
+			pgprot_val(ref_prot2) &= ~_PAGE_NX;
 			set_pte(kpte, mk_pte(split, ref_prot2));
 			kpte_page = split;
 		}
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-nx-bit-handling-in-change_page_attr.patch
x86_64-efi-boot-support-efi-frame-buffer-driver.patch
x86_64-efi-boot-support-efi-boot-document.patch
