Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A228EA3D
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723574128; cv=none; b=TVJ2FxW6+/+O7dvNNhupu5Mr7wJiaY2V0H/HvauGSaNQvxFQRTdYg/+bVpfwOJKBIVwRY0aBo0Hggxd0MzoaZ3gQYmUrlgf/0aU0BwWNaUak1dL5rVGNhnDC1e1LyhmiT91J1WDdPTSx2h7kCEs2nAC7WC2Rg0pp9bp4r9C9HHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723574128; c=relaxed/simple;
	bh=tR3Qo6ouHEFCLRckwCkw6B7jEz4XCiu+A3j7NPoH69k=;
	h=Date:To:From:Subject:Message-Id; b=K8bNoYheXAo4KqO1I2npz8qf6jtQtxh9Tbi/mNifJAk9Ei9fHd3jQJxSo8ZyJFsqq9h/KY9M1VOqVHsLfkMD0jIe+DJfrZQUlSuIsOPiYZAplBlgIWgC17dB2SR2c2LDiD86iuXl7MpJkcNHjpiFlvFj8087Sffab/L04AYjaW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GxE/Gy0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GxE/Gy0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE9CC32782;
	Tue, 13 Aug 2024 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723574128;
	bh=tR3Qo6ouHEFCLRckwCkw6B7jEz4XCiu+A3j7NPoH69k=;
	h=Date:To:From:Subject:From;
	b=GxE/Gy0f3SUL5SU9YlS7Gg0sIqXrJvvj+Mil3fEkYalWQKmCdfZbYqo6Eqo3jueYh
	 /V9HNPVBukLY3RRViKZFfMtl3M1+locS4OOrN04GdSpRSbfS1b3yZlB7O0lIQrwEVP
	 vT5v1R4VmRm9ReyDvOtnT42TjCalIy10Rvx72t/Q=
Date: Tue, 13 Aug 2024 11:35:27 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,ioworker0@gmail.com,yuanchu@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true.patch added to mm-unstable branch
Message-Id: <20240813183528.1EE9CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: multi-gen LRU: ignore non-leaf pmd_young for force_scan=true
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3499,7 +3499,7 @@ static void walk_pmd_range_locked(pud_t
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (should_clear_pmd_young())
+			if (!walk->force_scan && should_clear_pmd_young())
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
@@ -3586,7 +3586,7 @@ restart:
 
 		walk->mm_stats[MM_NONLEAF_TOTAL]++;
 
-		if (should_clear_pmd_young()) {
+		if (!walk->force_scan && should_clear_pmd_young()) {
 			if (!pmd_young(val))
 				continue;
 
_

Patches currently in -mm which might be from yuanchu@google.com are

mm-multi-gen-lru-ignore-non-leaf-pmd_young-for-force_scan=true.patch

