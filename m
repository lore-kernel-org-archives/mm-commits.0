From: akpm@linux-foundation.org
Subject: [merged]
 mm-arch-use-__free_reserved_page-to-simplify-the-code.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:37:47 -0800
Message-ID: <5283e31b.sJidBN7mZSD7DtJB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3KMUhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paulus@samba.org, monstr@monstr.eu, james.hogan@imgtec.com, benh@kernel.crashing.org, qiuxishi@huawei.com

Subject: [merged] mm-arch-use-__free_reserved_page-to-simplify-the-code.patch removed from -mm tree
To: qiuxishi@huawei.com,benh@kernel.crashing.org,james.hogan@imgtec.com,monstr@monstr.eu,paulus@samba.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:47 -0800


The patch titled
     Subject: mm/arch: use __free_reserved_page() to simplify the code
has been removed from the -mm tree.  Its filename was
     mm-arch-use-__free_reserved_page-to-simplify-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/arch: use __free_reserved_page() to simplify the code

Use __free_reserved_page() to simplify the code in arch.

It used split_page() in consistent_alloc()/__dma_alloc_coherent()/dma_alloc_coherent(),
so page->_count == 1, and we can free it safely.

__free_reserved_page()
	ClearPageReserved()
	init_page_count()  // it won't change the value
	__free_page()

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/kernel/dma.c           |    4 +---
 arch/microblaze/mm/consistent.c   |    7 ++-----
 arch/powerpc/mm/dma-noncoherent.c |    4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

diff -puN arch/metag/kernel/dma.c~mm-arch-use-__free_reserved_page-to-simplify-the-code arch/metag/kernel/dma.c
--- a/arch/metag/kernel/dma.c~mm-arch-use-__free_reserved_page-to-simplify-the-code
+++ a/arch/metag/kernel/dma.c
@@ -305,9 +305,7 @@ void dma_free_coherent(struct device *de
 
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
-				ClearPageReserved(page);
-
-				__free_page(page);
+				__free_reserved_page(page);
 				continue;
 			}
 		}
diff -puN arch/microblaze/mm/consistent.c~mm-arch-use-__free_reserved_page-to-simplify-the-code arch/microblaze/mm/consistent.c
--- a/arch/microblaze/mm/consistent.c~mm-arch-use-__free_reserved_page-to-simplify-the-code
+++ a/arch/microblaze/mm/consistent.c
@@ -176,8 +176,7 @@ void consistent_free(size_t size, void *
 	page = virt_to_page(vaddr);
 
 	do {
-		ClearPageReserved(page);
-		__free_page(page);
+		__free_reserved_page(page);
 		page++;
 	} while (size -= PAGE_SIZE);
 #else
@@ -194,9 +193,7 @@ void consistent_free(size_t size, void *
 			pte_clear(&init_mm, (unsigned int)vaddr, ptep);
 			if (pfn_valid(pfn)) {
 				page = pfn_to_page(pfn);
-
-				ClearPageReserved(page);
-				__free_page(page);
+				__free_reserved_page(page);
 			}
 		}
 		vaddr += PAGE_SIZE;
diff -puN arch/powerpc/mm/dma-noncoherent.c~mm-arch-use-__free_reserved_page-to-simplify-the-code arch/powerpc/mm/dma-noncoherent.c
--- a/arch/powerpc/mm/dma-noncoherent.c~mm-arch-use-__free_reserved_page-to-simplify-the-code
+++ a/arch/powerpc/mm/dma-noncoherent.c
@@ -287,9 +287,7 @@ void __dma_free_coherent(size_t size, vo
 			pte_clear(&init_mm, addr, ptep);
 			if (pfn_valid(pfn)) {
 				struct page *page = pfn_to_page(pfn);
