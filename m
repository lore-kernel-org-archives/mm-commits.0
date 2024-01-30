Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFEF38DF9
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597045; cv=none; b=TOpdv6kwupCXugiucwLHyJu6qdH7P6wtEANNQpvU6wumlpgg0KXZzqfDV28baaWyyosIOZYTczaLc2VhY62XvrTSpBDrRFshK8gP5LS6UPv6Y87Pj6sC6K89WvYnl9LQX1rl9ElzSNu4//c71bCqLfoai3PuEXnJ5x8GqKYQ2EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597045; c=relaxed/simple;
	bh=FBH9S9bIVovBfH5z0UPIF/QQOtzTCW+XGUSGXjin2s4=;
	h=Date:To:From:Subject:Message-Id; b=Q49D8Wno2Jzor2N/nEiWXY2xshNVys+Xc+IdlzPMmyUsKpK2Obu6NQdstXaz1AZVSS9suXQfQW7HI1wIpnEKpxkcvBSzY5q9N0TlCQ9TNsFNxGE1pJQkOPU87AjO1KDSRaMlUbC71jl2JlAXIOTlWjHhML91mWIVwqvRrbvCC3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CszFrlB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CszFrlB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05526C433F1;
	Tue, 30 Jan 2024 06:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597045;
	bh=FBH9S9bIVovBfH5z0UPIF/QQOtzTCW+XGUSGXjin2s4=;
	h=Date:To:From:Subject:From;
	b=CszFrlB2OvFV+odgoOB8MXa+w4yVSs7BHx70BJwE9vY0ZWhwGIV2/yfZZAGQvbSg4
	 m1cpMIggW08KXt0zk0SjtGXMA1IX1RhSBVb2aA4w+Mv74BfVUGm0zfSYnxMZq93HHq
	 HQmjeSVHdvUpey52ARHz+eqUKdLp1j6zZScI6tso=
Date: Mon, 29 Jan 2024 22:43:52 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-function-ordering-per-cpu-compression-infra.patch added to mm-unstable branch
Message-Id: <20240130064404.05526C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: function ordering: per-cpu compression infra
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-function-ordering-per-cpu-compression-infra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-function-ordering-per-cpu-compression-infra.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: function ordering: per-cpu compression infra
Date: Mon, 29 Jan 2024 20:36:54 -0500

The per-cpu compression init/exit callbacks are awkwardly in the
middle of the shrinker code. Move them up to the compression section.

Link: https://lkml.kernel.org/r/20240130014208.565554-19-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
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

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

