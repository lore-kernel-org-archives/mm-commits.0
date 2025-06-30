Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E7423185E
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 22:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322927; cv=none; b=Cv+xibhFNA/d5uR7TRzfSGPsA7nCaMLIlvkRhc2mcwzu9as/7urjnmnAWXGbkN93DLFqyD+7KoPQ6WE+YkT9rAn7p0/fEQne35kc10XxX3nJh5fLxTkUd7PyyL+bebyJDAbf/mxWMJmxAc1PvN7iwBM6LsZ4vyQdTy+PzORymko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322927; c=relaxed/simple;
	bh=dJcYe7lR4OUhrXEJcV1IBmV75rQoxm3iDcI7BYVTS7I=;
	h=Date:To:From:Subject:Message-Id; b=OGA+V9adeed5QT0Bb5Qn8WvXasct4tHI0tWuhT+UUeHDGyb2IIyxA3I0xxX525XIUNYkmO7UxVIYxZG/kd5RCbikbLsqdImRAa1jOKakCHDNT/bd25q0/G+IUnjMst1QXgccEXIEXwKRrZ4Pat0hV9CoZ9M9CNl+aY19FRwOkE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hiLiGhza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hiLiGhza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D89C4CEE3;
	Mon, 30 Jun 2025 22:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751322927;
	bh=dJcYe7lR4OUhrXEJcV1IBmV75rQoxm3iDcI7BYVTS7I=;
	h=Date:To:From:Subject:From;
	b=hiLiGhza6+kvNBnbgytRRxnBaOnDUwz5jZ/9EK7FW0tiKjy3iWZx1vARvKK6j5SAE
	 SybsvtquxyPKGeylzUug9uEvDU91ck5WQHyr4AaqmVFHehnepUwygKlUMCnnk76dgu
	 mMIsLJ8vsMuvPErwy/d5Aa0wpBzITZ0IRlXbTKDA=
Date: Mon, 30 Jun 2025 15:35:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,osalvador@suse.de,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch removed from -mm tree
Message-Id: <20250630223526.F3D89C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: simplify weighted interleave bulk alloc calculations
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: simplify weighted interleave bulk alloc calculations
Date: Thu, 26 Jun 2025 13:09:33 -0700

Patch series "mm/mempolicy: Cleanup and optimization for weighted
interleave".

Two small patches for weighted interleave bulk allocaton.

The first patch simplifies the delta calculation needed for the allocations,
removing an if-else and performing unconditional additions instead.

The second patch makes a minor improvement to the weighted interleave bulk
allocation function by skipping a call to __alloc_pages_bulk.

Running a quick benchmark by compiling the kernel shows a small increase
in performance. These experiments were run on a machine with 2 nodes, each
with 125GB memory and 40 CPUs.

time numactl -w 0,1 make -j$(nproc)

+----------+---------+------------+---------+
| Time (s) |  6.16   | With patch | % Delta |
+----------+---------+------------+---------+
| Real     |  88.374 |    88.3356 | -0.2019 |
| User     |  3631.7 |   3636.263 |  0.0631 |
| Sys      | 366.029 |    363.792 | -0.7534 |
+----------+---------+------------+---------+


This patch (of 2):

Simplify the math used to figure out how many pages should be allocated
per node.  Instead of making conditional additions and deletions, we can
just make them unconditional by using min().  No functional changes
intended.

Link: https://lkml.kernel.org/r/20250626200936.3974420-1-joshua.hahnjy@gmail.com
Link: https://lkml.kernel.org/r/20250626200936.3974420-2-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations
+++ a/mm/mempolicy.c
@@ -2645,18 +2645,15 @@ static unsigned long alloc_pages_bulk_we
 	for (i = 0; i < nnodes; i++) {
 		node = next_node_in(prev_node, nodes);
 		weight = weights[node];
-		node_pages = weight * rounds;
-		/* If a delta exists, add this node's portion of the delta */
-		if (delta > weight) {
-			node_pages += weight;
-			delta -= weight;
-		} else if (delta) {
-			/* when delta is depleted, resume from that node */
-			node_pages += delta;
+		/* when delta is depleted, resume from that node */
+		if (delta && delta < weight) {
 			resume_node = node;
 			resume_weight = weight - delta;
-			delta = 0;
 		}
+		/* Add the node's portion of the delta, if there is one */
+		node_pages = weight * rounds + min(delta, weight);
+		delta -= min(delta, weight);
+
 		/* node_pages can be 0 if an allocation fails and rounds == 0 */
 		if (!node_pages)
 			break;
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-skip-unnecessary-synchronize_rcu.patch
mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch

