From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
 added to -mm tree
Date: Thu, 18 Sep 2014 16:02:07 -0700
Message-ID: <541b646f.Ack1lTV+fuxn2hNa%akpm__40216.9112036519$1411081343$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIRXCI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 19:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, hughd@google.com, james.hogan@imgtec.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix getting refcount 0 page in hugetlb_fault()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: fix getting refcount 0 page in hugetlb_fault()

When running the test which causes the race as shown in the previous
patch, we can hit the BUG "get_page() on refcount 0 page" in
hugetlb_fault().

This race happens when pte turns into migration entry just after the first
check of is_hugetlb_entry_migration() in hugetlb_fault() passed with
false.  To fix this, we need to check pte_present() again after
huge_ptep_get().

This patch also reorders taking ptl and doing pte_page(), because
pte_page() should be done in ptl.  Due to this reordering, we need use
trylock_page() in page != pagecache_page case to respect locking order.

Fixes: 66aebce747ea ("hugetlb: fix race condition in hugetlb_fault()")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -3128,6 +3128,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	struct page *pagecache_page = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
+	int need_wait_lock = 0;
 
 	address &= huge_page_mask(h);
 
@@ -3164,6 +3165,15 @@ int hugetlb_fault(struct mm_struct *mm,
 	}
 
 	ret = 0;
+	/*
+	 * entry could be a migration/hwpoison entry at this point, so this
+	 * check prevents the kernel from going below assuming that we have
+	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
+	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
+	 * handle it.
+	 */
+	if (!pte_present(entry))
+		goto out_mutex;
 
 	/*
 	 * If we are going to COW the mapping later, we examine the pending
@@ -3184,6 +3194,12 @@ int hugetlb_fault(struct mm_struct *mm,
 								vma, address);
 	}
 
+	ptl = huge_pte_lock(h, mm, ptep);
+
+	/* Check for a racing update before calling hugetlb_cow */
+	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
+		goto out_ptl;
+
 	/*
 	 * hugetlb_cow() requires page locks of pte_page(entry) and
 	 * pagecache_page, so here we need take the former one
@@ -3192,22 +3208,19 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
-	get_page(page);
 	if (page != pagecache_page)
-		lock_page(page);
-
-	ptl = huge_pte_lockptr(h, mm, ptep);
-	spin_lock(ptl);
-	/* Check for a racing update before calling hugetlb_cow */
-	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
-		goto out_ptl;
+		if (!trylock_page(page)) {
+			need_wait_lock = 1;
+			goto out_ptl;
+		}
 
+	get_page(page);
 
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
 					pagecache_page, ptl);
-			goto out_ptl;
+			goto out_put_page;
 		}
 		entry = huge_pte_mkdirty(entry);
 	}
@@ -3215,7 +3228,10 @@ int hugetlb_fault(struct mm_struct *mm,
 	if (huge_ptep_set_access_flags(vma, address, ptep, entry,
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, address, ptep);
-
+out_put_page:
+	if (page != pagecache_page)
+		unlock_page(page);
+	put_page(page);
 out_ptl:
 	spin_unlock(ptl);
 
@@ -3223,12 +3239,10 @@ out_ptl:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	if (page != pagecache_page)
-		unlock_page(page);
-	put_page(page);
-
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	if (need_wait_lock)
+		wait_on_page_locked(page);
 	return ret;
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-softdirty-addresses-before-vmas-in-pte-holes-arent-softdirty.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirty-cleared.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

