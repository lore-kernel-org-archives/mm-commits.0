From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:36:33 -0700
Message-ID: <20120731233633.E9328A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54150 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2GaXgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:36:35 -0400
Received: by obbwc20 with SMTP id wc20so4820714obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:36:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mgorman@suse.de, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

This patch was dropped because it was folded into mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix

name the args, lazy.  And fix CONFIG_HUGETLBFS=n build

Cc: <stable@vger.kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix
+++ a/include/linux/hugetlb.h
@@ -49,8 +49,9 @@ int follow_hugetlb_page(struct mm_struct
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
-			  struct vm_area_struct *,
-			  unsigned long, unsigned long, struct page *);
+			  struct vm_area_struct *vma,
+			  unsigned long start, unsigned long end,
+			  struct page *ref_page);
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				unsigned long start, unsigned long end,
 				struct page *ref_page);
@@ -133,6 +134,13 @@ static inline void copy_huge_page(struct
 
 #define hugetlb_change_protection(vma, address, end, newprot)
 
+static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+			struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, struct page *ref_page)
+{
+	BUG();
+}
+
 static inline void __unmap_hugepage_range(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, struct page *ref_page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables.patch

