From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unused-mem_cgroup-oom_wakeups.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:12 -0700
Message-ID: <5591acf0.NaMe3fHFEkiF10yW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbbF2UjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove unused mem_cgroup->oom_wakeups
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-mem_cgroup-oom_wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: remove unused mem_cgroup->oom_wakeups

Since 4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully"), nobody uses mem_cgroup->oom_wakeups.  Remove it.

While at it, also fold memcg_wakeup_oom() into memcg_oom_recover() which
is its only user.  This cleanup was suggested by Michal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-mem_cgroup-oom_wakeups mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-mem_cgroup-oom_wakeups
+++ a/mm/memcontrol.c
@@ -287,7 +287,6 @@ struct mem_cgroup {
 
 	bool		oom_lock;
 	atomic_t	under_oom;
-	atomic_t	oom_wakeups;
 
 	int	swappiness;
 	/* OOM-Killer disable */
@@ -1850,17 +1849,10 @@ static int memcg_oom_wake_function(wait_
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-static void memcg_wakeup_oom(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->oom_wakeups);
-	/* for filtering, pass "memcg" as argument. */
-	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
-}
