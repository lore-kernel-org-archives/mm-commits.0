From: akpm@linux-foundation.org
Subject: [merged] mm-drop-zap_details-check_swap_entries.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:17:28 -0800
Message-ID: <58af5168.YfdlD1tlwV6DPHyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41636 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdBWVRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop zap_details::check_swap_entries
has been removed from the -mm tree.  Its filename was
     mm-drop-zap_details-check_swap_entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop zap_details::check_swap_entries

detail == NULL would give the same functionality as
.check_swap_entries==true.

Link: http://lkml.kernel.org/r/20170118122429.43661-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/memory.c        |    4 ++--
 mm/oom_kill.c      |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-drop-zap_details-check_swap_entries include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-zap_details-check_swap_entries
+++ a/include/linux/mm.h
@@ -1175,7 +1175,6 @@ struct zap_details {
 	struct address_space *check_mapping;	/* Check page->mapping if set */
 	pgoff_t	first_index;			/* Lowest page->index to unmap */
 	pgoff_t last_index;			/* Highest page->index to unmap */
-	bool check_swap_entries;		/* Check also swap entries */
 };
 
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
diff -puN mm/memory.c~mm-drop-zap_details-check_swap_entries mm/memory.c
--- a/mm/memory.c~mm-drop-zap_details-check_swap_entries
+++ a/mm/memory.c
@@ -1173,8 +1173,8 @@ again:
 			}
 			continue;
 		}
-		/* only check swap_entries if explicitly asked for in details */
-		if (unlikely(details && !details->check_swap_entries))
+		/* If details->check_mapping, we leave swap entries. */
+		if (unlikely(details))
 			continue;
 
 		entry = pte_to_swp_entry(ptent);
diff -puN mm/oom_kill.c~mm-drop-zap_details-check_swap_entries mm/oom_kill.c
--- a/mm/oom_kill.c~mm-drop-zap_details-check_swap_entries
+++ a/mm/oom_kill.c
@@ -465,7 +465,6 @@ static bool __oom_reap_task_mm(struct ta
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
-	struct zap_details details = {.check_swap_entries = true};
 	bool ret = true;
 
 	/*
@@ -531,7 +530,7 @@ static bool __oom_reap_task_mm(struct ta
 		 */
 		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED))
 			unmap_page_range(&tlb, vma, vma->vm_start, vma->vm_end,
-					 &details);
+					 NULL);
 	}
 	tlb_finish_mmu(&tlb, 0, -1);
 	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

