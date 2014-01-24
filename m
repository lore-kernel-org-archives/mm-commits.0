From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-fix-last_dead_count-memory-wastage.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:31 -0800
Message-ID: <52e2b813.Ve4auv8v7P4KqAgX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com

Subject: [merged] mm-memcg-fix-last_dead_count-memory-wastage.patch removed from -mm tree
To: hughd@google.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:31 -0800


The patch titled
     Subject: mm/memcg: fix last_dead_count memory wastage
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-last_dead_count-memory-wastage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: fix last_dead_count memory wastage

Shorten mem_cgroup_reclaim_iter.last_dead_count from unsigned long to int:
it's assigned from an int and compared with an int, and adjacent to an
unsigned int: so there's no point to it being unsigned long, which wasted
104 bytes in every mem_cgroup_per_zone.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-fix-last_dead_count-memory-wastage mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-last_dead_count-memory-wastage
+++ a/mm/memcontrol.c
@@ -149,7 +149,7 @@ struct mem_cgroup_reclaim_iter {
 	 * matches memcg->dead_count of the hierarchy root group.
 	 */
 	struct mem_cgroup *last_visited;
-	unsigned long last_dead_count;
+	int last_dead_count;
 
 	/* scan generation, increased every round-trip */
 	unsigned int generation;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

