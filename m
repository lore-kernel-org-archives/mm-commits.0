Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194D7F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dCiEUgai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7E7C433C8;
	Tue, 12 Dec 2023 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407550;
	bh=vWNh5u3Bw9pJ18/McCijDDX+Q1AopyrK2EJ5PrBT4zQ=;
	h=Date:To:From:Subject:From;
	b=dCiEUgaiPq2aOS8PHGIkaIZnp6IHz8sQvx1HDFB58yhiep6MdsbydezVQsV2WwQyy
	 tZu2TWRpxfjE7Q4zlmZTJrWC/EEC6sld0lcAS/rdO4jNphsBg4CCXyme90hWpQ5qpc
	 Klnenau2Syjj0uY7nDwdRTQjNGIq8+z9L3ayz12o=
Date: Tue, 12 Dec 2023 10:59:10 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-mtree_range_walk-clean-up.patch removed from -mm tree
Message-Id: <20231212185910.BE7E7C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: mtree_range_walk() clean up
has been removed from the -mm tree.  Its filename was
     maple_tree-mtree_range_walk-clean-up.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: mtree_range_walk() clean up
Date: Wed, 1 Nov 2023 13:16:29 -0400

mtree_range_walk() needed to be updated to avoid checking if there was a
pivot value.  On closer examination, the code could avoid setting min or
max in certain scenarios.  The commit removes the extra check for
pivot[offset] before setting max and only sets max when necessary.  It
also only sets min if it is necessary by checking offset 0 prior to the
loop (as it has always done).

The commit also drops a dead node check since the end of the node will
return the array size when the last slot is occupied (by a potential reuse
in a dead node).  The data will be discarded later if the node is marked
dead.

Benchmarking these changes results in an increase in performance of 5.45%
using the BENCH_WALK in the maple tree test code.

Link: https://lkml.kernel.org/r/20231101171629.3612299-13-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mtree_range_walk-clean-up
+++ a/lib/maple_tree.c
@@ -2806,32 +2806,29 @@ static inline void *mtree_range_walk(str
 	min = mas->min;
 	max = mas->max;
 	do {
-		offset = 0;
 		last = next;
 		node = mte_to_node(next);
 		type = mte_node_type(next);
 		pivots = ma_pivots(node, type);
 		end = ma_data_end(node, type, pivots, max);
-		if (unlikely(ma_dead_node(node)))
-			goto dead_node;
-
-		if (pivots[offset] >= mas->index) {
-			prev_max = max;
-			prev_min = min;
-			max = pivots[offset];
+		prev_min = min;
+		prev_max = max;
+		if (pivots[0] >= mas->index) {
+			offset = 0;
+			max = pivots[0];
 			goto next;
 		}
 
-		do {
+		offset = 1;
+		while (offset < end) {
+			if (pivots[offset] >= mas->index) {
+				max = pivots[offset];
+				break;
+			}
 			offset++;
-		} while ((offset < end) && (pivots[offset] < mas->index));
+		}
 
-		prev_min = min;
 		min = pivots[offset - 1] + 1;
-		prev_max = max;
-		if (likely(offset < end && pivots[offset]))
-			max = pivots[offset];
-
 next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


