From: akpm@linux-foundation.org
Subject: [merged] mm-swapfile-clean-up-unuse_pte-race-handling.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:52 -0700
Message-ID: <20120801201752.CAD471E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab2HAURy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:54 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mel@csn.ul.ie, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: swapfile: clean up unuse_pte race handling
has been removed from the -mm tree.  Its filename was
     mm-swapfile-clean-up-unuse_pte-race-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: swapfile: clean up unuse_pte race handling

The conditional mem_cgroup_cancel_charge_swapin() is a leftover from when
the function would continue to reestablish the page even after
mem_cgroup_try_charge_swapin() failed.  After 85d9fc8 "memcg: fix refcnt
handling at swapoff", the condition is always true when this code is
reached.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwp.linux@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/swapfile.c~mm-swapfile-clean-up-unuse_pte-race-handling mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfile-clean-up-unuse_pte-race-handling
+++ a/mm/swapfile.c
@@ -835,8 +835,7 @@ static int unuse_pte(struct vm_area_stru
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte_same(*pte, swp_entry_to_pte(entry)))) {
-		if (ret > 0)
-			mem_cgroup_cancel_charge_swapin(memcg);
+		mem_cgroup_cancel_charge_swapin(memcg);
 		ret = 0;
 		goto out;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-slab-remove-duplicate-check.patch

