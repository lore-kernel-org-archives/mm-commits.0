Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA8323C9
	for <mm-commits@vger.kernel.org>; Tue, 26 Dec 2023 19:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Exb3ztqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740C5C433C8;
	Tue, 26 Dec 2023 19:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703620273;
	bh=cwZMHkp/Hco578ZkZ63HSJ+SenNInW7Y26P7gCtXY2k=;
	h=Date:To:From:Subject:From;
	b=Exb3ztqcIduV4rSfrLuRx7FTs3Of8iQh2q5V5PAMxuV8e8klL0I9rENpAhr8WQuis
	 t1OLDrbf3Mu6B19ls5FSnYTxL1VVhzA2taV7lJmCGjTQI2yc6SE2/3psQe8rfWXPFr
	 gxDQzHly8bY5jvlGdj0Em0boLpoRy68vzhFExRyU=
Date: Tue, 26 Dec 2023 11:51:12 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-refactor-out-__zswap_load.patch added to mm-unstable branch
Message-Id: <20231226195113.740C5C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: refactor out __zswap_load()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-refactor-out-__zswap_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-refactor-out-__zswap_load.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: refactor out __zswap_load()
Date: Tue, 26 Dec 2023 15:54:10 +0000

The zswap_load() and zswap_writeback_entry() have the same part that
decompress the data from zswap_entry to page, so refactor out the common
part as __zswap_load(entry, page).

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v4-3-f228b059dd89@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   92 +++++++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 60 deletions(-)

--- a/mm/zswap.c~mm-zswap-refactor-out-__zswap_load
+++ a/mm/zswap.c
@@ -1392,6 +1392,35 @@ static int zswap_enabled_param_set(const
 	return ret;
 }
 
+static void __zswap_load(struct zswap_entry *entry, struct page *page)
+{
+	struct zpool *zpool = zswap_find_zpool(entry);
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
+	u8 *src;
+
+	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(acomp_ctx->mutex);
+
+	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
+	if (!zpool_can_sleep_mapped(zpool)) {
+		memcpy(acomp_ctx->dstmem, src, entry->length);
+		src = acomp_ctx->dstmem;
+		zpool_unmap_handle(zpool, entry->handle);
+	}
+
+	sg_init_one(&input, src, entry->length);
+	sg_init_table(&output, 1);
+	sg_set_page(&output, page, PAGE_SIZE, 0);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
+	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
+	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
+	mutex_unlock(acomp_ctx->mutex);
+
+	if (zpool_can_sleep_mapped(zpool))
+		zpool_unmap_handle(zpool, entry->handle);
+}
+
 /*********************************
 * writeback code
 **********************************/
@@ -1413,12 +1442,7 @@ static int zswap_writeback_entry(struct
 	swp_entry_t swpentry = entry->swpentry;
 	struct page *page;
 	struct mempolicy *mpol;
-	struct scatterlist input, output;
-	struct crypto_acomp_ctx *acomp_ctx;
-	struct zpool *pool = zswap_find_zpool(entry);
 	bool page_was_allocated;
-	u8 *src;
-	unsigned int dlen;
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
@@ -1456,31 +1480,7 @@ static int zswap_writeback_entry(struct
 	}
 	spin_unlock(&tree->lock);
 
-	/* decompress */
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	dlen = PAGE_SIZE;
-	mutex_lock(acomp_ctx->mutex);
-
-	src = zpool_map_handle(pool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(pool)) {
-		memcpy(acomp_ctx->dstmem, src, entry->length);
-		src = acomp_ctx->dstmem;
-		zpool_unmap_handle(pool, entry->handle);
-	}
-
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_page(&output, page, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
-	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-	mutex_unlock(acomp_ctx->mutex);
-
-	if (zpool_can_sleep_mapped(pool))
-		zpool_unmap_handle(pool, entry->handle);
-
-	BUG_ON(ret);
-	BUG_ON(dlen != PAGE_SIZE);
+	__zswap_load(entry, page);
 
 	/* page is up to date */
 	SetPageUptodate(page);
@@ -1753,11 +1753,7 @@ bool zswap_load(struct folio *folio)
 	struct page *page = &folio->page;
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	struct scatterlist input, output;
-	struct crypto_acomp_ctx *acomp_ctx;
-	u8 *src, *dst;
-	struct zpool *zpool;
-	unsigned int dlen;
+	u8 *dst;
 	bool ret;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
@@ -1779,31 +1775,7 @@ bool zswap_load(struct folio *folio)
 		goto stats;
 	}
 
-	zpool = zswap_find_zpool(entry);
-
-	/* decompress */
-	dlen = PAGE_SIZE;
-	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	mutex_lock(acomp_ctx->mutex);
-
-	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(zpool)) {
-		memcpy(acomp_ctx->dstmem, src, entry->length);
-		src = acomp_ctx->dstmem;
-		zpool_unmap_handle(zpool, entry->handle);
-	}
-
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_page(&output, page, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
-	if (crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait))
-		WARN_ON(1);
-	mutex_unlock(acomp_ctx->mutex);
-
-	if (zpool_can_sleep_mapped(zpool))
-		zpool_unmap_handle(zpool, entry->handle);
-
+	__zswap_load(entry, page);
 	ret = true;
 stats:
 	count_vm_event(ZSWPIN);
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_writeback_entry.patch
mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx.patch

