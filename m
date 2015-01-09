From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch added to
 -mm tree
Date: Fri, 09 Jan 2015 14:39:18 -0800
Message-ID: <54b05896.qEZFm0fGL1uK4vwY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAIWjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix suboptimal migration/hwpoisoned entry check
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch

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
Subject: mm/hugetlb: fix suboptimal migration/hwpoisoned entry check

Currently hugetlb_fault() checks at first whether pte of the faulted
address is a migration or hwpoisoned entry, which means that we call
huge_ptep_get() twice in single hugetlb_fault().  This is not optimized. 
The reason of this approach is that without checking at first,
huge_pte_alloc() can trigger BUG_ON() because pmd_huge() returned false
for non-present hugetlb entry.

With a previous patch in this series, pmd_huge() becomes to return true
for non-present entry, so we no longer need this dirty workaround.  Let's
move the checking code to the proper place.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check
+++ a/mm/hugetlb.c
@@ -3136,20 +3136,10 @@ int hugetlb_fault(struct mm_struct *mm,
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
+	int need_wait_migration = 0;
 
 	address &= huge_page_mask(h);
 
-	ptep = huge_pte_offset(mm, address);
-	if (ptep) {
-		entry = huge_ptep_get(ptep);
-		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, mm, ptep);
-			return 0;
-		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
-			return VM_FAULT_HWPOISON_LARGE |
-				VM_FAULT_SET_HINDEX(hstate_index(h));
-	}
-
 	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
 	if (!ptep)
 		return VM_FAULT_OOM;
@@ -3176,12 +3166,16 @@ int hugetlb_fault(struct mm_struct *mm,
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
-	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
-	 * handle it.
+	 * a active hugepage in pagecache.
 	 */
-	if (!pte_present(entry))
+	if (!pte_present(entry)) {
+		if (is_hugetlb_entry_migration(entry))
+			need_wait_migration = 1;
+		else if (is_hugetlb_entry_hwpoisoned(entry))
+			ret = VM_FAULT_HWPOISON_LARGE |
+				VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
+	}
 
 	/*
 	 * If we are going to COW the mapping later, we examine the pending
@@ -3247,6 +3241,8 @@ out_ptl:
 	}
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	if (need_wait_migration)
+		migration_entry_wait_huge(vma, mm, ptep);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
 	 * here we just wait to defer the next page fault to avoid busy loop and
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

