Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213441FAD
	for <mm-commits@vger.kernel.org>; Tue, 26 Dec 2023 19:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p83g4OQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E23C433C7;
	Tue, 26 Dec 2023 19:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703620279;
	bh=rQj2AE7YSNpakF4OapaIekKpkqn+wsiTqz95IcqfN7I=;
	h=Date:To:From:Subject:From;
	b=p83g4OQTgftMBG3KKYFIdY2Uvd2cUXBQNdvp9/E2hfkgtwLD7y1gFSJCEIzOm1CMc
	 pwoRvmmER6JGJCr5U7zPtRhRUHubjN6SVmoKOG93hTMMHwYJthLswD5NA3PudTCL2+
	 4t/idlNYPzzDgWQr4IzK8KaYLzKGNpvOPoXbzfC0=
Date: Tue, 26 Dec 2023 11:51:18 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx.patch added to mm-unstable branch
Message-Id: <20231226195118.D6E23C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: change per-cpu mutex and buffer to per-acomp_ctx
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx.patch

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
Subject: mm/zswap: change per-cpu mutex and buffer to per-acomp_ctx
Date: Tue, 26 Dec 2023 15:54:13 +0000

First of all, we need to rename acomp_ctx->dstmem field to buffer, since
we are now using for purposes other than compression.

Then we change per-cpu mutex and buffer to per-acomp_ctx, since them
belong to the acomp_ctx and are necessary parts when used in the
compress/decompress contexts.

So we can remove the old per-cpu mutex and dstmem.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v4-6-f228b059dd89@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuhotplug.h |    1 
 mm/zswap.c                 |   98 ++++++++++-------------------------
 2 files changed, 28 insertions(+), 71 deletions(-)

--- a/include/linux/cpuhotplug.h~mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx
+++ a/include/linux/cpuhotplug.h
@@ -124,7 +124,6 @@ enum cpuhp_state {
 	CPUHP_ARM_BL_PREPARE,
 	CPUHP_TRACE_RB_PREPARE,
 	CPUHP_MM_ZS_PREPARE,
-	CPUHP_MM_ZSWP_MEM_PREPARE,
 	CPUHP_MM_ZSWP_POOL_PREPARE,
 	CPUHP_KVM_PPC_BOOK3S_PREPARE,
 	CPUHP_ZCOMP_PREPARE,
--- a/mm/zswap.c~mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx
+++ a/mm/zswap.c
@@ -166,8 +166,8 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *dstmem;
-	struct mutex *mutex;
+	u8 *buffer;
+	struct mutex mutex;
 };
 
 /*
@@ -694,63 +694,26 @@ static void zswap_alloc_shrinker(struct
 /*********************************
 * per-cpu code
 **********************************/
-static DEFINE_PER_CPU(u8 *, zswap_dstmem);
-/*
- * If users dynamically change the zpool type and compressor at runtime, i.e.
- * zswap is running, zswap can have more than one zpool on one cpu, but they
- * are sharing dtsmem. So we need this mutex to be per-cpu.
- */
-static DEFINE_PER_CPU(struct mutex *, zswap_mutex);
-
-static int zswap_dstmem_prepare(unsigned int cpu)
-{
-	struct mutex *mutex;
-	u8 *dst;
-
-	dst = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!dst)
-		return -ENOMEM;
-
-	mutex = kmalloc_node(sizeof(*mutex), GFP_KERNEL, cpu_to_node(cpu));
-	if (!mutex) {
-		kfree(dst);
-		return -ENOMEM;
-	}
-
-	mutex_init(mutex);
-	per_cpu(zswap_dstmem, cpu) = dst;
-	per_cpu(zswap_mutex, cpu) = mutex;
-	return 0;
-}
-
-static int zswap_dstmem_dead(unsigned int cpu)
-{
-	struct mutex *mutex;
-	u8 *dst;
-
-	mutex = per_cpu(zswap_mutex, cpu);
-	kfree(mutex);
-	per_cpu(zswap_mutex, cpu) = NULL;
-
-	dst = per_cpu(zswap_dstmem, cpu);
-	kfree(dst);
-	per_cpu(zswap_dstmem, cpu) = NULL;
-
-	return 0;
-}
-
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
+	int ret;
+
+	mutex_init(&acomp_ctx->mutex);
+
+	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffer)
+		return -ENOMEM;
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp));
-		return PTR_ERR(acomp);
+		ret = PTR_ERR(acomp);
+		goto acomp_fail;
 	}
 	acomp_ctx->acomp = acomp;
 
@@ -758,8 +721,8 @@ static int zswap_cpu_comp_prepare(unsign
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
-		crypto_free_acomp(acomp_ctx->acomp);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto req_fail;
 	}
 	acomp_ctx->req = req;
 
@@ -772,10 +735,13 @@ static int zswap_cpu_comp_prepare(unsign
 	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
-	acomp_ctx->mutex = per_cpu(zswap_mutex, cpu);
-	acomp_ctx->dstmem = per_cpu(zswap_dstmem, cpu);
-
 	return 0;
+
+req_fail:
+	crypto_free_acomp(acomp_ctx->acomp);
+acomp_fail:
+	kfree(acomp_ctx->buffer);
+	return ret;
 }
 
 static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
@@ -788,6 +754,7 @@ static int zswap_cpu_comp_dead(unsigned
 			acomp_request_free(acomp_ctx->req);
 		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 			crypto_free_acomp(acomp_ctx->acomp);
+		kfree(acomp_ctx->buffer);
 	}
 
 	return 0;
@@ -1400,12 +1367,12 @@ static void __zswap_load(struct zswap_en
 	u8 *src;
 
 	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
-	mutex_lock(acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->mutex);
 
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
 	if (!zpool_can_sleep_mapped(zpool)) {
-		memcpy(acomp_ctx->dstmem, src, entry->length);
-		src = acomp_ctx->dstmem;
+		memcpy(acomp_ctx->buffer, src, entry->length);
+		src = acomp_ctx->buffer;
 		zpool_unmap_handle(zpool, entry->handle);
 	}
 
@@ -1415,7 +1382,7 @@ static void __zswap_load(struct zswap_en
 	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
-	mutex_unlock(acomp_ctx->mutex);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (zpool_can_sleep_mapped(zpool))
 		zpool_unmap_handle(zpool, entry->handle);
@@ -1631,9 +1598,9 @@ bool zswap_store(struct folio *folio)
 	/* compress */
 	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 
-	mutex_lock(acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->dstmem;
+	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -1676,7 +1643,7 @@ bool zswap_store(struct folio *folio)
 	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
 	memcpy(buf, dst, dlen);
 	zpool_unmap_handle(zpool, handle);
-	mutex_unlock(acomp_ctx->mutex);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	/* populate entry */
 	entry->swpentry = swp_entry(type, offset);
@@ -1719,7 +1686,7 @@ insert_entry:
 	return true;
 
 put_dstmem:
-	mutex_unlock(acomp_ctx->mutex);
+	mutex_unlock(&acomp_ctx->mutex);
 put_pool:
 	zswap_pool_put(entry->pool);
 freepage:
@@ -1894,13 +1861,6 @@ static int zswap_setup(void)
 		goto cache_fail;
 	}
 
-	ret = cpuhp_setup_state(CPUHP_MM_ZSWP_MEM_PREPARE, "mm/zswap:prepare",
-				zswap_dstmem_prepare, zswap_dstmem_dead);
-	if (ret) {
-		pr_err("dstmem alloc failed\n");
-		goto dstmem_fail;
-	}
-
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
@@ -1932,8 +1892,6 @@ fallback_fail:
 	if (pool)
 		zswap_pool_destroy(pool);
 hp_fail:
-	cpuhp_remove_state(CPUHP_MM_ZSWP_MEM_PREPARE);
-dstmem_fail:
 	kmem_cache_destroy(zswap_entry_cache);
 cache_fail:
 	/* if built-in, we aren't unloaded on failure; don't allow use */
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_writeback_entry.patch
mm-zswap-change-per-cpu-mutex-and-buffer-to-per-acomp_ctx.patch

