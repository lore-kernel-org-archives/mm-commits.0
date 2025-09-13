Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678828488
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801740; cv=none; b=HWFCFb5uOCdoJN/MJto0fSu90Ca6d5JhSlk8Szsa++mmsTxflltlKvvgFOhet+LNXdu4zdDJDGPGn1EtDeH1uxTBgHoeYlf8KNrrpSjItsKDjelRkUPbSfbrzVMVF652dot6DrAB9+3lb5fvz//FGWGvB9Zi8LGPZmAU4oZJI7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801740; c=relaxed/simple;
	bh=HxwTNvj9hJoPk1Q8ouxc5FAX2668SYSklwJuisA+cCo=;
	h=Date:To:From:Subject:Message-Id; b=oLyw1Ez9QoSaSD14jEt3d/z0y7E+h5zMGvoXHR+9kD5OwBIwSBQ/impF64jaDAyIQ3X6SdpQN99krwcdpIeQgDiEuBV06kYTifY11ZkPtoU1ztXumsTAPK2J4K/NcnQ5kERs0e/kD57rUGOUSk2VH34MtikHbOydjFwzxwFSQ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UgNHKYoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UgNHKYoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E940DC4CEEB;
	Sat, 13 Sep 2025 22:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801740;
	bh=HxwTNvj9hJoPk1Q8ouxc5FAX2668SYSklwJuisA+cCo=;
	h=Date:To:From:Subject:From;
	b=UgNHKYoS26cwsCD7dkOs6+Mxcnb7GmbbXZK04y5Ac+pp2m1mc3v8MnIiWtiB6lPvi
	 t89NxgRpQGhdamGulCe0ET1Afp+ylLxysXIarQq2C9zmD2Oj8ze2pE42pnqMpT9hvw
	 OMkRNN3XmvCKxEDA3fFvROYF7pt+dnoaZcAcP2GE=
Date: Sat, 13 Sep 2025 15:15:39 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,flintglass@gmail.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baohua@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch removed from -mm tree
Message-Id: <20250913221539.E940DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: cleanup incompressible pages handling code
has been removed from the -mm tree.  Its filename was
     mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch

This patch was dropped because it was folded into mm-zswap-store-page_size-compression-failed-page-as-is.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: cleanup incompressible pages handling code
Date: Wed, 27 Aug 2025 13:18:38 -0700

Following Chris Li's suggestions [1], make the code easier to read and
manage.

Link: https://lkml.kernel.org/r/20250828163913.57957-1-sj@kernel.org
Kink: https://lore.kernel.org/CACePvbWGPApYr7G29FzbmWzRw-BJE39WH7kUHSaHs+Lnw8=-qQ@mail.gmail.com [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Takero Funaki <flintglass@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/zswap.c~mm-zswap-store-page_size-compression-failed-page-as-is-fix-2
+++ a/mm/zswap.c
@@ -952,6 +952,7 @@ static bool zswap_compress(struct page *
 	struct zpool *zpool;
 	gfp_t gfp;
 	u8 *dst;
+	bool mapped = false;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	dst = acomp_ctx->buffer;
@@ -988,9 +989,8 @@ static bool zswap_compress(struct page *
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen)
+	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		dlen = PAGE_SIZE;
-	if (dlen >= PAGE_SIZE) {
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
@@ -999,6 +999,7 @@ static bool zswap_compress(struct page *
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
+		mapped = true;
 	}
 
 	zpool = pool->zpool;
@@ -1012,7 +1013,7 @@ static bool zswap_compress(struct page *
 	entry->length = dlen;
 
 unlock:
-	if (dst != acomp_ctx->buffer)
+	if (mapped)
 		kunmap_local(dst);
 	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
 		zswap_reject_compress_poor++;
@@ -1030,7 +1031,7 @@ static bool zswap_decompress(struct zswa
 	struct zpool *zpool = entry->pool->zpool;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	int decomp_ret, dlen;
+	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
@@ -1039,9 +1040,7 @@ static bool zswap_decompress(struct zswa
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
 		memcpy_to_folio(folio, 0, obj, entry->length);
-		zpool_obj_read_end(zpool, entry->handle, obj);
-		acomp_ctx_put_unlock(acomp_ctx);
-		return true;
+		goto read_done;
 	}
 
 	/*
@@ -1064,6 +1063,7 @@ static bool zswap_decompress(struct zswa
 	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
 
+read_done:
 	zpool_obj_read_end(zpool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

