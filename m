Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CDD2FE04D
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268292; cv=none; b=BYh1UQ7pKCmH2dr4HOpqNmleb+pHZ9ui3NAytk8ZERmxeDZWZW8I7N31mDVfmAhVnHQAT27ZZHRy4KJYzWIYRry9FBtWUnNzddEo/9vt6QRkr0+dMkEkA7fPgLVT+Iz4IUULoKRBVt3G9OjpevSzpWHAin5BWixkWYWJ1t7gyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268292; c=relaxed/simple;
	bh=Gm1vICQ6BN3t/uIQL/sGvU1oqUiXNsfs4e5lpjL8n88=;
	h=Date:To:From:Subject:Message-Id; b=lMEwLzFfTW1FOfp1wVQKvfzg8NbMOFgdgeY20k4GkUIUv5UQxLpFztW29DeLEoWmlfU9yJ+roaZbrTa6HWZl+1tCF1OcgyESnEmBLWQmHegXhCGhpvmMDspheuqg0z3lYPpjsihZy7L71r/xOhD+MJ7mEsweffEbjay8MeynXN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w/RfjkMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w/RfjkMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14944C4CEF5;
	Sat, 20 Dec 2025 22:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268292;
	bh=Gm1vICQ6BN3t/uIQL/sGvU1oqUiXNsfs4e5lpjL8n88=;
	h=Date:To:From:Subject:From;
	b=w/RfjkMjvHw+i/K54paLVRxeAZxdCfebMCwrQycjf8RPnHbG866Y7vvlVLyPfYpGu
	 tKkD+9wQHCW2DYSjYZ7W5VfwWFievi6RMaeos2mJjjTY9rdTXDuntxRHPFT9s7DHY5
	 dnkYdz0+jyzr6ma5W6UH9LKxC9YpxTYtOiqSKahQ=
Date: Sat, 20 Dec 2025 14:04:51 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch added to mm-new branch
Message-Id: <20251220220452.14944C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices
+++ a/mm/memory.c
@@ -4354,12 +4354,26 @@ static vm_fault_t remove_device_exclusiv
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
@@ -4931,7 +4945,7 @@ check_folio:
 	 * yet.
 	 */
 	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(folio, vma, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
_

Patches currently in -mm which might be from kasong@tencent.com are

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

