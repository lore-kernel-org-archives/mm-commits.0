Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80892632
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 05:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736659653; cv=none; b=uj8R/hJ6LHjJ4fHvho45iZcX+/EYcYhuGMSi51mtirC8DGOpslsl/OeCvcC9pRrJ/cG2SChi4U7jAUcHsYlR8HyBDQOZm1trIjmNGEVpRCfAAAu5NJASscaWoG5rfSRlgo81Ejrx1PDO98LoQLDTsRnJJxUpBXth9DNSY8uYTw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736659653; c=relaxed/simple;
	bh=HT4b6+4flhrmqHF6sk7AbyYGsu9tMrhL0S9D6ih5rNQ=;
	h=Date:To:From:Subject:Message-Id; b=jaYDdHs8tWkf4JzimSowVIu/JjPhMexBes3jL/TpkJV9BE+t/tJcbBOQ0BLwDESLDM4n0mkSvEDUl+OuN+ZuStW5IbKvge3J/vZrVDqttxkGAufu3zI1e1hbUVpB2cJGDF/up4PT273lbTgASv2nlNAeVwsqIBA5cBw2E8rvkRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B7EH/UTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7EH/UTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB28C4CEE0;
	Sun, 12 Jan 2025 05:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736659653;
	bh=HT4b6+4flhrmqHF6sk7AbyYGsu9tMrhL0S9D6ih5rNQ=;
	h=Date:To:From:Subject:From;
	b=B7EH/UTeu9cosG2vdiQ+QJV+KM61jY5Bjor1eXXE0ldMEOg6ku4U41gPn9O58+j78
	 TwaxBhxez0eKcK72NDaA0cVZrxWaqJ3AQHX9nlvZpCnAKYltNaykwhxtgqsA+vyuuV
	 sIJiXugJZTdu7vFNW5+sQpedCrI3ria12Uuv8vQs=
Date: Sat, 11 Jan 2025 21:27:32 -0800
To: mm-commits@vger.kernel.org,yangge1116@126.com,sj@kernel.org,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] replace-free-hugepage-folios-after-migration-fix.patch removed from -mm tree
Message-Id: <20250112052732.DFB28C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: replace-free-hugepage-folios-after-migration-fix
has been removed from the -mm tree.  Its filename was
     replace-free-hugepage-folios-after-migration-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: replace-free-hugepage-folios-after-migration-fix
Date: Wed Dec 18 05:57:21 PM PST 2024

fix comments, 80-column tweak

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: yangge <yangge1116@126.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c    |    5 +++--
 mm/page_alloc.c |   11 +++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~replace-free-hugepage-folios-after-migration-fix
+++ a/mm/hugetlb.c
@@ -2978,7 +2978,7 @@ int isolate_or_dissolve_huge_page(struct
 /*
  *  replace_free_hugepage_folios - Replace free hugepage folios in a given pfn
  *  range with new folios.
- *  @stat_pfn: start pfn of the given pfn range
+ *  @start_pfn: start pfn of the given pfn range
  *  @end_pfn: end pfn of the given pfn range
  *  Returns 0 on success, otherwise negated error.
  */
@@ -3000,7 +3000,8 @@ int replace_free_hugepage_folios(unsigne
 		}
 
 		if (!folio_ref_count(folio)) {
-			ret = alloc_and_dissolve_hugetlb_folio(h, folio, &isolate_list);
+			ret = alloc_and_dissolve_hugetlb_folio(h, folio,
+							       &isolate_list);
 			if (ret)
 				break;
 
--- a/mm/page_alloc.c~replace-free-hugepage-folios-after-migration-fix
+++ a/mm/page_alloc.c
@@ -6509,12 +6509,11 @@ int alloc_contig_range_noprof(unsigned l
 		goto done;
 
 	/*
-	 * When in-use hugetlb pages are migrated, they may simply be
-	 * released back into the free hugepage pool instead of being
-	 * returned to the buddy system. After the migration of in-use
-	 * huge pages is completed, we will invoke the
-	 * replace_free_hugepage_folios() function to ensure that
-	 * these hugepages are properly released to the buddy system.
+	 * When in-use hugetlb pages are migrated, they may simply be released
+	 * back into the free hugepage pool instead of being returned to the
+	 * buddy system.  After the migration of in-use huge pages is completed,
+	 * we will invoke replace_free_hugepage_folios() to ensure that these
+	 * hugepages are properly released to the buddy system.
 	 */
 	ret = replace_free_hugepage_folios(start, end);
 	if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch
hung_task-add-task-flags-blocked-by-coredump-to-log-fix.patch

