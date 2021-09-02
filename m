Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0860AC43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E39BE610E7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347914AbhIBV47 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347628AbhIBV4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5DD60E8B;
        Thu,  2 Sep 2021 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619747;
        bh=TZgBNOxI2/JSHhxbjHA+RWU0HPb/1PyvQOnta5uKIpw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=exW9pJkZfEA/h/rXMtNmcH6sGdS/Ua9f+yvXVNtDMPHbPzVJN0awfUBMKW2GnWGg8
         6t9POGLerGjbKf4bf8QhASsTmyjy+E7en46ITZegWtr4Bxcgmequ/6uUn0dlMtsNpE
         ZXpskmTK+M13aWhivJfGhtteWaEqLENihlPGIYPw=
Date:   Thu, 02 Sep 2021 14:55:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 108/212] memcg: cleanup racy sum avoidance code
Message-ID: <20210902215546.-ZRVZlmOv%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
