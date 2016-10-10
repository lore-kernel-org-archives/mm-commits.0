From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-make-the-walk_page_range-limit-obvious.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:07 -0700
Message-ID: <57fc19f3.ULlCyRejUOHIbrNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbcJJWpI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.morse@arm.com, hannes@cmpxchg.org, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: make the walk_page_range() limit obvious
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-the-walk_page_range-limit-obvious.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: mm/memcontrol.c: make the walk_page_range() limit obvious

mem_cgroup_count_precharge() and mem_cgroup_move_charge() both call
walk_page_range() on the range 0 to ~0UL, neither provide a pte_hole
callback, which causes the current implementation to skip non-vma
regions.  This is all fine but follow up changes would like to make
walk_page_range more generic so it is better to be explicit about which
range to traverse so let's use highest_vm_end to explicitly traverse
only user mmaped memory.

[mhocko@kernel.org: rewrote changelog]
Link: http://lkml.kernel.org/r/1472655897-22532-1-git-send-email-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-make-the-walk_page_range-limit-obvious mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-make-the-walk_page_range-limit-obvious
+++ a/mm/memcontrol.c
@@ -4681,7 +4681,8 @@ static unsigned long mem_cgroup_count_pr
 		.mm = mm,
 	};
 	down_read(&mm->mmap_sem);
-	walk_page_range(0, ~0UL, &mem_cgroup_count_precharge_walk);
+	walk_page_range(0, mm->highest_vm_end,
+			&mem_cgroup_count_precharge_walk);
 	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
@@ -4969,7 +4970,8 @@ retry:
 	 * When we have consumed all precharges and failed in doing
 	 * additional charge, the page walk just aborts.
 	 */
-	walk_page_range(0, ~0UL, &mem_cgroup_move_charge_walk);
+	walk_page_range(0, mc.mm->highest_vm_end, &mem_cgroup_move_charge_walk);
+
 	up_read(&mc.mm->mmap_sem);
 	atomic_dec(&mc.from->moving_account);
 }
_

Patches currently in -mm which might be from james.morse@arm.com are


