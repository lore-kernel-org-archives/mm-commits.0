Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2395C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D00B2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781324;
	bh=oQ8voHX5dfQMAOwgZvfX9mLPjnZLDynr9IV4MlZ0KUI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=JEKrnDDk0cXPPRVwnrf6rIYMF+aIkR0A+9v1noi8E+4GzNM9s/PcFjn0ssHo0yT+x
	 nenRG0VhjLNUIGBOvy0Wgfq7rBCD6I/kQ7MLXfJl+ThZFJe3puzhPK6LClwuv0JBgX
	 whcsTXZQSPMd3ChlrrrhRrQlT4I2nTRVvD8wWFf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgHGGWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGWD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62B8B221E5;
        Fri,  7 Aug 2020 06:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781322;
        bh=oQ8voHX5dfQMAOwgZvfX9mLPjnZLDynr9IV4MlZ0KUI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iFtudIPMk3G+AR1dQzn3PNGudcGimpz2TCm1HRcJhH6Br8LWtCA2/D8wp9/z9pU5m
         PdfZ4G8TwESptY+cStueZPkma7NnI9fytIy95+dXFagl5JtQKdgG/5zyk/cJgFQvyB
         0o0cMeWzbwSIKezWGM+3CGRqz5aO5l38qAWnzKao=
Date:   Thu, 06 Aug 2020 23:22:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 088/163] mm, memcg: avoid stale protection values
 when cgroup is above protection
Message-ID: <20200807062201.4toCRHwgc%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: avoid stale protection values when cgroup is above protection

Patch series "mm, memcg: memory.{low,min} reclaim fix & cleanup", v4.

This series contains a fix for a edge case in my earlier protection
calculation patches, and a patch to make the area overall a little more
robust to hopefully help avoid this in future.


This patch (of 2):

A cgroup can have both memory protection and a memory limit to isolate it
from its siblings in both directions - for example, to prevent it from
being shrunk below 2G under high pressure from outside, but also from
growing beyond 4G under low pressure.

Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
implemented proportional scan pressure so that multiple siblings in excess
of their protection settings don't get reclaimed equally but instead in
accordance to their unprotected portion.

During limit reclaim, this proportionality shouldn't apply of course:
there is no competition, all pressure is from within the cgroup and should
be applied as such.  Reclaim should operate at full efficiency.

However, mem_cgroup_protected() never expected anybody to look at the
effective protection values when it indicated that the cgroup is above its
protection.  As a result, a query during limit reclaim may return stale
protection values that were calculated by a previous reclaim cycle in
which the cgroup did have siblings.

When this happens, reclaim is unnecessarily hesitant and potentially slow
to meet the desired limit.  In theory this could lead to premature OOM
kills, although it's not obvious this has occurred in practice.

Workaround the problem by special casing reclaim roots in
mem_cgroup_protection.  These memcgs are never participating in the
reclaim protection because the reclaim is internal.

We have to ignore effective protection values for reclaim roots because
mem_cgroup_protected might be called from racing reclaim contexts with
different roots.  Calculation is relying on root -> leaf tree traversal
therefore top-down reclaim protection invariants should hold.  The only
exception is the reclaim root which should have effective protection set
to 0 but that would be problematic for the following setup:

 Let's have global and A's reclaim in parallel:
  |
  A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
  |\
  | C (low = 1G, usage = 2.5G)
  B (low = 1G, usage = 0.5G)

 for A reclaim we have
 B.elow = B.low
 C.elow = C.low

 For the global reclaim
 A.elow = A.low
 B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
 C.elow = min(C.usage, C.low)

 With the effective values resetting we have A reclaim
 A.elow = 0
 B.elow = B.low
 C.elow = C.low

 and global reclaim could see the above and then
 B.elow = C.elow = 0 because children_low_usage > A.elow

Which means that protected memcgs would get reclaimed.

In future we would like to make mem_cgroup_protected more robust against
racing reclaim contexts but that is likely more complex solution than this
simple workaround.

[hannes@cmpxchg.org - large part of the changelog]
[mhocko@suse.com - workaround explanation]
[chris@chrisdown.name - retitle]
Link: http://lkml.kernel.org/r/cover.1594638158.git.chris@chrisdown.name
Link: http://lkml.kernel.org/r/044fb8ecffd001c7905d27c0c2ad998069fdc396.1594638158.git.chris@chrisdown.name
Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   42 +++++++++++++++++++++++++++++++++--
 mm/memcontrol.c            |    8 ++++++
 mm/vmscan.c                |    3 +-
 3 files changed, 50 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection
+++ a/include/linux/memcontrol.h
@@ -355,12 +355,49 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
+static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
+						  struct mem_cgroup *memcg,
 						  bool in_low_reclaim)
 {
 	if (mem_cgroup_disabled())
 		return 0;
 
+	/*
+	 * There is no reclaim protection applied to a targeted reclaim.
+	 * We are special casing this specific case here because
+	 * mem_cgroup_protected calculation is not robust enough to keep
+	 * the protection invariant for calculated effective values for
+	 * parallel reclaimers with different reclaim target. This is
+	 * especially a problem for tail memcgs (as they have pages on LRU)
+	 * which would want to have effective values 0 for targeted reclaim
+	 * but a different value for external reclaim.
+	 *
+	 * Example
+	 * Let's have global and A's reclaim in parallel:
+	 *  |
+	 *  A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
+	 *  |\
+	 *  | C (low = 1G, usage = 2.5G)
+	 *  B (low = 1G, usage = 0.5G)
+	 *
+	 * For the global reclaim
+	 * A.elow = A.low
+	 * B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
+	 * C.elow = min(C.usage, C.low)
+	 *
+	 * With the effective values resetting we have A reclaim
+	 * A.elow = 0
+	 * B.elow = B.low
+	 * C.elow = C.low
+	 *
+	 * If the global reclaim races with A's reclaim then
+	 * B.elow = C.elow = 0 because children_low_usage > A.elow)
+	 * is possible and reclaiming B would be violating the protection.
+	 *
+	 */
+	if (root == memcg)
+		return 0;
+
 	if (in_low_reclaim)
 		return READ_ONCE(memcg->memory.emin);
 
@@ -891,7 +928,8 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
+static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
+						  struct mem_cgroup *memcg,
 						  bool in_low_reclaim)
 {
 	return 0;
--- a/mm/memcontrol.c~mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection
+++ a/mm/memcontrol.c
@@ -6605,6 +6605,14 @@ enum mem_cgroup_protection mem_cgroup_pr
 
 	if (!root)
 		root = root_mem_cgroup;
+
+	/*
+	 * Effective values of the reclaim targets are ignored so they
+	 * can be stale. Have a look at mem_cgroup_protection for more
+	 * details.
+	 * TODO: calculation should be more robust so that we do not need
+	 * that special casing.
+	 */
 	if (memcg == root)
 		return MEMCG_PROT_NONE;
 
--- a/mm/vmscan.c~mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection
+++ a/mm/vmscan.c
@@ -2331,7 +2331,8 @@ out:
 		unsigned long protection;
 
 		lruvec_size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-		protection = mem_cgroup_protection(memcg,
+		protection = mem_cgroup_protection(sc->target_mem_cgroup,
+						   memcg,
 						   sc->memcg_low_reclaim);
 
 		if (protection) {
_
