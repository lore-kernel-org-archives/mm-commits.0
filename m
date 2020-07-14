Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F200C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB05C21841
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 01:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594688614;
	bh=u4ywBEqt+I2cHjBKONZp29QQB/hdvk9QHG0RJZCotek=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=M8Iufe5hTs3xGAcwM0T4O04pZ9/0nui8eyj6zPy+d7Wj/39j7eu1a3QOA9sWWCDSd
	 /VxgBAgRolsOQB3blPP14zGh0mscw6O+YjKfjxxWg81RWjmSOW9A1jw26pL+vuw3QA
	 Sri+KSc2ONb4BX6aRA3aQU1gDIMmymiqgI114ZSY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgGNBDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgGNBDe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 21:03:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C5A217BA;
        Tue, 14 Jul 2020 01:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594688613;
        bh=u4ywBEqt+I2cHjBKONZp29QQB/hdvk9QHG0RJZCotek=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oqO8F3jTIO1qbU8zZMCm6GTI4PuRlxg8ZTWr/s47iMOUr+eWQnhhg3w7pukZL5s3X
         slO2LuFsHZfACljVW8TuUgZYRsQIMf4bo72ua6+XF6hpPkC3QpkOEzDkYTztwvj4Ui
         IqRgL0BY1FfDlHNc4yn8D0UncvgPVlDsTludS0PM=
Date:   Mon, 13 Jul 2020 18:03:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-?=
 =?US-ASCII?Q?protection.patch?= added to -mm tree
Message-ID: <20200714010330.7qs10F-VM%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: avoid stale protection values when cgroup is above protection
has been added to the -mm tree.  Its filename is
     mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -363,12 +363,49 @@ static inline bool mem_cgroup_disabled(v
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
 
@@ -899,7 +936,8 @@ static inline void memcg_memory_event_mm
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
@@ -6595,6 +6595,14 @@ enum mem_cgroup_protection mem_cgroup_pr
 
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

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate.patch
mm-oom-make-the-calculation-of-oom-badness-more-accurate-v3.patch

