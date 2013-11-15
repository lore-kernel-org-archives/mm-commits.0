From: akpm@linux-foundation.org
Subject: [merged] m68k-handle-pgtable_page_ctor-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:08:16 -0800
Message-ID: <52867f30.Utkmz+R5T3zUdlxY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3KOUIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:08:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, kirill.shutemov@linux.intel.com

Subject: [merged] m68k-handle-pgtable_page_ctor-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:08:16 -0800


The patch titled
     Subject: m68k: handle pgtable_page_ctor() fail
has been removed from the -mm tree.  Its filename was
     m68k-handle-pgtable_page_ctor-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: m68k: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgalloc.h      |    4 ++++
 arch/m68k/include/asm/motorola_pgalloc.h |    8 ++++++--
 arch/m68k/include/asm/sun3_pgalloc.h     |    5 ++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff -puN arch/m68k/include/asm/mcf_pgalloc.h~m68k-handle-pgtable_page_ctor-fail arch/m68k/include/asm/mcf_pgalloc.h
--- a/arch/m68k/include/asm/mcf_pgalloc.h~m68k-handle-pgtable_page_ctor-fail
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -56,6 +56,10 @@ static inline struct page *pte_alloc_one
 
 	if (!page)
 		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 
 	pte = kmap(page);
 	if (pte) {
diff -puN arch/m68k/include/asm/motorola_pgalloc.h~m68k-handle-pgtable_page_ctor-fail arch/m68k/include/asm/motorola_pgalloc.h
--- a/arch/m68k/include/asm/motorola_pgalloc.h~m68k-handle-pgtable_page_ctor-fail
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -29,18 +29,22 @@ static inline void pte_free_kernel(struc
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	struct page *page = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	struct page *page;
 	pte_t *pte;
 
+	page = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
 	if(!page)
 		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 
 	pte = kmap(page);
 	__flush_page_to_ram(pte);
 	flush_tlb_kernel_page(pte);
 	nocache_page(pte);
 	kunmap(page);
-	pgtable_page_ctor(page);
 	return page;
 }
 
diff -puN arch/m68k/include/asm/sun3_pgalloc.h~m68k-handle-pgtable_page_ctor-fail arch/m68k/include/asm/sun3_pgalloc.h
--- a/arch/m68k/include/asm/sun3_pgalloc.h~m68k-handle-pgtable_page_ctor-fail
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -59,7 +59,10 @@ static inline pgtable_t pte_alloc_one(st
 		return NULL;
 
 	clear_highpage(page);
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

