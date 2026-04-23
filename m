Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A3537E31A
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 11:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776942783; cv=none; b=Zk47ExtdDJOyLlULJpmShTFI+Eu8m9n+7KlccYu/oxka3Bjq7budrxsXVADmSaM1XKrgFT/agZUteNZ/N7mNxzgy9LVATGoUPM+Z/M9WNdIPPJ9CAsj7u3hgpJcs05oOGAMoUXIfH9iQZ5cjQdq5yfAZZ2k2zZtO8g11Te1ncvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776942783; c=relaxed/simple;
	bh=lMsjzTvT/QuEFXkwE6JM4fiSOrjcSwQp/1gYRc+UUOI=;
	h=Date:To:From:Subject:Message-Id; b=sMqGc0DxHy9vOxVNpYtrKm8Ip0RzFbORT1TRQbHKKw+4VthLA3f/ebjxG/+hsKJR57n0LzktMCCn47DYKJFdxPOC+Cf9bPV47H00akI2scOIyUGlXLUapu9Iqg09DczuEDsVxliukFgGkgMZnFzshJY+AWoVhI3/r2+H4Fp6oM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LBeK5OhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LBeK5OhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAE0C2BCAF;
	Thu, 23 Apr 2026 11:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776942783;
	bh=lMsjzTvT/QuEFXkwE6JM4fiSOrjcSwQp/1gYRc+UUOI=;
	h=Date:To:From:Subject:From;
	b=LBeK5OhWSOnjNRkc6NrtmZse7Abz0CuBowyPVNrk2EBAYbHWkGikV2nyuCpInTnqC
	 OJT90QLUyuIOeyiKimqL0A6iiEZ4WQe/i7BGxmCfvBa7m9DZKNmlOoBob/9N+9BwxK
	 gta6BbNh3qVGZtzn+TgecH7bHz636nMuNBYuMEEo=
Date: Thu, 23 Apr 2026 04:13:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shivankg@amd.com,rppt@kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bharata@amd.com,ankur.a.arora@oracle.com,hsalunke@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch added to mm-new branch
Message-Id: <20260423111302.EDAE0C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: replace kernel_init_pages() with batch page clearing
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch

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
From: Hrushikesh Salunke <hsalunke@amd.com>
Subject: mm/page_alloc: replace kernel_init_pages() with batch page clearing
Date: Wed, 22 Apr 2026 10:26:58 +0000

When init_on_alloc is enabled, kernel_init_pages() clears every page
one at a time via clear_highpage_kasan_tagged(), which incurs per-page
kmap_local_page()/kunmap_local() overhead and prevents the architecture
clearing primitive from operating on contiguous ranges.

Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
clearing helper that calls clear_pages() for the full contiguous range
on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
a single invocation of the arch clearing primitive across the entire
allocation. The HIGHMEM path falls back to per-page clearing since
those pages require kmap.

Replace kernel_init_pages() with direct calls to the new helper, as it
becomes a trivial wrapper.

Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:

  Before: 0.445s
  After:  0.166s  (-62.7%, 2.68x faster)

Kernel time (sys) reduction per workload with init_on_alloc=1:

  Workload            Before       After       Change
  Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
  Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
  Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
  Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%

Link: https://lore.kernel.org/20260422102729.166599-1-hsalunke@amd.com
Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   15 +++++++++++++++
 mm/page_alloc.c         |   15 ++-------------
 2 files changed, 17 insertions(+), 13 deletions(-)

--- a/include/linux/highmem.h~mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing
+++ a/include/linux/highmem.h
@@ -345,6 +345,21 @@ static inline void clear_highpage_kasan_
 	kunmap_local(kaddr);
 }
 
+static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
+{
+	/* s390's use of memset() could override KASAN redzones. */
+	kasan_disable_current();
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_pages(kasan_reset_tag(page_address(page)), numpages);
+	} else {
+		int i;
+
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
+	kasan_enable_current();
+}
+
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 /* Returns true if the caller has to initialize the pages */
--- a/mm/page_alloc.c~mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing
+++ a/mm/page_alloc.c
@@ -1208,17 +1208,6 @@ static inline bool should_skip_kasan_poi
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-static void kernel_init_pages(struct page *page, int numpages)
-{
-	int i;
-
-	/* s390's use of memset() could override KASAN redzones. */
-	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
-	kasan_enable_current();
-}
-
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -1428,7 +1417,7 @@ __always_inline bool __free_pages_prepar
 			init = false;
 	}
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -1853,7 +1842,7 @@ inline void post_alloc_hook(struct page
 	}
 	/* If memory is still not initialized, initialize it now. */
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
_

Patches currently in -mm which might be from hsalunke@amd.com are

mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch

