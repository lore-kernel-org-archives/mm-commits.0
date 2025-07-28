Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114638488
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753740324; cv=none; b=LeYySOUfbAbopNMS+suq+H5xq5vt6KJjK4tdKkxFnOvUxVp9Ctgacm44wNbLqPpbMfgZd04nsjyg1VziBd997WhHpBj5DUn7cpBctB7BJTxLuupQw8ULFCrdUx+0xFK6/uEAghguCY7EpPRQI8DxIY+MD6AcRje6PYsZGSikltw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753740324; c=relaxed/simple;
	bh=8RC4RbK2p2ubQ2nytZUFX2DMUtRcNvESdb8ov3bqrEY=;
	h=Date:To:From:Subject:Message-Id; b=PFJjQiYzl6eZphYUPI+O++VK+Hq6UQgcy4NCuFwYhmbJLERrCLOIQIaidiXPCuPrUHCm46DwnGj8HCUEDP4d20GFMdtCkDeAKaWX+IiS6Yfxodp5z1ZmVp/7rYaZ5agxaG1ZA0FWReo2LYNQ9KZX+6wmGfY4W7xsrahSARpAl/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TsgsTibH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TsgsTibH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CBDC4CEE7;
	Mon, 28 Jul 2025 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753740323;
	bh=8RC4RbK2p2ubQ2nytZUFX2DMUtRcNvESdb8ov3bqrEY=;
	h=Date:To:From:Subject:From;
	b=TsgsTibH4xmmK5+K1jIfJQiOJvfVvg5RvqgUzzuohRdfEpstauSL9x/Jh9N8eNuNJ
	 2MbACe/r6C2Ipe1ZrPzvm3X/U++tL3QrqfpEaNvZYzFq0XhaDXDpbDjksYLF+Pp7iq
	 E/SvKGySnoatN6SjIt2v9PvAELfbNSqCN3TsbyM4=
Date: Mon, 28 Jul 2025 15:05:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch added to mm-new branch
Message-Id: <20250728220523.80CBDC4CEE7@smtp.kernel.org>
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
Date: Mon, 28 Jul 2025 15:53:03 +0800

For SWP_SYNCHRONOUS_IO devices, if a cache bypassing THP swapin failed due
to reasons like memory pressure, partially conflicting swap cache or ZSWAP
enabled, shmem will fallback to cached order 0 swapin.

Right now the swap cache still has a non-trivial overhead, and readahead
is not helpful for SWP_SYNCHRONOUS_IO devices, so we should always skip
the readahead and swap cache even if the swapin falls back to order 0.

So handle the fallback logic without falling back to the cached read.

Link: https://lkml.kernel.org/r/20250728075306.12704-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/shmem.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io
+++ a/mm/shmem.c
@@ -2019,6 +2019,7 @@ static struct folio *shmem_swap_alloc_fo
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int nr_pages = 1 << order;
 	struct folio *new;
+	gfp_t alloc_gfp;
 	void *shadow;
 
 	/*
@@ -2026,6 +2027,7 @@ static struct folio *shmem_swap_alloc_fo
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
+	alloc_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);
@@ -2040,19 +2042,22 @@ static struct folio *shmem_swap_alloc_fo
 		if ((vma && unlikely(userfaultfd_armed(vma))) ||
 		     !zswap_never_enabled() ||
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
-			return ERR_PTR(-EINVAL);
+			goto fallback;
 
-		gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+	}
+retry:
+	new = shmem_alloc_folio(alloc_gfp, order, info, index);
+	if (!new) {
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
-
-	new = shmem_alloc_folio(gfp, order, info, index);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
 
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
-					   gfp, entry)) {
+					   alloc_gfp, entry)) {
 		folio_put(new);
-		return ERR_PTR(-ENOMEM);
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
 
 	/*
@@ -2067,7 +2072,9 @@ static struct folio *shmem_swap_alloc_fo
 	 */
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
-		return ERR_PTR(-EEXIST);
+		new = ERR_PTR(-EEXIST);
+		/* Try smaller folio to avoid cache conflict */
+		goto fallback;
 	}
 
 	__folio_set_locked(new);
@@ -2081,6 +2088,15 @@ static struct folio *shmem_swap_alloc_fo
 	folio_add_lru(new);
 	swap_read_folio(new, NULL);
 	return new;
+fallback:
+	/* Order 0 swapin failed, nothing to fallback to, abort */
+	if (!order)
+		return new;
+	entry.val += index - round_down(index, nr_pages);
+	alloc_gfp = gfp;
+	nr_pages = 1;
+	order = 0;
+	goto retry;
 }
 
 /*
@@ -2350,13 +2366,12 @@ static int shmem_swapin_folio(struct ino
 			}
 
 			/*
-			 * Fallback to swapin order-0 folio unless the swap entry
-			 * already exists.
+			 * Direct swapin handled order 0 fallback already,
+			 * if it failed, abort.
 			 */
 			error = PTR_ERR(folio);
 			folio = NULL;
-			if (error == -EEXIST)
-				goto failed;
+			goto failed;
 		}
 
 		/*
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

