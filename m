Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC3017557E
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968127; cv=none; b=FbAIlvlkcUCo5FVxQkj6fZEbZ3QSbNkj0EewCMVdXivxyIwI0U4umq3wEpCrG5kFCYvitalk1gJ7cX93QOi+zjzaRUGKxfGx4CCUOARB7ngecxGTxAVbdYtkd+GWWzeiwWP1xIRitgnBmslY31edkqs3HhaESaQMFwp5GGU6AF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968127; c=relaxed/simple;
	bh=gsb8N/FCxLIJpOrQT9WCKMKtBdxREGdZTkflKdsOpPI=;
	h=Date:To:From:Subject:Message-Id; b=A3d8U4b1xlgGs3KTBwq+DQQKP4f9pivTi3cNtaFvBD1mt2Rvr7pevSOb64+bHx2Hc85HmW8tjyovLu0II58cqI/Zy1fkv3rEowexkzOsRLHCbrVGUQdOTwRefNpRK0BpG3JqTbyLlirAqXiHf/T88SAebYMYGXyNY5Ebr2r0I0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lcBU2CBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lcBU2CBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA791F00893;
	Tue,  9 Jun 2026 01:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968125;
	bh=L1qJLzsWuj9CSEcblyQzKyqJvUK1kCu9VNhaF0H6/4k=;
	h=Date:To:From:Subject;
	b=lcBU2CBKfwhHtMa9utb8Xy/6bd64mnyqt0mB5FbLre4obxGM+tOJkKKEd3Q0+XdBv
	 YH7UK2lIdJR2yp28JdGVgZkYdTTg+bMI4rcLh4LoxQxwA6CD0pRNL68++L6+ENuEkh
	 Bm4pjJhcMTaPeiXtCg9yptc6FmW/cL05FYwzp8p0=
Date: Mon, 08 Jun 2026 18:22:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,sj@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,linux@rasmusvillemoes.dk,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nodemask-correctly-describe-nodemask-operation-return-types.patch removed from -mm tree
Message-Id: <20260609012205.6CA791F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/nodemask: correctly describe nodemask operation return types
has been removed from the -mm tree.  Its filename was
     mm-nodemask-correctly-describe-nodemask-operation-return-types.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/nodemask: correctly describe nodemask operation return types
Date: Fri, 29 May 2026 13:27:54 -0700

Commit 0dfe54071d7c8 ("nodemask: Fix return values to be unsigned")
changed a number of nodemask operations that used to return int to
returning a bool instead.  However, it did not update the comment block
that described these functions, leaving the documentation incorrect.

Fix the comment block to accurately describe the functions.  Also fix a
typo (unsigend --> unsigned), and fix a callsite in mempolicy.c that did
not get updated during the conversion.

No functional changes intended; changes are purely cosmetic.

Link: https://lore.kernel.org/20260529202755.1846800-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   18 +++++++++---------
 mm/mempolicy.c           |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/nodemask.h~mm-nodemask-correctly-describe-nodemask-operation-return-types
+++ a/include/linux/nodemask.h
@@ -24,23 +24,23 @@
  * void nodes_setall(mask)		set all bits
  * void nodes_clear(mask)		clear all bits
  * int node_isset(node, mask)		true iff bit 'node' set in mask
- * int node_test_and_set(node, mask)	test and set bit 'node' in mask
+ * bool node_test_and_set(node, mask)	test and set bit 'node' in mask
  *
- * void nodes_and(dst, src1, src2)	dst = src1 & src2  [intersection]
+ * bool nodes_and(dst, src1, src2)	dst = src1 & src2  [intersection]
  * void nodes_or(dst, src1, src2)	dst = src1 | src2  [union]
  * void nodes_xor(dst, src1, src2)	dst = src1 ^ src2
- * void nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
+ * bool nodes_andnot(dst, src1, src2)	dst = src1 & ~src2
  * void nodes_complement(dst, src)	dst = ~src
  *
- * int nodes_equal(mask1, mask2)	Does mask1 == mask2?
- * int nodes_intersects(mask1, mask2)	Do mask1 and mask2 intersect?
- * int nodes_subset(mask1, mask2)	Is mask1 a subset of mask2?
- * int nodes_empty(mask)		Is mask empty (no bits sets)?
- * int nodes_full(mask)			Is mask full (all bits sets)?
+ * bool nodes_equal(mask1, mask2)	Does mask1 == mask2?
+ * bool nodes_intersects(mask1, mask2)	Do mask1 and mask2 intersect?
+ * bool nodes_subset(mask1, mask2)	Is mask1 a subset of mask2?
+ * bool nodes_empty(mask)		Is mask empty (no bits sets)?
+ * bool nodes_full(mask)		Is mask full (all bits sets)?
  * int nodes_weight(mask)		Hamming weight - number of set bits
  *
  * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
- * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
+ * unsigned int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
  * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
  *					or MAX_NUMNODES
  * unsigned int first_unset_node(mask)	First node not set in mask, or
--- a/mm/mempolicy.c~mm-nodemask-correctly-describe-nodemask-operation-return-types
+++ a/mm/mempolicy.c
@@ -2865,7 +2865,7 @@ bool __mpol_equal(struct mempolicy *a, s
 	case MPOL_PREFERRED:
 	case MPOL_PREFERRED_MANY:
 	case MPOL_WEIGHTED_INTERLEAVE:
-		return !!nodes_equal(a->nodes, b->nodes);
+		return nodes_equal(a->nodes, b->nodes);
 	case MPOL_LOCAL:
 		return true;
 	default:
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


