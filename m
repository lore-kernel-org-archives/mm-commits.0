Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7882035960
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734573588; cv=none; b=WDb5HC8tjLwlkVf+/11SMMhGT/VBTnoUKuSvIbd6P52fzFwnqBj/rcyPTgioF9FafG1prlFQDV5aPY+51Lc08F8JN9xklOqbaApaJghGeDt/n6a8nID35JO6q25nszTSXdSbeLb8vW/TOt2HZMKq1OidW5uCSgTsuIZnkI06Pww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734573588; c=relaxed/simple;
	bh=PjCXGEnCaifIh/Ymlkuq/xtm4hPkSL8/3MtMYnnfNHM=;
	h=Date:To:From:Subject:Message-Id; b=bcHVrIRmtjuQ4CID+aToXzNuNrvuJvptyrbcN5i3WGTaj5jXrIiSNnyG7r6F07ia8myq+NZ6JMn07sZbXAA/JvzWZrwsA31QOHYjmu1x5TsIEG0Li1ecmTFpfMs7oNfpyilpOJrvNsGKQ0bmXZckgfTuSMa4GcSEREfn24+56AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbzLo9BA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbzLo9BA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E329AC4CECD;
	Thu, 19 Dec 2024 01:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734573588;
	bh=PjCXGEnCaifIh/Ymlkuq/xtm4hPkSL8/3MtMYnnfNHM=;
	h=Date:To:From:Subject:From;
	b=qbzLo9BAT6+JVG+NtvQuKpDioYzm39aWNxJi5AzA7Ix3gAICEkH5EpitUb6weg1ML
	 mn3vjcwlwwAyD49lE/PxWovTu/jh4YfQYnJ7oaC/f9fYJH+OspZskbzpZNvKXzk/r6
	 2MVqsUQjRTkb7rCMGpceq3XvDoTEPaiDHYPoGzh4=
Date: Wed, 18 Dec 2024 17:59:47 -0800
To: mm-commits@vger.kernel.org,yangge1116@126.com,muchun.song@linux.dev,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + replace-free-hugepage-folios-after-migration-fix.patch added to mm-unstable branch
Message-Id: <20241219015947.E329AC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: replace-free-hugepage-folios-after-migration-fix
has been added to the -mm mm-unstable branch.  Its filename is
     replace-free-hugepage-folios-after-migration-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/replace-free-hugepage-folios-after-migration-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: replace-free-hugepage-folios-after-migration-fix
Date: Wed Dec 18 05:57:21 PM PST 2024

fix comments, 80-column tweak

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: yangge <yangge1116@126.com>
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
@@ -6506,12 +6506,11 @@ int alloc_contig_range_noprof(unsigned l
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

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

