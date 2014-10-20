From: akpm@linux-foundation.org
Subject: +
 memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
 added to -mm tree
Date: Mon, 20 Oct 2014 14:33:28 -0700
Message-ID: <54457fa8.2YlJhRdWPJT6+W1Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJTVd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify unreclaimable groups handling in soft limit reclaim
has been added to the -mm tree.  Its filename is
     memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: simplify unreclaimable groups handling in soft limit reclaim

If we fail to reclaim anything from a cgroup during a soft reclaim pass
we want to get the next largest cgroup exceeding its soft limit. To
achieve this, we should obviously remove the current group from the tree
and then pick the largest group. Currently we have a weird loop instead.
Let's simplify it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim
+++ a/mm/memcontrol.c
@@ -3509,34 +3509,16 @@ unsigned long mem_cgroup_soft_limit_recl
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
+		__mem_cgroup_remove_exceeded(mz, mctz);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
 		 * it is time to move on to the next cgroup
 		 */
 		next_mz = NULL;
-		if (!reclaimed) {
-			do {
-				/*
-				 * Loop until we find yet another one.
-				 *
-				 * By the time we get the soft_limit lock
-				 * again, someone might have aded the
-				 * group back on the RB tree. Iterate to
-				 * make sure we get a different mem.
-				 * mem_cgroup_largest_soft_limit_node returns
-				 * NULL if no other cgroup is present on
-				 * the tree
-				 */
-				next_mz =
-				__mem_cgroup_largest_soft_limit_node(mctz);
-				if (next_mz == mz)
-					css_put(&next_mz->memcg->css);
-				else /* next_mz == NULL or other memcg */
-					break;
-			} while (1);
-		}
-		__mem_cgroup_remove_exceeded(mz, mctz);
+		if (!reclaimed)
+			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
+
 		excess = soft_limit_excess(mz->memcg);
 		/*
 		 * One school of thought says that we should not add
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch

