Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8971FF1C7
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 20:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751055410; cv=none; b=H2m3I/Ftwcj/meCyW9CUBouEMIP4Dg9/3gARqE4nGT91z1rBOX9opTqn9l13bM8OnkViw/5Ku112ViXzsNofoKDJYXYqiqLhIt+fwzkF6XERyzoEzl61pf2CgiuT0QLZz8v2pNqGPbP8zyJ0CfcjwVUWnn4eGgVQ+dUfV/vf2Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751055410; c=relaxed/simple;
	bh=V+w3sL+m/Lbyd4mO4u0RyoW+yQq+SpEs0L1PsJV1hik=;
	h=Date:To:From:Subject:Message-Id; b=lqYqAa8sYwTbhtEYgo9b1CHUPHCi5JlKKb2u+gYfkBtDa1kZKyHABKRlUSVGnKi9KVpBi+treKb5TqnqTr45ZJI4NyG36y+QEOiry3A1Tf5cQCuDNpvU/vlYJfnmoEhwNvt5zJqSsAlSWScAHJyHk1C1yaN468vX01rnxcYE2TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USK3Ok+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USK3Ok+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A5AC4CEE3;
	Fri, 27 Jun 2025 20:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751055409;
	bh=V+w3sL+m/Lbyd4mO4u0RyoW+yQq+SpEs0L1PsJV1hik=;
	h=Date:To:From:Subject:From;
	b=USK3Ok+d7UMxA6vGvaHln2cAx3kqxNXWKdkIG3QbGffQg/LQ8lBhd80AUYiH6h0RT
	 0zUjrhtWhx4sCuIJDX6piP5q2cZF0Sd4JHqaASfnC9JYAvFqtXCFmKf6YHR7w+eScV
	 UOomxaEu53xdzyyK6iRJwVdIS9BSHu4TWMB90WUo=
Date: Fri, 27 Jun 2025 13:16:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch added to mm-new branch
Message-Id: <20250627201649.77A5AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
Date: Fri, 27 Jun 2025 14:20:18 +0800

Currently if THP swapin failed due to reasons like partially conflicting
swap cache or ZSWAP enabled, it will fallback to cached swapin.

Right now the swap cache has a non-trivial overhead, and readahead is not
helpful for SWP_SYNCHRONOUS_IO devices, so we should always skip the
readahead and swap cache even if the swapin falls back to order 0.

So handle the fallback logic without falling back to the cached read.

Also slightly tweak the behavior if the WARN_ON is triggered (shmem
mapping is corrupted or buggy code) as a side effect, just return with
-EINVAL.  This should be OK as things are already very wrong beyond
recovery at that point.

Link: https://lkml.kernel.org/r/20250627062020.534-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   68 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io
+++ a/mm/shmem.c
@@ -1975,13 +1975,15 @@ unlock:
 	return ERR_PTR(error);
 }
 
-static struct folio *shmem_swap_alloc_folio(struct inode *inode,
+static struct folio *shmem_swapin_direct(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int nr_pages = 1 << order;
 	struct folio *new;
+	pgoff_t offset;
+	gfp_t swap_gfp;
 	void *shadow;
 
 	/*
@@ -1989,6 +1991,7 @@ static struct folio *shmem_swap_alloc_fo
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
+	swap_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);
@@ -2003,20 +2006,23 @@ static struct folio *shmem_swap_alloc_fo
 		if ((vma && unlikely(userfaultfd_armed(vma))) ||
 		     !zswap_never_enabled() ||
 		     non_swapcache_batch(entry, nr_pages) != nr_pages) {
-			return ERR_PTR(-EINVAL);
+			goto fallback;
 		} else {
-			gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+			swap_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 		}
 	}
-
-	new = shmem_alloc_folio(gfp, order, info, index);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
+retry:
+	new = shmem_alloc_folio(swap_gfp, order, info, index);
+	if (!new) {
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
+	}
 
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
-					   gfp, entry)) {
+					   swap_gfp, entry)) {
 		folio_put(new);
-		return ERR_PTR(-ENOMEM);
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
 
 	/*
@@ -2045,6 +2051,17 @@ static struct folio *shmem_swap_alloc_fo
 	folio_add_lru(new);
 	swap_read_folio(new, NULL);
 	return new;
+fallback:
+	/* Order 0 swapin failed, nothing to fallback to, abort */
+	if (!order)
+		return new;
+	/* High order swapin failed, fallback to order 0 and retry */
+	order = 0;
+	nr_pages = 1;
+	swap_gfp = gfp;
+	offset = index - round_down(index, nr_pages);
+	entry = swp_entry(swp_type(entry), swp_offset(entry) + offset);
+	goto retry;
 }
 
 /*
@@ -2243,7 +2260,6 @@ static int shmem_split_swap_entry(struct
 			cur_order = split_order;
 			split_order = xas_try_split_min_order(split_order);
 		}
-
 unlock:
 		xas_unlock_irq(&xas);
 
@@ -2306,34 +2322,26 @@ static int shmem_swapin_folio(struct ino
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
-
-		/* Skip swapcache for synchronous device. */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
-			if (!IS_ERR(folio)) {
+			/* Direct mTHP swapin without swap cache or readahead */
+			folio = shmem_swapin_direct(inode, vma, index,
+						    swap, order, gfp);
+			if (IS_ERR(folio)) {
+				error = PTR_ERR(folio);
+				folio = NULL;
+			} else {
 				skip_swapcache = true;
-				goto alloced;
 			}
-
+		} else {
 			/*
-			 * Fallback to swapin order-0 folio unless the swap entry
-			 * already exists.
+			 * Order 0 swapin using swap cache and readahead, it
+			 * may return order > 0 folio due to raced swap cache
 			 */
-			error = PTR_ERR(folio);
-			folio = NULL;
-			if (error == -EEXIST)
-				goto failed;
+			folio = shmem_swapin_cluster(swap, gfp, info, index);
 		}
-
-		/* Here we actually start the io */
-		folio = shmem_swapin_cluster(swap, gfp, info, index);
-		if (!folio) {
-			error = -ENOMEM;
+		if (!folio)
 			goto failed;
-		}
 	}
-
-alloced:
 	/*
 	 * We need to split an existing large entry if swapin brought in a
 	 * smaller folio due to various of reasons.
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-clean-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-fix-major-fault-counting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

