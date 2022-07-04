Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF17C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiGDBJg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiGDBJc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0186274
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 888C5B80CEE
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387BEC341C6;
        Mon,  4 Jul 2022 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896968;
        bh=2cb6xnkDqqrh6Syl2KE910kaow83kAP4npi6BV/AOFU=;
        h=Date:To:From:Subject:From;
        b=s8AeBet13dH7bHRkByNQmHexngrL8p+uZVfR/lWr0zmqQEp1Tkixov4eCELFJfu24
         dXaJGfXFtmUkqOQGVbjJ7xDJuKAIndM5XXFV015X2n60UiXX5GxLCBOIeKplyRn2ze
         slmhDou4lSlXij2g7qiECRSiVxbwlw3wmUIA+2qU=
Date:   Sun, 03 Jul 2022 18:09:27 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, peterx@redhat.com, osalvador@suse.de,
        mike.kravetz@oracle.com, lkp@intel.com, hch@lst.de,
        dhowells@redhat.com, david@redhat.com, cl@linux.com,
        apopple@nvidia.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch removed from -mm tree
Message-Id: <20220704010928.387BEC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migration: fix potential pte_unmap on an not mapped pte
has been removed from the -mm tree.  Its filename was
     mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migration: fix potential pte_unmap on an not mapped pte
Date: Mon, 30 May 2022 19:30:16 +0800

__migration_entry_wait and migration_entry_wait_on_locked assume pte is
always mapped from caller.  But this is not the case when it's called from
migration_entry_wait_huge and follow_huge_pmd.  Add a hugetlbfs variant
that calls hugetlb_migration_entry_wait(ptep == NULL) to fix this issue.

Link: https://lkml.kernel.org/r/20220530113016.16663-5-linmiaohe@huawei.com
Fixes: 30dad30922cc ("mm: migration: add migrate_entry_wait_huge()")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   12 ++++++++----
 mm/hugetlb.c            |    4 ++--
 mm/migrate.c            |   23 +++++++++++++++++++----
 3 files changed, 29 insertions(+), 10 deletions(-)

--- a/include/linux/swapops.h~mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/include/linux/swapops.h
@@ -244,8 +244,10 @@ extern void __migration_entry_wait(struc
 					spinlock_t *ptl);
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-extern void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte);
+#ifdef CONFIG_HUGETLB_PAGE
+extern void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl);
+extern void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte);
+#endif
 #else
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
@@ -271,8 +273,10 @@ static inline void __migration_entry_wai
 					spinlock_t *ptl) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
-static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte) { }
+#ifdef CONFIG_HUGETLB_PAGE
+static inline void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl) { }
+static inline void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte) { }
+#endif
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
--- a/mm/hugetlb.c~mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/mm/hugetlb.c
@@ -5702,7 +5702,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 */
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, mm, ptep);
+			migration_entry_wait_huge(vma, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
@@ -6927,7 +6927,7 @@ retry:
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+			__migration_entry_wait_huge((pte_t *)pmd, ptl);
 			goto retry;
 		}
 		/*
--- a/mm/migrate.c~mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte
+++ a/mm/migrate.c
@@ -315,12 +315,27 @@ void migration_entry_wait(struct mm_stru
 	__migration_entry_wait(mm, ptep, ptl);
 }
 
-void migration_entry_wait_huge(struct vm_area_struct *vma,
-		struct mm_struct *mm, pte_t *pte)
+#ifdef CONFIG_HUGETLB_PAGE
+void __migration_entry_wait_huge(pte_t *ptep, spinlock_t *ptl)
 {
-	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), mm, pte);
-	__migration_entry_wait(mm, pte, ptl);
+	pte_t pte;
+
+	spin_lock(ptl);
+	pte = huge_ptep_get(ptep);
+
+	if (unlikely(!is_hugetlb_entry_migration(pte)))
+		spin_unlock(ptl);
+	else
+		migration_entry_wait_on_locked(pte_to_swp_entry(pte), NULL, ptl);
+}
+
+void migration_entry_wait_huge(struct vm_area_struct *vma, pte_t *pte)
+{
+	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, pte);
+
+	__migration_entry_wait_huge(pte, ptl);
 }
+#endif
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

