From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 13/35] mm: bring sparc pte_index() semantics
 inline with other platforms
Date: Fri, 10 Apr 2020 14:32:54 -0700
Message-ID: <20200410213254.K8twzUhDB%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVc5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:57 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy.kdev@gmail.com, arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au, soheil@google.com, torvalds@linux-foundation.org, willy@infradead.org

From: Arjun Roy <arjunroy@google.com>
Subject: mm: bring sparc pte_index() semantics inline with other platforms

pte_index() on platforms other than sparc return a numerical index.  On
sparc, it returns a pte_t*.  This presents an issue for vm_insert_pages(),
which relies on pte_index() to find the offset for a pte within a pmd, for
batched inserts.

This patch:
1. Modifies pte_index() for sparc to return a numerical index, like
   other platforms,
2. Defines pte_entry() for sparc which returns a pte_t*
   (as pte_index() used to),
3. Converts existing sparc callers for pte_index() to use pte_entry().

[sfr@canb.auug.org.au: remove pte_entry and just directly modified pte_offset_kernel instead]
Link: http://lkml.kernel.org/r/20200227105045.6b421d9f@canb.auug.org.au
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arjun Roy <arjunroy.kdev@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h~mm-bring-sparc-pte_index-semantics-inline-with-other-platforms
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -907,11 +907,11 @@ static inline unsigned long pud_pfn(pud_
 	 (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1)))
 
 /* Find an entry in the third-level page table.. */
-#define pte_index(dir, address)	\
-	((pte_t *) __pmd_page(*(dir)) + \
-	 ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-#define pte_offset_kernel		pte_index
-#define pte_offset_map			pte_index
+#define pte_index(address)			\
+	 ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset_kernel(dir, address)	\
+	((pte_t *) __pmd_page(*(dir)) + pte_index(address))
+#define pte_offset_map(dir, address)	pte_offset_kernel((dir), (address))
 #define pte_unmap(pte)			do { } while (0)
 
 /* We cannot include <linux/mm_types.h> at this point yet: */
_
