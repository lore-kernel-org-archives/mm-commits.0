From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-call-reclaim-if-__gfp_wait.patch removed
 from -mm tree
Date: Thu, 11 Jun 2015 14:01:23 -0700
Message-ID: <5579f723.yXj1gQ/KJquHFJHU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbFKVBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jun 2015 17:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not call reclaim if !__GFP_WAIT
has been removed from the -mm tree.  Its filename was
     memcg-do-not-call-reclaim-if-__gfp_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: do not call reclaim if !__GFP_WAIT

When trimming memcg consumption excess (see memory.high), we call
try_to_free_mem_cgroup_pages without checking if we are allowed to sleep
in the current context, which can result in a deadlock.  Fix this.

Fixes: 241994ed8649 ("mm: memcontrol: default hierarchy interface for memory")
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~memcg-do-not-call-reclaim-if-__gfp_wait mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-call-reclaim-if-__gfp_wait
+++ a/mm/memcontrol.c
@@ -2323,6 +2323,8 @@ done_restock:
 	css_get_many(&memcg->css, batch);
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
+	if (!(gfp_mask & __GFP_WAIT))
+		goto done;
 	/*
 	 * If the hierarchy is above the normal consumption range,
 	 * make the charging task trim their excess contribution.
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
linux-next.patch

