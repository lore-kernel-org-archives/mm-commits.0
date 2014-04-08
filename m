From: akpm@linux-foundation.org
Subject: [merged]
 memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:52:04 -0700
Message-ID: <53446174.UgM3pn2u3TdsKZAG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbaDHUwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:52:04 -0700


The patch titled
     Subject: memcg: remove unnecessary !mm check from try_get_mem_cgroup_from_mm()
has been removed from the -mm tree.  Its filename was
     memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg: remove unnecessary !mm check from try_get_mem_cgroup_from_mm()

Users pass either a mm that has been established under task lock, or use a
verified current->mm, which means the task can't be exiting.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm
+++ a/mm/memcontrol.c
@@ -1075,13 +1075,6 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 {
 	struct mem_cgroup *memcg = NULL;
 
-	if (!mm)
-		return NULL;
-	/*
-	 * Because we have no locks, mm->owner's may be being moved to other
-	 * cgroup. We use css_tryget() here even if this looks
-	 * pessimistic (rather than adding locks here).
-	 */
 	rcu_read_lock();
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

