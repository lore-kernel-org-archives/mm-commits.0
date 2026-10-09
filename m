Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1361942252A
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525594; cv=none; b=jzGdvE4u9I96QNX5I7aJ+4d+zz9wI1SpXljbMx2H2uyGW9ukmjUdr8BA7yKNeh8Fs/gvTFHWIZx2J26um5s3O3FTJCEJFwbBu7r8W+LmFHgpgn8VIeg41FASJ43XR46L0s+oaLKZ03GdnzTbSH59uNHXbu1JoP/jnKam/BDvGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525594; c=relaxed/simple;
	bh=omasTa9SUQstFDqrw1PzMhVCLrgk56B92CqKh4nCgBM=;
	h=Date:To:From:Subject:Message-Id; b=LtLTywrKZo46LY70ge6hGPsv412d/somhWdLodxg+V+l0Mmmf03kset4uP3R0CQJqTk+T8icHpvIrBj8rmayY+Ag88v12jKjYsFISROabtH8ROD35zVSu3tCXRiN/yIPBxv41sHfbP8yU20dSHSdC01l+4i6vfcpCpQsBoQTbC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PxQQhz0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PxQQhz0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4931F00899;
	Fri,  9 Oct 2026 05:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525593;
	bh=xtGzqOwXVsck2rzbdr4nnKXufhSXEGCh23nPzKIuUl0=;
	h=Date:To:From:Subject;
	b=PxQQhz0PJ2FHOLOCIiRU2Bv+QWhULRrtH/JwQ2evONN/JwDQj0bNevnjSotc2YfNp
	 mjc/0Vd6UEbwMECCf4Xk9fFKFT5OyS68sO3cWnjQynowEsv/ggI1skFTi6eKQWfaDm
	 MmH1jkWVgT7315IxxIqdGvjUuv5zGf22/AJQtxjY=
Date: Thu, 08 Oct 2026 22:59:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch removed from -mm tree
Message-Id: <20261009055952.DD4931F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: fix rejection of swap cache folios with a mapping
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: fix rejection of swap cache folios with a mapping
Date: Wed, 23 Sep 2026 23:32:33 +0200

A folio in the swap cache cannot be split if it has a mapping (shmem). 
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen and
the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented.  It rejects
the split and returns -EINVAL without unfreezing the folio or restoring
the counters.

That error path is buggy, if it is ever taken.  It leaves the folio frozen
and stuck, skews the counters, and fires the VM_WARN_ON_ONCE_FOLIO for a
state that is actually legitimate.

Check for this case up front in folio_check_splittable and return -EBUSY
before any state is modified, so the split routine always backs out
cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining about.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-2-ba1b4ba72c6f@tencent.com
Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping
+++ a/mm/huge_memory.c
@@ -3933,6 +3933,9 @@ static int __split_unmapped_folio(struct
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3941,11 +3944,11 @@ int folio_check_splittable(struct folio
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3956,7 +3959,7 @@ int folio_check_splittable(struct folio
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -3965,6 +3968,15 @@ int folio_check_splittable(struct folio
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -4037,14 +4049,8 @@ static int __folio_freeze_and_split_unma
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)
_

Patches currently in -mm which might be from kasong@tencent.com are


