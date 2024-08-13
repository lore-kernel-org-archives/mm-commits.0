Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8D716BE34
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588892; cv=none; b=FLMBl+E9iNILq4zLIbaFr3ggnQpfU9/7q+8/icHngLeyZW50I7y9PCv4Ek7rfJOMNuxyKBqGhQ6oqmmACh20SKCjf2WIP5yIe5+Gz6y6SFZCyNQsPYr7wjKMBqPGdVFswLF7O8j6bW5NkaEuG1yQDlmVHqwYeB6uVFnes0cUH9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588892; c=relaxed/simple;
	bh=glGzGBvVHBgiRm4oEJGXzB3Fn/BhMD2Ie0Powk5Ous8=;
	h=Date:To:From:Subject:Message-Id; b=DReCFEmfvEySVDmcEAE4xVX0QzsTOeFxfY1EHkSuGzNOCFVha5ODg0IgtA1AqXli+RWzHxwVvAnFr/5Rnh4HXT45h5TlMzWFrnzed3u0p6ddNAFXMmemO/kkE4yvPsxT2EOBhcWk86CboVdZCo4u6xfDhAyoI/qNo9T6Po2cG+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PfUFoQJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PfUFoQJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BE9C32782;
	Tue, 13 Aug 2024 22:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723588892;
	bh=glGzGBvVHBgiRm4oEJGXzB3Fn/BhMD2Ie0Powk5Ous8=;
	h=Date:To:From:Subject:From;
	b=PfUFoQJ4tXMWnzJrLc0WW26Llo5ZrABlN4ki6kNxDSG4l/nAUxbpZ8Zixo7OWMtaB
	 KJsmvyJrR0rBuw0ZDxzh2uOaTKe8t88lkpCvML3T84pz/rLea82PmzYsZE85dcvA11
	 LgZzuXoJst2joTfMCCP/qu1M79wWAI6krsTqdpZE=
Date: Tue, 13 Aug 2024 15:41:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,da.gomez@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch added to mm-unstable branch
Message-Id: <20240813224132.45BE9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: return number of pages beeing freed in shmem_free_swap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

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

mm-shmem-return-number-of-pages-beeing-freed-in-shmem_free_swap.patch

