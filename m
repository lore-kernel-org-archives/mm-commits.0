From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch added to -mm tree
Date: Mon, 21 Nov 2011 14:27:37 -0800
Message-ID: <201111212227.pALMRcZK009600@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59022 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1KUW1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 17:27:39 -0500
Received: by yenm12 with SMTP id m12so189295yen.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 14:27:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm/hugetlb.c: fix virtual address handling in hugetlb fault
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch

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
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: mm/hugetlb.c: fix virtual address handling in hugetlb fault

handle_mm_fault() passes 'faulted' address to hugetlb_fault().  This
address is not aligned to a hugepage boundary.

Most of the functions for hugetlb pages are aware of that and calculate an
alignment themselves.  However some functions such as
copy_user_huge_page() and clear_huge_page() don't handle alignment by
themselves.

This patch make hugeltb_fault() fix the alignment and pass an aligned
addresss (to address of a faulted hugepage) to functions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault
+++ a/mm/hugetlb.c
@@ -2639,6 +2639,8 @@ int hugetlb_fault(struct mm_struct *mm, 
 	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
 
+	address = address & huge_page_mask(h);
+
 	ptep = huge_pte_offset(mm, address);
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
_
Subject: Subject: mm/hugetlb.c: fix virtual address handling in hugetlb fault

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch

