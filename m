From: akpm@linux-foundation.org
Subject: [to-be-updated]
 =?US-ASCII?Q?mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-?=
 =?US-ASCII?Q?protection.patch?= removed from -mm tree
Date: Tue, 05 May 2020 12:54:58 -0700
Message-ID: <20200505195458.kozMxY4l3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEETy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 15:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: avoid stale protection values when cgroup is above protection
has been removed from the -mm tree.  Its filename was
     mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: avoid stale protection values when cgroup is above protection

Patch series "mm: memcontrol: memory.{low,min} reclaim fix & cleanup".

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
[hannes@cmpxchg.org: rework code comment]
[hannes@cmpxchg.org: changelog]
[chris@chrisdown.name: fix store tear]
[chris@chrisdown.name: retitle]
Link: http://lkml.kernel.org/r/cover.1588092152.git.chris@chrisdown.name
Link: http://lkml.kernel.org/r/d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name
Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-avoid-stale-protection-values-when-cgroup-is-above-protection
+++ a/mm/memcontrol.c
@@ -6392,8 +6392,19 @@ enum mem_cgroup_protection mem_cgroup_pr
 
 	if (!root)
 		root = root_mem_cgroup;
-	if (memcg == root)
+	if (memcg == root) {
+		/*
+		 * The cgroup is the reclaim root in this reclaim
+		 * cycle, and therefore not protected. But it may have
+		 * stale effective protection values from previous
+		 * cycles in which it was not the reclaim root - for
+		 * example, global reclaim followed by limit reclaim.
+		 * Reset these values for mem_cgroup_protection().
+		 */
+		WRITE_ONCE(memcg->memory.emin, 0);
+		WRITE_ONCE(memcg->memory.elow, 0);
 		return MEMCG_PROT_NONE;
+	}
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch
mm-memcg-fix-inconsistent-oom-event-behavior.patch
mm-memcg-add-workingset_restore-in-memorystat.patch
