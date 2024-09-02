Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010F57CB6
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247791; cv=none; b=Jpflg63groZuhkz2iP+CqLzp9aJ8yQLAryirBHtagSKykgS0kZUMf5vQB3JauZEHzq2WwQ04S92N+uOn7t2uEv2XWg18tz8OaqsmhbIqA8JcrgVL6Ob/OL0lhinpwt/BHDNIXw0oR3MMgvFTpD5//7XJUApP+tj/X6aZyfEdZj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247791; c=relaxed/simple;
	bh=a5XSyVTuvQCyPLE/Pi1mUx33SaOJO2T6jEgtj9h2R6A=;
	h=Date:To:From:Subject:Message-Id; b=HNjGaOPKgOTG6muH/eWmNYTxZ+0+eGgk6tNZENLz+sm9eWOtytkB98TMW1s/0hfPEdqr4EHmfMFSIslZ0mlXnTexUREi9QWgmg1jEkNZjhpTMuMvL6OEv3l/4rahaajfHy3d2A8aRQsRB8ej+aepYcYoxL6rw9EccnVyo2jR2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SD19+5uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SD19+5uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE85C4CEC2;
	Mon,  2 Sep 2024 03:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247791;
	bh=a5XSyVTuvQCyPLE/Pi1mUx33SaOJO2T6jEgtj9h2R6A=;
	h=Date:To:From:Subject:From;
	b=SD19+5uLSEybmdhSG9AKi8jMC3E99MKdBj5mYnKZa/Ai5DOH/dnM6ifAMkJdj5E4Q
	 35tXawB+q2lB8tqfNS8CHp6icJo3iHu9JQFH6Mko6WeUsyicsb8pBpwtnCDzUEuCrF
	 EYUpvNgdCVsNk7lNnJ/cMLaTAl6RhDdCWKg/xVvI=
Date: Sun, 01 Sep 2024 20:29:50 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,ioworker0@gmail.com,yuanchu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true.patch removed from -mm tree
Message-Id: <20240902032951.2FE85C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: multi-gen LRU: ignore non-leaf pmd_young for force_scan=true
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuanchu Xie <yuanchu@google.com>
Subject: mm: multi-gen LRU: ignore non-leaf pmd_young for force_scan=true
Date: Tue, 13 Aug 2024 09:37:59 -0700

When non-leaf pmd accessed bits are available, MGLRU page table walks can
clear the non-leaf pmd accessed bit and ignore the accessed bit on the pte
if it's on a different node, skipping a generation update as well.  If
another scan occurs on the same node as said skipped pte.

The non-leaf pmd accessed bit might remain cleared and the pte accessed
bits won't be checked.  While this is sufficient for reclaim-driven aging,
where the goal is to select a reasonably cold page, the access can be
missed when aging proactively for workingset estimation of a node/memcg.

In more detail, get_pfn_folio returns NULL if the folio's nid != node
under scanning, so the page table walk skips processing of said pte.  Now
the pmd_young flag on this pmd is cleared, and if none of the pte's are
accessed before another scan occurs on the folio's node, the pmd_young
check fails and the pte accessed bit is skipped.

Since force_scan disables various other optimizations, we check force_scan
to ignore the non-leaf pmd accessed bit.

Link: https://lkml.kernel.org/r/20240813163759.742675-1-yuanchu@google.com
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true
+++ a/mm/vmscan.c
@@ -3481,7 +3481,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (should_clear_pmd_young())
+			if (!walk->force_scan && should_clear_pmd_young())
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
@@ -3568,7 +3568,7 @@ restart:
 
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (should_clear_pmd_young()) {
+		if (!walk->force_scan && should_clear_pmd_young()) {
 			if (!pmd_young(val))
 				continue;
 
_

Patches currently in -mm which might be from yuanchu@google.com are


