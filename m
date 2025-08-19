Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE91023ABAF
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 22:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755641701; cv=none; b=Wqg9YTcwLIjCmGBE6T9PumbWvx4r7G6bKIgK05Ibuv6H3KMBW3x9YnOoNPPP8C6g2EhjX868VAnu+8D2KeRBIarEhp58Z1xpsPoaGpFSSxREp5gEKmyx+kUwdKUr2MQwl+sZswynSFZ46xO2qffvvNtiojCr48AUZ0mqQFp/RZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755641701; c=relaxed/simple;
	bh=4sLP4CNHWudN0duJi78x5iNyThAU6L7q/fKns5TjQf4=;
	h=Date:To:From:Subject:Message-Id; b=rYVKlPM+6gBVEJwm5Xu1izCx6RTSPHok++BjLo93ob110FkWpCtCgoG18qwy5Ksru1MirfinZYKPYoPuDylhokdarO3RU0PNbkfq+KkgVEfR2/SAPeceXQsmA1m9jrKLMfjETvkKpvyRiQbmaiDUJEFxRblKkQDQuSRkVbpiGPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TjIiOE7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TjIiOE7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA43C4CEF1;
	Tue, 19 Aug 2025 22:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755641701;
	bh=4sLP4CNHWudN0duJi78x5iNyThAU6L7q/fKns5TjQf4=;
	h=Date:To:From:Subject:From;
	b=TjIiOE7uiP3EISwfp0VJCmS4Dx/sYQRUkUxJn/mRafc1WktFooB3KHJFdsj+JGbCM
	 iRGVO+Rtn4vJgVDP59rKOOFWU20YvPeagSf0OpQuD3u1ur1NKQqoeNVHqNjaGKS+oO
	 bU2RnkVkpHdDY2sevX0DoXu8pbvv//a890nsYoNM=
Date: Tue, 19 Aug 2025 15:15:00 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch added to mm-new branch
Message-Id: <20250819221501.2FA43C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: selftests/mm: use nr_pages instead of 1UL << order.
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: fixup: selftests/mm: use nr_pages instead of 1UL << order.
Date: Tue, 19 Aug 2025 12:52:13 -0400

reduce code duplication, per David

Link: https://lkml.kernel.org/r/F54782D6-65A3-4D35-AE03-8ADE636EE258@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -38,6 +38,7 @@ unsigned int pmd_order;
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
+	const unsigned long nr_pages = 1UL << order;
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
 	unsigned long pfn;
@@ -63,7 +64,7 @@ static bool is_backed_by_folio(char *vad
 	if (!(pfn_flags & KPF_THP))
 		return false;
 
-	pfn_head = pfn & ~((1 << order) - 1);
+	pfn_head = pfn & ~(nr_pages - 1);
 
 	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
 		goto fail;
@@ -73,7 +74,7 @@ static bool is_backed_by_folio(char *vad
 		return false;
 
 	/* check all tail PFN flags */
-	for (i = 1; i < 1UL << order; i++) {
+	for (i = 1; i < nr_pages; i++) {
 		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
 			goto fail;
 		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
@@ -84,7 +85,7 @@ static bool is_backed_by_folio(char *vad
 	 * check the PFN after this folio, but if its flags cannot be obtained,
 	 * assume this folio has the expected order
 	 */
-	if (pageflags_get(pfn_head + (1UL << order), kpageflags_fd, &pfn_flags))
+	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
 		return true;
 
 	/* this folio is bigger than the given order */
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-force_read-to-read-input-value-correctly.patch
mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-mark-all-functions-static-in-split_huge_page_testc.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check.patch
selftests-mm-reimplement-is_backed_by_thp-with-more-precise-check-fix.patch
selftests-mm-add-check_after_split_folio_orders-helper.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

