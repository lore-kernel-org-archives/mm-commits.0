Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D41135F5E5
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 03:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026775; cv=none; b=MHffmkIrellxl9q3mmiHs6WWc0MRhZfKGVg2KaFoswKA/40VZPoNr/z7tX3uiPoU6GmcQd9BJImZjQGlvbkamUdfKKG3Xheav7qCZImtK/vuVevKwEZzZioTZS4PeIK9Kp1FT98ZpAD0QggKjJpsdgxh9OtlVTPtj6SGHK4WAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026775; c=relaxed/simple;
	bh=B1TP0Ub7R7ZaHYDNMOzuATSvv2+argOH9g2VANz+Ma4=;
	h=Date:To:From:Subject:Message-Id; b=rEc7KkQyJc8ji9cf4eKSfxc9gB28J9sJQBYoZqr0yT+fhasDXxHs83TQPfuNj0Mx+Xg6xvLtS/7SBzwCDvcRyeDmoNBIN6F+XQ+y45gVXR+prXQ75cFPTHjBhHrRKh6BwcBfGgDZsbF9Ut6w9JqkmCfUvEOJpJt3Ck0lDy1cQGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exjPb24+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exjPb24+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC1E1F000E9;
	Fri, 29 May 2026 03:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780026774;
	bh=WyR7FPcNTJcJCQk08ihfD7dIlaffbX1pR60AIepIpgU=;
	h=Date:To:From:Subject;
	b=exjPb24+7usQOMrkGOLnr0/n4/LA3kBsCjEJliNt9rJxLtI6n5FwQSqBKE9swbkfU
	 XSNwyzK0B/KQS2fxZDgGVsr4VX71YpIwxnpEtn6NqAdg5xRMPwnI2jnu/xmHbV0E8Z
	 GgKd87sD57+IjFv74gpsFe/GDGht0II+odXspzIE=
Date: Thu, 28 May 2026 20:52:53 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,leitao@debian.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2.patch removed from -mm tree
Message-Id: <20260529035254.2CC1E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2.patch

This patch was dropped because it was folded into mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch

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

mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch
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

