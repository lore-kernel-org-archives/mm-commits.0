Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D66C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C4F6113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349566AbhICU7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350495AbhICU7B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7213D610FB;
        Fri,  3 Sep 2021 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702680;
        bh=TjvZvXVEDG1XZPSeob0t4yKRygTYvewt7XyXkcr+i/c=;
        h=Date:From:To:Subject:From;
        b=j0rHDOrdqe+0ukkqdvjHiBWBj0hOgqELyBfbv1EJawzRwWHIoqRf4im4j0C+805k0
         dwJavbLueg4r2hWShUcpGfgpVDEk2O9Qs86JZ2n8E2ECY2fKasHHse3qkaeevZCfKW
         freGPfssMfeqs27H8KQ3aQvtL52UzoNTdgUy7wVk=
Date:   Fri, 03 Sep 2021 13:58:00 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] memcg-cleanup-racy-sum-avoidance-code.patch
 removed from -mm tree
Message-ID: <20210903205800.IqBUCYOGN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup racy sum avoidance code
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-racy-sum-avoidance-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.com>
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


