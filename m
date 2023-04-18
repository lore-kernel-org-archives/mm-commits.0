Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57ECC77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjDRXi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjDRXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF53A10259
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0F563A01
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11F7C433D2;
        Tue, 18 Apr 2023 23:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860949;
        bh=MMsfg/7/ozMPFCbdZvJ/DbPz3VEPT2m89ErVGtEcR1I=;
        h=Date:To:From:Subject:From;
        b=twFYVwMqqV5LpS0+vykxLy7tJlrYetPUlvTn4gUm4NhJrCZw/fcsTt7ilr5KmuHGK
         pyOcdU/+lQZmBpTPHtPWvWi2Gzw4oc0SjprP0rhePb/dt+wJSjrBhF/R5juu+4FjUh
         knGd9/udm3zaukzwCv3GP5Xine1DQzonOOokZLVA=
Date:   Tue, 18 Apr 2023 16:35:48 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, vbabka@suse.cz,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, peterx@redhat.com,
        neilb@suse.de, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, djwong@kernel.org,
        david@redhat.com, david@fromorbit.com, cl@linux.com,
        42.hyeyoo@gmail.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch removed from -mm tree
Message-Id: <20230418233548.E11F7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
Date: Thu, 13 Apr 2023 10:40:32 +0000

Patch series "Ignore non-LRU-based reclaim in memcg reclaim", v6.

Upon running some proactive reclaim tests using memory.reclaim, we noticed
some tests flaking where writing to memory.reclaim would be successful
even though we did not reclaim the requested amount fully Looking further
into it, I discovered that *sometimes* we overestimate the number of
reclaimed pages in memcg reclaim.

Reclaimed pages through other means than LRU-based reclaim are tracked
through reclaim_state in struct scan_control, which is stashed in current
task_struct.  These pages are added to the number of reclaimed pages
through LRUs.  For memcg reclaim, these pages generally cannot be linked
to the memcg under reclaim and can cause an overestimated count of
reclaimed pages.  This short series tries to address that.

Patch 1 ignores pages reclaimed outside of LRU reclaim in memcg reclaim. 
The pages are uncharged anyway, so even if we end up under-reporting
reclaimed pages we will still succeed in making progress during charging.

Patches 2-3 are just refactoring.  Patch 2 moves set_reclaim_state()
helper next to flush_reclaim_state().  Patch 3 adds a helper that wraps
updating current->reclaim_state, and renames reclaim_state->reclaimed_slab
to reclaim_state->reclaimed.


This patch (of 3):

We keep track of different types of reclaimed pages through
reclaim_state->reclaimed_slab, and we add them to the reported number of
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
global_reclaim() check instead of !cgroup_reclaim().

Generally, this should make the return value of
try_to_free_mem_cgroup_pages() more accurate.  In some limited cases (e.g.
freed a slab page that was mostly charged to the memcg under reclaim),
the return value of try_to_free_mem_cgroup_pages() can be underestimated,
but this should be fine.  The freed pages will be uncharged anyway, and we
can charge the memcg the next time around as we usually do memcg reclaim
in a retry loop.

Link: https://lkml.kernel.org/r/20230413104034.1086717-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20230413104034.1086717-2-yosryahmed@google.com
Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
instead of pages")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim
+++ a/mm/vmscan.c
@@ -528,6 +528,46 @@ static bool writeback_throttling_sane(st
 }
 #endif
 
+/*
+ * flush_reclaim_state(): add pages reclaimed outside of LRU-based reclaim to
+ * scan_control->nr_reclaimed.
+ */
+static void flush_reclaim_state(struct scan_control *sc)
+{
+	/*
+	 * Currently, reclaim_state->reclaimed includes three types of pages
+	 * freed outside of vmscan:
+	 * (1) Slab pages.
+	 * (2) Clean file pages from pruned inodes (on highmem systems).
+	 * (3) XFS freed buffer pages.
+	 *
+	 * For all of these cases, we cannot universally link the pages to a
+	 * single memcg. For example, a memcg-aware shrinker can free one object
+	 * charged to the target memcg, causing an entire page to be freed.
+	 * If we count the entire page as reclaimed from the memcg, we end up
+	 * overestimating the reclaimed amount (potentially under-reclaiming).
+	 *
+	 * Only count such pages for global reclaim to prevent under-reclaiming
+	 * from the target memcg; preventing unnecessary retries during memcg
+	 * charging and false positives from proactive reclaim.
+	 *
+	 * For uncommon cases where the freed pages were actually mostly
+	 * charged to the target memcg, we end up underestimating the reclaimed
+	 * amount. This should be fine. The freed pages will be uncharged
+	 * anyway, even if they are not counted here properly, and we will be
+	 * able to make forward progress in charging (which is usually in a
+	 * retry loop).
+	 *
+	 * We can go one step further, and report the uncharged objcg pages in
+	 * memcg reclaim, to make reporting more accurate and reduce
+	 * underestimation, but it's probably not worth the complexity for now.
+	 */
+	if (current->reclaim_state && global_reclaim(sc)) {
+		sc->nr_reclaimed += current->reclaim_state->reclaimed;
+		current->reclaim_state->reclaimed = 0;
+	}
+}
+
 static long xchg_nr_deferred(struct shrinker *shrinker,
 			     struct shrink_control *sc)
 {
@@ -5362,8 +5402,7 @@ static int shrink_one(struct lruvec *lru
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
 			   sc->nr_reclaimed - reclaimed);
 
-	sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
-	current->reclaim_state->reclaimed_slab = 0;
+	flush_reclaim_state(sc);
 
 	return success ? MEMCG_LRU_YOUNG : 0;
 }
@@ -6462,7 +6501,6 @@ static void shrink_node_memcgs(pg_data_t
 
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
-	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
@@ -6484,10 +6522,7 @@ again:
 
 	shrink_node_memcgs(pgdat, sc);
 
-	if (reclaim_state) {
-		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-		reclaim_state->reclaimed_slab = 0;
-	}
+	flush_reclaim_state(sc);
 
 	nr_node_reclaimed = sc->nr_reclaimed - nr_reclaimed;
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

