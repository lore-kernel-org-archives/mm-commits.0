Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15542853F2
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 21:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761081918; cv=none; b=Gal9KTFHjXEVLueHzwN0WRZv7dcbs3/8HFCmVnOgak81R0qUC3FuAtG5SYxT0BQCWAd6L/EnfFG80nrgq4bx+7xgTFYbKogZxuIrUPvXcs/EVnGWysW/Jf9dPttdn00Plm/PD8xOSYoyEto5X6OhsmxxKkLmcXNk2euqTDYW7Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761081918; c=relaxed/simple;
	bh=E/fcu6m4C+HNeI0DQJyCtVlodr4Q7ewTfRXdgxwyTSg=;
	h=Date:To:From:Subject:Message-Id; b=PNN/RSURXJFIFI8st7e4I0S6wUs0VSllTSp/mpQEtNCcNOg/IclxHRQJd7C4ccK++/y80DFS1f2E1TxL12a4hSzouwFNUzJIiWIRKMgDLoTCuIkUjatgp3IYbMA0kEiNSZ2HCB6z9iCOLxW3jU/ZmwfCHhENGLeO5lhJdpDmSVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qoeWbVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qoeWbVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463CCC4CEF1;
	Tue, 21 Oct 2025 21:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761081917;
	bh=E/fcu6m4C+HNeI0DQJyCtVlodr4Q7ewTfRXdgxwyTSg=;
	h=Date:To:From:Subject:From;
	b=0qoeWbVUX1684CmW+msdzEWOSdPmr92zLHhZ8FV0cf/63w1hoU6GdtX8iuxK2YZci
	 /Y9YcNv3cl1HU2CEKXobMGuCqm5u/rMQJlu/BwpzNhY9qxLVq/YtR8n64rdZ6k9+0i
	 /TSCyVC6kKb/IYzgXqcKt3y14ByDp1dL+/KQ/2Qs=
Date: Tue, 21 Oct 2025 14:25:16 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch added to mm-new branch
Message-Id: <20251021212517.463CCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: request large order pages from buddy allocator
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/vmalloc: request large order pages from buddy allocator
Date: Tue, 21 Oct 2025 12:44:56 -0700

Sometimes, vm_area_alloc_pages() will want many pages from the buddy
allocator.  Rather than making requests to the buddy allocator for at most
100 pages at a time, we can eagerly request large order pages a smaller
number of times.

We still split the large order pages down to order-0 as the rest of the
vmalloc code (and some callers) depend on it.  We still defer to the bulk
allocator and fallback path in case of order-0 pages or failure.

Running 1000 iterations of allocations on a small 4GB system finds:

1000 2mb allocations:
	[Baseline]			[This patch]
	real    46.310s			real    0m34.582
	user    0.001s			user    0.006s
	sys     46.058s			sys     0m34.365s

10000 200kb allocations:
	[Baseline]			[This patch]
	real    56.104s			real    0m43.696
	user    0.001s			user    0.003s
	sys     55.375s			sys     0m42.995s

Link: https://lkml.kernel.org/r/20251021194455.33351-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-request-large-order-pages-from-buddy-allocator
+++ a/mm/vmalloc.c
@@ -3619,8 +3619,44 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
+	unsigned int nr_remaining = nr_pages;
+	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
+	gfp_t large_gfp = (gfp &
+		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
+		| __GFP_NOWARN;
+	unsigned int large_order = ilog2(nr_remaining);
+
+	large_order = min(max_attempt_order, large_order);
+
+	/*
+	 * Initially, attempt to have the page allocator give us large order
+	 * pages. Do not attempt allocating smaller than order chunks since
+	 * __vmap_pages_range() expects physically contigous pages of exactly
+	 * order long chunks.
+	 */
+	while (large_order > order && nr_remaining) {
+		if (nid == NUMA_NO_NODE)
+			page = alloc_pages_noprof(large_gfp, large_order);
+		else
+			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
+
+		if (unlikely(!page)) {
+			max_attempt_order = --large_order;
+			continue;
+		}
+
+		split_page(page, large_order);
+		for (i = 0; i < (1U << large_order); i++)
+			pages[nr_allocated + i] = page + i;
+
+		nr_allocated += 1U << large_order;
+		nr_remaining = nr_pages - nr_allocated;
+
+		large_order = ilog2(nr_remaining);
+		large_order = min(max_attempt_order, large_order);
+	}
 
 	/*
 	 * For order-0 pages we make use of bulk allocator, if
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch

