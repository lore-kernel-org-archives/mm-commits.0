From: akpm@linux-foundation.org
Subject: [folded] hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:27:02 -0700
Message-ID: <20120731232702.C6545A028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:49944 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2GaX1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:27:04 -0400
Received: by wgbdt11 with SMTP id dt11so297297wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:27:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liwp.linux@gmail.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: Add huge_page_order check to avoid incorrectly uncharge
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge.patch

This patch was dropped because it was folded into hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm/hugetlb_cgroup: Add huge_page_order check to avoid incorrectly uncharge

alloc_huge_page() will call hugetlb_cgroup_charge_cgroup() to charge
pages, the compound page have less than 3 pages will not charge to hugetlb
cgroup.  When alloc_huge_page fails it will call
hugetlb_cgroup_uncharge_cgroup to uncharge pages, however,
hugetlb_cgroup_uncharge_cgroup doesn't have huge_page_order check.  That
means it will uncharge pages even if the compound page have less than 3
pages.  Add huge_page_order check to avoid this incorrectly uncharge.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/hugetlb_cgroup.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge
+++ a/mm/hugetlb_cgroup.c
@@ -184,6 +184,9 @@ void hugetlb_cgroup_uncharge_cgroup(int 
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
+	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
+		return;
+
 	res_counter_uncharge(&h_cg->hugepage[idx], csize);
 	return;
 }
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
mm-remove-unused-lru_all_evictable.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch
mm-memcg-complete-documentation-for-tcp-memcg-files.patch
mm-memcg-mem_cgroup_relize_xxx_limit-can-guarantee-memcg-reslimit-=-memcg-memswlimit.patch
mm-memcg-replace-inexistence-move_lock_page_cgroup-by-move_lock_mem_cgroup-in-comment.patch

