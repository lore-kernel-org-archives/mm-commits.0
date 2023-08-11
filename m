Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117CBC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbjHKXCk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236736AbjHKXA5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3693A9D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5960C63F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5AFC433C7;
        Fri, 11 Aug 2023 23:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794833;
        bh=daB0iLDQ5fz8KQXqPmYVnBkSLaO67vytKE3SMHphN4s=;
        h=Date:To:From:Subject:From;
        b=MtEdRO9UGZIKF/jUo7jZVhuD8kiB4fwJ+V9h5VyAz0PvcjwYxiUh0W4mqkSZR3kGB
         a/w1MVokNAfOv3i/aTkPAQDgfYijxrQbmy5cIxF5uyC2SP0G/ISg8WMoUz5Exv7jy1
         e/hQZkZyHOGpPANSAPEvx7N4rvnjgMjJ7522X5Js=
Date:   Fri, 11 Aug 2023 16:00:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        zhengqi.arch@bytedance.com, zackr@vmware.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, will@kernel.org,
        vishal.moola@gmail.com, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, rppt@kernel.org, rcampbell@nvidia.com,
        peterz@infradead.org, peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@nec.com, mpe@ellerman.id.au, minchan@kernel.org,
        mike.kravetz@oracle.com, mgorman@techsingularity.net,
        lstoakes@gmail.com, linux@armlinux.org.uk, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jannh@google.com,
        ira.weiny@intel.com, imbrenda@linux.ibm.com, hch@infradead.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        davem@davemloft.net, christophe.leroy@csgroup.eu,
        borntraeger@linux.ibm.com, axelrasmussen@google.com,
        apopple@nvidia.com, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com, agordeev@linux.ibm.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-add-pte_free_defer-for-pgtables-sharing-page.patch removed from -mm tree
Message-Id: <20230811230033.AC5AFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390: add pte_free_defer() for pgtables sharing page
has been removed from the -mm tree.  Its filename was
     s390-add-pte_free_defer-for-pgtables-sharing-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: s390: add pte_free_defer() for pgtables sharing page
Date: Tue, 11 Jul 2023 21:38:35 -0700 (PDT)

Add s390-specific pte_free_defer(), to free table page via call_rcu(). 
pte_free_defer() will be called inside khugepaged's retract_page_tables()
loop, where allocating extra memory cannot be relied upon.  This precedes
the generic version to avoid build breakage from incompatible pgtable_t.

This version is more complicated than others: because s390 fits two 2K
page tables into one 4K page (so page->rcu_head must be shared between
both halves), and already uses page->lru (which page->rcu_head overlays)
to list any free halves; with clever management by page->_refcount bits.

Build upon the existing management, adjusted to follow a new rule: that a
page is never on the free list if pte_free_defer() was used on either half
(marked by PageActive).  And for simplicity, delay calling RCU until both
halves are freed.

Not adding back unallocated fragments to the list in pte_free_defer() can
result in wasting some amount of memory for pagetables, depending on how
long the allocated fragment will stay in use.  In practice, this effect is
expected to be insignificant, and not justify a far more complex approach,
which might allow to add the fragments back later in __tlb_remove_table(),
where we might not have a stable mm any more.

[hughd@google.com: Claudio finds warning on mm_has_pgste() more useful than on mm_alloc_pgste()]
  Link: https://lkml.kernel.org/r/3bc095ba-a180-ce3b-82b1-2bfc64612f3@google.com
Link: https://lkml.kernel.org/r/94eccf5f-264c-8abe-4567-e77f4b4e14a@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Tested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgalloc.h |    4 +
 arch/s390/mm/pgalloc.c          |   80 +++++++++++++++++++++++++-----
 2 files changed, 72 insertions(+), 12 deletions(-)

--- a/arch/s390/include/asm/pgalloc.h~s390-add-pte_free_defer-for-pgtables-sharing-page
+++ a/arch/s390/include/asm/pgalloc.h
@@ -143,6 +143,10 @@ static inline void pmd_populate(struct m
 #define pte_free_kernel(mm, pte) page_table_free(mm, (unsigned long *) pte)
 #define pte_free(mm, pte) page_table_free(mm, (unsigned long *) pte)
 
+/* arch use pte_free_defer() implementation in arch/s390/mm/pgalloc.c */
+#define pte_free_defer pte_free_defer
+void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
+
 void vmem_map_init(void);
 void *vmem_crst_alloc(unsigned long val);
 pte_t *vmem_pte_alloc(void);
--- a/arch/s390/mm/pgalloc.c~s390-add-pte_free_defer-for-pgtables-sharing-page
+++ a/arch/s390/mm/pgalloc.c
@@ -229,6 +229,15 @@ void page_table_free_pgste(struct page *
  * logic described above. Both AA bits are set to 1 to denote a 4KB-pgtable
  * while the PP bits are never used, nor such a page is added to or removed
  * from mm_context_t::pgtable_list.
+ *
+ * pte_free_defer() overrides those rules: it takes the page off pgtable_list,
+ * and prevents both 2K fragments from being reused. pte_free_defer() has to
+ * guarantee that its pgtable cannot be reused before the RCU grace period
+ * has elapsed (which page_table_free_rcu() does not actually guarantee).
+ * But for simplicity, because page->rcu_head overlays page->lru, and because
+ * the RCU callback might not be called before the mm_context_t has been freed,
+ * pte_free_defer() in this implementation prevents both fragments from being
+ * reused, and delays making the call to RCU until both fragments are freed.
  */
 unsigned long *page_table_alloc(struct mm_struct *mm)
 {
@@ -261,7 +270,7 @@ unsigned long *page_table_alloc(struct m
 					table += PTRS_PER_PTE;
 				atomic_xor_bits(&page->_refcount,
 							0x01U << (bit + 24));
-				list_del(&page->lru);
+				list_del_init(&page->lru);
 			}
 		}
 		spin_unlock_bh(&mm->context.lock);
@@ -281,6 +290,7 @@ unsigned long *page_table_alloc(struct m
 	table = (unsigned long *) page_to_virt(page);
 	if (mm_alloc_pgste(mm)) {
 		/* Return 4K page table with PGSTEs */
+		INIT_LIST_HEAD(&page->lru);
 		atomic_xor_bits(&page->_refcount, 0x03U << 24);
 		memset64((u64 *)table, _PAGE_INVALID, PTRS_PER_PTE);
 		memset64((u64 *)table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
@@ -300,7 +310,9 @@ static void page_table_release_check(str
 {
 	char msg[128];
 
-	if (!IS_ENABLED(CONFIG_DEBUG_VM) || !mask)
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+	if (!mask && list_empty(&page->lru))
 		return;
 	snprintf(msg, sizeof(msg),
 		 "Invalid pgtable %p release half 0x%02x mask 0x%02x",
@@ -308,6 +320,15 @@ static void page_table_release_check(str
 	dump_page(page, msg);
 }
 
+static void pte_free_now(struct rcu_head *head)
+{
+	struct page *page;
+
+	page = container_of(head, struct page, rcu_head);
+	pgtable_pte_page_dtor(page);
+	__free_page(page);
+}
+
 void page_table_free(struct mm_struct *mm, unsigned long *table)
 {
 	unsigned int mask, bit, half;
@@ -325,10 +346,17 @@ void page_table_free(struct mm_struct *m
 		 */
 		mask = atomic_xor_bits(&page->_refcount, 0x11U << (bit + 24));
 		mask >>= 24;
-		if (mask & 0x03U)
+		if ((mask & 0x03U) && !PageActive(page)) {
+			/*
+			 * Other half is allocated, and neither half has had
+			 * its free deferred: add page to head of list, to make
+			 * this freed half available for immediate reuse.
+			 */
 			list_add(&page->lru, &mm->context.pgtable_list);
-		else
-			list_del(&page->lru);
+		} else {
+			/* If page is on list, now remove it. */
+			list_del_init(&page->lru);
+		}
 		spin_unlock_bh(&mm->context.lock);
 		mask = atomic_xor_bits(&page->_refcount, 0x10U << (bit + 24));
 		mask >>= 24;
@@ -342,8 +370,10 @@ void page_table_free(struct mm_struct *m
 	}
 
 	page_table_release_check(page, table, half, mask);
-	pgtable_pte_page_dtor(page);
-	__free_page(page);
+	if (TestClearPageActive(page))
+		call_rcu(&page->rcu_head, pte_free_now);
+	else
+		pte_free_now(&page->rcu_head);
 }
 
 void page_table_free_rcu(struct mmu_gather *tlb, unsigned long *table,
@@ -370,10 +400,18 @@ void page_table_free_rcu(struct mmu_gath
 	 */
 	mask = atomic_xor_bits(&page->_refcount, 0x11U << (bit + 24));
 	mask >>= 24;
-	if (mask & 0x03U)
+	if ((mask & 0x03U) && !PageActive(page)) {
+		/*
+		 * Other half is allocated, and neither half has had
+		 * its free deferred: add page to end of list, to make
+		 * this freed half available for reuse once its pending
+		 * bit has been cleared by __tlb_remove_table().
+		 */
 		list_add_tail(&page->lru, &mm->context.pgtable_list);
-	else
-		list_del(&page->lru);
+	} else {
+		/* If page is on list, now remove it. */
+		list_del_init(&page->lru);
+	}
 	spin_unlock_bh(&mm->context.lock);
 	table = (unsigned long *) ((unsigned long) table | (0x01U << bit));
 	tlb_remove_table(tlb, table);
@@ -403,9 +441,27 @@ void __tlb_remove_table(void *_table)
 	}
 
 	page_table_release_check(page, table, half, mask);
-	pgtable_pte_page_dtor(page);
-	__free_page(page);
+	if (TestClearPageActive(page))
+		call_rcu(&page->rcu_head, pte_free_now);
+	else
+		pte_free_now(&page->rcu_head);
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable)
+{
+	struct page *page;
+
+	page = virt_to_page(pgtable);
+	SetPageActive(page);
+	page_table_free(mm, (unsigned long *)pgtable);
+	/*
+	 * page_table_free() does not do the pgste gmap_unlink() which
+	 * page_table_free_rcu() does: warn us if pgste ever reaches here.
+	 */
+	WARN_ON_ONCE(mm_has_pgste(mm));
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
  * Base infrastructure required to generate basic asces, region, segment,
_

Patches currently in -mm which might be from hughd@google.com are


