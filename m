Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC5436C5BB
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 23:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780096968; cv=none; b=OCPXL1a4L0S7N3ETlt4omCffzjV3ycXxHutHfu2IYpV2h946OUEJ/x4y0nkdsmDobd99oD7Kjt89dRX3069UMvke6/58HBUChE+FoksY50C4xTPiWwBAnp8F4c+f+hGECqPS7VtW+ma8BF4CDmShht82AI/yLONbOLmB+4HfPuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780096968; c=relaxed/simple;
	bh=fxS0c5s9+8VNaIaol5MvYpYvWjDFcc6rZqRYE45S+OE=;
	h=Date:To:From:Subject:Message-Id; b=FxiD6BqKM/bf5ybq2xZaGM5iiD8qGdtEnpoIjO2baIv3myYBs6VOh+OD01YbM2JDLk6vKlSjBXYt2Tue3S2bgUaQseaRWqM6saZCWvNIllszVpLKj0PFcpN59DMbAK52Huo2LG2ceaq3jJ8qOxuwyHX8qYlb6/zsRE4mb5U2tj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YFHghwzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YFHghwzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C111F00893;
	Fri, 29 May 2026 23:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780096966;
	bh=YVbHrEWe0bQm2cWGmekbhv+M0/GQFTw7DcNt7GDYSgQ=;
	h=Date:To:From:Subject;
	b=YFHghwzKAFKEAOeto1cqeDbr/d12xqj6O4KT7sB0Yv+7J25lB9O76T89A+gawFMsQ
	 ReZP84TgtAbOmbGB4izS1nUV9KdqdcAv8d3gyUtIHxeLC1+SEwk7v7dJCEmz/+zwV6
	 1jEn9ML7h6tVPy78W3wo9O4vSC3CgT4/mvEwBIbs=
Date: Fri, 29 May 2026 16:22:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,linux@rasmusvillemoes.dk,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nodemask-correctly-describe-nodemask-operation-return-types.patch added to mm-unstable branch
Message-Id: <20260529232246.C3C111F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/nodemask: correctly describe nodemask operation return types
has been added to the -mm mm-unstable branch.  Its filename is
     mm-nodemask-correctly-describe-nodemask-operation-return-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nodemask-correctly-describe-nodemask-operation-return-types.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-nodemask-correctly-describe-nodemask-operation-return-types.patch

