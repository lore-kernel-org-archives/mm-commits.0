Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBB3C07
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560128; cv=none; b=ZBo5AaRhgmbkS6vH3yxHtS8HmHEF8rMpLc+ghfgTEnw/qQjepMb69MFRRUrYfoGUM+Bqus8dumN2IFmgcB2wZ+SiV7rYIQvJ+4MwWJjNoox3JuFI0OUs1JNxgpGmnYfbGiCe/Neq1VFKdjPFKm/CXESgVRwwlm42S/FgmMZRjlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560128; c=relaxed/simple;
	bh=L/s2SkJIs0GjtLiTcbQh06Dn3mItSqRfgUoS12K7L1I=;
	h=Date:To:From:Subject:Message-Id; b=p5JAU5YLDdsrLJtQs84lCtWIOzKSPlobTJ9wxAy+bsb6G04sqc7wZfZFqOi0K6WyB93IMheHtT/alrMeTQfvY60+nRBES1bMquBQYkNZJsNKoJll712eET6v6qXsqI/QQLm7AIGBNc5PySviJbJ07j/6Cc1mUHJ+1vegP243Cbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JhZevRPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JhZevRPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B839EC433C7;
	Thu, 22 Feb 2024 00:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560127;
	bh=L/s2SkJIs0GjtLiTcbQh06Dn3mItSqRfgUoS12K7L1I=;
	h=Date:To:From:Subject:From;
	b=JhZevRPxf/cySIQbVD0UQHwMBok4SrjAbdKuHBfFl7/nCxxkWeAqmlyWCR7BSFjYo
	 SoJmir3S5vsGBZhH4PRvD8fb61i8eGBbtZCrBQ1aHTW0PCNaxUsi2pIQOyIdLgSFZu
	 qlR4aKym6DC/RITc76Z5FHWlbh5j8GQqPgvxoF30=
Date: Wed, 21 Feb 2024 16:02:07 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-function-ordering-per-cpu-compression-infra.patch removed from -mm tree
Message-Id: <20240222000207.B839EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: function ordering: per-cpu compression infra
has been removed from the -mm tree.  Its filename was
     mm-zswap-function-ordering-per-cpu-compression-infra.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: per-cpu compression infra
Date: Mon, 29 Jan 2024 20:36:54 -0500

The per-cpu compression init/exit callbacks are awkwardly in the
middle of the shrinker code. Move them up to the compression section.

Link: https://lkml.kernel.org/r/20240130014208.565554-19-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |  135 ++++++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 69 deletions(-)

--- a/mm/zswap.c~mm-zswap-function-ordering-per-cpu-compression-infra
+++ a/mm/zswap.c
@@ -995,6 +995,72 @@ static void zswap_invalidate_entry(struc
 /*********************************
 * compressed storage functions
 **********************************/
+static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
+{
+	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
+	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	struct crypto_acomp *acomp;
+	struct acomp_req *req;
+	int ret;
+
+	mutex_init(&acomp_ctx->mutex);
+
+	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffer)
+		return -ENOMEM;
+
+	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp)) {
+		pr_err("could not alloc crypto acomp %s : %ld\n",
+				pool->tfm_name, PTR_ERR(acomp));
+		ret = PTR_ERR(acomp);
+		goto acomp_fail;
+	}
+	acomp_ctx->acomp = acomp;
+
+	req = acomp_request_alloc(acomp_ctx->acomp);
+	if (!req) {
+		pr_err("could not alloc crypto acomp_request %s\n",
+		       pool->tfm_name);
+		ret = -ENOMEM;
+		goto req_fail;
+	}
+	acomp_ctx->req = req;
+
+	crypto_init_wait(&acomp_ctx->wait);
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &acomp_ctx->wait);
+
+	return 0;
+
+req_fail:
+	crypto_free_acomp(acomp_ctx->acomp);
+acomp_fail:
+	kfree(acomp_ctx->buffer);
+	return ret;
+}
+
+static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
+	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+
+	if (!IS_ERR_OR_NULL(acomp_ctx)) {
+		if (!IS_ERR_OR_NULL(acomp_ctx->req))
+			acomp_request_free(acomp_ctx->req);
+		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+			crypto_free_acomp(acomp_ctx->acomp);
+		kfree(acomp_ctx->buffer);
+	}
+
+	return 0;
+}
+
 static bool zswap_compress(struct folio *folio, struct zswap_entry *entry)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
@@ -1201,75 +1267,6 @@ static void zswap_alloc_shrinker(struct
 	pool->shrinker->seeks = DEFAULT_SEEKS;
 }
 
-/*********************************
-* per-cpu code
-**********************************/
-static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp;
-	struct acomp_req *req;
-	int ret;
-
-	mutex_init(&acomp_ctx->mutex);
-
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return -ENOMEM;
-
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
-		ret = PTR_ERR(acomp);
-		goto acomp_fail;
-	}
-	acomp_ctx->acomp = acomp;
-
-	req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!req) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		ret = -ENOMEM;
-		goto req_fail;
-	}
-	acomp_ctx->req = req;
-
-	crypto_init_wait(&acomp_ctx->wait);
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &acomp_ctx->wait);
-
-	return 0;
-
-req_fail:
-	crypto_free_acomp(acomp_ctx->acomp);
-acomp_fail:
-	kfree(acomp_ctx->buffer);
-	return ret;
-}
-
-static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-
-	if (!IS_ERR_OR_NULL(acomp_ctx)) {
-		if (!IS_ERR_OR_NULL(acomp_ctx->req))
-			acomp_request_free(acomp_ctx->req);
-		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
-			crypto_free_acomp(acomp_ctx->acomp);
-		kfree(acomp_ctx->buffer);
-	}
-
-	return 0;
-}
-
 static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_one *l,
 				       spinlock_t *lock, void *arg)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


