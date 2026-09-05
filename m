Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEF032B130
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788651449; cv=none; b=eU6cAm9q5Pb9/xUAaISfORHx71J15OHlDIZR1Zo2HXGlRPQZWMoa6k0f9tkFypB4r9OoHArHvitvzWd+qEcbhifgNDa7LrH+/ADpjXdPo/+Q3ubb4saX3PLF9wh+d7AbfsojAwjVt0agzWVz0DNDCzEPzYobiLclf/+HVTb+OBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788651449; c=relaxed/simple;
	bh=la4F2Lr4gxtShmp3uW91s8YuKqmLDxfHK954w8RObrA=;
	h=Date:To:From:Subject:Message-Id; b=V7HD5hcVrO1FKwvi04cdYkJw9P8vsIyfzvUn5px0vmjs34URp2Ql8tCkmDvSOjop0RKGYAXNFhPH64mGSdrScQ4kCGhxHQyc+UvX5UuyOl6PhXrAXWnk8DHNK42Ff5tB8B9IZhkBOLL7nNL4IvvbF0f2f2bGS+6iKXNUJ3X7DsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zT6RL49m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zT6RL49m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618221F00A3A;
	Sat,  5 Sep 2026 23:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788651447;
	bh=M6zUpUDVYg/GIJEqsDmBb7GYjGXFi7aOdDqyegTsFI0=;
	h=Date:To:From:Subject;
	b=zT6RL49mhX6hPyuGTuASJN5/maRXM9i0vHwAramQJWV4VXkaevESWL/z8hluV/5Du
	 Ed2ONQGOmck26GIaijtTzbSyOMxKeOpJSr8KPdp4Gvqpm1uKGCdcD2eYiHt3LVxrqC
	 8HVQhd4YiBoOJLR8T6MjNKox5uUjcuhiCyF9NiII=
Date: Sat, 05 Sep 2026 16:37:26 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wfelipe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch added to mm-new branch
Message-Id: <20260905233727.618221F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: convert zswap_store_page() and zswap_compress() to take a folio
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch

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
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/zswap.c~mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio
+++ a/mm/zswap.c
@@ -827,8 +827,8 @@ fail:
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+static bool zswap_compress(struct folio *folio, long index,
+			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -844,7 +844,7 @@ static bool zswap_compress(struct page *
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
+	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
@@ -873,8 +873,7 @@ static bool zswap_compress(struct page *
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
+		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
@@ -882,12 +881,12 @@ static bool zswap_compress(struct page *
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
@@ -1395,21 +1394,22 @@ resched:
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
@@ -1518,9 +1518,7 @@ bool zswap_store(struct folio *folio)
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

selftests-cgroup-test_zswap-wait-for-cgroup-to-unpopulate-in-test_zswap_writeback.patch
selftests-cgroup-test_zswap-fix-implicit-unsigned-promotion-bug-in-test_no_kmem_bypass.patch
mm-zswap-convert-zswap_store_page-and-zswap_compress-to-take-a-folio.patch
init-arch-make-config_command_line_size-globally-configurable.patch
init-kconfig-make-config-init_env_arg_limit-user-configurable.patch
init-main-fix-off-by-one-in-argv_init-cleanup.patch
init-main-fix-false-positive-kernel-panic-on-environment-variable-overwrite.patch

