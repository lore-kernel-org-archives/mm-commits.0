From: akpm@linux-foundation.org
Subject: [merged] mm-make-faultaround-produce-old-ptes.patch removed from
 -mm tree
Date: Mon, 23 May 2016 12:46:52 -0700
Message-ID: <57435e2c.iZOg2jY/Q4g1gOF3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbcEWTqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, vinmenon@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make faultaround produce old ptes
has been removed from the -mm tree.  Its filename was
     mm-make-faultaround-produce-old-ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: make faultaround produce old ptes

Currently, faultaround code produces young pte.  This can screw up vmscan
behaviour[1], as it makes vmscan think that these pages are hot and not
push them out on first round.

During sparse file access faultaround gets more pages mapped and all of
them are young.  Under memory pressure, this makes vmscan swap out anon
pages instead, or to drop other page cache pages which otherwise stay
resident.

Modify faultaround to produce old ptes, so they can easily be reclaimed
under memory pressure.

This can to some extend defeat the purpose of faultaround on machines
without hardware accessed bit as it will not help us with reducing the
number of minor page faults.

We may want to disable faultaround on such machines altogether, but that's
subject for separate patchset.

Minchan:

I tested 512M mmap sequential word read test on non-HW access bit system
(i.e., ARM) and confirmed it doesn't increase minor fault any more.

old: 4096 fault_around
minor fault: 131291
elapsed time: 6747645 usec

new: 65536 fault_around
minor fault: 131291
elapsed time: 6709263 usec

0.56% benefit


[1] https://lkml.kernel.org/r/1460992636-711-1-git-send-email-vinmenon@codeaurora.org

Link: http://lkml.kernel.org/r/1463488366-47723-1-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/filemap.c       |    2 +-
 mm/memory.c        |   23 ++++++++++++++++++-----
 3 files changed, 20 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-make-faultaround-produce-old-ptes include/linux/mm.h
--- a/include/linux/mm.h~mm-make-faultaround-produce-old-ptes
+++ a/include/linux/mm.h
@@ -596,7 +596,7 @@ static inline pte_t maybe_mkwrite(pte_t
 }
 
 void do_set_pte(struct vm_area_struct *vma, unsigned long address,
-		struct page *page, pte_t *pte, bool write, bool anon);
+		struct page *page, pte_t *pte, bool write, bool anon, bool old);
 #endif
 
 /*
diff -puN mm/filemap.c~mm-make-faultaround-produce-old-ptes mm/filemap.c
--- a/mm/filemap.c~mm-make-faultaround-produce-old-ptes
+++ a/mm/filemap.c
@@ -2191,7 +2191,7 @@ repeat:
 		if (file->f_ra.mmap_miss > 0)
 			file->f_ra.mmap_miss--;
 		addr = address + (page->index - vmf->pgoff) * PAGE_SIZE;
-		do_set_pte(vma, addr, page, pte, false, false);
+		do_set_pte(vma, addr, page, pte, false, false, true);
 		unlock_page(page);
 		goto next;
 unlock:
diff -puN mm/memory.c~mm-make-faultaround-produce-old-ptes mm/memory.c
--- a/mm/memory.c~mm-make-faultaround-produce-old-ptes
+++ a/mm/memory.c
@@ -2876,7 +2876,7 @@ static int __do_fault(struct vm_area_str
  * vm_ops->map_pages.
  */
 void do_set_pte(struct vm_area_struct *vma, unsigned long address,
-		struct page *page, pte_t *pte, bool write, bool anon)
+		struct page *page, pte_t *pte, bool write, bool anon, bool old)
 {
 	pte_t entry;
 
@@ -2884,6 +2884,8 @@ void do_set_pte(struct vm_area_struct *v
 	entry = mk_pte(page, vma->vm_page_prot);
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	if (old)
+		entry = pte_mkold(entry);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, address, false);
@@ -3021,9 +3023,20 @@ static int do_read_fault(struct mm_struc
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
 			goto unlock_out;
+		do_fault_around(vma, address, pte, pgoff, flags);
+		/* Check if the fault is handled by faultaround */
+		if (!pte_same(*pte, orig_pte)) {
+			/*
+			 * Faultaround produce old pte, but the pte we've
+			 * handler fault for should be young.
+			 */
+			pte_t entry = pte_mkyoung(*pte);
+			if (ptep_set_access_flags(vma, address, pte, entry, 0))
+				update_mmu_cache(vma, address, pte);
+			goto unlock_out;
+		}
 		pte_unmap_unlock(pte, ptl);
 	}
 
@@ -3038,7 +3051,7 @@ static int do_read_fault(struct mm_struc
 		put_page(fault_page);
 		return ret;
 	}
-	do_set_pte(vma, address, fault_page, pte, false, false);
+	do_set_pte(vma, address, fault_page, pte, false, false, false);
 	unlock_page(fault_page);
 unlock_out:
 	pte_unmap_unlock(pte, ptl);
@@ -3090,7 +3103,7 @@ static int do_cow_fault(struct mm_struct
 		}
 		goto uncharge_out;
 	}
-	do_set_pte(vma, address, new_page, pte, true, true);
+	do_set_pte(vma, address, new_page, pte, true, true, false);
 	mem_cgroup_commit_charge(new_page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pte_unmap_unlock(pte, ptl);
@@ -3147,7 +3160,7 @@ static int do_shared_fault(struct mm_str
 		put_page(fault_page);
 		return ret;
 	}
-	do_set_pte(vma, address, fault_page, pte, true, false);
+	do_set_pte(vma, address, fault_page, pte, true, false, false);
 	pte_unmap_unlock(pte, ptl);
 
 	if (set_page_dirty(fault_page))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

