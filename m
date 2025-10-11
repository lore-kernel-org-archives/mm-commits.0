Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2503342A96
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760207744; cv=none; b=lnhVN/roDkMKTISTX8CRuRyNiqLsIe+ivPUgKAu/rVrl+ZAisRsHSSXRwHvkpTag+BRmNw9NE3NV6S0h+xEkAXfns1n+By6MhDERGWgojD7tzofoDHudOV70q4Fa59RGYJ50YBKmFb0h1qwfYb9JYcs1GwDFlo36GzNvUOtZ720=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760207744; c=relaxed/simple;
	bh=TssqD8Kkh+uuRl5AsbwSn9LFNiZtLEUMwOQ6rSTFBHg=;
	h=Date:To:From:Subject:Message-Id; b=uGGRWhh2JOTrMW/hv4mdJYT1zTQdHPdep4Ep53iw93AxieJ2Xx4xQ6lLYqcLuyDO199jPVNpCFIHAG64bfg8P6IDtzEOGjBlSGkBFmYCzfWvupoC24CTJZwp9Xo0xeQEXL9m1R6mBxHoqAk0yqZmQkdrWqa0+eReEKWBr0HwajU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXM933pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXM933pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E038C4CEF4;
	Sat, 11 Oct 2025 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760207743;
	bh=TssqD8Kkh+uuRl5AsbwSn9LFNiZtLEUMwOQ6rSTFBHg=;
	h=Date:To:From:Subject:From;
	b=KXM933pr9xbNHPeBgI1QMNa0tKIm96Q6Shuop26itfPE8Dh3i1sv4JKUKAuo1jfYN
	 FBJyZlU7hdROTzAl6o1FLn0uWnNaTT7FrmuBsgXG2Jv3UVBGHOPxlgvpDAcUsX2pXg
	 bC9ut6HPKenATDcjRiOIaV1bzrG7KvX1fR8Q4LFI=
Date: Sat, 11 Oct 2025 11:35:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch added to mm-new branch
Message-Id: <20251011183543.7E038C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: only get folio_order() once during __folio_split()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/huge_memory: only get folio_order() once during __folio_split()
Date: Fri, 10 Oct 2025 14:11:42 +0000

Before splitting folio, its order keeps the same.

It is only necessary to get folio_order() once.

Also rename order to old_order to represent the original folio order.

Link: https://lkml.kernel.org/r/20251010141142.1349-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-only-get-folio_order-once-during-__folio_split
+++ a/mm/huge_memory.c
@@ -3701,7 +3701,7 @@ static int __folio_split(struct folio *f
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
-	int order = folio_order(folio);
+	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
@@ -3715,7 +3715,7 @@ static int __folio_split(struct folio *f
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	if (new_order >= folio_order(folio))
+	if (new_order >= old_order)
 		return -EINVAL;
 
 	if (uniform_split && !uniform_split_supported(folio, new_order, true))
@@ -3787,7 +3787,7 @@ static int __folio_split(struct folio *f
 
 		if (uniform_split) {
 			xas_set_order(&xas, folio->index, new_order);
-			xas_split_alloc(&xas, folio, folio_order(folio), gfp);
+			xas_split_alloc(&xas, folio, old_order, gfp);
 			if (xas_error(&xas)) {
 				ret = xas_error(&xas);
 				goto out;
@@ -3843,13 +3843,13 @@ static int __folio_split(struct folio *f
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1 &&
+		if (old_order > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+				mod_mthp_stat(old_order,
+					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
 			/*
 			 * Reinitialize page_deferred_list after removing the
@@ -3977,7 +3977,7 @@ fail:
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 
-	remap_page(folio, 1 << order, remap_flags);
+	remap_page(folio, 1 << old_order, remap_flags);
 
 	/*
 	 * Unlock all after-split folios except the one containing
@@ -4008,9 +4008,9 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (order == HPAGE_PMD_ORDER)
+	if (old_order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
-	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
+	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch
mm-huge_memory-only-get-folio_order-once-during-__folio_split.patch

