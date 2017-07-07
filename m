From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-migration-use-set_huge_pte_at-instead-of-set_pte_at.patch
 removed from -mm tree
Date: Fri, 07 Jul 2017 12:09:41 -0700
Message-ID: <20170707190941.8vjuFxPs-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbdGGTJm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm/hugetlb/migration: use set_huge_pte_at instead of set_pte_at
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-migration-use-set_huge_pte_at-instead-of-set_pte_at.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/hugetlb/migration: use set_huge_pte_at instead of set_pte_at

Patch series "HugeTLB migration support for PPC64", v2.


This patch (of 9):

The right interface to use to set a hugetlb pte entry is set_huge_pte_at. 
Use that instead of set_pte_at.

Link: http://lkml.kernel.org/r/1494926612-23928-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/migrate.c~mm-hugetlb-migration-use-set_huge_pte_at-instead-of-set_pte_at mm/migrate.c
--- a/mm/migrate.c~mm-hugetlb-migration-use-set_huge_pte_at-instead-of-set_pte_at
+++ a/mm/migrate.c
@@ -227,25 +227,26 @@ static bool remove_migration_pte(struct
 		if (is_write_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
 
+		flush_dcache_page(new);
 #ifdef CONFIG_HUGETLB_PAGE
 		if (PageHuge(new)) {
 			pte = pte_mkhuge(pte);
 			pte = arch_make_huge_pte(pte, vma, new, 0);
-		}
-#endif
-		flush_dcache_page(new);
-		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
-
-		if (PageHuge(new)) {
+			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 			if (PageAnon(new))
 				hugepage_add_anon_rmap(new, vma, pvmw.address);
 			else
 				page_dup_rmap(new, true);
-		} else if (PageAnon(new))
-			page_add_anon_rmap(new, vma, pvmw.address, false);
-		else
-			page_add_file_rmap(new, false);
+		} else
+#endif
+		{
+			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 
+			if (PageAnon(new))
+				page_add_anon_rmap(new, vma, pvmw.address, false);
+			else
+				page_add_file_rmap(new, false);
+		}
 		if (vma->vm_flags & VM_LOCKED && !PageTransCompound(new))
 			mlock_vma_page(new);
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


