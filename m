From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch added
 to -mm tree
Date: Wed, 26 Feb 2020 17:19:44 -0800
Message-ID: <20200227011944.tn_YOQqrJ%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbgB0BTr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 Feb 2020 20:19:47 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjunroy@google.com, davem@davemloft.net, edumazet@google.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, willy@infradead.org


The patch titled
     Subject: mm: bring sparc pte_index() semantics inline with other platforms
has been added to the -mm tree.  Its filename is
     mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
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

Patches currently in -mm which might be from arjunroy@google.com are

mm-refactor-insert_page-to-prepare-for-batched-lock-insert.patch
mm-bring-sparc-pte_index-semantics-inline-with-other-platforms.patch
mm-add-vm_insert_pages.patch
mm-add-vm_insert_pages-2.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy.patch
