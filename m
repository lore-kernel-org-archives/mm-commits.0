From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:50:19 -0700
Message-ID: <5344610b.7jyC8tJyMYkLw7Lz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbaDHUuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-remove-mem_cgroup_move_account_page_stat.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:50:19 -0700


The patch titled
     Subject: mm: memcg: remove mem_cgroup_move_account_page_stat()
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-mem_cgroup_move_account_page_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: remove mem_cgroup_move_account_page_stat()

It used to disable preemption and run sanity checks but now it's only
taking a number out of one percpu counter and putting it into another.  Do
this directly in the callsite and save the indirection.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-mem_cgroup_move_account_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-mem_cgroup_move_account_page_stat
+++ a/mm/memcontrol.c
@@ -3744,16 +3744,6 @@ void mem_cgroup_split_huge_fixup(struct
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
-					      struct mem_cgroup *to,
-					      unsigned int nr_pages,
-					      enum mem_cgroup_stat_index idx)
-{
-	/* Update stat data for mem_cgroup */
-	__this_cpu_sub(from->stat->count[idx], nr_pages);
-	__this_cpu_add(to->stat->count[idx], nr_pages);
-}
-
 /**
  * mem_cgroup_move_account - move account of the page
  * @page: the page
@@ -3799,13 +3789,19 @@ static int mem_cgroup_move_account(struc
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (!anon && page_mapped(page))
-		mem_cgroup_move_account_page_stat(from, to, nr_pages,
-			MEM_CGROUP_STAT_FILE_MAPPED);
-
-	if (PageWriteback(page))
-		mem_cgroup_move_account_page_stat(from, to, nr_pages,
-			MEM_CGROUP_STAT_WRITEBACK);
+	if (!anon && page_mapped(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       nr_pages);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       nr_pages);
+	}
+
+	if (PageWriteback(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
+			       nr_pages);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
+			       nr_pages);
+	}
 
 	mem_cgroup_charge_statistics(from, page, anon, -nr_pages);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

