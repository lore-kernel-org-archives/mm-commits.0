Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EBF38A9C1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898395; cv=none; b=UOd8PcGJozAdOnXVS24Jar7GBej9ERPbF3REOPt5CSvmxchmmMpC6I8EGmv/JbsoKElXnCSOCQ909/eBiCdZjXjcdgEBeF+zkZi4/OvL2QskvMry/Qp4iwOtpWRuFq9J/srUnH/0PEOVojlflY1VLBIZBwOwdgdFR7emGrl7zd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898395; c=relaxed/simple;
	bh=14ckoQOrppCiZX82wZKueAfgfWxEOkSdT5/IJPT2Km4=;
	h=Date:To:From:Subject:Message-Id; b=kSIUBqmi5xiED09sHLZDwaFmN6Oq7OtUzNpIP88+WkWpwINApjuXMxY5zb/IHTbgvGOazTPLlhX/wvXlGhi/uFH/UlYqXC4xKCrQirefvIZc8n/yPztfFlVZ6XiK7+xGU/LOza7np33TNoylOu5QrnQ1wUuQUSR5w/9wv6/24Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HO3wjWuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HO3wjWuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50754C4CEF1;
	Sat, 31 Jan 2026 22:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898395;
	bh=14ckoQOrppCiZX82wZKueAfgfWxEOkSdT5/IJPT2Km4=;
	h=Date:To:From:Subject:From;
	b=HO3wjWuOfpFx02SQ6KTlmtbDJ3xlL/utgtWUHF7MwL8v+xLlF15oBhj2BkTvGzwfN
	 5YFU69BIZrb9PIy8RMQSJgZOOodasOwGCerrEdxIiSe8auXYxFx3pMVadfnWTkG7/H
	 nHUF9OPsnWwH1EIe51ksdL0mF9adw3GjJ2kvMQek=
Date: Sat, 31 Jan 2026 14:26:34 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch removed from -mm tree
Message-Id: <20260131222635.50754C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
has been removed from the -mm tree.  Its filename was
     mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
Date: Sat, 20 Dec 2025 03:43:33 +0800

Now SWP_SYNCHRONOUS_IO devices are also using swap cache.  One side effect
is that a folio may stay in swap cache for a longer time due to lazy
freeing (vm_swap_full()).  This can help save some CPU / IO if folios are
being swapped out very frequently right after swapin, hence improving the
performance.  But the long pinning of swap slots also increases the
fragmentation rate of the swap device significantly, and currently, all
in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also causes the
backing memory to be pinned, increasing the memory pressure.

So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices after
swapin finishes.  Swap cache has served its role as a synchronization
layer to prevent any parallel swap-in from wasting CPU or memory
allocation, and the redundant IO is not a major concern for
SWP_SYNCHRONOUS_IO devices.

Worth noting, without this patch, this series so far can provide a ~30%
performance gain for certain workloads like MySQL or kernel compilation,
but causes significant regression or OOM when under extreme global
pressure.  With this patch, we still have a nice performance gain for most
workloads, and without introducing any observable regressions.  This is a
hint that further optimization can be done based on the new unified swapin
with swap cache, but for now, just keep the behaviour consistent with
before.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-4-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices
+++ a/mm/memory.c
@@ -4357,12 +4357,26 @@ static vm_fault_t remove_device_exclusiv
 	return 0;
 }
 
-static inline bool should_try_to_free_swap(struct folio *folio,
+/*
+ * Check if we should call folio_free_swap to free the swap cache.
+ * folio_free_swap only frees the swap cache to release the slot if swap
+ * count is zero, so we don't need to check the swap count here.
+ */
+static inline bool should_try_to_free_swap(struct swap_info_struct *si,
+					   struct folio *folio,
 					   struct vm_area_struct *vma,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
 		return false;
+	/*
+	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
+	 * cache can help save some IO or memory overhead, but these devices
+	 * are fast, and meanwhile, swap cache pinning the slot deferring the
+	 * release of metadata or fragmentation is a more critical issue.
+	 */
+	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		return true;
 	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
 	    folio_test_mlocked(folio))
 		return true;
@@ -4934,7 +4948,7 @@ check_folio:
 	 * yet.
 	 */
 	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(folio, vma, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

