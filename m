Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4360EC6FD1D
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbjDDVip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbjDDVio (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021713A9C
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D4863A30
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5DDC433D2;
        Tue,  4 Apr 2023 21:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644322;
        bh=yGMxBE9zosRdR/SqiXDyUf3FVS4IRb0MWCxNHXuspkg=;
        h=Date:To:From:Subject:From;
        b=QgGDtgPaf3FponSGUkBpt89v7J5pvHiEJMuzbqv/n96Bq73FBAMaAQOnAMtv5yUP0
         xjEmeQIev4ckAhDzxYTCgvlrbXGvV8JQ2nj4XP+Jrlj9W1DLQiDKtU7+2HEcPNuHNl
         Z16vIYFpdibGSWKUQ3nSORxENUzmWmE/zeKqISdk=
Date:   Tue, 04 Apr 2023 14:38:41 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, peterx@redhat.com, neilb@suse.de,
        mhocko@kernel.org, linmiaohe@huawei.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, djwong@kernel.org, david@redhat.com,
        david@fromorbit.com, cl@linux.com, 42.hyeyoo@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-move-set_task_reclaim_state-after-global_reclaim.patch added to mm-unstable branch
Message-Id: <20230404213841.DD5DDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move set_task_reclaim_state() after global_reclaim()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-move-set_task_reclaim_state-after-global_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-move-set_task_reclaim_state-after-global_reclaim.patch

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
Subject: mm: vmscan: move set_task_reclaim_state() after global_reclaim()
Date: Tue, 4 Apr 2023 00:13:51 +0000

Patch series "Ignore non-LRU-based reclaim in memcg reclaim", v4.

Upon running some proactive reclaim tests using memory.reclaim, we noticed
some tests flaking where writing to memory.reclaim would be successful
even though we did not reclaim the requested amount fully.  Looking
further into it, I discovered that *sometimes* we over-report the number
of reclaimed pages in memcg reclaim.

Reclaimed pages through other means than LRU-based reclaim are tracked
through reclaim_state in struct scan_control, which is stashed in current
task_struct.  These pages are added to the number of reclaimed pages
through LRUs.  For memcg reclaim, these pages generally cannot be linked
to the memcg under reclaim and can cause an overestimated count of
reclaimed pages.  This short series tries to address that.

Patches 1-2 are just refactoring, they add helpers that wrap some
operations on current->reclaim_state, and rename
reclaim_state->reclaimed_slab to reclaim_state->reclaimed.

Patch 3 ignores pages reclaimed outside of LRU reclaim in memcg reclaim. 
The pages are uncharged anyway, so even if we end up under-reporting
reclaimed pages we will still succeed in making progress during charging.

Do not be fooled by the diffstat - the core of this series is patch 3,
which has one line of code change.  All the rest is refactoring and one
huge comment.


This patch (of 3):

set_task_reclaim_state() is currently defined in mm/vmscan.c above an
#ifdef CONFIG_MEMCG block where global_reclaim() is defined.  We are about
to add some more helpers that operate on reclaim_state, and will need to
use global_reclaim().  Move set_task_reclaim_state() after the #ifdef
CONFIG_MEMCG block containing the definition of global_reclaim() to keep
helpers operating on reclaim_state together.

Link: https://lkml.kernel.org/r/20230404001353.468224-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20230404001353.468224-2-yosryahmed@google.com
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

 mm/vmscan.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-move-set_task_reclaim_state-after-global_reclaim
+++ a/mm/vmscan.c
@@ -189,18 +189,6 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
-static void set_task_reclaim_state(struct task_struct *task,
-				   struct reclaim_state *rs)
-{
-	/* Check for an overwrite */
-	WARN_ON_ONCE(rs && task->reclaim_state);
-
-	/* Check for the nulling of an already-nulled member */
-	WARN_ON_ONCE(!rs && !task->reclaim_state);
-
-	task->reclaim_state = rs;
-}
-
 LIST_HEAD(shrinker_list);
 DEFINE_MUTEX(shrinker_mutex);
 DEFINE_SRCU(shrinker_srcu);
@@ -528,6 +516,18 @@ static bool writeback_throttling_sane(st
 }
 #endif
 
+static void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs)
+{
+	/* Check for an overwrite */
+	WARN_ON_ONCE(rs && task->reclaim_state);
+
+	/* Check for the nulling of an already-nulled member */
+	WARN_ON_ONCE(!rs && !task->reclaim_state);
+
+	task->reclaim_state = rs;
+}
+
 static long xchg_nr_deferred(struct shrinker *shrinker,
 			     struct shrink_control *sc)
 {
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

