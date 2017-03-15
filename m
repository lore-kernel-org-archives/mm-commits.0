From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch added to -mm tree
Date: Wed, 15 Mar 2017 12:18:37 -0700
Message-ID: <58c9938d.RWKeEYBvhTkWNUko%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdCOTSj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 15:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, riel@redhat.com, shakeelb@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: more restrictive condition for retry in do_try_to_free_pages
has been added to the -mm tree.  Its filename is
     mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
have already done hard work but made no progress.

To avoid this unneeded retrying, add a new field in scan_control named
memcg_low_protection, set it if there is any memcg protected by low limit
and only do the retry when memcg_low_protection is set while may_thrash is
clear.

Link: http://lkml.kernel.org/r/1489577808-19228-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Suggested-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages
+++ a/mm/vmscan.c
@@ -100,6 +100,9 @@ struct scan_control {
 	/* Can cgroups be reclaimed below their normal consumption range? */
 	unsigned int may_thrash:1;
 
+	/* Did we have any memcg protected by the low limit */
+	unsigned int memcg_low_protection:1;
+
 	unsigned int hibernation_mode:1;
 
 	/* One of the zones is ready for compaction */
@@ -2512,6 +2515,8 @@ static bool shrink_node(pg_data_t *pgdat
 			unsigned long scanned;
 
 			if (mem_cgroup_low(root, memcg)) {
+				sc->memcg_low_protection = 1;
+
 				if (!sc->may_thrash)
 					continue;
 				mem_cgroup_events(memcg, MEMCG_LOW, 1);
@@ -2768,7 +2773,7 @@ retry:
 		return 1;
 
 	/* Untapped cgroup reserves?  Don't OOM, retry. */
-	if (!sc->may_thrash) {
+	if (sc->memcg_low_protection && !sc->may_thrash) {
 		sc->priority = initial_priority;
 		sc->may_thrash = 1;
 		goto retry;
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-compaction-ignore-block-suitable-after-check-large-free-page.patch
mm-vmscan-more-restrictive-condition-for-retry-in-do_try_to_free_pages.patch

