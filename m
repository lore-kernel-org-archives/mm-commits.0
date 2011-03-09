From: akpm@linux-foundation.org
Subject: + thp-fix-page_referenced-to-modify-mapcount-vm_flags-only-if-page-is-found.patch added to -mm tree
Date: Wed, 09 Mar 2011 15:11:07 -0800
Message-ID: <201103092311.p29NB70X001099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab1CIXL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 18:11:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, walken@google.com


The patch titled
     thp: fix page_referenced to modify mapcount/vm_flags only if page is found
has been added to the -mm tree.  Its filename is
     thp-fix-page_referenced-to-modify-mapcount-vm_flags-only-if-page-is-found.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix page_referenced to modify mapcount/vm_flags only if page is found
From: Andrea Arcangeli <aarcange@redhat.com>

When vmscan.c calls page_referenced(), if an anon page was created before
a process forked, rmap will search for it in both of the processes, even
though one of them might have since broken COW.  If the child process
mlocks the vma where the COWed page belongs to, page_referenced() running
on the page mapped by the parent would lead to *vm_flags getting VM_LOCKED
set erroneously (leading to the references on the parent page being
ignored and evicting the parent page too early).

*mapcount would also be decremented by page_referenced_one even if the
page wasn't found by page_check_address.

This also lets pmdp_clear_flush_young_notify() go ahead on a
pmd_trans_splitting() pmd.  We hold the page_table_lock so
__split_huge_page_map() must wait the pmdp_clear_flush_young_notify() to
complete before it can modify the pmd.  The pmd is also still mapped in
userland so the young bit may materialize through a tlb miss before
split_huge_page_map runs.  This will provide a more accurate
page_referenced() behavior during split_huge_page().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel<riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   54 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff -puN mm/rmap.c~thp-fix-page_referenced-to-modify-mapcount-vm_flags-only-if-page-is-found mm/rmap.c
--- a/mm/rmap.c~thp-fix-page_referenced-to-modify-mapcount-vm_flags-only-if-page-is-found
+++ a/mm/rmap.c
@@ -497,41 +497,51 @@ int page_referenced_one(struct page *pag
 	struct mm_struct *mm = vma->vm_mm;
 	int referenced = 0;
 
-	/*
-	 * Don't want to elevate referenced for mlocked page that gets this far,
-	 * in order that it progresses to try_to_unmap and is moved to the
-	 * unevictable list.
-	 */
-	if (vma->vm_flags & VM_LOCKED) {
-		*mapcount = 0;	/* break early from loop */
-		*vm_flags |= VM_LOCKED;
-		goto out;
-	}
-
-	/* Pretend the page is referenced if the task has the
-	   swap token and is in the middle of a page fault. */
-	if (mm != current->mm && has_swap_token(mm) &&
-			rwsem_is_locked(&mm->mmap_sem))
-		referenced++;
-
 	if (unlikely(PageTransHuge(page))) {
 		pmd_t *pmd;
 
 		spin_lock(&mm->page_table_lock);
+		/*
+		 * rmap might return false positives; we must filter
+		 * these out using page_check_address_pmd().
+		 */
 		pmd = page_check_address_pmd(page, mm, address,
 					     PAGE_CHECK_ADDRESS_PMD_FLAG);
-		if (pmd && !pmd_trans_splitting(*pmd) &&
-		    pmdp_clear_flush_young_notify(vma, address, pmd))
+		if (!pmd) {
+			spin_unlock(&mm->page_table_lock);
+			goto out;
+		}
+
+		if (vma->vm_flags & VM_LOCKED) {
+			spin_unlock(&mm->page_table_lock);
+			*mapcount = 0;	/* break early from loop */
+			*vm_flags |= VM_LOCKED;
+			goto out;
+		}
+
+		/* go ahead even if the pmd is pmd_trans_splitting() */
+		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
 		spin_unlock(&mm->page_table_lock);
 	} else {
 		pte_t *pte;
 		spinlock_t *ptl;
 
+		/*
+		 * rmap might return false positives; we must filter
+		 * these out using page_check_address().
+		 */
 		pte = page_check_address(page, mm, address, &ptl, 0);
 		if (!pte)
 			goto out;
 
+		if (vma->vm_flags & VM_LOCKED) {
+			pte_unmap_unlock(pte, ptl);
+			*mapcount = 0;	/* break early from loop */
+			*vm_flags |= VM_LOCKED;
+			goto out;
+		}
+
 		if (ptep_clear_flush_young_notify(vma, address, pte)) {
 			/*
 			 * Don't treat a reference through a sequentially read
@@ -546,6 +556,12 @@ int page_referenced_one(struct page *pag
 		pte_unmap_unlock(pte, ptl);
 	}
 
+	/* Pretend the page is referenced if the task has the
+	   swap token and is in the middle of a page fault. */
+	if (mm != current->mm && has_swap_token(mm) &&
+			rwsem_is_locked(&mm->mmap_sem))
+		referenced++;
+
 	(*mapcount)--;
 
 	if (referenced)
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-fix-page_referenced-to-modify-mapcount-vm_flags-only-if-page-is-found.patch
x86-fix-pgd_lock-deadlock.patch
mm-compaction-prevent-kswapd-compacting-memory-to-reduce-cpu-usage.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-add-vm-counters-for-transparent-hugepages.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch

