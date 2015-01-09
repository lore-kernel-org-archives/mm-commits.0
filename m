From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
 added to -mm tree
Date: Fri, 09 Jan 2015 14:39:12 -0800
Message-ID: <54b05890.BRkMsDCVxxZC8O2v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAIWjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:39:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, steve.capper@linaro.org, mm-commits@vger.kernel.org


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

When running the test which causes the race as shown in the previous patch,
we can hit the BUG "get_page() on refcount 0 page" in hugetlb_fault().

This race happens when pte turns into migration entry just after the first
check of is_hugetlb_entry_migration() in hugetlb_fault() passed with false.
To fix this, we need to check pte_present() again after huge_ptep_get().

This patch also reorders taking ptl and doing pte_page(), because
pte_page() should be done in ptl.  Due to this reordering, we need use
trylock_page() in page != pagecache_page case to respect locking order.

Fixes: 66aebce747ea ("hugetlb: fix race condition in hugetlb_fault()")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: <stable@vger.kernel.org>	[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   52 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -3134,6 +3134,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	struct page *pagecache_page = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
+	int need_wait_lock = 0;
 
 	address &= huge_page_mask(h);
 
@@ -3172,6 +3173,16 @@ int hugetlb_fault(struct mm_struct *mm,
 	ret = 0;
 
 	/*
+	 * entry could be a migration/hwpoison entry at this point, so this
+	 * check prevents the kernel from going below assuming that we have
+	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
+	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
+	 * handle it.
+	 */
+	if (!pte_present(entry))
+		goto out_mutex;
+
+	/*
 	 * If we are going to COW the mapping later, we examine the pending
 	 * reservations for this page now. This will ensure that any
 	 * allocations necessary to record that reservation occur outside the
@@ -3190,30 +3201,31 @@ int hugetlb_fault(struct mm_struct *mm,
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
 	 * when page != pagecache_page or !pagecache_page.
-	 * Note that locking order is always pagecache_page -> page,
-	 * so no worry about deadlock.
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
@@ -3221,7 +3233,10 @@ int hugetlb_fault(struct mm_struct *mm,
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
 
@@ -3229,12 +3244,17 @@ out_ptl:
 		unlock_page(pagecache_page);
 		put_page(pagecache_page);
 	}
-	if (page != pagecache_page)
-		unlock_page(page);
-	put_page(page);
-
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	/*
+	 * Generally it's safe to hold refcount during waiting page lock. But
+	 * here we just wait to defer the next page fault to avoid busy loop and
+	 * the page is not used after unlocked before returning from the current
+	 * page fault. So we are safe from accessing freed page, even if we wait
+	 * here without taking refcount.
+	 */
+	if (need_wait_lock)
+		wait_on_page_locked(page);
 	return ret;
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

