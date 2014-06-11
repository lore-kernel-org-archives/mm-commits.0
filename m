From: akpm@linux-foundation.org
Subject: +
 mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 16:21:29 -0700
Message-ID: <5398e479.parHk32G5i/Cf2qW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaFKXVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:21:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kirill@shutemov.name,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:21:29 -0700


The patch titled
     Subject: mm/pagewalk: replace mm_walk->skip with more general mm_walk->control
has been added to the -mm tree.  Its filename is
     mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch

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
Subject: mm/pagewalk: replace mm_walk->skip with more general mm_walk->control

Originally mm_walk->skip is used to determine whether we walk over a vma
or not.  But this is not enough because one of the page table walker's
caller subpage_mark_vma_nohuge(), will need another behavior PTWALK_BREAK,
which let us break current loop and continue from the beginning of the
next loop.

To implement this behavior and make it extensible for future users, this
patch replaces mm_walk->skip with more flexible mm_walk->control, and
changes its default value to PTWALK_NEXT (which is equivalent to present
walk->skip == 1.) This is because PTWALK_NEXT provides the behavior which
is most likely to be used globally.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   20 ++++------
 include/linux/mm.h |   13 +++++--
 mm/memcontrol.c    |    5 +-
 mm/mempolicy.c     |    3 -
 mm/pagewalk.c      |   79 ++++++++++++++++++++++++++-----------------
 5 files changed, 71 insertions(+), 49 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control
+++ a/fs/proc/task_mmu.c
@@ -508,9 +508,8 @@ static int smaps_pmd(pmd_t *pmd, unsigne
 		smaps_pte((pte_t *)pmd, addr, addr + HPAGE_PMD_SIZE, walk);
 		spin_unlock(ptl);
 		mss->anonymous_thp += HPAGE_PMD_SIZE;
-		/* don't call smaps_pte() */
-		walk->skip = 1;
-	}
+	} else
+		walk->control = PTWALK_DOWN;
 	return 0;
 }
 
@@ -821,13 +820,14 @@ static int clear_refs_test_walk(unsigned
 	 * Writing 4 to /proc/pid/clear_refs affects all pages.
 	 */
 	if (cp->type == CLEAR_REFS_ANON && vma->vm_file)
-		walk->skip = 1;
+		return 0;
 	if (cp->type == CLEAR_REFS_MAPPED && !vma->vm_file)
-		walk->skip = 1;
+		return 0;
 	if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
 		if (vma->vm_flags & VM_SOFTDIRTY)
 			vma->vm_flags &= ~VM_SOFTDIRTY;
 	}
+	walk->control = PTWALK_DOWN;
 	return 0;
 }
 
@@ -1066,9 +1066,8 @@ static int pagemap_pmd(pmd_t *pmd, unsig
 				break;
 		}
 		spin_unlock(ptl);
-		/* don't call pagemap_pte() */
-		walk->skip = 1;
-	}
+	} else
+		walk->control = PTWALK_DOWN;
 	return err;
 }
 
@@ -1348,9 +1347,8 @@ static int gather_pmd_stats(pmd_t *pmd,
 			gather_stats(page, md, pte_dirty(huge_pte),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
 		spin_unlock(ptl);
-		/* don't call gather_pte_stats() */
-		walk->skip = 1;
-	}
+	} else
+		walk->control = PTWALK_DOWN;
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
diff -puN include/linux/mm.h~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control include/linux/mm.h
--- a/include/linux/mm.h~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control
+++ a/include/linux/mm.h
@@ -1112,8 +1112,7 @@ void unmap_vmas(struct mmu_gather *tlb,
  *             walk_page_test() for how the skip control works.
  * @mm:        mm_struct representing the target process of page table walk
  * @vma:       vma currently walked
- * @skip:      internal control flag which is set when we skip the lower
- *             level entries.
+ * @control:   walk control flag
  * @private:   private data for callbacks' use
  *
  * (see the comment on walk_page_range() for more details)
@@ -1131,10 +1130,18 @@ struct mm_walk {
 			struct mm_walk *walk);
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int skip;
+	int control;
 	void *private;
 };
 
+enum mm_walk_control {
+	PTWALK_NEXT = 0,	/* Go to the next entry in the same level or
+				 * the next vma. This is default behavior. */
+	PTWALK_DOWN,		/* Go down to lower level */
+	PTWALK_BREAK,		/* Break current loop and continue from the
+				 * next loop */
+};
+
 int walk_page_range(unsigned long addr, unsigned long end,
 		struct mm_walk *walk);
 int walk_page_vma(struct vm_area_struct *vma, struct mm_walk *walk);
diff -puN mm/memcontrol.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control mm/memcontrol.c
--- a/mm/memcontrol.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control
+++ a/mm/memcontrol.c
@@ -6670,9 +6670,8 @@ static int mem_cgroup_count_precharge_pm
 		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
 		spin_unlock(ptl);
-		/* don't call mem_cgroup_count_precharge_pte() */
-		walk->skip = 1;
-	}
+	} else
+		skip->control = PTWALK_DOWN;
 	return 0;
 }
 
diff -puN mm/mempolicy.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control mm/mempolicy.c
--- a/mm/mempolicy.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control
+++ a/mm/mempolicy.c
@@ -596,7 +596,6 @@ static int queue_pages_test_walk(unsigne
 	}
 
 	qp->prev = vma;
-	walk->skip = 1;
 
 	if (vma->vm_flags & VM_PFNMAP)
 		return 0;
@@ -610,7 +609,7 @@ static int queue_pages_test_walk(unsigne
 	    ((flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) &&
 	     vma_migratable(vma)))
 		/* queue pages from current vma */
-		walk->skip = 0;
+		walk->control = PTWALK_DOWN;
 	return 0;
 }
 
diff -puN mm/pagewalk.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control
+++ a/mm/pagewalk.c
@@ -3,22 +3,12 @@
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
 
-/*
- * Check the current skip status of page table walker.
- *
- * Here what I mean by skip is to skip lower level walking, and that was
- * determined for each entry independently. For example, when walk_pmd_range
- * handles a pmd_trans_huge we don't have to walk over ptes under that pmd,
- * and the skipping does not affect the walking over ptes under other pmds.
- * That's why we reset @walk->skip after tested.
- */
-static bool skip_lower_level_walking(struct mm_walk *walk)
+static int get_reset_walk_control(struct mm_walk *walk)
 {
-	if (walk->skip) {
-		walk->skip = 0;
-		return true;
-	}
-	return false;
+	int ret = walk->control;
+	/* Reset to default value */
+	walk->control = PTWALK_NEXT;
+	return ret;
 }
 
 static int walk_pte_range(pmd_t *pmd, unsigned long addr,
@@ -47,7 +37,18 @@ static int walk_pte_range(pmd_t *pmd, un
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, walk);
 		if (err)
 		       break;
+		switch (get_reset_walk_control(walk)) {
+		case PTWALK_NEXT:
+			continue;
+		case PTWALK_DOWN:
+			break;
+		case PTWALK_BREAK:
+			goto out_unlock;
+		default:
+			BUG();
+		}
 	} while (pte++, addr += PAGE_SIZE, addr < end);
+out_unlock:
 	pte_unmap_unlock(orig_pte, ptl);
 	cond_resched();
 	return addr == end ? 0 : err;
@@ -75,10 +76,16 @@ again:
 
 		if (walk->pmd_entry) {
 			err = walk->pmd_entry(pmd, addr, next, walk);
-			if (skip_lower_level_walking(walk))
-				continue;
 			if (err)
 				break;
+			switch (get_reset_walk_control(walk)) {
+			case PTWALK_NEXT:
+				continue;
+			case PTWALK_DOWN:
+				break;
+			default:
+				BUG();
+			}
 		}
 
 		if (walk->pte_entry) {
@@ -204,13 +211,13 @@ static inline int walk_hugetlb_range(uns
 #endif /* CONFIG_HUGETLB_PAGE */
 
 /*
- * Decide whether we really walk over the current vma on [@start, @end)
- * or skip it. When we skip it, we set @walk->skip to 1.
- * The return value is used to control the page table walking to
- * continue (for zero) or not (for non-zero).
+ * Decide whether we really walk over the current vma on [@start, @end) or
+ * skip it. If we walk over it, we should set @walk->control to PTWALK_DOWN.
+ * Otherwise, we skip it. The return value is used to control the current
+ * walking to continue (for zero) or terminate (for non-zero).
  *
- * Default check (only VM_PFNMAP check for now) is used when the caller
- * doesn't define test_walk() callback.
+ * We fall through to the default check if the caller doesn't define its own
+ * test_walk() callback.
  */
 static int walk_page_test(unsigned long start, unsigned long end,
 			struct mm_walk *walk)
@@ -224,8 +231,8 @@ static int walk_page_test(unsigned long
 	 * Do not walk over vma(VM_PFNMAP), because we have no valid struct
 	 * page backing a VM_PFNMAP range. See also commit a9ff785e4437.
 	 */
-	if (vma->vm_flags & VM_PFNMAP)
-		walk->skip = 1;
+	if (!(vma->vm_flags & VM_PFNMAP))
+		walk->control = PTWALK_DOWN;
 	return 0;
 }
 
@@ -266,7 +273,7 @@ static int __walk_page_range(unsigned lo
  * defines test_walk(), pmd_entry(), and pte_entry(), then callbacks are
  * called in the order of test_walk(), pmd_entry(), and pte_entry().
  * If you don't want to go down to lower level at some point and move to
- * the next entry in the same level, you set @walk->skip to 1.
+ * the next entry in the same level, you set @walk->control to PTWALK_DOWN.
  * For example if you succeed to handle some pmd entry as trans_huge entry,
  * you need not call walk_pte_range() any more, so set it to avoid that.
  * We can't determine whether to go down to lower level with the return
@@ -310,10 +317,16 @@ int walk_page_range(unsigned long start,
 			next = min(end, vma->vm_end);
 
 			err = walk_page_test(start, next, walk);
-			if (skip_lower_level_walking(walk))
-				continue;
 			if (err)
 				break;
+			switch (get_reset_walk_control(walk)) {
+			case PTWALK_NEXT:
+				continue;
+			case PTWALK_DOWN:
+				break;
+			default:
+				BUG();
+			}
 		}
 		err = __walk_page_range(start, next, walk);
 		if (err)
@@ -333,9 +346,15 @@ int walk_page_vma(struct vm_area_struct
 	VM_BUG_ON(!vma);
 	walk->vma = vma;
 	err = walk_page_test(vma->vm_start, vma->vm_end, walk);
-	if (skip_lower_level_walking(walk))
-		return 0;
 	if (err)
 		return err;
+	switch (get_reset_walk_control(walk)) {
+	case PTWALK_NEXT:
+		return 0;
+	case PTWALK_DOWN:
+		break;
+	default:
+		BUG();
+	}
 	return __walk_page_range(vma->vm_start, vma->vm_end, walk);
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalkc-move-pte-null-check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

