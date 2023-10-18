Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB250CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjJRVfW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjJRVfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A88126
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:34:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76575C433CB;
        Wed, 18 Oct 2023 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664891;
        bh=f0FH8iZcuC6UwFKuV275oKUY6ZplbxJyolOS+5MCy50=;
        h=Date:To:From:Subject:From;
        b=TJ9kAyO64djea9kWSvB0RjiNNjW0xAwRibjjCyDQwo21RdflpYDy1oovws+MX4OiS
         lRQVPHB3+qESv7zofahpc/DHs3nJBGKYTxWGUmHwrkAygZAqitXcQOXGTboXUKyLXU
         xdQBigYhdeHFfsgpS/qNt/mQTwdH++VK/WoHkQd8=
Date:   Wed, 18 Oct 2023 14:34:50 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
        mhocko@kernel.org, hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch removed from -mm tree
Message-Id: <20231018213451.76575C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: normalize the value passed into memcg_rstat_updated()
has been removed from the -mm tree.  Its filename was
     mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: normalize the value passed into memcg_rstat_updated()
Date: Fri, 22 Sep 2023 17:57:40 +0000

memcg_rstat_updated() uses the value of the state update to keep track of
the magnitude of pending updates, so that we only do a stats flush when
it's worth the work.  Most values passed into memcg_rstat_updated() are in
pages, however, a few of them are actually in bytes or KBs.

To put this into perspective, a 512 byte slab allocation today would look
the same as allocating 512 pages.  This may result in premature flushes,
which means unnecessary work and latency.

Normalize all the state values passed into memcg_rstat_updated() to pages.
Round up non-zero sub-page to 1 page, because memcg_rstat_updated()
ignores 0 page updates.

Link: https://lkml.kernel.org/r/20230922175741.635002-3-yosryahmed@google.com
Fixes: 5b3be698a872 ("memcg: better bounds on the memcg stats updates")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-normalize-the-value-passed-into-memcg_rstat_updated
+++ a/mm/memcontrol.c
@@ -763,6 +763,22 @@ unsigned long memcg_page_state(struct me
 	return x;
 }
 
+static int memcg_page_state_unit(int item);
+
+/*
+ * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
+ * up non-zero sub-page updates to 1 page as zero page updates are ignored.
+ */
+static int memcg_state_val_in_pages(int idx, int val)
+{
+	int unit = memcg_page_state_unit(idx);
+
+	if (!val || unit == PAGE_SIZE)
+		return val;
+	else
+		return max(val * unit / PAGE_SIZE, 1UL);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -775,7 +791,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -826,7 +842,7 @@ void __mod_memcg_lruvec_state(struct lru
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
 
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 	memcg_stats_unlock();
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-change-flush_next_time-to-flush_last_time.patch
mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch
mm-memcg-make-stats-flushing-threshold-per-memcg.patch
mm-memcg-make-stats-flushing-threshold-per-memcg-fix.patch
mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
mm-memcg-restore-subtree-stats-flushing.patch

