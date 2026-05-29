Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683CA3624C2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027559; cv=none; b=eDtPCIQ9F6AfgWcdI117oplso63qyD8NKgyCOTt53Te309h5D3f+FzTM7R+UiKvVGbMbTQGU8iq6PwkB7tvkP7i9GkO1iwJwgO1EO+r9MERZWiKPU1J3ISUMlmqWP2Qayzfj3UcAkfa7BL99eawhMiBnSL7Oj8BA1HmcZoaemm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027559; c=relaxed/simple;
	bh=6U8PEeDohAwavPdTAfjKmTluSvDv4A0Vw7IMfMF/+nA=;
	h=Date:To:From:Subject:Message-Id; b=aX9ipvjd8iz19J6yCOe99eGK1Y2dpkTMtOl8MobC6qbtkiRldFWN4BCvKSk/nSqTICmsX8JwP3CxTp8IXWUxNc7qRYpQj7SkRVb+TZP9FQR1IGJpHmPdla8X4sIZu2VZ14iyKNcyDgcytcg5c5SiXMZQrQMVB/98LYf28yFZ8UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BNfOx+l3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BNfOx+l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227001F0089A;
	Fri, 29 May 2026 04:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027558;
	bh=OyNEmXd2gjc1HPk425Tmp0TgNKVlPqIYqpw6dAcUk/Q=;
	h=Date:To:From:Subject;
	b=BNfOx+l38UPWbm6LYWL4zH78oy/uKBNFgRaxaVxyQ2vzFSeYWhAyCJ8lVzt+pRbK9
	 ey28ZksSi2TXnbFwKX8gMabPmd9n2ENUha6cXIN6Yz2hwEJ9UwOZ3GEQJSh7PcpmwN
	 +7GLlTw4bGLu3dLPjBe78ebvz3FZ6gxtT0+COAwM=
Date: Thu, 28 May 2026 21:05:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shivankg@amd.com,rppt@kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bharata@amd.com,ankur.a.arora@oracle.com,hsalunke@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch removed from -mm tree
Message-Id: <20260529040558.227001F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: replace kernel_init_pages() with batch page clearing
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hrushikesh Salunke <hsalunke@amd.com>
Subject: mm/page_alloc: replace kernel_init_pages() with batch page clearing
Date: Wed, 22 Apr 2026 10:26:58 +0000

When init_on_alloc is enabled, kernel_init_pages() clears every page one
at a time via clear_highpage_kasan_tagged(), which incurs per-page
kmap_local_page()/kunmap_local() overhead and prevents the architecture
clearing primitive from operating on contiguous ranges.

Introduce clear_highpages_kasan_tagged() as a static batch clearing helper
in page_alloc.c that calls clear_pages() for the full contiguous range on
!HIGHMEM systems, bypassing the per-page kmap overhead and allowing a
single invocation of the arch clearing primitive across the entire
allocation.  The HIGHMEM path falls back to per-page clearing since those
pages require kmap.

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

[hsalunke@amd.com: move clear_highpages_kasan_tagged() to page_alloc.c]
  Link: https://lore.kernel.org/20260504063942.553438-1-hsalunke@amd.com
Link: https://lore.kernel.org/20260422102729.166599-1-hsalunke@amd.com
Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing
+++ a/mm/page_alloc.c
@@ -1211,14 +1211,18 @@ static inline bool should_skip_kasan_poi
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
-static void kernel_init_pages(struct page *page, int numpages)
+static void clear_highpages_kasan_tagged(struct page *page, int numpages)
 {
-	int i;
-
 	/* s390's use of memset() could override KASAN redzones. */
 	kasan_disable_current();
-	for (i = 0; i < numpages; i++)
-		clear_highpage_kasan_tagged(page + i);
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_pages(kasan_reset_tag(page_address(page)), numpages);
+	} else {
+		int i;
+
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
 	kasan_enable_current();
 }
 
@@ -1423,7 +1427,7 @@ __always_inline bool __free_pages_prepar
 			init = false;
 	}
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
@@ -1848,7 +1852,7 @@ inline void post_alloc_hook(struct page
 	}
 	/* If memory is still not initialized, initialize it now. */
 	if (init)
-		kernel_init_pages(page, 1 << order);
+		clear_highpages_kasan_tagged(page, 1 << order);
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
_

Patches currently in -mm which might be from hsalunke@amd.com are


