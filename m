From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages-v5.patch removed from -mm tree
Date: Wed, 03 May 2017 14:39:41 -0700
Message-ID: <590a4e1d.i1t57GeIsGx7OCBs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45742 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdECVjm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, riel@redhat.com, shakeelb@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages-v5
has been removed from the -mm tree.  Its filename was
     mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages-v5.patch

This patch was dropped because it was folded into mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages-v5

 - remove may_thrash field in scan_control, and introduce mem_cgroup_reclaim
   and memcg_low_skipped to make code more readable. - Johannes

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

 mm/vmscan.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages-v5 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages-v5
+++ a/mm/vmscan.c
@@ -97,11 +97,13 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
-	/* Can cgroups be reclaimed below their normal consumption range? */
-	unsigned int may_thrash:1;
-
-	/* Did we have any memcg protected by the low limit */
-	unsigned int memcg_low_protection:1;
+	/*
+	 * Cgroups are not reclaimed below their configured memory.low,
+	 * unless we threaten to OOM. If any cgroups are skipped due to
+	 * memory.low and nothing was reclaimed, go back for memory.low.
+	 */
+	unsigned int memcg_low_reclaim:1;
+	unsigned int memcg_low_skipped:1;
 
 	unsigned int hibernation_mode:1;
 
@@ -2515,10 +2517,10 @@ static bool shrink_node(pg_data_t *pgdat
 			unsigned long scanned;
 
 			if (mem_cgroup_low(root, memcg)) {
-				sc->memcg_low_protection = 1;
-
-				if (!sc->may_thrash)
+				if (!sc->memcg_low_reclaim) {
+					sc->memcg_low_skipped = 1;
 					continue;
+				}
 				mem_cgroup_events(memcg, MEMCG_LOW, 1);
 			}
 
@@ -2773,9 +2775,10 @@ retry:
 		return 1;
 
 	/* Untapped cgroup reserves?  Don't OOM, retry. */
-	if (sc->memcg_low_protection && !sc->may_thrash) {
+	if (sc->memcg_low_skipped) {
 		sc->priority = initial_priority;
-		sc->may_thrash = 1;
+		sc->memcg_low_reclaim = 1;
+		sc->memcg_low_skipped = 0;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-compaction-ignore-block-suitable-after-check-large-free-page.patch
mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch

