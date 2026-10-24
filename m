Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832462;
	b=JASpINpIzR1EQij27sBdd0YXUwA6iJSJu8/CjDvhUO+hP4wnlImqCMVHwWF50LsckVCC
	 zhM5Aa4QKFRTZ8pCF1Uqq1MqUXf0eIdhNmBj+qysC2imWf33lCcLMJxhqXSOYEISLyjKs
	 xpv8kc2fACXbV2hRPAkWzi1V2tKP13gwSzzQX4Cwt1kY0V07oZTwdRjEQySBe1VI9TIaD
	 4qMalTz5YgK7QAFTyDn4gJJj5OHiLaHfN4nTR4RPy6ey7QfHh4m2wahv4NNOp7UZztHTz
	 qdN7MZ9ZPj8JdYoB2grYgc+9NgiClMTZgU8sdys+7bQtFzK8FswoytxSPrEjSIqmgpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832462;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Capku4Z+t0oRzQxYnwD7223dAUoKEKRrLcaiPdofoVE=;
	b=EOqg2Kj78c68jvqjGb1co/+3s2Efe3y6GjrpulWgTZCez/duZsTOajprdl1nPIbTqWKC
	 O2Q4PZrTZVOjcvYn4GqJUydCAOiFJ4Y81xa+pz17xoDu3YLfjd+g4wUKJaCWL3ryNrEUo
	 Swa+mH8qEbPAYSIOUHxaTeYYsdIXMP95xprfvCWLaQAO9lN0O3xPTM1SJFf/gm8QsU0S6
	 atslabFdO8IEwfeoJt2boKUIv1Q09gzKfuF6d2wDBlM9GayYgC9igV6BN0hlRJ2FY0cse
	 h6G+o2hugi61fpzfAr2sLittmHyoEhKOL6Yw3eYyLdwxVzLcvoU1kqYWj/X4yqerjVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1KWW5BdO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94AE606A31B;
	Sat, 24 Oct 2026 09:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1KWW5BdO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E251F01825;
	Sat, 24 Oct 2026 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832461;
	bh=Capku4Z+t0oRzQxYnwD7223dAUoKEKRrLcaiPdofoVE=;
	h=Date:To:From:Subject;
	b=1KWW5BdO8YJ3FRwqfLZfx8WO5CvumvKKehublOkKOVIOvjK/xI7D+AOutC7gdJ/66
	 23+dGFw7ZQKJTeMEPQUcfOPFjW+Vz1bIyYUYDNxvjKY0PAKVmZiI6g9/yBc6y1zWMF
	 aGgBaeVXm0iwQub86BKlQ7XvJnv3T2Ag4tfAxCRs=
Date: Sat, 24 Oct 2026 02:01:01 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,hughd@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch removed from -mm tree
Message-Id: <20261024090101.A3E251F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memfd: fix hugetlb reservation accounting in error paths
has been removed from the -mm tree.  Its filename was
     mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/memfd: fix hugetlb reservation accounting in error paths
Date: Thu, 3 Sep 2026 11:01:34 +0800

If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with -EEXIST,
a concurrent fault has already instantiated the folio in the page cache,
and the reservation now belongs to that folio.  Calling
hugetlb_unreserve_pages() in that case incorrectly removes the region
backing the cached folio and releases one reservation more than it should,
leaving that folio in the page cache with no region recording it.

That leaves resv_huge_pages one page short until that folio is removed
from the page cache, so available_huge_pages() reports a page that is not
actually free and the pool can grant one reservation more than it can
back.  Applications using hugetlb memfds can then fail to allocate or
fault in a page they already reserved.  They see -ENOMEM or -ENOSPC from
the allocation or fault path even though the reservation and
HugePages_Free still look healthy.

So hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
error-path unreserve completes to make the reserve, allocate and
instantiate steps atomic against concurrent faults.  With the mutex held
from the start, a concurrent fault can no longer consume the reservation
between reserve and allocate/instantiate.  If a fault completed before the
mutex was taken, it has already added the region for that index, so
hugetlb_reserve_pages() returns 0 and the error path leaves the region in
place.

Link: https://lore.kernel.org/20260927094757.31665-1-hongfu.li@linux.dev
Link: https://lore.kernel.org/20260903030134.7407-1-hongfu.li@linux.dev
Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
---

 mm/memfd.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/mm/memfd.c~mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths
+++ a/mm/memfd.c
@@ -82,22 +82,31 @@ struct folio *memfd_alloc_folio(struct f
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
 		long nr_resv;
+		u32 hash;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
+		/*
+		 * Serialize hugepage allocation and instantiation to prevent
+		 * races with concurrent allocations, as required by all other
+		 * callers of hugetlb_add_to_page_cache().
+		 */
+		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
-		if (nr_resv < 0)
-			return ERR_PTR(nr_resv);
+		if (nr_resv < 0) {
+			err = nr_resv;
+			goto out_unlock;
+		}
 
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
 		if (folio) {
-			u32 hash;
-
 			/*
 			 * Zero the folio to prevent information leaks to userspace.
 			 * Use folio_zero_user() which is optimized for huge/gigantic
@@ -112,20 +121,9 @@ struct folio *memfd_alloc_folio(struct f
 			 */
 			__folio_mark_uptodate(folio);
 
-			/*
-			 * Serialize hugepage allocation and instantiation to prevent
-			 * races with concurrent allocations, as required by all other
-			 * callers of hugetlb_add_to_page_cache().
-			 */
-			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
-
-			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
@@ -133,11 +131,14 @@ struct folio *memfd_alloc_folio(struct f
 
 			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
 			folio_unlock(folio);
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return folio;
 		}
 err_unresv:
 		if (nr_resv > 0)
 			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+out_unlock:
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		return ERR_PTR(err);
 	}
 #endif
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are


