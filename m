Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374606F2E3
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423465; cv=none; b=VZ9CsVmXLM6++Q7tGoHUE3fFr8jFkTNdDDytLP4+SpJJ2JCf31UwYk0NzcHMGdIHuu+MjgbsOUymKHV+GW46iyOIogsTZ2kJaHH3FfgMIP+0u7VaTo2zvZzM5v9N1ap4zEe6WbZks5Poc4N/hOzfilpX5HzDN10iSDEWxYQweig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423465; c=relaxed/simple;
	bh=SEIEEdzGMX4TuJzT9XJYY0NvqflahBi7Vl1SiEsZctk=;
	h=Date:To:From:Subject:Message-Id; b=FByS2lKDXmM+YBFwaUwBoNlKZmr4rAmhVYj3uAZUZnbaLfyJbfaN5Yv9gOogfmL0cfP3n1aTjUbB0ozArciYgur8kYGchzm3xEyZ7vAJgCL/42PhDzEF1lZ/E6dWiA4eB0H2E8+lM+4Rr4OIs5FhV8xqswRPP1pD0EkBgFpFUYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zq1isgcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zq1isgcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD59C4CEC2;
	Wed,  4 Sep 2024 04:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423465;
	bh=SEIEEdzGMX4TuJzT9XJYY0NvqflahBi7Vl1SiEsZctk=;
	h=Date:To:From:Subject:From;
	b=zq1isgcFOifD86OrW8QfqdcHIMYf6yg67+oP1kdO5muuHb+ww+LKjURo6ULAiAGtx
	 S9pDilEkHeWOI6Au4CjMhaTpGmp+l/+bTxKQzbZEQvZ+csD8oRe1Gv9AvDTS47l+UT
	 MlCiJC+OiC8M9P6//JGVw4NK+ZKbA9j5hims46vU=
Date: Tue, 03 Sep 2024 21:17:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,da.gomez@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch removed from -mm tree
Message-Id: <20240904041745.0DD59C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: return number of pages beeing freed in shmem_free_swap
has been removed from the -mm tree.  Its filename was
     mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Gomez <da.gomez@samsung.com>
Subject: mm: shmem: return number of pages beeing freed in shmem_free_swap
Date: Mon, 12 Aug 2024 15:42:04 +0800

Both shmem_free_swap callers expect the number of pages being freed.  In
the large folios context, this needs to support larger values other than 0
(used as 1 page being freed) and -ENOENT (used as 0 pages being freed). 
In preparation for large folios adoption, make shmem_free_swap routine
return the number of pages being freed.  So, returning 0 in this context,
means 0 pages being freed.

While we are at it, changing to use free_swap_and_cache_nr() to free large
order swap entry by Baolin Wang.

Link: https://lkml.kernel.org/r/9623e863c83d749d5ab407f6fdf0a8e5a3bdf052.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap
+++ a/mm/shmem.c
@@ -856,18 +856,22 @@ static void shmem_delete_from_page_cache
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache. Returns
+ * the number of pages being freed. 0 means entry not found in XArray (0 pages
+ * being freed).
  */
-static int shmem_free_swap(struct address_space *mapping,
-			   pgoff_t index, void *radswap)
+static long shmem_free_swap(struct address_space *mapping,
+			    pgoff_t index, void *radswap)
 {
+	int order = xa_get_order(&mapping->i_pages, index);
 	void *old;
 
 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
 	if (old != radswap)
-		return -ENOENT;
-	free_swap_and_cache(radix_to_swp_entry(radswap));
-	return 0;
+		return 0;
+	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+
+	return 1 << order;
 }
 
 /*
@@ -1019,7 +1023,7 @@ static void shmem_undo_range(struct inod
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += !shmem_free_swap(mapping,
+				nr_swaps_freed += shmem_free_swap(mapping,
 							indices[i], folio);
 				continue;
 			}
@@ -1086,14 +1090,17 @@ whole_folios:
 			folio = fbatch.folios[i];
 
 			if (xa_is_value(folio)) {
+				long swaps_freed;
+
 				if (unfalloc)
 					continue;
-				if (shmem_free_swap(mapping, indices[i], folio)) {
+				swaps_freed = shmem_free_swap(mapping, indices[i], folio);
+				if (!swaps_freed) {
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;
 				}
-				nr_swaps_freed++;
+				nr_swaps_freed += swaps_freed;
 				continue;
 			}
 
_

Patches currently in -mm which might be from da.gomez@samsung.com are


