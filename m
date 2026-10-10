Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EDE386568
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 22:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791670936; cv=none; b=GwwvpzhDWVQUOOLNfewckZb35PV5drSFe5khu3OqzEw1nj7RydYX2kVorwY7/ePsY0Gk7q5YHPIZhBrEJnjyZFnOdBiK16XLoiAE+Aakszcg3FwKLzJzlpTmx8FJri5DwCF0nLDMLFq6urhlTw3mLNKaCg1Vpl8kzLYdqKFR7C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791670936; c=relaxed/simple;
	bh=eFBBgGI81A5A2g6bgZhGWdtEkEqnh/wxkXJ3IYMMI74=;
	h=Date:To:From:Subject:Message-Id; b=irVfo2E4qreBLtv4sNdT5d4Aa0bU0/k2O1K9XCRuiX9K6M0SNrCW/oUYT1OdFpcH98vZD4A4YYay8fiiTTWTE1BPXWLWFJkSZNNHXwEtcf+l7EPC7W1/SqTWbxqnEXTE/MygVqa9zLm39Z3v8igSVIxMorvTw7MFWYXgPjHbz4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sBqk8j0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sBqk8j0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84D31F000FF;
	Sat, 10 Oct 2026 22:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791670934;
	bh=Ey9mU2Fm7wsxexv0wvFw/wGEv58kZUVXo3Ngyz1cMpU=;
	h=Date:To:From:Subject;
	b=sBqk8j0/xlVeIBpx6z5HCYvgMIVXzXV8bgp/MLT9xkXQdry+xD6ktHDvgdYSqAM2Q
	 1A97RMqQfsa6QBRst1hCs3GAiQLKKxT9bID2DA8ZPIkoPMGm05HqZTObFlulKJvj82
	 YVabJ3i3aCRXWVuCW+r+Wsv4YDLI2tfYoTVopoC0=
Date: Sat, 10 Oct 2026 15:22:13 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,terrelln@fb.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,riel@surriel.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,dsterba@suse.com,davem@davemloft.net,chengming.zhou@linux.dev,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-stack-requests-for-synchronous-decompression.patch added to mm-new branch
Message-Id: <20261010222213.E84D31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: use stack requests for synchronous decompression
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-use-stack-requests-for-synchronous-decompression.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-stack-requests-for-synchronous-decompression.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: zswap: use stack requests for synchronous decompression
Date: Fri, 09 Oct 2026 09:30:31 -0700

With separate requests for compression and decompression, loads still
serialize on the per-CPU decompression mutex. A low-priority load that
is preempted after the codec drops its stream lock keeps holding the mutex
and stalls every other load on that CPU, including higher-priority ones.

Synchronous algorithms whose requests need no extra context can use an
on-stack request, so decompress with one and take no zswap lock. All
in-tree software compressors qualify. Add acomp_can_use_stack_req() to
keep the synchronous and request-size checks in the Crypto API.
Asynchronous algorithms, and synchronous ones with request context,
keep the per-CPU request and mutex, which is still taken before the
zsmalloc read lock.

Reading the per-CPU context without the mutex is safe. Since
commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
pool"), it is set up before its CPU comes online and is not torn down
until the pool is destroyed. The codecs keep their own stream locks, and
crypto_acomp_decompress() rejects on-stack requests only for
asynchronous transforms, which never take this path.

For software compressors this drops the heap request added by the
previous patch. The on-stack request and wait take 216 bytes, which
makes the load path about 270 bytes deeper on x86-64. Asynchronous
algorithms pay this too.

Link: https://lore.kernel.org/20261009163146.83112-3-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: <chengming.zhou@linux.dev>
Cc: David Sterba <dsterba@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <alex@ghiti.fr>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David S. Miller <davem@davemloft.net>
---

 include/crypto/acompress.h |   13 +++++
 mm/zswap.c                 |   87 +++++++++++++++++++++++------------
 2 files changed, 72 insertions(+), 28 deletions(-)

--- a/include/crypto/acompress.h~mm-zswap-use-stack-requests-for-synchronous-decompression
+++ a/include/crypto/acompress.h
@@ -203,6 +203,19 @@ static inline bool acomp_is_async(struct
 	       CRYPTO_ALG_ASYNC;
 }
 
+/**
+ * acomp_can_use_stack_req() - check whether a transform can use stack requests
+ * @tfm: ACOMPRESS transform
+ *
+ * Return: true if @tfm completes synchronously and its request context fits
+ * in the storage reserved by ACOMP_REQUEST_ON_STACK(), false otherwise.
+ */
+static inline bool acomp_can_use_stack_req(struct crypto_acomp *tfm)
+{
+	return !acomp_is_async(tfm) &&
+	       crypto_acomp_reqsize(tfm) <= MAX_SYNC_COMP_REQSIZE;
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
--- a/mm/zswap.c~mm-zswap-use-stack-requests-for-synchronous-decompression
+++ a/mm/zswap.c
@@ -153,7 +153,7 @@ struct zswap_comp_ctx {
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct zswap_comp_ctx comp;
-	struct zswap_acomp_req decomp;
+	struct zswap_acomp_req decomp;	/* unused with on-stack requests */
 };
 
 /*
@@ -803,6 +803,18 @@ static void zswap_entry_free(struct zswa
 /*********************************
 * compressed storage functions
 **********************************/
+static void zswap_set_acomp_req_callback(struct acomp_req *req,
+					 struct crypto_wait *wait)
+{
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, wait);
+}
+
 static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 				struct crypto_acomp *acomp)
 {
@@ -812,14 +824,7 @@ static int zswap_acomp_req_init(struct z
 		return -ENOMEM;
 
 	crypto_init_wait(&areq->wait);
-
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &areq->wait);
+	zswap_set_acomp_req_callback(areq->req, &areq->wait);
 
 	mutex_init(&areq->mutex);
 	return 0;
@@ -856,15 +861,19 @@ static int zswap_cpu_comp_prepare(unsign
 		goto fail;
 	}
 
-	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
-	    zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		goto fail;
+	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp))
+		goto req_fail;
+
+	/* Skip the per-CPU request when decompression can use the stack. */
+	if (!acomp_can_use_stack_req(acomp_ctx->acomp)) {
+		if (zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp))
+			goto req_fail;
 	}
 
 	return 0;
 
+req_fail:
+	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
@@ -956,19 +965,14 @@ unlock:
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
-static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+static bool __zswap_decompress(struct zswap_entry *entry,
+			       struct zswap_pool *pool, struct acomp_req *req,
+			       struct crypto_wait *wait, struct folio *folio)
 {
-	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
-	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
-	if (WARN_ON_ONCE(!pool))
-		return false;
-
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -985,15 +989,13 @@ static bool zswap_decompress(struct zswa
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
-					 entry->length, PAGE_SIZE);
-		ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
-		ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
-		dlen = acomp_ctx->decomp.req->dlen;
+		acomp_request_set_params(req, input, &output, entry->length, PAGE_SIZE);
+		ret = crypto_acomp_decompress(req);
+		ret = crypto_wait_req(ret, wait);
+		dlen = req->dlen;
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	mutex_unlock(&acomp_ctx->decomp.mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1007,6 +1009,35 @@ static bool zswap_decompress(struct zswa
 	return false;
 }
 
+static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+{
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+	struct crypto_acomp_ctx *acomp_ctx;
+	bool ret;
+
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	/*
+	 * Use a private on-stack request when the transform supports it.
+	 * Otherwise serialize decompression on the shared per-CPU request.
+	 */
+	if (!acomp_ctx->decomp.req) {
+		ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
+		DECLARE_CRYPTO_WAIT(wait);
+
+		zswap_set_acomp_req_callback(req, &wait);
+		return __zswap_decompress(entry, pool, req, &wait, folio);
+	}
+
+	mutex_lock(&acomp_ctx->decomp.mutex);
+	ret = __zswap_decompress(entry, pool, acomp_ctx->decomp.req,
+				 &acomp_ctx->decomp.wait, folio);
+	mutex_unlock(&acomp_ctx->decomp.mutex);
+	return ret;
+}
+
 /*********************************
 * writeback code
 **********************************/
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-filemap-move-lruvec-accounting-outside-the-xarray-lock.patch
mm-remove-the-unused-zone-unaccepted_cleanup.patch
mm-zswap-use-separate-compression-and-decompression-requests.patch
mm-zswap-use-stack-requests-for-synchronous-decompression.patch

