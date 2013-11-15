From: akpm@linux-foundation.org
Subject: [merged] openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:54 -0800
Message-ID: <52867f1a.QrRPP/ZNTp3t7cab%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3KOUHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jonas@southpole.se, kirill.shutemov@linux.intel.com

Subject: [merged] openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,jonas@southpole.se,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:54 -0800


The patch titled
     Subject: openrisc: add missing pgtable_page_ctor/dtor calls
has been removed from the -mm tree.  Its filename was
     openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: openrisc: add missing pgtable_page_ctor/dtor calls

It will fix NR_PAGETABLE accounting.  It's also required if the arch is
going ever support split ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/pgalloc.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/openrisc/include/asm/pgalloc.h~openrisc-add-missing-pgtable_page_ctor-dtor-calls arch/openrisc/include/asm/pgalloc.h
--- a/arch/openrisc/include/asm/pgalloc.h~openrisc-add-missing-pgtable_page_ctor-dtor-calls
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -78,8 +78,13 @@ static inline struct page *pte_alloc_one
 {
 	struct page *pte;
 	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
-	if (pte)
-		clear_page(page_address(pte));
+	if (!pte)
+		return NULL;
+	clear_page(page_address(pte));
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
+	}
 	return pte;
 }
 
@@ -90,6 +95,7 @@ static inline void pte_free_kernel(struc
 
 static inline void pte_free(struct mm_struct *mm, struct page *pte)
 {
+	pgtable_page_dtor(pte);
 	__free_page(pte);
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

