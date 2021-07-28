Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBA1C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 19:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F53C61040
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jul 2021 19:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhG1ToB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhG1ToB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Jul 2021 15:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8555260234;
        Wed, 28 Jul 2021 19:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627501438;
        bh=DX0B5Wi2GzTXL5nYzTwe+87LvFsIh1fhvX2OLWfpHjQ=;
        h=Date:From:To:Subject:From;
        b=hhbTbVnG0iLyMvdPYeBbwwZch8Jqe7YjEJ4es2TuGm9e4AtfOE9YLA/EIHItX2z8f
         ZUVg7hR3TFvl0hdlocI9H9TbCfbH3IRQ5jJDCEvrJ546BlC9xnj04arvuxfC+XghqU
         o6f2D2mNdS7fxZkv0+peSrESYbWLvgCPFO84yHP8=
Date:   Wed, 28 Jul 2021 12:43:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org,
        guro@fb.com, david@redhat.com, shakeelb@google.com
Subject:  + memcg-cleanup-racy-sum-avoidance-code.patch added to -mm
 tree
Message-ID: <20210728194358.jpJTD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup racy sum avoidance code
has been added to the -mm tree.  Its filename is
     memcg-cleanup-racy-sum-avoidance-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-cleanup-racy-sum-avoidance-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-cleanup-racy-sum-avoidance-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: cleanup racy sum avoidance code

We used to have per-cpu memcg and lruvec stats and the readers have to
traverse and sum the stats from each cpu.  This summing was racy and may
expose transient negative values.  So, an explicit check was added to
avoid such scenarios.  Now these stats are moved to rstat infrastructure
and are no more per-cpu, so we can remove the fixup for transient negative
values.

Link: https://lkml.kernel.org/r/20210728012243.3369123-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/include/linux/memcontrol.h~memcg-cleanup-racy-sum-avoidance-code
+++ a/include/linux/memcontrol.h
@@ -977,30 +977,19 @@ static inline void mod_memcg_state(struc
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	long x = READ_ONCE(memcg->vmstats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
+	return READ_ONCE(memcg->vmstats.state[idx]);
 }
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
-	long x;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
+	return READ_ONCE(pn->lruvec_stats.state[idx]);
 }
 
 static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
_

Patches currently in -mm which might be from shakeelb@google.com are

slub-fix-unreclaimable-slab-stat-for-bulk-free.patch
writeback-memcg-simplify-cgroup_writeback_by_id.patch
memcg-switch-lruvec-stats-to-rstat.patch
memcg-infrastructure-to-flush-memcg-stats.patch
memcg-infrastructure-to-flush-memcg-stats-v5.patch
memcg-cleanup-racy-sum-avoidance-code.patch

