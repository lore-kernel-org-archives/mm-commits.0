Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C754C21B9DE
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409727; cv=none; b=Eg1oh11l75WfGEvoaxs+E42VG927TuBfhVF1MD51KhXfRs7dOTpFcn/05Thraxl+CGjcOUJnwmbZyEalybU8YurKHshcgT+sbb6GeLRWkUMU7XqwZlLvS8mPGAzKxxUyLGcqGuiO+GpA04gji0gECGhClpJLlUC99QJ7E1I8eDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409727; c=relaxed/simple;
	bh=4KMlsqClrtKJrj40qkKihgrEHYjsy/FFNES3sxOpirc=;
	h=Date:To:From:Subject:Message-Id; b=J5kDAhaCR0c5E5qi3gY3taHmCobJzwKeA77Hxa+dtiCXVkaCl7oXGMY105kRj+isSA7d49WYb7/hPeZlElibMD3hCRaG4XIgcr+jFlZUZYEgyljS4opZUYUDG3UacGPcMnpfT/cEg9ScGMQhiPwKuuj3exFpD1JLpwenC9iSNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1GBBk3S2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1GBBk3S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F626C4CEED;
	Fri, 25 Jul 2025 02:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409727;
	bh=4KMlsqClrtKJrj40qkKihgrEHYjsy/FFNES3sxOpirc=;
	h=Date:To:From:Subject:From;
	b=1GBBk3S2D4JHEA9VU2N/jQbWw1Ih27x8vXimlYphpJCOOuP+tswwEjvUqhGoONhuS
	 qk6yt0JieoSfPM9ngIWAHLHPwPW2P8JrtNX7JijMPrp+QAKNYCz/pLjsuyQGyTqG54
	 7kubKs86BgbO3DdrBHuMhINoO4aY6o04yDNpqiyQ=
Date: Thu, 24 Jul 2025 19:15:27 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-refactor-after-split-page-cache-code.patch removed from -mm tree
Message-Id: <20250725021527.9F626C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: refactor after-split (page) cache code
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-refactor-after-split-page-cache-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: refactor after-split (page) cache code
Date: Fri, 18 Jul 2025 14:37:20 -0400

Smatch/coverity checkers report NULL mapping referencing issues[1][2][3]
every time the code is modified, because they do not understand that
mapping cannot be NULL when a folio is in page cache in the code. 
Refactor the code to make it explicit.

Remove "end = -1" for anonymous folios, since after code refactoring, end
is no longer used by anonymous folio handling code.

No functional change is intended.

Link: https://lkml.kernel.org/r/20250718023000.4044406-7-ziy@nvidia.com
Link: https://lore.kernel.org/linux-mm/2afe3d59-aca5-40f7-82a3-a6d976fb0f4f@stanley.mountain/ [1]
Link: https://lore.kernel.org/oe-kbuild/64b54034-f311-4e7d-b935-c16775dbb642@suswa.mountain/ [2]
Link: https://lore.kernel.org/linux-mm/20250716145804.4836-1-antonio@mandelbit.com/ [3]
Link: https://lkml.kernel.org/r/20250718183720.4054515-7-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-refactor-after-split-page-cache-code
+++ a/mm/huge_memory.c
@@ -3640,7 +3640,6 @@ static int __folio_split(struct folio *f
 			ret = -EBUSY;
 			goto out;
 		}
-		end = -1;
 		mapping = NULL;
 		anon_vma_lock_write(anon_vma);
 	} else {
@@ -3793,6 +3792,8 @@ static int __folio_split(struct folio *f
 		 */
 		for (new_folio = folio_next(folio); new_folio != end_folio;
 		     new_folio = next) {
+			unsigned long nr_pages = folio_nr_pages(new_folio);
+
 			next = folio_next(new_folio);
 
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
@@ -3800,25 +3801,36 @@ static int __folio_split(struct folio *f
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-			/* Some pages can be beyond EOF: drop them from cache */
-			if (new_folio->index >= end) {
-				if (shmem_mapping(mapping))
-					nr_shmem_dropped += folio_nr_pages(new_folio);
-				else if (folio_test_clear_dirty(new_folio))
-					folio_account_cleaned(
-						new_folio,
-						inode_to_wb(mapping->host));
-				__filemap_remove_folio(new_folio, NULL);
-				folio_put_refs(new_folio,
-					       folio_nr_pages(new_folio));
-			} else if (mapping) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-			} else if (swap_cache) {
+			/*
+			 * Anonymous folio with swap cache.
+			 * NOTE: shmem in swap cache is not supported yet.
+			 */
+			if (swap_cache) {
 				__xa_store(&swap_cache->i_pages,
 					   swap_cache_index(new_folio->swap),
 					   new_folio, 0);
+				continue;
 			}
+
+			/* Anonymous folio without swap cache */
+			if (!mapping)
+				continue;
+
+			/* Add the new folio to the page cache. */
+			if (new_folio->index < end) {
+				__xa_store(&mapping->i_pages, new_folio->index,
+					   new_folio, 0);
+				continue;
+			}
+
+			/* Drop folio beyond EOF: ->index >= end */
+			if (shmem_mapping(mapping))
+				nr_shmem_dropped += nr_pages;
+			else if (folio_test_clear_dirty(new_folio))
+				folio_account_cleaned(
+					new_folio, inode_to_wb(mapping->host));
+			__filemap_remove_folio(new_folio, NULL);
+			folio_put_refs(new_folio, nr_pages);
 		}
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

