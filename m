From: akpm@linux-foundation.org
Subject: + memcg-separate-mem_cgroup_move_charge_pte_range.patch added to
 -mm tree
Date: Wed, 11 Jun 2014 16:21:33 -0700
Message-ID: <5398e47d.HGOsBil1wqc2RuNu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaFKXVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + memcg-separate-mem_cgroup_move_charge_pte_range.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kirill@shutemov.name,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:21:33 -0700


The patch titled
     Subject: memcg: separate mem_cgroup_move_charge_pte_range()
has been added to the -mm tree.  Its filename is
     memcg-separate-mem_cgroup_move_charge_pte_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-separate-mem_cgroup_move_charge_pte_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-separate-mem_cgroup_move_charge_pte_range.patch

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
Subject: memcg: separate mem_cgroup_move_charge_pte_range()

mem_cgroup_move_charge_pte_range() handles both pte and pmd, which is not
standardized, so let's cleanup it.  One tricky part is the retry, which is
performed when we detect !mc.precharge.  In such case we retry the same
entry, so we don't have to go outside the pte loop.  With rewriting this
retry in the pte loop, we can separate pmd_entry() and pte_entry(), which
is what we need.

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

 mm/memcontrol.c |  128 +++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 62 deletions(-)

diff -puN mm/memcontrol.c~memcg-separate-mem_cgroup_move_charge_pte_range mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-separate-mem_cgroup_move_charge_pte_range
+++ a/mm/memcontrol.c
@@ -6821,14 +6821,72 @@ static void mem_cgroup_cancel_attach(str
 	mem_cgroup_clear_mc();
 }
 
-static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
+static int mem_cgroup_move_charge_pte(pte_t *pte,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
 {
 	int ret = 0;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte;
-	spinlock_t *ptl;
+	union mc_target target;
+	struct page *page;
+	struct page_cgroup *pc;
+	swp_entry_t ent;
+
+retry:
+	if (!mc.precharge) {
+		pte_t *orig_pte = pte - ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+		pte_unmap_unlock(orig_pte, walk->ptl);
+		cond_resched();
+		/*
+		 * We have consumed all precharges we got in can_attach().
+		 * We try charge one by one, but don't do any additional
+		 * charges to mc.to if we have failed in charge once in attach()
+		 * phase.
+		 */
+		ret = mem_cgroup_do_precharge(1);
+		pte_offset_map(walk->pmd, addr & PMD_MASK);
+		spin_lock(walk->ptl);
+		if (!ret)
+			goto retry;
+		return ret;
+	}
+
+	switch (get_mctgt_type(vma, addr, *pte, &target)) {
+	case MC_TARGET_PAGE:
+		page = target.page;
+		if (isolate_lru_page(page))
+			goto put;
+		pc = lookup_page_cgroup(page);
+		if (!mem_cgroup_move_account(page, 1, pc,
+					     mc.from, mc.to)) {
+			mc.precharge--;
+			/* we uncharge from mc.from later. */
+			mc.moved_charge++;
+		}
+		putback_lru_page(page);
+put:		/* get_mctgt_type() gets the page */
+		put_page(page);
+		break;
+	case MC_TARGET_SWAP:
+		ent = target.ent;
+		if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
+			mc.precharge--;
+			/* we fixup refcnts and charges later. */
+			mc.moved_swap++;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int mem_cgroup_move_charge_pmd(pmd_t *pmd,
+				unsigned long addr, unsigned long end,
+				struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
 	enum mc_target_type target_type;
 	union mc_target target;
 	struct page *page;
@@ -6864,71 +6922,17 @@ static int mem_cgroup_move_charge_pte_ra
 			put_page(page);
 		}
 		spin_unlock(ptl);
-		return 0;
-	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-retry:
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; addr += PAGE_SIZE) {
-		pte_t ptent = *(pte++);
-		swp_entry_t ent;
-
-		if (!mc.precharge)
-			break;
-
-		switch (get_mctgt_type(vma, addr, ptent, &target)) {
-		case MC_TARGET_PAGE:
-			page = target.page;
-			if (isolate_lru_page(page))
-				goto put;
-			pc = lookup_page_cgroup(page);
-			if (!mem_cgroup_move_account(page, 1, pc,
-						     mc.from, mc.to)) {
-				mc.precharge--;
-				/* we uncharge from mc.from later. */
-				mc.moved_charge++;
-			}
-			putback_lru_page(page);
-put:			/* get_mctgt_type() gets the page */
-			put_page(page);
-			break;
-		case MC_TARGET_SWAP:
-			ent = target.ent;
-			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
-				mc.precharge--;
-				/* we fixup refcnts and charges later. */
-				mc.moved_swap++;
-			}
-			break;
-		default:
-			break;
-		}
-	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-
-	if (addr != end) {
-		/*
-		 * We have consumed all precharges we got in can_attach().
-		 * We try charge one by one, but don't do any additional
-		 * charges to mc.to if we have failed in charge once in attach()
-		 * phase.
-		 */
-		ret = mem_cgroup_do_precharge(1);
-		if (!ret)
-			goto retry;
-	}
-
-	return ret;
+	} else
+		walk->control = PTWALK_DOWN;
+	return 0;
 }
 
 static void mem_cgroup_move_charge(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	struct mm_walk mem_cgroup_move_charge_walk = {
-		.pmd_entry = mem_cgroup_move_charge_pte_range,
+		.pmd_entry = mem_cgroup_move_charge_pmd,
+		.pte_entry = mem_cgroup_move_charge_pte,
 		.mm = mm,
 	};
 
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

