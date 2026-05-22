Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619F9257459;
	Fri, 22 May 2026 18:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779474092; cv=none; b=puOcEW/l2+OE5XFKuNGh+jB6k6vkwoGFfB0wb/1tuAgoAAAgJ1sSa26BqcKtlyymlU2S/FIgFl9d7CaJ4+6F3RYNcAkpjC1NVOZRcFM5EkJohUPMC/2EqjLrBFBYfgvUdRU+p9sQxy9h5ct7rrKiyDx68q1byRprxI5hq5j4iKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779474092; c=relaxed/simple;
	bh=eRl4shUEi5QLvdF4zeGSMq/iaU0zgIS1NjbRqiaWmb0=;
	h=Date:To:From:Subject:Message-Id; b=HeWmD07c/ySFgu6nclH4HlEjg5s+p3p875RLySQew3/ZkLf4bouWP92p8i7ZFugakHtV5ggSpqU1cXId7M4Ckh4XdX/wL06sIkgZoqVieHD/iZfFyMfzRL4goG0aw5M1+21ioBCRj1JyGwtHRowSB4IBEoWIz4ridm0SAQwJNgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYP8CXrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYP8CXrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B2F1F00ADE;
	Fri, 22 May 2026 18:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779474091;
	bh=pBJ6FuyFlFt6o7BJE2eMhBkzUApGogFrBeTLh6e1KzE=;
	h=Date:To:From:Subject;
	b=FYP8CXrLx+ash+bhjMHq0jr4yToX1KebD+eM//xTQPv/BLyZmL+cpQiV3ZSsVXL6T
	 x/eTSgodcMPJfuSs2Gkuo4PKP0QBC4fc4gCrxw8GeBiS7bKhUJCb64zGWpFAFtcWHH
	 PUY7hZ3CtERNbWIEOfWNQ6cFmN2JBXFVi6HQI+P0=
Date: Fri, 22 May 2026 11:21:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-fix-reserved-page-leak-on-activation-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20260522182131.14B2F1F00ADE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: fix reserved page leak on activation failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-fix-reserved-page-leak-on-activation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-fix-reserved-page-leak-on-activation-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/cma: fix reserved page leak on activation failure
Date: Fri, 22 May 2026 14:26:58 +0800

If cma_activate_area() fails after allocating only part of the range
bitmaps, its cleanup path frees the bitmaps for the ranges below
allocrange and then releases reserved pages using the same bound.

That bound is only correct for bitmap freeing.  Pages in ranges that did
not reach bitmap allocation are still reserved and should also be returned
to the buddy when CMA_RESERVE_PAGES_ON_ERROR is clear.  As a result, a
partial bitmap allocation failure can permanently leak the reserved pages
from the failed range and all later ranges.

Fix this by releasing reserved pages for all ranges.  For ranges whose
bitmap allocation succeeded, use the early_pfn[] snapshot saved before the
bitmap pointer overwrote the union field.  For later ranges, continue to
use cmr->early_pfn directly.

Link: https://lore.kernel.org/20260522062658.4095405-1-songmuchun@bytedance.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-fix-reserved-page-leak-on-activation-failure
+++ a/mm/cma.c
@@ -188,10 +188,13 @@ cleanup:
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < allocrange; r++) {
+		for (r = 0; r < cma->nranges; r++) {
+			unsigned long start_pfn;
+
 			cmr = &cma->ranges[r];
+			start_pfn = r < allocrange ? early_pfn[r] : cmr->early_pfn;
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
+			for (pfn = start_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-cma_debug-fix-invalid-accesses-for-inactive-cma-areas.patch
mm-cma-fix-reserved-page-leak-on-activation-failure.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch
mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch
mm-memory_hotplug-fix-incorrect-altmap-passing-in-error-path.patch
mm-sparse-vmemmap-pass-pgmap-argument-to-memory-deactivation-paths.patch
mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch
mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch
mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

