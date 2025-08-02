Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741812505CE
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160882; cv=none; b=BfTCtf/yVJZTIcipcLFKjYN2unmVothfXalA1DMAraJ3LPiZESOi3rMYl6jWXjgXKLkq3M20RRAdccRugGvIT6vcCuUwPwl+RoX6oRaihpDJdu2oIU1GrPEfbkx+ldpe5tfnUmLkPKDV6lzEtb7EZ/hQf6UUSbRKbffuU/UxX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160882; c=relaxed/simple;
	bh=gb7SBq/+bsxr7Rw5cCXlcXNVDxhdPCC8so56MoMAmqA=;
	h=Date:To:From:Subject:Message-Id; b=lzYJBfWwahNcNQLAXGqmTigelgcf8exkk1jvqfxKIE4VeiermVd3QwQ9vLMxGpKKhbhE1cYAADAlrOLImtEB5zLLUbIpFuzeJPl+vP9qhKh775HoYbVNR9kaEH3HeaBsLPHdeBuZcBtEqdGVXUPhcu8CbnFxYd0vWXnoLK+/tGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AYGIaQUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYGIaQUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49715C4CEEF;
	Sat,  2 Aug 2025 18:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160882;
	bh=gb7SBq/+bsxr7Rw5cCXlcXNVDxhdPCC8so56MoMAmqA=;
	h=Date:To:From:Subject:From;
	b=AYGIaQUb/7nkjQCFpYt1f+aaIVIWUaKMJRXo10F4cXhbx6eSfH2K/y45yf/QOJei/
	 CuNuVBIBB3y3kP+uYqp7CUQ5wtS83r6dCoSTvAvAJb/cav3dXB1Fuhrm5cM/Q4DLNK
	 J2d8VCOTp0xbwzLQJart/uJvcM7Fr/85NLWZF34A=
Date: Sat, 02 Aug 2025 11:54:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch removed from -mm tree
Message-Id: <20250802185442.49715C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


