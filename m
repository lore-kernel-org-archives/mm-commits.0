From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 12/35] mm/memory.c: refactor insert_page to
 prepare for batched-lock insert
Date: Fri, 10 Apr 2020 14:32:51 -0700
Message-ID: <20200410213251.5673tN9hi%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:53 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, linux-mm@kvack.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, torvalds@linux-foundation.org, willy@infradead.org

From: Arjun Roy <arjunroy@google.com>
Subject: mm/memory.c: refactor insert_page to prepare for batched-lock insert

Add helper methods for vm_insert_page()/insert_page() to prepare for
vm_insert_pages(), which batch-inserts pages to reduce spinlock operations
when inserting multiple consecutive pages into the user page table.

The intention of this patch-set is to reduce atomic ops for tcp zerocopy
receives, which normally hits the same spinlock multiple times
consecutively.

Link: http://lkml.kernel.org/r/20200128025958.43490-1-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-refactor-insert_page-to-prepare-for-batched-lock-insert
+++ a/mm/memory.c
@@ -1442,6 +1442,27 @@ pte_t *__get_locked_pte(struct mm_struct
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
+static int validate_page_before_insert(struct page *page)
+{
+	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+		return -EINVAL;
+	flush_dcache_page(page);
+	return 0;
+}
+
+static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
+			unsigned long addr, struct page *page, pgprot_t prot)
+{
+	if (!pte_none(*pte))
+		return -EBUSY;
+	/* Ok, finally just insert the thing.. */
+	get_page(page);
+	inc_mm_counter_fast(mm, mm_counter_file(page));
+	page_add_file_rmap(page, false);
+	set_pte_at(mm, addr, pte, mk_pte(page, prot));
+	return 0;
+}
+
 /*
  * This is the old fallback for page remapping.
  *
@@ -1457,26 +1478,14 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = -EINVAL;
-	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+	retval = validate_page_before_insert(page);
+	if (retval)
 		goto out;
 	retval = -ENOMEM;
-	flush_dcache_page(page);
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
 		goto out;
-	retval = -EBUSY;
-	if (!pte_none(*pte))
-		goto out_unlock;
-
-	/* Ok, finally just insert the thing.. */
-	get_page(page);
-	inc_mm_counter_fast(mm, mm_counter_file(page));
-	page_add_file_rmap(page, false);
-	set_pte_at(mm, addr, pte, mk_pte(page, prot));
