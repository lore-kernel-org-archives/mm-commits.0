From: akpm@linux-foundation.org
Subject: +
 arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch added to -mm tree
Date: Wed, 11 Jun 2014 16:21:34 -0700
Message-ID: <5398e47e.ggTvnYn/R4ZjNk6e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaFKXVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, riel@redhat.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, benh@kernel.crashing.org, aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com

Subject: + arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,aneesh.kumar@linux.vnet.ibm.com,benh@kernel.crashing.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kirill@shutemov.name,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:21:34 -0700


The patch titled
     Subject: arch/powerpc/mm/subpage-prot.c: cleanup subpage_walk_pmd_entry()
has been added to the -mm tree.  Its filename is
     arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch

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
Subject: arch/powerpc/mm/subpage-prot.c: cleanup subpage_walk_pmd_entry()

Currently subpage_mark_vma_nohuge() uses page table walker to find thps
and then split them.  But this can be done by page table walker itself, so
let's rewrite it in more suitable way.  No functional change.

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

 arch/powerpc/mm/subpage-prot.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/mm/subpage-prot.c~arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry arch/powerpc/mm/subpage-prot.c
--- a/arch/powerpc/mm/subpage-prot.c~arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry
+++ a/arch/powerpc/mm/subpage-prot.c
@@ -131,11 +131,10 @@ static void subpage_prot_clear(unsigned
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static int subpage_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
+static int subpage_walk_pte(pte_t *pte, unsigned long addr,
 				  unsigned long end, struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->vma;
-	split_huge_page_pmd(vma, addr, pmd);
+	walk->control = PTWALK_BREAK;
 	return 0;
 }
 
@@ -143,9 +142,14 @@ static void subpage_mark_vma_nohuge(stru
 				    unsigned long len)
 {
 	struct vm_area_struct *vma;
+	/*
+	 * What this walking expects is to split all thps under this mm.
+	 * Page table walker internally splits thps just before we try to
+	 * call .pte_entry() on them, so let's utilize it.
+	 */
 	struct mm_walk subpage_proto_walk = {
 		.mm = mm,
-		.pmd_entry = subpage_walk_pmd_entry,
+		.pte_entry = subpage_walk_pte,
 	};
 
 	/*
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

