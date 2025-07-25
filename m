Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E16F20D4E9
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409678; cv=none; b=fl7RISj8wTHDFZyyLznE2iFVhHANqEn4iir6bfQ5Bkg26KlAwSQ1QGS0i49zyHrQVo9z9a70qFVVYRafpfruDRUsNIfqOx8v4zMbl66zDgcpMAQ3PXuv1uj3pgKvsf5Qu8hyiEiIkPjGRcfKD5hlQlJJmCLTsxOZUpicQCHVer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409678; c=relaxed/simple;
	bh=iPcWtU8B4FZf0bRTOkWlLjFmVROcFEXfFCoMP/qICHY=;
	h=Date:To:From:Subject:Message-Id; b=A7JIfrpvcRd84DP8Jxs+IVyzTyGZYJVJ9dsDkE5T6lZDy+bkM2DYVe7KqLSsObrsYuw2K3NJdxzhRmGBcPhMRcBvABW8ljTNoizKXSkiEGGrEF3ReV9Lh+tQWjggIWAiVZ5rCWP7k5dxlmWdIT3b1ET8YexdANLp36TdhEwsEU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SCxoVG7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SCxoVG7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8684C4CEED;
	Fri, 25 Jul 2025 02:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409677;
	bh=iPcWtU8B4FZf0bRTOkWlLjFmVROcFEXfFCoMP/qICHY=;
	h=Date:To:From:Subject:From;
	b=SCxoVG7+6rXN+ZM6pjfishZF3RDe6ekMqV1/gxpKub4K7LZV1O54gsYUpn1U/M4Ft
	 pHe17/Hv6S/QUAKgWeFTC3GgQpecQHN2O4Ka5g543hHFC3JkXZWNhIHisUiw+ErS6r
	 J7V9XkTbb6WqIHMXSxOSuGTAIQlCK4YZh6ZduQoU=
Date: Thu, 24 Jul 2025 19:14:37 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,rientjes@google.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch removed from -mm tree
Message-Id: <20250725021437.C8684C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: writeout free swap if swap_writeout() reactivates
has been removed from the -mm tree.  Its filename was
     mm-shmem-writeout-free-swap-if-swap_writeout-reactivates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: writeout free swap if swap_writeout() reactivates
Date: Wed, 16 Jul 2025 01:08:39 -0700 (PDT)

If swap_writeout() returns AOP_WRITEPAGE_ACTIVATE (for example, because
zswap cannot compress and memcg disables writeback), there is no virtue in
keeping that folio in swap cache and holding the swap allocation:
shmem_writeout() switch it back to shmem page cache before returning.

Folio lock is held, and folio->memcg_data remains set throughout, so there
is no need to get into any memcg or memsw charge complications:
swap_free_nr() and delete_from_swap_cache() do as much as is needed (but
beware the race with shmem_free_swap() when inode truncated or evicted).

Doing the same for an anonymous folio is harder, since it will usually
have been unmapped, with references to the swap left in the page tables. 
Adding a function to remap the folio would be fun, but not worthwhile
unless it has other uses, or an urgent bug with anon is demonstrated.

[hughd@google.com: use shmem_recalc_inode() rather than open coding, per Baolin]
  Link: https://lkml.kernel.org/r/101a7d89-290c-545d-8a6d-b1174ed8b1e5@google.com
Link: https://lkml.kernel.org/r/5c911f7a-af7a-5029-1dd4-2e00b66d565c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-writeout-free-swap-if-swap_writeout-reactivates
+++ a/mm/shmem.c
@@ -1631,6 +1631,7 @@ try_split:
 
 	if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
+		int error;
 
 		/*
 		 * Add inode to shmem_unuse()'s list of swapped-out inodes,
@@ -1651,7 +1652,35 @@ try_split:
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
-		return swap_writeout(folio, plug);
+		error = swap_writeout(folio, plug);
+		if (error != AOP_WRITEPAGE_ACTIVATE) {
+			/* folio has been unlocked */
+			return error;
+		}
+
+		/*
+		 * The intention here is to avoid holding on to the swap when
+		 * zswap was unable to compress and unable to writeback; but
+		 * it will be appropriate if other reactivate cases are added.
+		 */
+		error = shmem_add_to_page_cache(folio, mapping, index,
+				swp_to_radix_entry(folio->swap),
+				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		/* Swap entry might be erased by racing shmem_free_swap() */
+		if (!error) {
+			shmem_recalc_inode(inode, 0, -nr_pages);
+			swap_free_nr(folio->swap, nr_pages);
+		}
+
+		/*
+		 * The delete_from_swap_cache() below could be left for
+		 * shrink_folio_list()'s folio_free_swap() to dispose of;
+		 * but I'm a little nervous about letting this folio out of
+		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
+		 * e.g. folio_mapping(folio) might give an unexpected answer.
+		 */
+		delete_from_swap_cache(folio);
+		goto redirty;
 	}
 	if (nr_pages > 1)
 		goto try_split;
_

Patches currently in -mm which might be from hughd@google.com are


