From: akpm@linux-foundation.org
Subject: [patch 26/41] Revert "mm: make faultaround produce old ptes"
Date: Fri, 24 Jun 2016 14:49:45 -0700
Message-ID: <576daaf9.y3hsHyG/a6HQZ2oD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbcFXVtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, vinmenon@codeaurora.org, ying.huang@intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Revert "mm: make faultaround produce old ptes"

This reverts commit 5c0a85fad949212b3e059692deecdeed74ae7ec7.

The commit causes ~6% regression in unixbench.

Let's revert it for now and consider other solution for reclaim problem
later.

Link: http://lkml.kernel.org/r/1465893750-44080-2-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/filemap.c       |    2 +-
 mm/memory.c        |   23 +++++------------------
 3 files changed, 7 insertions(+), 20 deletions(-)

diff -puN include/linux/mm.h~revert-mm-make-faultaround-produce-old-ptes include/linux/mm.h
--- a/include/linux/mm.h~revert-mm-make-faultaround-produce-old-ptes
+++ a/include/linux/mm.h
@@ -602,7 +602,7 @@ static inline pte_t maybe_mkwrite(pte_t
 }
 
 void do_set_pte(struct vm_area_struct *vma, unsigned long address,
-		struct page *page, pte_t *pte, bool write, bool anon, bool old);
+		struct page *page, pte_t *pte, bool write, bool anon);
 #endif
 
 /*
diff -puN mm/filemap.c~revert-mm-make-faultaround-produce-old-ptes mm/filemap.c
--- a/mm/filemap.c~revert-mm-make-faultaround-produce-old-ptes
+++ a/mm/filemap.c
@@ -2186,7 +2186,7 @@ repeat:
 		if (file->f_ra.mmap_miss > 0)
 			file->f_ra.mmap_miss--;
 		addr = address + (page->index - vmf->pgoff) * PAGE_SIZE;
-		do_set_pte(vma, addr, page, pte, false, false, true);
+		do_set_pte(vma, addr, page, pte, false, false);
 		unlock_page(page);
 		goto next;
 unlock:
diff -puN mm/memory.c~revert-mm-make-faultaround-produce-old-ptes mm/memory.c
--- a/mm/memory.c~revert-mm-make-faultaround-produce-old-ptes
+++ a/mm/memory.c
@@ -2877,7 +2877,7 @@ static int __do_fault(struct vm_area_str
  * vm_ops->map_pages.
  */
 void do_set_pte(struct vm_area_struct *vma, unsigned long address,
-		struct page *page, pte_t *pte, bool write, bool anon, bool old)
+		struct page *page, pte_t *pte, bool write, bool anon)
 {
 	pte_t entry;
 
@@ -2885,8 +2885,6 @@ void do_set_pte(struct vm_area_struct *v
 	entry = mk_pte(page, vma->vm_page_prot);
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	if (old)
-		entry = pte_mkold(entry);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, address, false);
@@ -3032,20 +3030,9 @@ static int do_read_fault(struct mm_struc
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-		if (!pte_same(*pte, orig_pte))
-			goto unlock_out;
 		do_fault_around(vma, address, pte, pgoff, flags);
-		/* Check if the fault is handled by faultaround */
-		if (!pte_same(*pte, orig_pte)) {
-			/*
-			 * Faultaround produce old pte, but the pte we've
-			 * handler fault for should be young.
-			 */
-			pte_t entry = pte_mkyoung(*pte);
-			if (ptep_set_access_flags(vma, address, pte, entry, 0))
-				update_mmu_cache(vma, address, pte);
+		if (!pte_same(*pte, orig_pte))
 			goto unlock_out;
-		}
 		pte_unmap_unlock(pte, ptl);
 	}
 
@@ -3060,7 +3047,7 @@ static int do_read_fault(struct mm_struc
 		put_page(fault_page);
 		return ret;
 	}
-	do_set_pte(vma, address, fault_page, pte, false, false, false);
+	do_set_pte(vma, address, fault_page, pte, false, false);
 	unlock_page(fault_page);
 unlock_out:
 	pte_unmap_unlock(pte, ptl);
@@ -3111,7 +3098,7 @@ static int do_cow_fault(struct mm_struct
 		}
 		goto uncharge_out;
 	}
-	do_set_pte(vma, address, new_page, pte, true, true, false);
+	do_set_pte(vma, address, new_page, pte, true, true);
 	mem_cgroup_commit_charge(new_page, memcg, false, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pte_unmap_unlock(pte, ptl);
@@ -3164,7 +3151,7 @@ static int do_shared_fault(struct mm_str
 		put_page(fault_page);
 		return ret;
 	}
-	do_set_pte(vma, address, fault_page, pte, true, false, false);
+	do_set_pte(vma, address, fault_page, pte, true, false);
 	pte_unmap_unlock(pte, ptl);
 
 	if (set_page_dirty(fault_page))
_
