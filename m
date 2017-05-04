From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-vmscan-more-restrictive-condition-for-retry-in-do=5Ftry?=
 =?US-ASCII?Q?=5Fto=5Ffree=5Fpages.patch?= removed from -mm tree
Date: Thu, 04 May 2017 12:11:17 -0700
Message-ID: <20170504191117.F306QiAzO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbdEDTLT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:11:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, riel@redhat.com, shakeelb@google.com, vbabka@suse.cz, xieyisheng1@huawei.com


The patch titled
     Subject: mm/vmscan: more restrictive condition for retry in do_try_to_free_pages
has been removed from the -mm tree.  Its filename was
     mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/vmscan: more restrictive condition for retry in do_try_to_free_pages

By reviewing code, I find that when enter do_try_to_free_pages, the
may_thrash is always clear, and it will retry shrink zones to tap cgroup's
reserves memory by setting may_thrash when the former shrink_zones reclaim
nothing.

However, when memcg is disabled or on legacy hierarchy, or there do not
have any memcg protected by low limit, it should not do this useless retry
at all, for we do not have any cgroup's reserves memory to tap, and we
have already done hard work but made no progress, which as Michal pointed
out in former version, we are trying hard to control the retry logical of
page alloctor, and the current additional round of reclaim is just lame.

Therefore, to avoid this unneeded retrying and make code more readable, we
remove the may_thrash field in scan_control, instead, introduce
memcg_low_reclaim and memcg_low_skipped, and only retry when
memcg_low_skipped, by setting memcg_low_reclaim.

[xieyisheng1@huawei.com: remove may_thrash field, introduce mem_cgroup_reclaim]
  Link: http://lkml.kernel.org/r/1490191893-5923-1-git-send-email-ysxie@foxmail.com
Link: http://lkml.kernel.org/r/1490191893-5923-1-git-send-email-ysxie@foxmail.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages
+++ a/mm/vmscan.c
@@ -97,8 +97,13 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
-	/* Can cgroups be reclaimed below their normal consumption range? */
-	unsigned int may_thrash:1;
+	/*
+	 * Cgroups are not reclaimed below their configured memory.low,
+	 * unless we threaten to OOM. If any cgroups are skipped due to
+	 * memory.low and nothing was reclaimed, go back for memory.low.
+	 */
+	unsigned int memcg_low_reclaim:1;
+	unsigned int memcg_low_skipped:1;
 
 	unsigned int hibernation_mode:1;
 
@@ -2512,8 +2517,10 @@ static bool shrink_node(pg_data_t *pgdat
 			unsigned long scanned;
 
 			if (mem_cgroup_low(root, memcg)) {
-				if (!sc->may_thrash)
+				if (!sc->memcg_low_reclaim) {
+					sc->memcg_low_skipped = 1;
 					continue;
+				}
 				mem_cgroup_events(memcg, MEMCG_LOW, 1);
 			}
 
@@ -2768,9 +2775,10 @@ retry:
 		return 1;
 
 	/* Untapped cgroup reserves?  Don't OOM, retry. */
-	if (!sc->may_thrash) {
+	if (sc->memcg_low_skipped) {
 		sc->priority = initial_priority;
-		sc->may_thrash = 1;
+		sc->memcg_low_reclaim = 1;
+		sc->memcg_low_skipped = 0;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are


