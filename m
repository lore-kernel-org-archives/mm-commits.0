Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B858488
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801739; cv=none; b=B9/c0MFg64jgaG1LwOB6va1QJ432uUKxKSK8YHltu/Egkx86l+9AJPL/m/FTIu3Rx5ejJvQufmpTCjCY88JBNiY5Slfz3JzeQDAxdyv+0sXSwtw4Ny3LOgVGJARngJVTK8t563SrmqKFHPpf9cQ+Kd0AQee+gRz7UQ+7TPd13As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801739; c=relaxed/simple;
	bh=ua6yLn/Gl9GFaDsgVMKjc6YcBUhHoeMQf44ihax5z4Q=;
	h=Date:To:From:Subject:Message-Id; b=X5lDuzITU0+P4fOtHKlI7fwth0yjlVFRxjIJLUC6GWrhHtahB29WrpnLdRQdVtuwCOJquoBYNT21fHwxLSo04yvsZTO/5mMDLS1pno0dCEIFUGH6NtWj1OiCpoHLDazRrCtuREVWjcYnrMaiCuT+mO5O2DgG5WPsKoFcsvjWq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dM4mC+DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dM4mC+DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98742C4CEEB;
	Sat, 13 Sep 2025 22:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801738;
	bh=ua6yLn/Gl9GFaDsgVMKjc6YcBUhHoeMQf44ihax5z4Q=;
	h=Date:To:From:Subject:From;
	b=dM4mC+DGg8hSpt8sXh9jG+DjqO6KJhXCqxpnGnQLNgqYhUo6bQ7YIGNpUDOkY5qhs
	 0S3y7xBGqrFgVFQ6gmQFKbSnbht+6VzaQYEuvM9SE4P/aYZs3cuEycj2E2EDIx0CtR
	 7m64dfXNgvdBPNixQIpDn+gYy+9383yaKGLq4W/4=
Date: Sat, 13 Sep 2025 15:15:38 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,flintglass@gmail.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baohua@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch removed from -mm tree
Message-Id: <20250913221538.98742C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zswap-store-page_size-compression-failed-page-as-is-v5
has been removed from the -mm tree.  Its filename was
     mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch

This patch was dropped because it was folded into mm-zswap-store-page_size-compression-failed-page-as-is.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm-zswap-store-page_size-compression-failed-page-as-is-v5
Date: Fri, 22 Aug 2025 12:08:17 -0700

- Restore reject_compress_poor code path.
- Remove crypto_compress_fail debugfs file.

Link: https://lkml.kernel.org/r/20250822190817.49287-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Takero Funaki <flintglass@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-store-page_size-compression-failed-page-as-is-v5
+++ a/mm/zswap.c
@@ -62,8 +62,6 @@ static u64 zswap_written_back_pages;
 static u64 zswap_reject_reclaim_fail;
 /* Store failed due to compression algorithm failure */
 static u64 zswap_reject_compress_fail;
-/* Compression failed by the crypto library */
-static u64 zswap_crypto_compress_fail;
 /* Compressed page was too big for the allocator to (optimally) store */
 static u64 zswap_reject_compress_poor;
 /* Load or writeback failed due to decompression failure */
@@ -990,14 +988,12 @@ static bool zswap_compress(struct page *
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen) {
-		zswap_crypto_compress_fail++;
+	if (comp_ret || !dlen)
 		dlen = PAGE_SIZE;
-	}
 	if (dlen >= PAGE_SIZE) {
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
-			comp_ret = -EINVAL;
+			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
 		comp_ret = 0;
@@ -1855,8 +1851,6 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_kmemcache_fail);
 	debugfs_create_u64("reject_compress_fail", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_fail);
-	debugfs_create_u64("crypto_compress_fail", 0444,
-			   zswap_debugfs_root, &zswap_crypto_compress_fail);
 	debugfs_create_u64("reject_compress_poor", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("decompress_fail", 0444,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
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

