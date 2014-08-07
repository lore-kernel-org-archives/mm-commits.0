From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:04:25 -0700
Message-ID: <53e3dbc9.FWOhqfYR72KzrllD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:47498 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaHGUE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:26 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1176791pde.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: use GFP_TRANSHUGE when charging huge pages
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: huge_memory: use GFP_TRANSHUGE when charging huge pages

Transparent huge page charges prefer falling back to regular pages rather
than spending a lot of time in direct reclaim.

Desired reclaim behavior is usually declared in the gfp mask, but THP
charges use GFP_KERNEL and then rely on the fact that OOM is disabled for
THP charges, and that OOM-disabled charges don't retry reclaim.  Needless
to say, this is anything but obvious and quite error prone.

Convert THP charges to use GFP_TRANSHUGE instead, which implies
__GFP_NORETRY, to indicate the low-latency requirement.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages
+++ a/mm/huge_memory.c
@@ -827,7 +827,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	if (unlikely(mem_cgroup_charge_anon(page, mm, GFP_KERNEL))) {
+	if (unlikely(mem_cgroup_charge_anon(page, mm, GFP_TRANSHUGE))) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -1132,7 +1132,7 @@ alloc:
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL))) {
+	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_TRANSHUGE))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -2399,7 +2399,7 @@ static void collapse_huge_page(struct mm
 	if (!new_page)
 		return;
 
-	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_KERNEL)))
+	if (unlikely(mem_cgroup_charge_anon(new_page, mm, GFP_TRANSHUGE)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

