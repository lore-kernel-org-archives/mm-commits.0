Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7558F36E496
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896704; cv=none; b=YQvfwuZQg/xy3JrJ97dwOG2DmGZAr1iP4GgvjBBiTcvuStakgjrj2btUhIF7ER7x/VeAkVgffxb+4YwF2dju7cG/CStI9cVmvqdLuiCBXrWyJ3KVcIUEc+3r+VsJaGFbRw73X8ap0uc4/VbnRfyFh1BaLhcj3bWbPZg2PQB0MBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896704; c=relaxed/simple;
	bh=7TpDZMHFivTN410pr7XRdKs7OVpRTLpb2VOSm/59XTo=;
	h=Date:To:From:Subject:Message-Id; b=Xhv+Ef/gaplT6R7SwefAdTjzO3J+d8gQ7VdqxCqsypBrH2U3UpmRR44I/44C4LPmf80f1PdXv0bAaIwPE4ehLdymBMscdlT2o2qLFB1LTi0Ig63Gi0OqC7Qj00nQBltJKjlln4r1aHVwFx97WeTNwa2EkInbA+sQVugOTqU8//A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=psNQMUxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="psNQMUxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290E5C4CEF1;
	Sat, 31 Jan 2026 21:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896704;
	bh=7TpDZMHFivTN410pr7XRdKs7OVpRTLpb2VOSm/59XTo=;
	h=Date:To:From:Subject:From;
	b=psNQMUxROjGjQstYeP9hDXsYqUyxl+L2/DbXlsKUS5bnp/ud2gb9SxBjYuHMRTj38
	 Vl47fNSyK5/hisGA1UTha6jv0c/KDGap1amnk8dP3QdG6E60GqkS1c2n4bc7EN+Rl3
	 GwKL/1TME3MIqapr1R3D4gAHn4xpZGe4oCv2vn2Y=
Date: Sat, 31 Jan 2026 13:58:23 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,yi1.lai@linux.intel.com,ryncsn@gmail.com,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,clm@meta.com,clm@fb.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-cleanup-swap-entry-management-workflow-fix.patch removed from -mm tree
Message-Id: <20260131215824.290E5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix locking and leaking with hibernation snapshot releasing
has been removed from the -mm tree.  Its filename was
     mm-swap-cleanup-swap-entry-management-workflow-fix.patch

This patch was dropped because it was folded into mm-swap-cleanup-swap-entry-management-workflow.patch

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix locking and leaking with hibernation snapshot releasing
Date: Thu, 15 Jan 2026 00:15:27 +0800

fix leak, per Chris Mason.  Remove WARN_ON, per Lai Yi

Link: https://lkml.kernel.org/r/CAMgjq7AUz10uETVm8ozDWcB3XohkOqf0i33KGrAquvEVvfp5cg@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Lai Yi <yi1.lai@linux.intel.com>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/swap.c |    2 +-
 mm/swapfile.c       |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/power/swap.c~mm-swap-cleanup-swap-entry-management-workflow-fix
+++ a/kernel/power/swap.c
@@ -199,7 +199,7 @@ void free_all_swap_pages(int swap)
 		ext = rb_entry(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 
-		for (offset = ext->start; offset < ext->end; offset++)
+		for (offset = ext->start; offset <= ext->end; offset++)
 			swap_free_hibernation_slot(swp_entry(swap, offset));
 
 		kfree(ext);
--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-management-workflow-fix
+++ a/mm/swapfile.c
@@ -2096,7 +2096,6 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	swap_entry_put_locked(si, ci, entry, 1);
-	WARN_ON(swap_entry_swapped(si, entry));
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch
mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

