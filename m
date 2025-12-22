Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9995C2C3261
	for <mm-commits@vger.kernel.org>; Mon, 22 Dec 2025 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766427301; cv=none; b=WHAbG+IUS2uHtMwDWZaVDKpi+oEBPUq++NWT881OCndWaQKU1RqQQFXOz1raAqWcARsmG5mBl8UbsY1gd2G+Ql9Ny8Wj4OtUHeE8PmQKnjhIuw5dPnx6hNHbXJMl/lR6qmrOnimV7nDpP4bKtROOpusgDzNXPtZDf/tnMBNINCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766427301; c=relaxed/simple;
	bh=iUmw3owyvqF9UsMxnqNiVumUjlz9GD5kmrMLsuSZJtY=;
	h=Date:To:From:Subject:Message-Id; b=n4/He19K2dmwQpPv87rRsqFs/FKKWB54mclIvoLNux4lLncx2/XkkDUyeX1hwnsL/lkZTlcX1mfpmseIeiDzHmWmYoGKKtu5BCqJ88WlL7H1idZ16oGFX7iyhir+TbgBohezNGuG6x0pfRdlktnmUzIbUp+h8V9T1uTtP86yU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQ4sGXTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQ4sGXTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E91C4CEF1;
	Mon, 22 Dec 2025 18:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766427301;
	bh=iUmw3owyvqF9UsMxnqNiVumUjlz9GD5kmrMLsuSZJtY=;
	h=Date:To:From:Subject:From;
	b=WQ4sGXTKxL0MgAzm/e9IEp+b/3hCrBtjqZg+npNtRc3UnASz4ypCBX1JC95Id4faw
	 izhbFa+FbAY3htqawS9dYHKCk76QKGtn6bnorseggWcQg4jgWE3AYnFyF9EDDen48t
	 RtvuV1OcCeI/kZ/Q/b6I2w/DdhvKsbFPOS5VyS98=
Date: Mon, 22 Dec 2025 10:15:00 -0800
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,urezki@gmail.com,sumit.semwal@linaro.org,mripard@kernel.org,jstultz@google.com,david@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-whenever-possible.patch removed from -mm tree
Message-Id: <20251222181501.18E91C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: map contiguous pages in batches for vmap() whenever possible
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-whenever-possible.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm/vmalloc: map contiguous pages in batches for vmap() whenever possible
Date: Mon, 15 Dec 2025 13:30:50 +0800

In many cases, the pages passed to vmap() may include high-order pages
allocated with __GFP_COMP flags.  For example, the systemheap often
allocates pages in descending order: order 8, then 4, then 0.  Currently,
vmap() iterates over every page individually—even pages inside a
high-order block are handled one by one.

This patch detects high-order pages and maps them as a single contiguous
block whenever possible.

An alternative would be to implement a new API, vmap_sg(), but that
change seems to be large in scope.

When vmapping a 128MB dma-buf using the systemheap, this patch makes
system_heap_do_vmap() roughly 17× faster.

W/ patch:
[   10.404769] system_heap_do_vmap took 2494000 ns
[   12.525921] system_heap_do_vmap took 2467008 ns
[   14.517348] system_heap_do_vmap took 2471008 ns
[   16.593406] system_heap_do_vmap took 2444000 ns
[   19.501341] system_heap_do_vmap took 2489008 ns

W/o patch:
[    7.413756] system_heap_do_vmap took 42626000 ns
[    9.425610] system_heap_do_vmap took 42500992 ns
[   11.810898] system_heap_do_vmap took 42215008 ns
[   14.336790] system_heap_do_vmap took 42134992 ns
[   16.373890] system_heap_do_vmap took 42750000 ns

Link: https://lkml.kernel.org/r/20251215053050.11599-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: John Stultz <jstultz@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-whenever-possible
+++ a/mm/vmalloc.c
@@ -647,6 +647,29 @@ static int vmap_small_pages_range_noflus
 	return err;
 }
 
+static inline int get_vmap_batch_order(struct page **pages,
+		unsigned int stride, unsigned int max_steps, unsigned int idx)
+{
+	int nr_pages = 1;
+
+	/*
+	 * Currently, batching is only supported in vmap_pages_range
+	 * when page_shift == PAGE_SHIFT.
+	 */
+	if (stride != 1)
+		return 0;
+
+	nr_pages = compound_nr(pages[idx]);
+	if (nr_pages == 1)
+		return 0;
+	if (max_steps < nr_pages)
+		return 0;
+
+	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
+		return compound_order(pages[idx]);
+	return 0;
+}
+
 /*
  * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
  * flush caches.
@@ -660,23 +683,33 @@ int __vmap_pages_range_noflush(unsigned
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
+	unsigned int stride;
 
 	WARN_ON(page_shift < PAGE_SHIFT);
 
+	/*
+	 * For vmap(), users may allocate pages from high orders down to
+	 * order 0, while always using PAGE_SHIFT as the page_shift.
+	 * We first check whether the initial page is a compound page. If so,
+	 * there may be an opportunity to batch multiple pages together.
+	 */
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
+			(page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
 		return vmap_small_pages_range_noflush(addr, end, prot, pages);
 
-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
+	stride = 1U << (page_shift - PAGE_SHIFT);
+	for (i = 0; i < nr; ) {
+		int err, order;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+		order = get_vmap_batch_order(pages, stride, nr - i, i);
+		err = vmap_range_noflush(addr, addr + (1UL << (page_shift + order)),
 					page_to_phys(pages[i]), prot,
-					page_shift);
+					page_shift + order);
 		if (err)
 			return err;
 
-		addr += 1UL << page_shift;
+		addr += 1UL  << (page_shift + order);
+		i += 1U << (order + page_shift - PAGE_SHIFT);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


