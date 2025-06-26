Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F7202990
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750972654; cv=none; b=B4P/ahHfiYoISz66L1gnenWU1YNnd5NN5e0GW0MT/1rrQpIJskR6TEQOZo3HnwF8gAoXOsZeDVDW1AnLG5Nmqk4E/HjvVMi01dgoDLvsAtbz6/27ns1yMZdwl7L2392tmtzBF/KvJp2luPAgfXJKcMifUjafIjXdCVMb6Adr9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750972654; c=relaxed/simple;
	bh=P9ZqIO/qGIGYp6lVAtLY6UFgaDdwL9+CmlE1yDIrSfI=;
	h=Date:To:From:Subject:Message-Id; b=WB2MlADs/wnHBvE3pv2JQIfeOV9mWZiT07NaN3bN/NQfFMvuRPO/1Me2C0XBiL344RsOge/uC1mhOqxQrh5waMCiS1+/7vO63VQ+OWBCEXJe88xOh5lFkW+osOk7l80/ND5AaqaqgF5eQVSmIf49iFKxLly7bDmdf0PDvu0kCSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q4SaM/GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q4SaM/GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB06C4CEEB;
	Thu, 26 Jun 2025 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750972654;
	bh=P9ZqIO/qGIGYp6lVAtLY6UFgaDdwL9+CmlE1yDIrSfI=;
	h=Date:To:From:Subject:From;
	b=Q4SaM/GFOMztTJWw7ZPCTWZe7qJjrczsCHAuNGZrHe14kxgbMc3VTua45R7bAgINh
	 0UxzINMAXIt4dOp/v5TRHd6+IYP7oTBmEDgHZ40y3tgjk3sTBg0WfP7Px3i8YS1v8R
	 j4iELWkkf17qEJaU7Zv6k8eN3SbkgrWXRxZdcxFg=
Date: Thu, 26 Jun 2025 14:17:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch added to mm-new branch
Message-Id: <20250626211734.0CB06C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: simplify weighted interleave bulk alloc calculations
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
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
mm-mempolicy-simplify-weighted-interleave-bulk-alloc-calculations.patch
mm-mempolicy-skip-extra-call-to-__alloc_pages_bulk-in-weighted-interleave.patch

