From: akpm@linux-foundation.org
Subject: [merged] arc-handle-pgtable_page_ctor-fail.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:58 -0800
Message-ID: <52867f1e.qvGvGC6xlRauh/mu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3KOUH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, kirill.shutemov@linux.intel.com

Subject: [merged] arc-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:58 -0800


The patch titled
     Subject: arc: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     arc-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arc: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com> [for arch/arc bits]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/pgalloc.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/arc/include/asm/pgalloc.h~arc-handle-pgtable_page_ctor-fail arch/arc/include/asm/pgalloc.h
--- a/arch/arc/include/asm/pgalloc.h~arc-handle-pgtable_page_ctor-fail
+++ a/arch/arc/include/asm/pgalloc.h
@@ -105,11 +105,16 @@ static inline pgtable_t
 pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	pgtable_t pte_pg;
+	struct page *page;
 
 	pte_pg = __get_free_pages(GFP_KERNEL | __GFP_REPEAT, __get_order_pte());
-	if (pte_pg) {
-		memzero((void *)pte_pg, PTRS_PER_PTE * 4);
-		pgtable_page_ctor(virt_to_page(pte_pg));
+	if (!pte_pg)
+		return 0;
+	memzero((void *)pte_pg, PTRS_PER_PTE * 4);
+	page = virt_to_page(pte_pg);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return 0;
 	}
 
 	return pte_pg;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

