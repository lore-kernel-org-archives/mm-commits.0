Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC22C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 20:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiB1Uco (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiB1Uch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 15:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362FB9FDD
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 12:31:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1B53B8164E
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 20:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD86C340F1;
        Mon, 28 Feb 2022 20:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646080314;
        bh=w+EM/aR5HVSdkN1YKQMIsPOzLJKtaqj3sVL5O+M+tT8=;
        h=Date:To:From:Subject:From;
        b=rAtyIK3Qd98XwlC9kDsWZ9wsbB44B+7aI3Fum56BLZ2BqOnIQkoGR548fM08Lf6x6
         dSMli1LS63BraaBm5gTWNtIWynOCcNl6QVC6yyzpirdtl93924HUnntnsoVvuGzqR/
         ijiC+CokJOjzqxKP+E4HW/gS3LwBDkOXuuSIayUU=
Date:   Mon, 28 Feb 2022 12:31:53 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@infradead.org, duanxiongchun@bytedance.com,
        dan.j.williams@intel.com, apopple@nvidia.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-range-parameter-from-follow_invalidate_pte.patch added to -mm tree
Message-Id: <20220228203154.8FD86C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove range parameter from follow_invalidate_pte()
has been added to the -mm tree.  Its filename is
     mm-remove-range-parameter-from-follow_invalidate_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-range-parameter-from-follow_invalidate_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-range-parameter-from-follow_invalidate_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: remove range parameter from follow_invalidate_pte()

The only user (DAX) of range parameter of follow_invalidate_pte() is gone,
it safe to remove the range paramter and make it static to simlify the
code.

Link: https://lkml.kernel.org/r/20220228063536.24911-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ---
 mm/memory.c        |   23 +++--------------------
 2 files changed, 3 insertions(+), 23 deletions(-)

--- a/include/linux/mm.h~mm-remove-range-parameter-from-follow_invalidate_pte
+++ a/include/linux/mm.h
@@ -1850,9 +1850,6 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
--- a/mm/memory.c~mm-remove-range-parameter-from-follow_invalidate_pte
+++ a/mm/memory.c
@@ -4890,9 +4890,8 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp)
+static int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
+				 pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4919,31 +4918,17 @@ int follow_invalidate_pte(struct mm_stru
 		if (!pmdpp)
 			goto out;
 
-		if (range) {
-			mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0,
-						NULL, mm, address & PMD_MASK,
-						(address & PMD_MASK) + PMD_SIZE);
-			mmu_notifier_invalidate_range_start(range);
-		}
 		*ptlp = pmd_lock(mm, pmd);
 		if (pmd_huge(*pmd)) {
 			*pmdpp = pmd;
 			return 0;
 		}
 		spin_unlock(*ptlp);
-		if (range)
-			mmu_notifier_invalidate_range_end(range);
 	}
 
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
 
-	if (range) {
-		mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
-					address & PAGE_MASK,
-					(address & PAGE_MASK) + PAGE_SIZE);
-		mmu_notifier_invalidate_range_start(range);
-	}
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
 	if (!pte_present(*ptep))
 		goto unlock;
@@ -4951,8 +4936,6 @@ int follow_invalidate_pte(struct mm_stru
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, *ptlp);
-	if (range)
-		mmu_notifier_invalidate_range_end(range);
 out:
 	return -EINVAL;
 }
@@ -4981,7 +4964,7 @@ out:
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp)
 {
-	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
+	return follow_invalidate_pte(mm, address, ptepp, NULL, ptlp);
 }
 EXPORT_SYMBOL_GPL(follow_pte);
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch
mm-introduce-kmem_cache_alloc_lru.patch
fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
fs-allocate-inode-by-using-alloc_inode_sb.patch
f2fs-allocate-inode-by-using-alloc_inode_sb.patch
mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch
xarray-use-kmem_cache_alloc_lru-to-allocate-xa_node.patch
mm-memcontrol-move-memcg_online_kmem-to-mem_cgroup_css_online.patch
mm-list_lru-allocate-list_lru_one-only-when-needed.patch
mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus.patch
mm-list_lru-replace-linear-array-with-xarray.patch
mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id.patch
mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch
mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id.patch
mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-remove-range-parameter-from-follow_invalidate_pte.patch

