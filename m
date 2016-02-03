From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
 removed from -mm tree
Date: Wed, 03 Feb 2016 13:53:17 -0800
Message-ID: <56b276cd.6ikRSpICurrVDHmr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop superfluous entry in the per-memcg stats array
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop superfluous entry in the per-memcg stats array

MEM_CGROUP_STAT_NSTATS is just a delimiter for cgroup1 statistics, not an
actual array entry.  Reuse it for the first cgroup2 stat entry, like in
the event array.

Fixes: b2807f07f4f8 ("mm: memcontrol: add "sock" to cgroup2 memory.stat")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array
+++ a/include/linux/memcontrol.h
@@ -51,7 +51,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_SWAP,		/* # of pages, swapped out */
 	MEM_CGROUP_STAT_NSTATS,
 	/* default hierarchy stats */
-	MEMCG_SOCK,
+	MEMCG_SOCK = MEM_CGROUP_STAT_NSTATS,
 	MEMCG_NR_STAT,
 };
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

