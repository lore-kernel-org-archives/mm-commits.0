Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FAA3F6C30
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525419; cv=none; b=OfexePl960BQXL+hggGr/Cek1ModkrWqglwMXns5WUY7C79wUINpDHOJQZ9OU5LCwUH3/uHe+C5t4ON+NYq/ZjNowoJQ36mgZOgoXzWEylVke3vXa0yp4SMuwLwV7H2M/azoZMDOXLeFfRtVNvm4eIW6p/5riKU5W7bh9AGPjhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525419; c=relaxed/simple;
	bh=+uiXBhCyJaxzjM2ymRjzLu9Xk0vjvX/gcsvaveLOYvA=;
	h=Date:To:From:Subject:Message-Id; b=nOheOt71m3VN0D128PyMoQKKD7op6z+ctKZaR0SEUoY16q0Evo9Jh9zSA/RT/YZVgvjZH/gs2zP1+NAE59xe7Uv5JhLLIP1LAuh3XbdZAXmLCO1G2tr1eXxteY4IS7vt+YOhk+lPMKyLttte1UqnKJT6l2zH7QR/o/X8U39SkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jX44yqjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jX44yqjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA3C1F000FF;
	Fri,  9 Oct 2026 05:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525417;
	bh=E/7U7icnZLFaVV3RrN+C/LY+YgyUi8YghQ+rHabYLG0=;
	h=Date:To:From:Subject;
	b=jX44yqjUs3vcp6Mj+c1jytrQaKDwdeV7J3YPeHjbxiCZ5SIT0XtxhfDPJ3b8ASgnv
	 5eYjG2Jc0+40rJHHVp5gzWOgkK+rvaZWbsou+qpBeyCl93/j9yb282u482fh1TrqkV
	 wssgMK/tYqTif/kVOyC/E99eo9ytO+boDs4NqYZY=
Date: Thu, 08 Oct 2026 22:56:57 -0700
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch removed from -mm tree
Message-Id: <20261009055657.ACA3C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: convert zswap_store_page() and zswap_compress() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wilson Felipe Pereira <wfelipe@google.com>
Subject: mm/zswap: convert zswap_store_page() and zswap_compress() to take a folio
Date: Fri, 4 Sep 2026 23:20:47 +0000

Currently, zswap_store() iterates through a folio and extracts individual
struct page pointers using folio_page() to pass into zswap_store_page()
and zswap_compress().

Pass the folio and the page index directly into these functions instead. 
This eliminates the need to materialize struct page pointers inside the
zswap_store() loop and replaces legacy page-based accessors with their
folio equivalents:

- sg_set_page() -> sg_set_folio()
- kmap_local_page() -> kmap_local_folio()
- page_to_nid() -> folio_nid()
- page_swap_entry() -> calculated via folio->swap and index

Link: https://lore.kernel.org/20260904232108.3034333-1-wfelipe@google.com
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
---

 mm/zswap.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/zswap.c~mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio
+++ a/mm/zswap.c
@@ -824,8 +824,8 @@ fail:
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+static bool zswap_compress(struct folio *folio, long index,
+			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -841,7 +841,7 @@ static bool zswap_compress(struct page *
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
+	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
@@ -870,8 +870,7 @@ static bool zswap_compress(struct page *
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
+		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
@@ -879,12 +878,12 @@ static bool zswap_compress(struct page *
 		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
-		dst = kmap_local_page(page);
+		dst = kmap_local_folio(folio, index * PAGE_SIZE);
 		mapped = true;
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
+	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
 	if (IS_ERR_VALUE(handle)) {
 		alloc_ret = PTR_ERR((void *)handle);
 		goto unlock;
@@ -1392,21 +1391,22 @@ resched:
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
+static bool zswap_store_page(struct folio *folio, long index,
 			     struct obj_cgroup *objcg,
 			     struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
+	swp_entry_t page_swpentry = swp_entry(swp_type(folio->swap),
+					      swp_offset(folio->swap) + index);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
 	}
 
-	if (!zswap_compress(page, entry, pool))
+	if (!zswap_compress(folio, index, entry, pool))
 		goto compress_failed;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
@@ -1515,9 +1515,7 @@ bool zswap_store(struct folio *folio)
 	}
 
 	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_page(folio, index, objcg, pool))
 			goto put_pool;
 	}
 
_

Patches currently in -mm which might be from wfelipe@google.com are


