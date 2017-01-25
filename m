From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-do-not-retry-precharge-charges.patch removed
 from -mm tree
Date: Wed, 25 Jan 2017 14:04:42 -0800
Message-ID: <588920fa.0zVF+dOGWcQlkX9Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbdAYWEs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2017 17:04:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: do not retry precharge charges
has been removed from the -mm tree.  Its filename was
     mm-memcg-do-not-retry-precharge-charges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: do not retry precharge charges

When memory.move_charge_at_immigrate is enabled and precharges are
depleted during move, mem_cgroup_move_charge_pte_range() will attempt to
increase the size of the precharge.

Prevent precharges from ever looping by setting __GFP_NORETRY.  This was
probably the intention of the GFP_KERNEL & ~__GFP_NORETRY, which is
pointless as written.

Fixes: 0029e19ebf84 ("mm: memcontrol: remove explicit OOM parameter in charge path")
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-do-not-retry-precharge-charges mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-do-not-retry-precharge-charges
+++ a/mm/memcontrol.c
@@ -4353,9 +4353,9 @@ static int mem_cgroup_do_precharge(unsig
 		return ret;
 	}
 
-	/* Try charges one by one with reclaim */
+	/* Try charges one by one with reclaim, but do not retry */
 	while (count--) {
-		ret = try_charge(mc.to, GFP_KERNEL & ~__GFP_NORETRY, 1);
+		ret = try_charge(mc.to, GFP_KERNEL | __GFP_NORETRY, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-add-vmstats-for-kcompactd-work.patch
mm-thp-add-new-defermadvise-defrag-option.patch
mm-page_alloc-warn_alloc-nodemask-is-null-when-cpusets-are-disabled.patch
mm-oom-header-nodemask-is-null-when-cpusets-are-disabled.patch
mm-oom-header-nodemask-is-null-when-cpusets-are-disabled-fix.patch

