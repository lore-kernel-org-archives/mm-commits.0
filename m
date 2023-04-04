Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920B0C761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbjDDViv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbjDDViu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19363A8C
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DD4C63A2B
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85993C433EF;
        Tue,  4 Apr 2023 21:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644328;
        bh=qCTXdGND5qujcYVocQmb95SlbyqXH1viX4iFjDnP7Fw=;
        h=Date:To:From:Subject:From;
        b=ecGcOoZegKN+V6j1ch8xH2fzSWHbwoPrx3aekQtQ+P4XHjKvYR0J2Cj1rI6JZJ8WA
         jrftcvjncFY/8IQ31h4ZacSlZR5JF6bFiJPzM437eC++J35OqEylo/jjwKghpfu8Kp
         7FK2TiIgnV3RoWycG1fn4U8ZkpMPEliKZ4ZnKJZo=
Date:   Tue, 04 Apr 2023 14:38:48 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, peterx@redhat.com, neilb@suse.de,
        mhocko@kernel.org, linmiaohe@huawei.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, djwong@kernel.org, david@redhat.com,
        david@fromorbit.com, cl@linux.com, 42.hyeyoo@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch added to mm-unstable branch
Message-Id: <20230404213848.85993C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
Date: Tue, 4 Apr 2023 00:13:53 +0000

We keep track of different types of reclaimed pages through
reclaim_state->reclaimed, and we add them to the reported number of
reclaimed pages.  For non-memcg reclaim, this makes sense.  For memcg
reclaim, we have no clue if those pages are charged to the memcg under
reclaim.

Slab pages are shared by different memcgs, so a freed slab page may have
only been partially charged to the memcg under reclaim.  The same goes for
clean file pages from pruned inodes (on highmem systems) or xfs buffer
pages, there is no simple way to currently link them to the memcg under
reclaim.

Stop reporting those freed pages as reclaimed pages during memcg reclaim. 
This should make the return value of writing to memory.reclaim, and may
help reduce unnecessary reclaim retries during memcg charging.  Writing to
memory.reclaim on the root memcg is considered as cgroup_reclaim(), but
for this case we want to include any freed pages, so use the
global_reclaim() check instead.

Generally, this should make the return value of
try_to_free_mem_cgroup_pages() more accurate.  In some limited cases (e.g.
freed a slab page that was mostly charged to the memcg under reclaim),
the return value of try_to_free_mem_cgroup_pages() can be underestimated,
but this should be fine.  The freed pages will be uncharged anyway, and we
can charge the memcg the next time around as we usually do memcg reclaim
in a retry loop.

Link: https://lkml.kernel.org/r/20230404001353.468224-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim
+++ a/mm/vmscan.c
@@ -535,7 +535,35 @@ static void set_task_reclaim_state(struc
 static void flush_reclaim_state(struct scan_control *sc,
 				struct reclaim_state *rs)
 {
-	if (rs) {
+	/*
+	 * Currently, reclaim_state->reclaimed includes three types of pages
+	 * freed outside of vmscan:
+	 * (1) Slab pages.
+	 * (2) Clean file pages from pruned inodes.
+	 * (3) XFS freed buffer pages.
+	 *
+	 * For all of these cases, we have no way of finding out whether these
+	 * pages were related to the memcg under reclaim. For example, a freed
+	 * slab page could have had only a single object charged to the memcg
+	 * under reclaim. Also, populated inodes are not on shrinker LRUs
+	 * anymore except on highmem systems.
+	 *
+	 * Instead of over-reporting the reclaimed pages in a memcg reclaim,
+	 * only count such pages in global reclaim. This prevents unnecessary
+	 * retries during memcg charging and false positive from proactive
+	 * reclaim (memory.reclaim).
+	 *
+	 * For uncommon cases were the freed pages were actually significantly
+	 * charged to the memcg under reclaim, and we end up under-reporting, it
+	 * should be fine. The freed pages will be uncharged anyway, even if
+	 * they are not reported properly, and we will be able to make forward
+	 * progress in charging (which is usually in a retry loop).
+	 *
+	 * We can go one step further, and report the uncharged objcg pages in
+	 * memcg reclaim, to make reporting more accurate and reduce
+	 * under-reporting, but it's probably not worth the complexity for now.
+	 */
+	if (rs && global_reclaim(sc)) {
 		sc->nr_reclaimed += rs->reclaimed;
 		rs->reclaimed = 0;
 	}
_

Patches currently in -mm which might be from yosryahmed@google.com are

cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch
memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch
memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch
mm-vmscan-move-set_task_reclaim_state-after-global_reclaim.patch
mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch

