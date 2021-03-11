Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946DDC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D58F64F8C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 20:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCKUiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhCKUhw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 15:37:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D55264F85;
        Thu, 11 Mar 2021 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615495072;
        bh=odmyJqeQ4VeRv6z0TarcqAa0xaZiQWJURqd/FTpKs74=;
        h=Date:From:To:Subject:From;
        b=1VR8lUegmjYdGXtHBGVnDn2ca33QOZ10fEu1ptx6VbUUj7VczbCQYjgdFkP+FYP4Q
         WA5gEMktYT/yUZBzuouOx54I7Szv2yJWL/4cXkuzGl9ORnFqgI3xF5F9bGZIGlitkp
         SGjJTeYjHPYDqHJxYgGVxUIAuKFV2h/2+EJ2Q0M8=
Date:   Thu, 11 Mar 2021 12:37:51 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, ktkhai@virtuozzo.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, vbabka@suse.cz
Subject:  +
 mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch added to
 -mm tree
Message-ID: <20210311203751.ML7huqkf7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: shrink deferred objects proportional to priority
has been added to the -mm tree.  Its filename is
     mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: shrink deferred objects proportional to priority

The number of deferred objects might get windup to an absurd number, and
it results in clamp of slab objects.  It is undesirable for sustaining
workingset.

So shrink deferred objects proportional to priority and cap nr_deferred to
twice of cache items.

The idea is borrowed from Dave Chinner's patch:
https://lore.kernel.org/linux-xfs/20191031234618.15403-13-david@fromorbit.com/

Tested with kernel build and vfs metadata heavy workload in our production
environment, no regression is spotted so far.

Link: https://lkml.kernel.org/r/20210311190845.9708-14-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   46 +++++++++++-----------------------------------
 1 file changed, 11 insertions(+), 35 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-shrink-deferred-objects-proportional-to-priority
+++ a/mm/vmscan.c
@@ -664,7 +664,6 @@ static unsigned long do_shrink_slab(stru
 	 */
 	nr = xchg_nr_deferred(shrinker, shrinkctl);
 
-	total_scan = nr;
 	if (shrinker->seeks) {
 		delta = freeable >> priority;
 		delta *= 4;
@@ -678,37 +677,9 @@ static unsigned long do_shrink_slab(stru
 		delta = freeable / 2;
 	}
 
+	total_scan = nr >> priority;
 	total_scan += delta;
-	if (total_scan < 0) {
-		pr_err("shrink_slab: %pS negative objects to delete nr=%ld\n",
-		       shrinker->scan_objects, total_scan);
-		total_scan = freeable;
-		next_deferred = nr;
-	} else
-		next_deferred = total_scan;
-
-	/*
-	 * We need to avoid excessive windup on filesystem shrinkers
-	 * due to large numbers of GFP_NOFS allocations causing the
-	 * shrinkers to return -1 all the time. This results in a large
-	 * nr being built up so when a shrink that can do some work
-	 * comes along it empties the entire cache due to nr >>>
-	 * freeable. This is bad for sustaining a working set in
-	 * memory.
-	 *
-	 * Hence only allow the shrinker to scan the entire cache when
-	 * a large delta change is calculated directly.
-	 */
-	if (delta < freeable / 4)
-		total_scan = min(total_scan, freeable / 2);
-
-	/*
-	 * Avoid risking looping forever due to too large nr value:
-	 * never try to free more than twice the estimate number of
-	 * freeable entries.
-	 */
-	if (total_scan > freeable * 2)
-		total_scan = freeable * 2;
+	total_scan = min(total_scan, (2 * freeable));
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
 				   freeable, delta, total_scan, priority);
@@ -747,10 +718,15 @@ static unsigned long do_shrink_slab(stru
 		cond_resched();
 	}
 
-	if (next_deferred >= scanned)
-		next_deferred -= scanned;
-	else
-		next_deferred = 0;
+	/*
+	 * The deferred work is increased by any new work (delta) that wasn't
+	 * done, decreased by old deferred work that was done now.
+	 *
+	 * And it is capped to two times of the freeable items.
+	 */
+	next_deferred = max_t(long, (nr + delta - scanned), 0);
+	next_deferred = min(next_deferred, (2 * freeable));
+
 	/*
 	 * move the unused scan count back into the shrinker in a
 	 * manner that handles concurrent updates.
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-vmscan-use-nid-from-shrink_control-for-tracepoint.patch
mm-vmscan-consolidate-shrinker_maps-handling-code.patch
mm-vmscan-use-shrinker_rwsem-to-protect-shrinker_maps-allocation.patch
mm-vmscan-remove-memcg_shrinker_map_size.patch
mm-vmscan-use-kvfree_rcu-instead-of-call_rcu.patch
mm-memcontrol-rename-shrinker_map-to-shrinker_info.patch
mm-vmscan-add-shrinker_info_protected-helper.patch
mm-vmscan-use-a-new-flag-to-indicate-shrinker-is-registered.patch
mm-vmscan-add-per-memcg-shrinker-nr_deferred.patch
mm-vmscan-use-per-memcg-nr_deferred-of-shrinker.patch
mm-vmscan-dont-need-allocate-shrinker-nr_deferred-for-memcg-aware-shrinkers.patch
mm-memcontrol-reparent-nr_deferred-when-memcg-offline.patch
mm-vmscan-shrink-deferred-objects-proportional-to-priority.patch

