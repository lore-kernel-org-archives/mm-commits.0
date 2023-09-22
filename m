Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF02BCD484A
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 18:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjIVSDW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Sep 2023 14:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjIVSDV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Sep 2023 14:03:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC110B7
        for <mm-commits@vger.kernel.org>; Fri, 22 Sep 2023 11:03:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D47C433C8;
        Fri, 22 Sep 2023 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695405795;
        bh=12D7mfXM2BRS473yamUrR6wq3aCWW8fI3W78Qdr0FAA=;
        h=Date:To:From:Subject:From;
        b=KJIJ25TTmS+EVtMfbpbcRE3sz+eLibVlAnFdJ2ghyOaQf1OD3L4j4akqQy7i0w1XM
         UshJ1ZgFqSu046qG9OIFDcbRyGIB5iy1nMqCcbjLbBun87ZlGWSY6wRmF3ZsgQQIA0
         CmyT/H/YLL696AbC6oGGeQn0Vohi5bzM0lsa3f90=
Date:   Fri, 22 Sep 2023 11:03:14 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-refactor-page-state-unit-helpers.patch added to mm-unstable branch
Message-Id: <20230922180315.55D47C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: refactor page state unit helpers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-refactor-page-state-unit-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-refactor-page-state-unit-helpers.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -4106,9 +4128,8 @@ static void memcg1_stat_format(struct me
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
-			   nr * memcg_page_state_unit(memcg1_stats[i]));
+		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
+		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -4134,9 +4155,9 @@ static void memcg1_stat_format(struct me
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state(memcg, memcg1_stats[i]);
+		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
+			       (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
@@ -6614,7 +6635,8 @@ static int memory_stat_show(struct seq_f
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

mm-memcg-refactor-page-state-unit-helpers.patch
mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch

