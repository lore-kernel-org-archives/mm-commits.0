From: akpm@linux-foundation.org
Subject: [merged] mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:10:30 -0700
Message-ID: <552eb7a6.fDRBmy1Vwr20g/Oi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbDOTKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raindel@mellanox.com, aarcange@redhat.com, ak@linux.intel.com, dave.hansen@intel.com, haggaie@mellanox.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, pfeiner@google.com, riel@redhat.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor do_wp_page - rewrite the unlock flow
has been removed from the -mm tree.  Its filename was
     mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shachar Raindel <raindel@mellanox.com>
Subject: mm: refactor do_wp_page - rewrite the unlock flow

When do_wp_page is ending, in several cases it needs to unlock the pages
and ptls it was accessing.

Currently, this logic was "called" by using a goto jump.  This makes
following the control flow of the function harder.  Readability was
further hampered by the unlock case containing large amount of logic
needed only in one of the 3 cases.

Using goto for cleanup is generally allowed.  However, moving the trivial
unlocking flows to the relevant call sites allow deeper refactoring in the
next patch.

Signed-off-by: Shachar Raindel <raindel@mellanox.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Haggai Eran <haggaie@mellanox.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Michel Lespinasse <walken@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN mm/memory.c~mm-refactor-do_wp_page-rewrite-the-unlock-flow mm/memory.c
--- a/mm/memory.c~mm-refactor-do_wp_page-rewrite-the-unlock-flow
+++ a/mm/memory.c
@@ -2066,7 +2066,7 @@ static int do_wp_page(struct mm_struct *
 {
 	struct page *old_page, *new_page = NULL;
 	pte_t entry;
-	int ret = 0;
+	int page_copied = 0;
 	unsigned long mmun_start = 0;	/* For mmu_notifiers */
 	unsigned long mmun_end = 0;	/* For mmu_notifiers */
 	struct mem_cgroup *memcg;
@@ -2101,7 +2101,9 @@ static int do_wp_page(struct mm_struct *
 							 &ptl);
 			if (!pte_same(*page_table, orig_pte)) {
 				unlock_page(old_page);
-				goto unlock;
+				pte_unmap_unlock(page_table, ptl);
+				page_cache_release(old_page);
+				return 0;
 			}
 			page_cache_release(old_page);
 		}
@@ -2148,7 +2150,9 @@ static int do_wp_page(struct mm_struct *
 							 &ptl);
 			if (!pte_same(*page_table, orig_pte)) {
 				unlock_page(old_page);
-				goto unlock;
+				pte_unmap_unlock(page_table, ptl);
+				page_cache_release(old_page);
+				return 0;
 			}
 			page_mkwrite = 1;
 		}
@@ -2246,29 +2250,28 @@ gotten:
 
 		/* Free the old page.. */
 		new_page = old_page;
-		ret |= VM_FAULT_WRITE;
+		page_copied = 1;
 	} else
 		mem_cgroup_cancel_charge(new_page, memcg);
 
 	if (new_page)
 		page_cache_release(new_page);
-unlock:
+
 	pte_unmap_unlock(page_table, ptl);
-	if (mmun_end > mmun_start)
-		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	if (old_page) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
 		 * keep the mlocked page.
 		 */
-		if ((ret & VM_FAULT_WRITE) && (vma->vm_flags & VM_LOCKED)) {
+		if (page_copied && (vma->vm_flags & VM_LOCKED)) {
 			lock_page(old_page);	/* LRU manipulation */
 			munlock_vma_page(old_page);
 			unlock_page(old_page);
 		}
 		page_cache_release(old_page);
 	}
-	return ret;
+	return page_copied ? VM_FAULT_WRITE : 0;
 oom_free_new:
 	page_cache_release(new_page);
 oom:
_

Patches currently in -mm which might be from raindel@mellanox.com are

origin.patch
linux-next.patch

