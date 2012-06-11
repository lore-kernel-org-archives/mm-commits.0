From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:37 -0700
Message-ID: <20120611210937.57A2EA0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50329 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2FKVJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:39 -0400
Received: by were53 with SMTP id e53so251327wer.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2
has been removed from the -mm tree.  Its filename was
     hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2

Further cleanup of the above patch

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2
+++ a/include/linux/hugetlb.h
@@ -100,7 +100,6 @@ static inline unsigned long hugetlb_tota
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
-#define unmap_hugepage_range(vma, start, end, page)	BUG()
 static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
@@ -114,7 +113,11 @@ static inline void hugetlb_report_meminf
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
 #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
 #define huge_pte_offset(mm, address)	0
-#define dequeue_hwpoisoned_huge_page(page)	0
+static inline int dequeue_hwpoisoned_huge_page(struct page *page)
+{
+	return 0;
+}
+
 static inline void copy_huge_page(struct page *dst, struct page *src)
 {
 }
@@ -125,6 +128,7 @@ static inline void __unmap_hugepage_rang
 			struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, struct page *ref_page)
 {
+	BUG();
 }
 
 #endif /* !CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

