From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-abuse-memcg_kmem_skip_account.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:06:57 -0800
Message-ID: <548d0ce1.nyvyyqbKW62LOTK0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaLNEGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not abuse memcg_kmem_skip_account
has been removed from the -mm tree.  Its filename was
     memcg-do-not-abuse-memcg_kmem_skip_account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: do not abuse memcg_kmem_skip_account

task_struct->memcg_kmem_skip_account was initially introduced to avoid
recursion during kmem cache creation: memcg_kmem_get_cache, which is
called by kmem_cache_alloc to determine the per-memcg cache to account
allocation to, may issue lazy cache creation if the needed cache doesn't
exist, which means issuing yet another kmem_cache_alloc.  We can't just
pass a flag to the nested kmem_cache_alloc disabling kmem accounting,
because there are hidden allocations, e.g.  in INIT_WORK.  So we
introduced a flag on the task_struct, memcg_kmem_skip_account, making
memcg_kmem_get_cache return immediately.

By its nature, the flag may also be used to disable accounting for
allocations shared among different cgroups, and currently it is used this
way in memcg_activate_kmem.  Using it like this looks like abusing it to
me.  If we want to disable accounting for some allocations (which we will
definitely want one day), we should either add GFP_NO_MEMCG or GFP_MEMCG
flag in order to blacklist/whitelist some allocations.

For now, let's simply remove memcg_stop/resume_kmem_account from
memcg_activate_kmem.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-abuse-memcg_kmem_skip_account mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-abuse-memcg_kmem_skip_account
+++ a/mm/memcontrol.c
@@ -3539,12 +3539,6 @@ static int memcg_activate_kmem(struct me
 		return 0;
 
 	/*
-	 * We are going to allocate memory for data shared by all memory
-	 * cgroups so let's stop accounting here.
-	 */
-	memcg_stop_kmem_account();
