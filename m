Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4537E50EBF8;
	Thu,  3 Sep 2026 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466954; cv=none; b=Jp3dvHabTmDiJr6nN6BiWAzXmmHaQjFPH5foN69WvCdfF5ptFOXYDQU7FVmahzdcu2IxODs6orHFo4fPOoVZMm9qtYmiuEZ4Wg2qAQDjQu/u9wWf7YUw8SiJpi6/yF8GdP0uc4MxUS26+wMl1E8QgcW7AAzQtNVKDWV0tUP1I5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466954; c=relaxed/simple;
	bh=K/tZV6fBB/aU3WhkL0+U/mUlRGE2ZXWNaaJEFbjwnW0=;
	h=Date:To:From:Subject:Message-Id; b=IluRFrJdUrD8jCavTdMASWXxC9pBJ8oLZtCaJaOsDx+fCy+uRN8FvJp/f6DR3HOwkqJYf6vbgWKzaZ0WjTWHY2G7ZfbXfrzUwuRe3VKeanrDaW2n591k8aU1uj01REVdrzm214BHGp7Oq2if5cYQUAjM4unDmlBKD1MbZ1Xl8TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TSBPYdeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TSBPYdeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2691F000E9;
	Thu,  3 Sep 2026 20:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788466939;
	bh=5TU2IVvOMNha00DlWblabzZ+tGzy2FmoetBd/Fpqj0w=;
	h=Date:To:From:Subject;
	b=TSBPYdeos74FmRmxfTrWyggu4mp8KX0zA2WGxQnE6j8WyP8DTIMrs2e4Ku3pgrgDD
	 bFLzrK0Sq1i2pbU317toaniODZgst4/TBy6I4czlpPDtg0QwyNWWxrhwpDdBak2qOv
	 MuoWk2LvLsUtVyGSvm27O0nmbismeaVrefXxdrQ4=
Date: Thu, 03 Sep 2026 13:22:19 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,hughd@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch added to mm-new branch
Message-Id: <20260903202219.AC2691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: fix hugetlb reservation accounting in error paths
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/memfd: fix hugetlb reservation accounting in error paths
Date: Thu, 3 Sep 2026 11:01:34 +0800

If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with -EEXIST,
a concurrent fault has already instantiated the folio in the page cache,
and the reservation now belongs to that folio.  Calling
hugetlb_unreserve_pages() in that case incorrectly removes the region
backing the cached folio.  A later truncate or inode eviction then passes
a negative (chg - freed) into hugepage_subpool_put_pages(), corrupting
subpool and resv_huge_pages accounting.

Over time, these corrupted counters would leak huge page reservations. 
Applications using hugetlb memfds would eventually find themselves unable
to allocate huge pages, receiving unexpected ENOMEM errors even though
system memory and pool capacities appeared free and healthy.

The corrupted accounting caused hugepage_subpool_put_pages() to receive a
negative value during a later file truncation or inode eviction.

While this typically manifests as kernel logs (WARN traces or badness
flags regarding subpool page counts), it could cause misbehaved resource
tracking that impacts subsequent system operations, unmounts, or process
teardowns interacting with that hugetlb file descriptor.

So hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
error-path unreserve completes to make the reserve, allocate and
instantiate steps atomic against concurrent faults.  With the mutex held
from the start, a concurrent fault can no longer consume the reservation
between reserve and allocate/instantiate.  If a fault completed before the
mutex was taken, it has already added the region for that index, so
hugetlb_reserve_pages() returns 0 and the error path leaves the region in
place.

Link: https://lore.kernel.org/20260903030134.7407-1-hongfu.li@linux.dev
Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch
mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

