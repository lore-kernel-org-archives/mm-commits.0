From: akpm@linux-foundation.org
Subject: [merged] sparc-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:32 -0800
Message-ID: <52867f40.OHZC6XRa7bvjiOTF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, kirill.shutemov@linux.intel.com

Subject: [merged] sparc-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,davem@davemloft.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:32 -0800


The patch titled
     Subject: sparc: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     sparc-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sparc: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   11 ++++++-----
 arch/sparc/mm/srmmu.c   |    5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN arch/sparc/mm/init_64.c~sparc-handle-pgtable_page_ctor-fail arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~sparc-handle-pgtable_page_ctor-fail
+++ a/arch/sparc/mm/init_64.c
@@ -2519,12 +2519,13 @@ pgtable_t pte_alloc_one(struct mm_struct
 		return pte;
 
 	page = __alloc_for_cache(mm);
-	if (page) {
-		pgtable_page_ctor(page);
-		pte = (pte_t *) page_address(page);
+	if (!page)
+		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		free_hot_cold_page(page, 0);
+		return NULL;
 	}
-
-	return pte;
+	return (pte_t *) page_address(page);
 }
 
 void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
diff -puN arch/sparc/mm/srmmu.c~sparc-handle-pgtable_page_ctor-fail arch/sparc/mm/srmmu.c
--- a/arch/sparc/mm/srmmu.c~sparc-handle-pgtable_page_ctor-fail
+++ a/arch/sparc/mm/srmmu.c
@@ -345,7 +345,10 @@ pgtable_t pte_alloc_one(struct mm_struct
 	if ((pte = (unsigned long)pte_alloc_one_kernel(mm, address)) == 0)
 		return NULL;
 	page = pfn_to_page(__nocache_pa(pte) >> PAGE_SHIFT);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 	return page;
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

