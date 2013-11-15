From: akpm@linux-foundation.org
Subject: [merged] unicore32-handle-pgtable_page_ctor-fail.patch removed
 from -mm tree
Date: Fri, 15 Nov 2013 12:08:38 -0800
Message-ID: <52867f46.EbGaRVwoZtIGcWeC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOUIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gxt@mprc.pku.edu.cn, kirill.shutemov@linux.intel.com

Subject: [merged] unicore32-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,gxt@mprc.pku.edu.cn,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:38 -0800


The patch titled
     Subject: unicore32: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     unicore32-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: unicore32: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/include/asm/pgalloc.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/unicore32/include/asm/pgalloc.h~unicore32-handle-pgtable_page_ctor-fail arch/unicore32/include/asm/pgalloc.h
--- a/arch/unicore32/include/asm/pgalloc.h~unicore32-handle-pgtable_page_ctor-fail
+++ a/arch/unicore32/include/asm/pgalloc.h
@@ -51,12 +51,14 @@ pte_alloc_one(struct mm_struct *mm, unsi
 	struct page *pte;
 
 	pte = alloc_pages(PGALLOC_GFP, 0);
-	if (pte) {
-		if (!PageHighMem(pte)) {
-			void *page = page_address(pte);
-			clean_dcache_area(page, PTRS_PER_PTE * sizeof(pte_t));
-		}
-		pgtable_page_ctor(pte);
+	if (!pte)
+		return NULL;
+	if (!PageHighMem(pte)) {
+		void *page = page_address(pte);
+		clean_dcache_area(page, PTRS_PER_PTE * sizeof(pte_t));
+	}
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
 	}
 
 	return pte;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

