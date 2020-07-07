From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch added
 to -mm tree
Date: Tue, 07 Jul 2020 12:28:22 -0700
Message-ID: <20200707192822.ixutZYuMy%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgGGT2Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:28:24 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, colin.king@canonical.com, davem@davemloft.net, ddstreet@ieee.org, herbert@gondor.apana.org.au, lgoncalv@redhat.com, mahipalreddy2006@gmail.com, mm-commits@vger.kernel.org, sjenning@redhat.com, song.bao.hua@hisilicon.com, vitaly.wool@konsulko.com, wangzhou1@hisilicon.com


The patch titled
     Subject: mm/zswap: move to use crypto_acomp API for hardware acceleration
has been added to the -mm tree.  Its filename is
     mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/zswap: move to use crypto_acomp API for hardware acceleration

Right now, all new ZIP drivers are using crypto_acomp APIs rather than
legacy crypto_comp APIs.  But zswap.c is still using the old APIs.  That
means zswap won't be able to use any new zip drivers in kernel.

This patch moves to use cryto_acomp APIs to fix the problem.  On the other
hand, tradiontal compressors like lz4,lzo etc have been wrapped into acomp
via scomp backend.  So platforms without async compressors can fallback to
use acomp via scomp backend.

It is probably the first real user to use acomp but perhaps not a good
example to demonstrate how multiple acomp requests can be executed in
parallel in one acomp instance.  frontswap is doing page load and store
page by page.  It doesn't have a queuing or buffering mechinism to permit
multiple pages to do frontswap simultaneously in one thread.  However this
patch creates multiple acomp instances, so multiple threads running on
multiple different cpus can actually do (de)compression parallelly,
leveraging the power of multiple ZIP hardware queues.  This is also
consistent with frontswap's page management model.

On the other hand, the current zswap implementation has some per-cpu
global resource like zswap_dstmem.  So we create acomp instances in number
of CPUs just like before, zswap created comp instances in number of CPUs.

Link: http://lkml.kernel.org/r/20200707125210.33256-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  177 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 134 insertions(+), 43 deletions(-)

--- a/mm/zswap.c~mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration
+++ a/mm/zswap.c
@@ -24,8 +24,10 @@
 #include <linux/rbtree.h>
 #include <linux/swap.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <linux/mempool.h>
 #include <linux/zpool.h>
+#include <crypto/acompress.h>
 
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -127,9 +129,17 @@ module_param_named(same_filled_pages_ena
 * data structures
 **********************************/
 
+struct crypto_acomp_ctx {
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+	struct crypto_wait wait;
+	u8 *dstmem;
+	struct mutex mutex;
+};
+
 struct zswap_pool {
 	struct zpool *zpool;
-	struct crypto_comp * __percpu *tfm;
+	struct crypto_acomp_ctx * __percpu *acomp_ctx;
 	struct kref kref;
 	struct list_head list;
 	struct work_struct release_work;
@@ -415,30 +425,73 @@ static int zswap_dstmem_dead(unsigned in
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_comp *tfm;
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+	struct crypto_acomp_ctx *acomp_ctx;
+	int ret;
 
-	if (WARN_ON(*per_cpu_ptr(pool->tfm, cpu)))
+	if (WARN_ON(*per_cpu_ptr(pool->acomp_ctx, cpu)))
 		return 0;
 
-	tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
-	if (IS_ERR_OR_NULL(tfm)) {
-		pr_err("could not alloc crypto comp %s : %ld\n",
-		       pool->tfm_name, PTR_ERR(tfm));
+	acomp_ctx = kzalloc(sizeof(*acomp_ctx), GFP_KERNEL);
+	if (!acomp_ctx)
 		return -ENOMEM;
+
+	acomp = crypto_alloc_acomp(pool->tfm_name, 0, 0);
+	if (IS_ERR(acomp)) {
+		pr_err("could not alloc crypto acomp %s : %ld\n",
+				pool->tfm_name, PTR_ERR(acomp));
+		ret = PTR_ERR(acomp);
+		goto free_ctx;
+	}
+	acomp_ctx->acomp = acomp;
+
+	req = acomp_request_alloc(acomp_ctx->acomp);
+	if (!req) {
+		pr_err("could not alloc crypto acomp_request %s\n",
+		       pool->tfm_name);
+		ret = -ENOMEM;
+		goto free_acomp;
 	}
-	*per_cpu_ptr(pool->tfm, cpu) = tfm;
+	acomp_ctx->req = req;
+
+	mutex_init(&acomp_ctx->mutex);
+	crypto_init_wait(&acomp_ctx->wait);
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &acomp_ctx->wait);
+
+	acomp_ctx->dstmem = per_cpu(zswap_dstmem, cpu);
+	*per_cpu_ptr(pool->acomp_ctx, cpu) = acomp_ctx;
+
 	return 0;
+
+free_acomp:
+	crypto_free_acomp(acomp_ctx->acomp);
+free_ctx:
+	kfree(acomp_ctx);
+	return ret;
 }
 
 static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_comp *tfm;
+	struct crypto_acomp_ctx *acomp_ctx;
+
+	acomp_ctx = *per_cpu_ptr(pool->acomp_ctx, cpu);
+	if (!IS_ERR_OR_NULL(acomp_ctx)) {
+		if (!IS_ERR_OR_NULL(acomp_ctx->req))
+			acomp_request_free(acomp_ctx->req);
+		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+			crypto_free_acomp(acomp_ctx->acomp);
+		kfree(acomp_ctx);
+	}
+	*per_cpu_ptr(pool->acomp_ctx, cpu) = NULL;
 
-	tfm = *per_cpu_ptr(pool->tfm, cpu);
-	if (!IS_ERR_OR_NULL(tfm))
-		crypto_free_comp(tfm);
-	*per_cpu_ptr(pool->tfm, cpu) = NULL;
 	return 0;
 }
 
@@ -561,8 +614,9 @@ static struct zswap_pool *zswap_pool_cre
 	pr_debug("using %s zpool\n", zpool_get_type(pool->zpool));
 
 	strlcpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
-	pool->tfm = alloc_percpu(struct crypto_comp *);
-	if (!pool->tfm) {
+
+	pool->acomp_ctx = alloc_percpu(struct crypto_acomp_ctx *);
+	if (!pool->acomp_ctx) {
 		pr_err("percpu alloc failed\n");
 		goto error;
 	}
@@ -585,7 +639,7 @@ static struct zswap_pool *zswap_pool_cre
 	return pool;
 
 error:
-	free_percpu(pool->tfm);
+	free_percpu(pool->acomp_ctx);
 	if (pool->zpool)
 		zpool_destroy_pool(pool->zpool);
 	kfree(pool);
@@ -596,14 +650,14 @@ static __init struct zswap_pool *__zswap
 {
 	bool has_comp, has_zpool;
 
-	has_comp = crypto_has_comp(zswap_compressor, 0, 0);
+	has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
 	if (!has_comp && strcmp(zswap_compressor,
 				CONFIG_ZSWAP_COMPRESSOR_DEFAULT)) {
 		pr_err("compressor %s not available, using default %s\n",
 		       zswap_compressor, CONFIG_ZSWAP_COMPRESSOR_DEFAULT);
 		param_free_charp(&zswap_compressor);
 		zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
-		has_comp = crypto_has_comp(zswap_compressor, 0, 0);
+		has_comp = crypto_has_acomp(zswap_compressor, 0, 0);
 	}
 	if (!has_comp) {
 		pr_err("default compressor %s not available\n",
@@ -639,7 +693,7 @@ static void zswap_pool_destroy(struct zs
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
-	free_percpu(pool->tfm);
+	free_percpu(pool->acomp_ctx);
 	zpool_destroy_pool(pool->zpool);
 	kfree(pool);
 }
@@ -723,7 +777,7 @@ static int __zswap_param_set(const char
 		}
 		type = s;
 	} else if (!compressor) {
-		if (!crypto_has_comp(s, 0, 0)) {
+		if (!crypto_has_acomp(s, 0, 0)) {
 			pr_err("compressor %s not available\n", s);
 			return -ENOENT;
 		}
@@ -774,7 +828,7 @@ static int __zswap_param_set(const char
 		 * failed, maybe both compressor and zpool params were bad.
 		 * Allow changing this param, so pool creation will succeed
 		 * when the other param is changed. We already verified this
-		 * param is ok in the zpool_has_pool() or crypto_has_comp()
+		 * param is ok in the zpool_has_pool() or crypto_has_acomp()
 		 * checks above.
 		 */
 		ret = param_set_charp(s, kp);
@@ -876,7 +930,9 @@ static int zswap_writeback_entry(struct
 	pgoff_t offset;
 	struct zswap_entry *entry;
 	struct page *page;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
+
 	u8 *src, *dst;
 	unsigned int dlen;
 	int ret;
@@ -916,14 +972,21 @@ static int zswap_writeback_entry(struct
 
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
+		acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
+
 		dlen = PAGE_SIZE;
 		src = (u8 *)zhdr + sizeof(struct zswap_header);
-		dst = kmap_atomic(page);
-		tfm = *get_cpu_ptr(entry->pool->tfm);
-		ret = crypto_comp_decompress(tfm, src, entry->length,
-					     dst, &dlen);
-		put_cpu_ptr(entry->pool->tfm);
-		kunmap_atomic(dst);
+		dst = kmap(page);
+
+		mutex_lock(&acomp_ctx->mutex);
+		sg_init_one(&input, src, entry->length);
+		sg_init_one(&output, dst, dlen);
+		acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+		ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+		dlen = acomp_ctx->req->dlen;
+		mutex_unlock(&acomp_ctx->mutex);
+
+		kunmap(page);
 		BUG_ON(ret);
 		BUG_ON(dlen != PAGE_SIZE);
 
@@ -1004,7 +1067,8 @@ static int zswap_frontswap_store(unsigne
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *dupentry;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
 	int ret;
 	unsigned int hlen, dlen = PAGE_SIZE;
 	unsigned long handle, value;
@@ -1074,12 +1138,32 @@ static int zswap_frontswap_store(unsigne
 	}
 
 	/* compress */
-	dst = get_cpu_var(zswap_dstmem);
-	tfm = *get_cpu_ptr(entry->pool->tfm);
-	src = kmap_atomic(page);
-	ret = crypto_comp_compress(tfm, src, PAGE_SIZE, dst, &dlen);
-	kunmap_atomic(src);
-	put_cpu_ptr(entry->pool->tfm);
+	acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
+
+	mutex_lock(&acomp_ctx->mutex);
+
+	src = kmap(page);
+	dst = acomp_ctx->dstmem;
+	sg_init_one(&input, src, PAGE_SIZE);
+	/* zswap_dstmem is of size (PAGE_SIZE * 2). Reflect same in sg_list */
+	sg_init_one(&output, dst, PAGE_SIZE * 2);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	/*
+	 * it maybe looks a little bit silly that we send an asynchronous request,
+	 * then wait for its completion synchronously. This makes the process look
+	 * synchronous in fact.
+	 * Theoretically, acomp supports users send multiple acomp requests in one
+	 * acomp instance, then get those requests done simultaneously. but in this
+	 * case, frontswap actually does store and load page by page, there is no
+	 * existing method to send the second page before the first page is done
+	 * in one thread doing frontswap.
+	 * but in different threads running on different cpu, we have different
+	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 */
+	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
+	dlen = acomp_ctx->req->dlen;
+	kunmap(page);
+
 	if (ret) {
 		ret = -EINVAL;
 		goto put_dstmem;
@@ -1103,7 +1187,7 @@ static int zswap_frontswap_store(unsigne
 	memcpy(buf, &zhdr, hlen);
 	memcpy(buf + hlen, dst, dlen);
 	zpool_unmap_handle(entry->pool->zpool, handle);
-	put_cpu_var(zswap_dstmem);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	/* populate entry */
 	entry->offset = offset;
@@ -1131,7 +1215,7 @@ insert_entry:
 	return 0;
 
 put_dstmem:
-	put_cpu_var(zswap_dstmem);
+	mutex_unlock(&acomp_ctx->mutex);
 	zswap_pool_put(entry->pool);
 freepage:
 	zswap_entry_cache_free(entry);
@@ -1148,7 +1232,8 @@ static int zswap_frontswap_load(unsigned
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	struct crypto_comp *tfm;
+	struct scatterlist input, output;
+	struct crypto_acomp_ctx *acomp_ctx;
 	u8 *src, *dst;
 	unsigned int dlen;
 	int ret;
@@ -1175,11 +1260,17 @@ static int zswap_frontswap_load(unsigned
 	src = zpool_map_handle(entry->pool->zpool, entry->handle, ZPOOL_MM_RO);
 	if (zpool_evictable(entry->pool->zpool))
 		src += sizeof(struct zswap_header);
-	dst = kmap_atomic(page);
-	tfm = *get_cpu_ptr(entry->pool->tfm);
-	ret = crypto_comp_decompress(tfm, src, entry->length, dst, &dlen);
-	put_cpu_ptr(entry->pool->tfm);
-	kunmap_atomic(dst);
+	dst = kmap(page);
+
+	acomp_ctx = *this_cpu_ptr(entry->pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+	sg_init_one(&input, src, entry->length);
+	sg_init_one(&output, dst, dlen);
+	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
+	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
+	mutex_unlock(&acomp_ctx->mutex);
+
+	kunmap(page);
 	zpool_unmap_handle(entry->pool->zpool, entry->handle);
 	BUG_ON(ret);
 
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch
