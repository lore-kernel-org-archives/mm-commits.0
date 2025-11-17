Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0F8224B06
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343210; cv=none; b=o1L44fkbG0JCPG5sDmrYLNw+Rnnzs4hMQgCZpx8rhClR6lKh1JGiGSTlUnBVXmtxA7vFtIMcnhXHRNqJiyK/OsjE2DKkoRdjYDzWEH0swxtM9YNMypqcIhAoUtV8RgQgBIh6Ajves26kkty2ZZe5OsaNBCSmiGKxbf3rVlT/dq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343210; c=relaxed/simple;
	bh=n5nv0RjL78R8s0ncf/iUChBhEc3xFUuT8S077I1Uyzc=;
	h=Date:To:From:Subject:Message-Id; b=bNgTaDCGtqZQAQs9LIfC/5OJBt12d2db688thczGEVpUTL0xhcjEa/aT6nzklWvrFUyGyNc5KMopMDavBV8sl1NgRUOqZSWn6WqSCRttodteeXn3+fIF2peO0haQVfN6nCCSzwe3RQ/OJ4cJce4GWOwewrMJMFJqcM92VlSvzG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A7Yrwy5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A7Yrwy5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447F9C4CEF1;
	Mon, 17 Nov 2025 01:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343210;
	bh=n5nv0RjL78R8s0ncf/iUChBhEc3xFUuT8S077I1Uyzc=;
	h=Date:To:From:Subject:From;
	b=A7Yrwy5x4JrIIpNW8+fV4B7gBGREPrrvjPtVTznuMSZspxYTRWVywnLjwO8f9wS2L
	 z5fbQ+qighP4MUNtCrIaBnrDVrNIdqgQFZl5LzLYH36czepm7IZEW3c2464m/Pz1D9
	 8TxofS76O7XP37SiyIvRczx85fYd1NYIMDgqfTOg=
Date: Sun, 16 Nov 2025 17:33:29 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch removed from -mm tree
Message-Id: <20251117013330.447F9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: request large order pages from buddy allocator
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-request-large-order-pages-from-buddy-allocator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
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

mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
mm-vmalloc-add-a-helper-to-optimize-vmalloc-allocation-gfps.patch
mm-vmalloc-cleanup-large_gfp-in-vm_area_alloc_pages.patch
mm-vmalloc-cleanup-gfp-flag-use-in-new_vmap_block.patch

