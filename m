Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F25C77B6E
	for <mm-commits@archiver.kernel.org>; Thu, 13 Apr 2023 21:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjDMVrj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Apr 2023 17:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDMVri (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2023 17:47:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F72140E8
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 14:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B048615CD
        for <mm-commits@vger.kernel.org>; Thu, 13 Apr 2023 21:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B78C433EF;
        Thu, 13 Apr 2023 21:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681422456;
        bh=q2fS32Xno5PRoBtFGsHnHFgJ4kxT+51WftsThm2ZD64=;
        h=Date:To:From:Subject:From;
        b=g7qZ/82y+EstsA9XN7X1SDEroVzGWtwZzGG1WR9OLU5E1+O1x6IS/a3K/4/b02IuU
         vStzxzPUEWJvj4JZ+1fjTyPlKoe2PoI5mZwO8iJsNZOkj+2adzmpEf30rRAr4ElVXo
         OUNs1L39JiKNMLfOFSGAKvpHCrEItSaCdNVHcD+Y=
Date:   Thu, 13 Apr 2023 14:47:35 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, vbabka@suse.cz,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, peterx@redhat.com,
        neilb@suse.de, mhocko@kernel.org, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, djwong@kernel.org,
        david@redhat.com, david@fromorbit.com, cl@linux.com,
        42.hyeyoo@gmail.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch added to mm-unstable branch
Message-Id: <20230413214736.58B78C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move set_task_reclaim_state() near flush_reclaim_state()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch

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
Subject: mm: vmscan: move set_task_reclaim_state() near flush_reclaim_state()
Date: Thu, 13 Apr 2023 10:40:33 +0000

Move set_task_reclaim_state() near flush_reclaim_state() so that all
helpers manipulating reclaim_state are in close proximity.

Link: https://lkml.kernel.org/r/20230413104034.1086717-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state
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
 /*
  * flush_reclaim_state(): add pages reclaimed outside of LRU-based reclaim to
  * scan_control->nr_reclaimed.
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
memcg-page_cgroup_ino-get-memcg-from-the-pages-folio.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch
mm-vmscan-move-set_task_reclaim_state-near-flush_reclaim_state.patch
mm-vmscan-refactor-updating-current-reclaim_state.patch

