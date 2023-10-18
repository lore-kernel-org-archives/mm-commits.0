Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968F9CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjJRVfQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjJRVfO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D6D124
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:34:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724C0C433C9;
        Wed, 18 Oct 2023 21:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664890;
        bh=f7wwKiAffyn3MVAs0wQVk7cxWyFdp7oyW6dKtnvMx0c=;
        h=Date:To:From:Subject:From;
        b=OTzlMHCdD6HCp9UpwgfIOooVXRl2AfMj/gNzv1KV+2cO4g9BrHLcQ9XG8e81YTsYb
         QF1/ed3Kn7gUY+z2fp8V4E0F4vh749th6eQPeV994A6Do44FstYTe7iVlEsFfsyNNj
         J9hYW4c1yU3ZIWFU7ZVKUjF2XuCREl88xpbcZsLg=
Date:   Wed, 18 Oct 2023 14:34:49 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-refactor-page-state-unit-helpers.patch removed from -mm tree
Message-Id: <20231018213450.724C0C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: refactor page state unit helpers
has been removed from the -mm tree.  Its filename was
     mm-memcg-refactor-page-state-unit-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: refactor page state unit helpers
Date: Fri, 22 Sep 2023 17:57:39 +0000

Patch series "mm: memcg: fix tracking of pending stats updates values", v2.

While working on adjacent code [1], I realized that the values passed into
memcg_rstat_updated() to keep track of the magnitude of pending updates is
consistent.  It is mostly in pages, but sometimes it can be in bytes or
KBs.  Fix that.

Patch 1 reworks memcg_page_state_unit() so that we can reuse it in patch 2
to check and normalize the units of state updates.

[1]https://lore.kernel.org/lkml/20230921081057.3440885-1-yosryahmed@google.com/


This patch (of 2):

memcg_page_state_unit() is currently used to identify the unit of a memcg
state item so that all stats in memory.stat are in bytes.  However, it
lies about the units of WORKINGSET_* stats.  These stats actually
represent pages, but we present them to userspace as a scalar number of
events.  In retrospect, maybe those stats should have been memcg "events"
rather than memcg "state".

In preparation for using memcg_page_state_unit() for other purposes that
need to know the truthful units of different stat items, break it down
into two helpers:
- memcg_page_state_unit() retuns the actual unit of the item.
- memcg_page_state_output_unit() returns the unit used for output.

Use the latter instead of the former in memcg_page_state_output() and
lruvec_page_state_output().  While we are at it, let's show cgroup v1 some
love and add memcg_page_state_local_output() for consistency.

No functional change intended.

Link: https://lkml.kernel.org/r/20230922175741.635002-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20230922175741.635002-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-refactor-page-state-unit-helpers
+++ a/mm/memcontrol.c
@@ -1535,7 +1535,7 @@ static const struct memory_stat memory_s
 	{ "workingset_nodereclaim",	WORKINGSET_NODERECLAIM		},
 };
 
-/* Translate stat items to the correct unit for memory.stat output */
+/* The actual unit of the state item, not the same as the output unit */
 static int memcg_page_state_unit(int item)
 {
 	switch (item) {
@@ -1543,6 +1543,22 @@ static int memcg_page_state_unit(int ite
 	case MEMCG_ZSWAP_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
+		return 1;
+	case NR_KERNEL_STACK_KB:
+		return SZ_1K;
+	default:
+		return PAGE_SIZE;
+	}
+}
+
+/* Translate stat items to the correct unit for memory.stat output */
+static int memcg_page_state_output_unit(int item)
+{
+	/*
+	 * Workingset state is actually in pages, but we export it to userspace
+	 * as a scalar count of events, so special case it here.
+	 */
+	switch (item) {
 	case WORKINGSET_REFAULT_ANON:
 	case WORKINGSET_REFAULT_FILE:
 	case WORKINGSET_ACTIVATE_ANON:
@@ -1551,17 +1567,23 @@ static int memcg_page_state_unit(int ite
 	case WORKINGSET_RESTORE_FILE:
 	case WORKINGSET_NODERECLAIM:
 		return 1;
-	case NR_KERNEL_STACK_KB:
-		return SZ_1K;
 	default:
-		return PAGE_SIZE;
+		return memcg_page_state_unit(item);
 	}
 }
 
 static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
 						    int item)
 {
-	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
+	return memcg_page_state(memcg, item) *
+		memcg_page_state_output_unit(item);
+}
+
+static inline unsigned long memcg_page_state_local_output(
+		struct mem_cgroup *memcg, int item)
+{
+	return memcg_page_state_local(memcg, item) *
+		memcg_page_state_output_unit(item);
 }
 
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
@@ -4113,9 +4135,8 @@ static void memcg1_stat_format(struct me
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
-			   nr * memcg_page_state_unit(memcg1_stats[i]));
+		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
+		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -4141,9 +4162,9 @@ static void memcg1_stat_format(struct me
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state(memcg, memcg1_stats[i]);
+		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
+			       (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -6625,7 +6646,8 @@ static int memory_stat_show(struct seq_f
 static inline unsigned long lruvec_page_state_output(struct lruvec *lruvec,
 						     int item)
 {
-	return lruvec_page_state(lruvec, item) * memcg_page_state_unit(item);
+	return lruvec_page_state(lruvec, item) *
+		memcg_page_state_output_unit(item);
 }
 
 static int memory_numa_stat_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-change-flush_next_time-to-flush_last_time.patch
mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
mm-memcg-make-stats-flushing-threshold-per-memcg.patch
mm-memcg-make-stats-flushing-threshold-per-memcg-fix.patch
mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
mm-memcg-restore-subtree-stats-flushing.patch

