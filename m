From: akpm@linux-foundation.org
Subject: + hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch added to -mm tree
Date: Mon, 21 Nov 2011 14:08:03 -0800
Message-ID: <201111212208.pALM84vk022454@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61992 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1KUWPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 17:15:23 -0500
Received: by ywb5 with SMTP id 5so776221ywb.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 14:15:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, aarcange@redhat.com, dhillf@gmail.com, jweiner@redhat.com


The patch titled
     Subject: hugetlb: clarify hugetlb_instantiation_mutex usage
has been added to the -mm tree.  Its filename is
     hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch

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
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb: clarify hugetlb_instantiation_mutex usage

Let's make it clear that we cannot race with other fault handlers due to
hugetlb (global) mutex.  Also make it clear that we want to keep pte_same
checks anayway to have a transition from the global mutex easier.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-clarify-hugetlb_instantiation_mutex-usage mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-clarify-hugetlb_instantiation_mutex-usage
+++ a/mm/hugetlb.c
@@ -2348,6 +2348,9 @@ static int unmap_ref_private(struct mm_s
 
 /*
  * Hugetlb_cow() should be called with page lock of the original hugepage held.
+ * Called with hugetlb_instantiation_mutex held and pte_page locked so we
+ * cannot race with other handlers or page migration.
+ * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pte_t pte,
_
Subject: Subject: hugetlb: clarify hugetlb_instantiation_mutex usage

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
cgroup_freezer-fix-freezing-groups-with-stopped-tasks.patch
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

