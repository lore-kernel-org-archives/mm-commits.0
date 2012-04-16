From: akpm@linux-foundation.org
Subject: + hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:15:53 -0700
Message-ID: <20120416231553.43CC9A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:41817 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2DPXPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:15:55 -0400
Received: by wgbdt11 with SMTP id dt11so294693wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:15:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages
has been added to the -mm tree.  Its filename is
     hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages

Use an mmu_gather instead of a temporary linked list for accumulating
pages when we unmap a hugepage range.  This also allows us to get rid of
i_mmap_mutex unmap_hugepage_range in the following patch.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    4 +-
 include/linux/hugetlb.h |    6 +--
 mm/hugetlb.c            |   59 ++++++++++++++++++++++----------------
 mm/memory.c             |    7 +++-
 4 files changed, 45 insertions(+), 31 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages
+++ a/fs/hugetlbfs/inode.c
@@ -416,8 +416,8 @@ hugetlb_vmtruncate_list(struct prio_tree
 		else
 			v_offset = 0;
 
-		__unmap_hugepage_range(vma,
-				vma->vm_start + v_offset, vma->vm_end, NULL);
+		unmap_hugepage_range(vma, vma->vm_start + v_offset,
+				     vma->vm_end, NULL);
 	}
 }
 
diff -puN include/linux/hugetlb.h~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages
+++ a/include/linux/hugetlb.h
@@ -40,9 +40,9 @@ int follow_hugetlb_page(struct mm_struct
 			struct page **, struct vm_area_struct **,
 			unsigned long *, int *, int, unsigned int flags);
 void unmap_hugepage_range(struct vm_area_struct *,
-			unsigned long, unsigned long, struct page *);
-void __unmap_hugepage_range(struct vm_area_struct *,
-			unsigned long, unsigned long, struct page *);
+			  unsigned long, unsigned long, struct page *);
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *,
+			    unsigned long, unsigned long, struct page *);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
diff -puN mm/hugetlb.c~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages
+++ a/mm/hugetlb.c
@@ -24,8 +24,9 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <linux/io.h>
+#include <asm/tlb.h>
 
+#include <linux/io.h>
 #include <linux/hugetlb.h>
 #include <linux/node.h>
 #include "internal.h"
@@ -2301,30 +2302,26 @@ static int is_hugetlb_entry_hwpoisoned(p
 		return 0;
 }
 
-void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			    unsigned long end, struct page *ref_page)
+void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			    unsigned long start, unsigned long end,
+			    struct page *ref_page)
 {
+	int force_flush = 0;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
 	pte_t *ptep;
 	pte_t pte;
 	struct page *page;
-	struct page *tmp;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 
-	/*
-	 * A page gathering list, protected by per file i_mmap_mutex. The
-	 * lock is used to avoid list corruption from multiple unmapping
-	 * of the same page since we are using page->lru.
-	 */
-	LIST_HEAD(page_list);
-
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
+	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, start, end);
+again:
 	spin_lock(&mm->page_table_lock);
 	for (address = start; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
@@ -2363,30 +2360,45 @@ void __unmap_hugepage_range(struct vm_ar
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
+		tlb_remove_tlb_entry(tlb, ptep, address);
 		if (pte_dirty(pte))
 			set_page_dirty(page);
-		list_add(&page->lru, &page_list);
 
+		page_remove_rmap(page);
+		force_flush = !__tlb_remove_page(tlb, page);
+		if (force_flush)
+			break;
 		/* Bail out after unmapping reference page if supplied */
 		if (ref_page)
 			break;
 	}
-	flush_tlb_range(vma, start, end);
 	spin_unlock(&mm->page_table_lock);
-	mmu_notifier_invalidate_range_end(mm, start, end);
-	list_for_each_entry_safe(page, tmp, &page_list, lru) {
-		page_remove_rmap(page);
-		list_del(&page->lru);
-		put_page(page);
+	/*
+	 * mmu_gather ran out of room to batch pages, we break out of
+	 * the PTE lock to avoid doing the potential expensive TLB invalidate
+	 * and page-free while holding it.
+	 */
+	if (force_flush) {
+		force_flush = 0;
+		tlb_flush_mmu(tlb);
+		if (address < end && !ref_page)
+			goto again;
 	}
+	mmu_notifier_invalidate_range_end(mm, start, end);
+	tlb_end_vma(tlb, vma);
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page)
 {
-	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
-	__unmap_hugepage_range(vma, start, end, ref_page);
-	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	struct mm_struct *mm;
+	struct mmu_gather tlb;
+
+	mm = vma->vm_mm;
+
+	tlb_gather_mmu(&tlb, mm, 0);
+	__unmap_hugepage_range(&tlb, vma, start, end, ref_page);
+	tlb_finish_mmu(&tlb, start, end);
 }
 
 /*
@@ -2431,9 +2443,8 @@ static int unmap_ref_private(struct mm_s
 		 * from the time of fork. This would look like data corruption
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
-			__unmap_hugepage_range(iter_vma,
-				address, address + huge_page_size(h),
-				page);
+			unmap_hugepage_range(iter_vma, address,
+					     address + huge_page_size(h), page);
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
 
diff -puN mm/memory.c~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages mm/memory.c
--- a/mm/memory.c~hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages
+++ a/mm/memory.c
@@ -1329,8 +1329,11 @@ static void unmap_single_vma(struct mmu_
 			 * Since no pte has actually been setup, it is
 			 * safe to do nothing in this case.
 			 */
-			if (vma->vm_file)
-				unmap_hugepage_range(vma, start, end, NULL);
+			if (vma->vm_file) {
+				mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
+				__unmap_hugepage_range(tlb, vma, start, end, NULL);
+				mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
 	}
_
Subject: Subject: hugetlb: use mmu_gather instead of a temporary linked list for accumulating pages

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

