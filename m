From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-remove-unnecessary-preemption-disabling.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:49:47 -0700
Message-ID: <534460eb.9jg2wxd46pbnLTyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbaDHUts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] mm-memcg-remove-unnecessary-preemption-disabling.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:49:47 -0700


The patch titled
     Subject: mm: memcg: remove unnecessary preemption disabling
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-unnecessary-preemption-disabling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: remove unnecessary preemption disabling

lock_page_cgroup() disables preemption, remove explicit preemption
disabling for code paths holding this lock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-unnecessary-preemption-disabling mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-unnecessary-preemption-disabling
+++ a/mm/memcontrol.c
@@ -921,8 +921,6 @@ static void mem_cgroup_charge_statistics
 					 struct page *page,
 					 bool anon, int nr_pages)
 {
-	preempt_disable();
-
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -947,8 +945,6 @@ static void mem_cgroup_charge_statistics
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
-
-	preempt_enable();
 }
 
 unsigned long
@@ -3748,17 +3744,14 @@ void mem_cgroup_split_huge_fixup(struct
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline
-void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
-					struct mem_cgroup *to,
-					unsigned int nr_pages,
-					enum mem_cgroup_stat_index idx)
+static void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
+					      struct mem_cgroup *to,
+					      unsigned int nr_pages,
+					      enum mem_cgroup_stat_index idx)
 {
 	/* Update stat data for mem_cgroup */
-	preempt_disable();
 	__this_cpu_sub(from->stat->count[idx], nr_pages);
 	__this_cpu_add(to->stat->count[idx], nr_pages);
-	preempt_enable();
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

