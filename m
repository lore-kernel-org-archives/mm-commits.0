Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE25EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjFSXW2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjFSXVh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2832B10FA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21C860F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF35BC433C0;
        Mon, 19 Jun 2023 23:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216887;
        bh=bhwwklHAE2ucwpfS3oZbVpC2o216lXflz5MnJoqIEAM=;
        h=Date:To:From:Subject:From;
        b=cXSD3Fn9ksK99IS1t1ndcJO9HekovmFUUhU3462aJUKzpRo9iwB9qOgzqJNJ5SE+Z
         QUoS1dDar3iwzBIidyXSZOGjz6q44XKbgZB5HPFwg430dc4Ohcqp69JlPIbjPUoc47
         CyZN7mwsq72r38Vde2DIplX+ikBBq+Ek2QQjSHP4=
Date:   Mon, 19 Jun 2023 16:21:26 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        zackr@vmware.com, yuzhao@google.com, ying.huang@intel.com,
        willy@infradead.org, will@kernel.org,
        thomas.hellstrom@linux.intel.com, surenb@google.com,
        steven.price@arm.com, song@kernel.org, sj@kernel.org,
        shy828301@gmail.com, ryan.roberts@arm.com, rppt@kernel.org,
        rcampbell@nvidia.com, peterz@infradead.org, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@nec.com,
        minchan@kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, ira.weiny@intel.com, hch@infradead.org,
        david@redhat.com, christophe.leroy@csgroup.eu,
        axelrasmussen@google.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-cruft-from-migration_entry_waits.patch removed from -mm tree
Message-Id: <20230619232126.EF35BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: remove cruft from migration_entry_wait()s
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-cruft-from-migration_entry_waits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/migrate: remove cruft from migration_entry_wait()s
Date: Thu, 8 Jun 2023 18:08:20 -0700 (PDT)

migration_entry_wait_on_locked() does not need to take a mapped pte
pointer, its callers can do the unmap first.  Annotate it with
__releases(ptl) to reduce sparse warnings.

Fold __migration_entry_wait_huge() into migration_entry_wait_huge().  Fold
__migration_entry_wait() into migration_entry_wait(), preferring the
tighter pte_offset_map_lock() to pte_offset_map() and pte_lockptr().

Link: https://lkml.kernel.org/r/b0e2a532-cdf2-561b-e999-f3b13b8d6d3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++--
 include/linux/swapops.h |   17 +++--------------
 mm/filemap.c            |   13 ++++---------
 mm/migrate.c            |   37 +++++++++++++------------------------
 4 files changed, 22 insertions(+), 49 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/include/linux/migrate.h
@@ -75,8 +75,8 @@ bool isolate_movable_page(struct page *p
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
-void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
-				spinlock_t *ptl);
+void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
+		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 void folio_migrate_copy(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
--- a/include/linux/swapops.h~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/include/linux/swapops.h
@@ -332,15 +332,9 @@ static inline bool is_migration_entry_di
 	return false;
 }
 
-extern void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
-					spinlock_t *ptl);
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-#ifdef CONFIG_HUGETLB_PAGE
-extern void __migration_entry_wait_huge(struct vm_area_struct *vma,
-					pte_t *ptep, spinlock_t *ptl);
 extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
-#endif	/* CONFIG_HUGETLB_PAGE */
 #else  /* CONFIG_MIGRATION */
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
@@ -362,15 +356,10 @@ static inline int is_migration_entry(swp
 	return 0;
 }
 
-static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
-					spinlock_t *ptl) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-					 unsigned long address) { }
-#ifdef CONFIG_HUGETLB_PAGE
-static inline void __migration_entry_wait_huge(struct vm_area_struct *vma,
-					       pte_t *ptep, spinlock_t *ptl) { }
-static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
-#endif	/* CONFIG_HUGETLB_PAGE */
+					unsigned long address) { }
+static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
+					pte_t *pte) { }
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
--- a/mm/filemap.c~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/mm/filemap.c
@@ -1362,8 +1362,6 @@ repeat:
 /**
  * migration_entry_wait_on_locked - Wait for a migration entry to be removed
  * @entry: migration swap entry.
- * @ptep: mapped pte pointer. Will return with the ptep unmapped. Only required
- *        for pte entries, pass NULL for pmd entries.
  * @ptl: already locked ptl. This function will drop the lock.
  *
  * Wait for a migration entry referencing the given page to be removed. This is
@@ -1372,13 +1370,13 @@ repeat:
  * should be called while holding the ptl for the migration entry referencing
  * the page.
  *
- * Returns after unmapping and unlocking the pte/ptl with pte_unmap_unlock().
+ * Returns after unlocking the ptl.
  *
  * This follows the same logic as folio_wait_bit_common() so see the comments
  * there.
  */
-void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
-				spinlock_t *ptl)
+void migration_entry_wait_on_locked(swp_entry_t entry, spinlock_t *ptl)
+	__releases(ptl)
 {
 	struct wait_page_queue wait_page;
 	wait_queue_entry_t *wait = &wait_page.wait;
@@ -1412,10 +1410,7 @@ void migration_entry_wait_on_locked(swp_
 	 * a valid reference to the page, and it must take the ptl to remove the
 	 * migration entry. So the page is valid until the ptl is dropped.
 	 */
-	if (ptep)
-		pte_unmap_unlock(ptep, ptl);
-	else
-		spin_unlock(ptl);
+	spin_unlock(ptl);
 
 	for (;;) {
 		unsigned int flags;
--- a/mm/migrate.c~mm-migrate-remove-cruft-from-migration_entry_waits
+++ a/mm/migrate.c
@@ -296,14 +296,18 @@ void remove_migration_ptes(struct folio
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
  */
-void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
-				spinlock_t *ptl)
+void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
+			  unsigned long address)
 {
+	spinlock_t *ptl;
+	pte_t *ptep;
 	pte_t pte;
 	swp_entry_t entry;
 
-	spin_lock(ptl);
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	pte = *ptep;
+	pte_unmap(ptep);
+
 	if (!is_swap_pte(pte))
 		goto out;
 
@@ -311,18 +315,10 @@ void __migration_entry_wait(struct mm_st
 	if (!is_migration_entry(entry))
 		goto out;
 
-	migration_entry_wait_on_locked(entry, ptep, ptl);
+	migration_entry_wait_on_locked(entry, ptl);
 	return;
 out:
-	pte_unmap_unlock(ptep, ptl);
-}
-
-void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
-{
-	spinlock_t *ptl = pte_lockptr(mm, pmd);
-	pte_t *ptep = pte_offset_map(pmd, address);
-	__migration_entry_wait(mm, ptep, ptl);
+	spin_unlock(ptl);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -332,9 +328,9 @@ void migration_entry_wait(struct mm_stru
  *
  * This function will release the vma lock before returning.
  */
-void __migration_entry_wait_huge(struct vm_area_struct *vma,
-				 pte_t *ptep, spinlock_t *ptl)
+void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *ptep)
 {
+	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, ptep);
 	pte_t pte;
 
 	hugetlb_vma_assert_locked(vma);
@@ -352,16 +348,9 @@ void __migration_entry_wait_huge(struct
 		 * lock release in migration_entry_wait_on_locked().
 		 */
 		hugetlb_vma_unlock_read(vma);
-		migration_entry_wait_on_locked(pte_to_swp_entry(pte), NULL, ptl);
+		migration_entry_wait_on_locked(pte_to_swp_entry(pte), ptl);
 	}
 }
-
-void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte)
-{
-	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, pte);
-
-	__migration_entry_wait_huge(vma, pte, ptl);
-}
 #endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
@@ -372,7 +361,7 @@ void pmd_migration_entry_wait(struct mm_
 	ptl = pmd_lock(mm, pmd);
 	if (!is_pmd_migration_entry(*pmd))
 		goto unlock;
-	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), NULL, ptl);
+	migration_entry_wait_on_locked(pmd_to_swp_entry(*pmd), ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
_

Patches currently in -mm which might be from hughd@google.com are


