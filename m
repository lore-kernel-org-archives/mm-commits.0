From: akpm@linux-foundation.org
Subject: [failures]
 =?us-ascii?Q?hugetlb=5Fcgroup-add-interface-for-charge-uncharge-hugetl?=
 =?us-ascii?Q?b-reservations-fix.patch?= removed from -mm tree
Date: Wed, 19 Feb 2020 17:20:41 -0800
Message-ID: <20200220012041.Dw2Ft%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBTBUo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 20:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, almasrymina@google.com, cai@lca.pw


The patch titled
     Subject: mm/hugetlb_cgroup: fix a -Wunused-but-set-variable
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/hugetlb_cgroup: fix a -Wunused-but-set-variable

The commit c32300516047 ("hugetlb_cgroup: add interface for
charge/uncharge hugetlb reservations") forgot to remove an unused
variable,

mm/hugetlb_cgroup.c: In function 'hugetlb_cgroup_migrate':
mm/hugetlb_cgroup.c:777:25: warning: variable 'h_cg' set but not used
[-Wunused-but-set-variable]
  struct hugetlb_cgroup *h_cg;
                         ^~~~

Link: http://lkml.kernel.org/r/1581953454-10671-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations-fix
+++ a/mm/hugetlb_cgroup.c
@@ -786,7 +786,6 @@ void __init hugetlb_cgroup_file_init(voi
  */
 void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 {
-	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
 	struct hstate *h = page_hstate(oldhpage);
 
@@ -795,7 +794,6 @@ void hugetlb_cgroup_migrate(struct page
 
 	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
 	spin_lock(&hugetlb_lock);
-	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
 
_

Patches currently in -mm which might be from cai@lca.pw are

mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
fork-annotate-a-data-race-in-vm_area_dup.patch
mm-annotate-a-data-race-in-page_zonenum.patch
