Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EA4330B01
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779147004; cv=none; b=pb/5a6hHbqfb+2E+qdkM66Y3vdO3ZBlQlNhsAAV7KwoqtRbpXomux+UgZf/BUzyvzErL0M97H9AE/87NRJLn9Gl2dRFBoBAPyffgTPgqdLkoLhChA9cYKqHIKu8U0ssW2xQyzyEnmZXIbsXBzjxQzUlQjfsnpbJQXO0K5qAJqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779147004; c=relaxed/simple;
	bh=MAMdogP2ykPZY10YdYC5W9/4jMgrIlsqsrEdZ+tZI1c=;
	h=Date:To:From:Subject:Message-Id; b=mNIEwe7txUmYYNelbTmcDBErlE+KcPSVRpSpd4MokNKtcZ2umzOR0HP7XvDGq3KcGy2zXbHqHbZHkyA/WA8gKBN2Q92qGMFMNDJ2RpbhZpoiENEWMRQIb9+ElhNxVQoFh/g7HrKXM9FhwXJM8x2+/E8wSjJWIYVN7/yPczXQNIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XtA3Wcv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XtA3Wcv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0237EC2BCB7;
	Mon, 18 May 2026 23:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779147004;
	bh=MAMdogP2ykPZY10YdYC5W9/4jMgrIlsqsrEdZ+tZI1c=;
	h=Date:To:From:Subject:From;
	b=XtA3Wcv+cp5RBz/THZb7oc+JQmIGguytV9xU8wM3HLuMt6Jq8bnEaQ6PF5c5LK6bT
	 221toBr/Ard7YHt4Dz+PsZbmKStkbPw2ZI/Csd+Q4Nft6gcxvewaBbRdcPqEFz0GKi
	 vlKj3irXs6rB6dn0SgkGiQ7SoAEfZsL8vU5M83NM=
Date: Mon, 18 May 2026 16:30:03 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,leitao@debian.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2.patch added to mm-new branch
Message-Id: <20260518233004.0237EC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2
Date: Fri, 15 May 2026 17:44:14 +0800

- Fix another race found by sashiko:
  https://lore.kernel.org/linux-mm/CAMgjq7CQM+vzjQ-dgnAjvE8+czs1FmrK7Cv+EJ6jCGysa8OSqQ@mail.gmail.com/
- The change is minor, stress tests are looking good, so I kept the old tags.
- Update commit message, swapoff could indeed leak the extend table.

Link: https://lore.kernel.org/20260515-swap-extend-table-fix-v2-1-833d72ad53e5@tencent.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/linux-mm/agG6Dp0umhs6O1SY@gmail.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2
+++ a/mm/swapfile.c
@@ -1537,13 +1537,21 @@ static void __swap_cluster_put_entry(str
 		if (count == (SWP_TB_COUNT_MAX - 1)) {
 			ci->extend_table[ci_off] = 0;
 			__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, count));
-			swap_extend_table_try_free(ci);
 		} else {
 			ci->extend_table[ci_off] = count;
 		}
 	} else {
 		__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, --count));
 	}
+
+	/*
+	 * `SWP_TB_COUNT_MAX - 1` triggers extend table allocation. If the
+	 * count was above that, then the extend table is no longer needed,
+	 * so free it. And if we just put the count value from MAX - 1, it's
+	 * also possible that a pending dup just attached an extend table.
+	 */
+	if (unlikely(count == SWP_TB_COUNT_MAX - 2 || count == SWP_TB_COUNT_MAX - 1))
+		swap_extend_table_try_free(ci);
 }
 
 /**
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch
mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch
mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2.patch
mm-swap-simplify-swap-cache-allocation-helper.patch
mm-swap-move-common-swap-cache-operations-into-standalone-helpers.patch
mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch
mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly.patch
mm-swap-unify-large-folio-allocation.patch
mm-memcg-swap-tidy-up-cgroup-v1-memsw-swap-helpers.patch
mm-swap-support-flexible-batch-freeing-of-slots-in-different-memcgs.patch
mm-swap-delay-and-unify-memcg-lookup-and-charging-for-swapin.patch
mm-swap-consolidate-cluster-allocation-helpers.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly.patch
mm-memcg-remove-no-longer-used-swap-cgroup-array.patch
mm-swap-merge-zeromap-into-swap-table.patch

