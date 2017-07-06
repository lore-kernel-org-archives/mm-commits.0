From: akpm@linux-foundation.org
Subject: [patch 064/108] mm/hugetlb: export hugetlb_entry_migration
 helper
Date: Thu, 06 Jul 2017 15:38:47 -0700
Message-ID: <20170706223847.uv3qXABa0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36322 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdGFWis (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/hugetlb: export hugetlb_entry_migration helper

We will be using this later from the ppc64 code.  Change the return type
to bool.

Link: http://lkml.kernel.org/r/1494926612-23928-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-export-hugetlb_entry_migration-helper include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-export-hugetlb_entry_migration-helper
+++ a/include/linux/hugetlb.h
@@ -126,6 +126,7 @@ int pud_huge(pud_t pud);
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
+bool is_hugetlb_entry_migration(pte_t pte);
 #else /* !CONFIG_HUGETLB_PAGE */
 
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
diff -puN mm/hugetlb.c~mm-hugetlb-export-hugetlb_entry_migration-helper mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-export-hugetlb_entry_migration-helper
+++ a/mm/hugetlb.c
@@ -3201,17 +3201,17 @@ static void set_huge_ptep_writable(struc
 		update_mmu_cache(vma, address, ptep);
 }
 
-static int is_hugetlb_entry_migration(pte_t pte)
+bool is_hugetlb_entry_migration(pte_t pte)
 {
 	swp_entry_t swp;
 
 	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
+		return false;
 	swp = pte_to_swp_entry(pte);
 	if (non_swap_entry(swp) && is_migration_entry(swp))
-		return 1;
+		return true;
 	else
-		return 0;
+		return false;
 }
 
 static int is_hugetlb_entry_hwpoisoned(pte_t pte)
_
