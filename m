From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch added
 to -mm tree
Date: Mon, 02 Dec 2013 16:01:28 -0800
Message-ID: <529d1f58.lphVsqwHBynTS1PF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3LCAB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 19:01:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, murzin.v@gmail.com, nasa4836@gmail.com

Subject: + mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch added to -mm tree
To: nasa4836@gmail.com,murzin.v@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 16:01:28 -0800


The patch titled
     Subject: mm/vmalloc: interchage the implementation of vmalloc_to_{pfn,page}
has been added to the -mm tree.  Its filename is
     mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+	unsigned long pfn;
 	pgd_t *pgd = pgd_offset_k(addr);
 
 	/*
@@ -244,23 +244,23 @@ struct page *vmalloc_to_page(const void
 				ptep = pte_offset_map(pmd, addr);
 				pte = *ptep;
 				if (pte_present(pte))
-					page = pte_page(pte);
+					pfn = pte_page(pte);
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

mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage.patch
mm-vmalloc-interchage-the-implementation-of-vmalloc_to_pfnpage-fix.patch

