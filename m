From: akpm@linux-foundation.org
Subject: [merged]
 revert-mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:07 -0800
Message-ID: <52e80053.qRwvih6Ou1M8nk5O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nasa4836@gmail.com, murzin.v@gmail.com, av1474@comtv.ru

Subject: [merged] revert-mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch removed from -mm tree
To: av1474@comtv.ru,murzin.v@gmail.com,nasa4836@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:07 -0800


The patch titled
     Subject: Revert "mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: malc <av1474@comtv.ru>
Subject: Revert "mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}"

Revert ece86e222db48d04bda, which was intended as a small performance
improvement.

Despite the claim that the patch doesn't introduce any functional changes
in fact it does.

The "no page" path behaves different now.  Originally, vmalloc_to_page
might return NULL under some conditions, with new implementation it
returns pfn_to_page(0) which is not the same as NULL.

Simple test shows the difference.

test.c

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>

int __init myi(void)
{
	struct page *p;
	void *v;

	v = vmalloc(PAGE_SIZE);
	/* trigger the "no page" path in vmalloc_to_page*/
	vfree(v);

	p = vmalloc_to_page(v);

	pr_err("expected val = NULL, returned val = %p", p);

	return -EBUSY;
}

void __exit mye(void)
{

}
module_init(myi)
module_exit(mye)

Before interchange:
expected val = NULL, returned val =   (null)

After interchange:
expected val = NULL, returned val = c7ebe000

Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/vmalloc.c~revert-mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage mm/vmalloc.c
--- a/mm/vmalloc.c~revert-mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage
+++ a/mm/vmalloc.c
@@ -220,12 +220,12 @@ int is_vmalloc_or_module_addr(const void
 }
 
 /*
- * Walk a vmap address to the physical pfn it maps to.
+ * Walk a vmap address to the struct page it maps.
  */
-unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
+struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
 	unsigned long addr = (unsigned long) vmalloc_addr;
-	unsigned long pfn = 0;
+	struct page *page = NULL;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,23 +244,23 @@ unsigned long vmalloc_to_pfn(const void
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					pfn = pte_pfn(pte);
+					page = pte_page(pte);
 				pte_unmap(ptep);
 			}
 		}
 	}
-	return pfn;
+	return page;
 }
-EXPORT_SYMBOL(vmalloc_to_pfn);
+EXPORT_SYMBOL(vmalloc_to_page);
 
 /*
- * Map a vmalloc()-space virtual address to the struct page.
+ * Map a vmalloc()-space virtual address to the physical page frame number.
  */
-struct page *vmalloc_to_page(const void *vmalloc_addr)
+unsigned long vmalloc_to_pfn(const void *vmalloc_addr)
 {
-	return pfn_to_page(vmalloc_to_pfn(vmalloc_addr));
+	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
 }
-EXPORT_SYMBOL(vmalloc_to_page);
+EXPORT_SYMBOL(vmalloc_to_pfn);
 
 
 /*** Global kva allocator ***/
_

Patches currently in -mm which might be from av1474@comtv.ru are

origin.patch
arm-move-arm_dma_limit-to-setup_dma_zone.patch

