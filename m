Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FAA6F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423469; cv=none; b=EbrMpxTjZVMtb9IkKEGxHoMNlc7ZtQJijyMEW0LpfGJs9O05xaB0yQv+h2AcVS9KIZWhcfNNFMtRZ8lnuauVJ9jrVp7U/SMgdyTs1d8eReiodc/lE+Soc2cEXZU7QxhU5NUIPagVj0VhrnT/MXfsPCtVpkuvLMqrvx4KNtkqnEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423469; c=relaxed/simple;
	bh=j0Follk8oHt1C9sJQAXbJ1CABfbLqM6SEJqp/Lc5VXI=;
	h=Date:To:From:Subject:Message-Id; b=G/POWTEBMqW9qx0qs/fJq88CnXuDJwgPidIGvIxgc925bHjR8Mp9wt0Zm/z+Y/NFGKQx2aDBsWXUpTzReOG2SJI4LFvELbpvK0zM44dN3qdPVBdw9v3Q0/Vk3EgrjrDdGVoyHT7F90Zi9d3DuCmrLkQcgv8i5tdmA883N0PvLgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j2mnjSqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j2mnjSqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98AAC4CEC2;
	Wed,  4 Sep 2024 04:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423469;
	bh=j0Follk8oHt1C9sJQAXbJ1CABfbLqM6SEJqp/Lc5VXI=;
	h=Date:To:From:Subject:From;
	b=j2mnjSqtfc6SAW45azMVrxXWT77Wm54vQnzJr+0orBuOZ/xMTVUNY/JdUuVaqCPMM
	 sBmuWzqlipp3GZ4FpX4+qSeAJOZxy81Djo/iHW9tNrJTf75/g/gCRo8hboLg0kb4kM
	 oPhSNMkVfgAT1o+y/lCg14uFuwOofVoMVs327ftA=
Date: Tue, 03 Sep 2024 21:17:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch removed from -mm tree
Message-Id: <20240904041748.E98AAC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: use swap_free_nr() to free shmem swap entries
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: use swap_free_nr() to free shmem swap entries
Date: Mon, 12 Aug 2024 15:42:06 +0800

As a preparation for supporting shmem large folio swapout, use
swap_free_nr() to free some continuous swap entries of the shmem large
folio when the large folio was swapped in from the swap cache.  In
addition, the index should also be round down to the number of pages when
adding the swapin folio into the pagecache.

Link: https://lkml.kernel.org/r/342207fa679fc88a447dac2e101ad79e6050fe79.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries
+++ a/mm/shmem.c
@@ -1961,6 +1961,7 @@ static void shmem_set_folio_swapin_error
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
 	void *old;
+	int nr_pages;
 
 	swapin_error = make_poisoned_swp_entry();
 	old = xa_cmpxchg_irq(&mapping->i_pages, index,
@@ -1969,6 +1970,7 @@ static void shmem_set_folio_swapin_error
 	if (old != swp_to_radix_entry(swap))
 		return;
 
+	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
 	delete_from_swap_cache(folio);
 	/*
@@ -1976,8 +1978,8 @@ static void shmem_set_folio_swapin_error
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
 	 * in shmem_evict_inode().
 	 */
-	shmem_recalc_inode(inode, -1, -1);
-	swap_free(swap);
+	shmem_recalc_inode(inode, -nr_pages, -nr_pages);
+	swap_free_nr(swap, nr_pages);
 }
 
 /*
@@ -1996,7 +1998,7 @@ static int shmem_swapin_folio(struct ino
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	swp_entry_t swap;
-	int error;
+	int error, nr_pages;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
 	swap = radix_to_swp_entry(*foliop);
@@ -2043,6 +2045,7 @@ static int shmem_swapin_folio(struct ino
 		goto failed;
 	}
 	folio_wait_writeback(folio);
+	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
@@ -2056,19 +2059,20 @@ static int shmem_swapin_folio(struct ino
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping, index,
+	error = shmem_add_to_page_cache(folio, mapping,
+					round_down(index, nr_pages),
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
 
-	shmem_recalc_inode(inode, 0, -1);
+	shmem_recalc_inode(inode, 0, -nr_pages);
 
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
 	delete_from_swap_cache(folio);
 	folio_mark_dirty(folio);
-	swap_free(swap);
+	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
 
 	*foliop = folio;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


