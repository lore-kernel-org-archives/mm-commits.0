From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:48 -0800
Message-ID: <52e02640.iS81k6u9tq0Z4ZV9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaAVUMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, murzin.v@gmail.com, nasa4836@gmail.com

Subject: [merged] mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch removed from -mm tree
To: nasa4836@gmail.com,murzin.v@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:48 -0800


The patch titled
     Subject: mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}

Currently we are implementing vmalloc_to_pfn() as a wrapper around
vmalloc_to_page(), which is implemented as follow:

 1. walks the page talbes to generates the corresponding pfn,
 2. then converts the pfn to struct page,
 3. returns it.

And vmalloc_to_pfn() re-wraps vmalloc_to_page() to get the pfn.

This seems too circuitous, so this patch reverses the way: implement
vmalloc_to_page() as a wrapper around vmalloc_to_pfn().  This makes
vmalloc_to_pfn() and vmalloc_to_page() slightly more efficient.

No functional change.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Vladimir Murzin <murzin.v@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage
+++ a/mm/vmalloc.c
@@ -220,12 +220,12 @@ int is_vmalloc_or_module_addr(const void
 }
 
 /*
- * Walk a vmap address to the struct page it maps.
+ * Walk a vmap address to the physical pfn it maps to.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
-	struct page *page = NULL;
+	unsigned long pfn = 0;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,23 +244,23 @@ struct page *vmalloc_to_page(const void
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					page = pte_page(pte);
+					pfn = pte_pfn(pte);
 				pte_unmap(ptep);
 			}
 		}
 	}
-	return page;
+	return pfn;
 }
-EXPORT_SYMBOL(vmalloc_to_page);
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 /*
- * Map a vmalloc()-space virtual address to the physical page frame number.
+ * Map a vmalloc()-space virtual address to the struct page.
  */
-unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
-	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
+	return pfn_to_page(vmalloc_to_pfn(vmalloc_addr));
 }
-EXPORT_SYMBOL(vmalloc_to_pfn);
+EXPORT_SYMBOL(vmalloc_to_page);
 
 
 /*** Global kva allocator ***/
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch

