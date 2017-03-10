From: akpm@linux-foundation.org
Subject: [merged] x86-mm-fix-gup_pte_range-vs-dax-mappings.patch removed
 from -mm tree
Date: Fri, 10 Mar 2017 13:42:46 -0800
Message-ID: <58c31dd6.mNo+hXQQMRp932d7%akpm__22890.3912859552$1489182171$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVms (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:42:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, tglx@linutronix.de, xzhou@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: fix gup_pte_range() vs DAX mappings
has been removed from the -mm tree.  Its filename was
     x86-mm-fix-gup_pte_range-vs-dax-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: x86, mm: fix gup_pte_range() vs DAX mappings

gup_pte_range() fails to check pte_allows_gup() before translating a DAX
pte entry, pte_devmap(), to a page.  This allows writes to read-only
mappings, and bypasses the DAX cacheline dirty tracking due to missed
'mkwrite' faults.  The gup_huge_pmd() path and the gup_huge_pud() path
correctly check pte_allows_gup() before checking for _devmap() entries.

Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Link: http://lkml.kernel.org/r/148804251312.36605.12665024794196605053.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Xiong Zhou <xzhou@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/gup.c~x86-mm-fix-gup_pte_range-vs-dax-mappings arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~x86-mm-fix-gup_pte_range-vs-dax-mappings
+++ a/arch/x86/mm/gup.c
@@ -120,6 +120,11 @@ static noinline int gup_pte_range(pmd_t
 			return 0;
 		}
 
+		if (!pte_allows_gup(pte_val(pte), write)) {
+			pte_unmap(ptep);
+			return 0;
+		}
+
 		if (pte_devmap(pte)) {
 			pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
@@ -127,8 +132,7 @@ static noinline int gup_pte_range(pmd_t
 				pte_unmap(ptep);
 				return 0;
 			}
-		} else if (!pte_allows_gup(pte_val(pte), write) ||
-			   pte_special(pte)) {
+		} else if (pte_special(pte)) {
 			pte_unmap(ptep);
 			return 0;
 		}
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


