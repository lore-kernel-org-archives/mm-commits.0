Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A20D1FE461
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 20:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751660409; cv=none; b=uGh2qw230ZdvBwlacx7xMusK/G/lbbipwPDcS8vehI8WINV1wUxOyTrQR5afrAyvHn9GORPSzmbM5bF4ciVlIw/FTsqeJlbGLtaeRp4w4KvdRjoF7jp3O5gDDH93NCy36wMzd2ckDV5moXFM1cQES1HuA0hKAnFwdwrG5lWyvVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751660409; c=relaxed/simple;
	bh=9CMCb1gKCs9OWl4dQK43vj9varCdIfEfdu/rCwiqXx0=;
	h=Date:To:From:Subject:Message-Id; b=LYBMS18mVUsIC/TEFCYbXFdOnSTf6RRoiEGhyXds74FO765fwQBOnXyLutILFvuMhtCWU7xO5YGleEvXGjiYsQu5ECLqAkNFYBR66+PwgkbtNTTiMBd97NVLK8ypTvHYe48k5INSKNWQrZ/Gb1DTCDo1Lqt/Bwxg1dDAaqgFCJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6BmqWpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6BmqWpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020BFC4CEE3;
	Fri,  4 Jul 2025 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751660409;
	bh=9CMCb1gKCs9OWl4dQK43vj9varCdIfEfdu/rCwiqXx0=;
	h=Date:To:From:Subject:From;
	b=t6BmqWpDpXc1n3o8X8VrA6EItomVWuqOWoF8An4auGo3tVZpyzpXtZHBh1Yg4q8zS
	 wEw1XOtG08J39nfo9SX2TYEHte51TJC2L+BzZWf0dwWVPTK5B560iTVeX30egW2bA2
	 t161zI10hGB1O/0qo162ei/vbQN6CZ/q3fJwpO+c=
Date: Fri, 04 Jul 2025 13:20:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch added to mm-unstable branch
Message-Id: <20250704202009.020BFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
Date: Sat, 5 Jul 2025 02:17:45 +0800

Currently if a THP swapin failed due to reasons like partially conflicting
swap cache or ZSWAP enabled, it will fallback to cached swapin.

Right now the swap cache still has a non-trivial overhead, and readahead
is not helpful for SWP_SYNCHRONOUS_IO devices, so we should always skip
the readahead and swap cache even if the swapin falls back to order 0.

So handle the fallback logic without falling back to the cached read.

Link: https://lkml.kernel.org/r/20250704181748.63181-7-ryncsn@gmail.com
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

 mm/shmem.c |   55 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 19 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io
+++ a/mm/shmem.c
@@ -1975,13 +1975,16 @@ unlock:
 	return ERR_PTR(error);
 }
 
-static struct folio *shmem_swap_alloc_folio(struct inode *inode,
+static struct folio *shmem_swapin_direct(struct inode *inode,
 		struct vm_area_struct *vma, pgoff_t index,
-		swp_entry_t entry, int order, gfp_t gfp)
+		swp_entry_t swap, swp_entry_t index_entry,
+		int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	swp_entry_t entry = index_entry;
 	int nr_pages = 1 << order;
 	struct folio *new;
+	gfp_t alloc_gfp;
 	void *shadow;
 
 	/*
@@ -1989,6 +1992,7 @@ static struct folio *shmem_swap_alloc_fo
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
+	alloc_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);
@@ -2003,19 +2007,22 @@ static struct folio *shmem_swap_alloc_fo
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
@@ -2030,7 +2037,9 @@ static struct folio *shmem_swap_alloc_fo
 	 */
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
-		return ERR_PTR(-EEXIST);
+		new = ERR_PTR(-EEXIST);
+		/* Try smaller folio to avoid cache conflict */
+		goto fallback;
 	}
 
 	__folio_set_locked(new);
@@ -2044,6 +2053,15 @@ static struct folio *shmem_swap_alloc_fo
 	folio_add_lru(new);
 	swap_read_folio(new, NULL);
 	return new;
+fallback:
+	/* Order 0 swapin failed, nothing to fallback to, abort */
+	if (!order)
+		return new;
+	order = 0;
+	nr_pages = 1;
+	alloc_gfp = gfp;
+	entry = swap;
+	goto retry;
 }
 
 /*
@@ -2309,25 +2327,24 @@ static int shmem_swapin_folio(struct ino
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
-
 		/* Skip swapcache for synchronous device. */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
-			folio = shmem_swap_alloc_folio(inode, vma, index,
-						       index_entry, order, gfp);
+			folio = shmem_swapin_direct(inode, vma, index, swap,
+						    index_entry, order, gfp);
 			if (!IS_ERR(folio)) {
-				swap = index_entry;
+				if (folio_test_large(folio))
+					swap = index_entry;
 				skip_swapcache = true;
 				goto alloced;
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
 		/* Cached swapin with readahead, only supports order 0 */
 		folio = shmem_swapin_cluster(swap, gfp, info, index);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-simplify-swap-entry-and-index-calculation-of-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

