Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD44364A0
	for <mm-commits@vger.kernel.org>; Sat,  9 Mar 2024 04:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709959416; cv=none; b=ixfHqyTHxYUKwSQztnw4b9ex8VM1OnPR//O5Te+moyZC2nk/F8d6CSxDuGU9QTJyAPotaI5rSC3JIezN4DY+EA5yM+ClP31Xwt+MXL8YsqigX9hZGngu59r31p1fiIAtjGbKTclc6sNAe83HzpwuX9rxOGJ/IMIFvOfXc5SXPNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709959416; c=relaxed/simple;
	bh=7oRvPd7CxV+u2RkYkwd9HSOhnfBlbhUxx0i21WocDUM=;
	h=Date:To:From:Subject:Message-Id; b=X37chZo8iQ52mabq9FtjOXe0BYc1/PzlMdIpu90CiwRjNMsgd6nBVBh2Vc/c2NzjXplfyYR/FOAxdb8VCpYxjGJZ/VAgyII/jXxKwAusnzW69wCcpHwUQMFDmXVKaY+Uy906Io9WIQbqcOcf2sCy5/dE4LmwU6DAaV1gSXPZhZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hjTuN6+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hjTuN6+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CAAC433F1;
	Sat,  9 Mar 2024 04:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709959415;
	bh=7oRvPd7CxV+u2RkYkwd9HSOhnfBlbhUxx0i21WocDUM=;
	h=Date:To:From:Subject:From;
	b=hjTuN6+w4Zt0BNA2Ohu/v01JNnvk9paOi/TZ1O18mXTo4JDMYPSmzpbfhf8ffdpcW
	 huqflToUcjYZBIV9CfozLoA/CdZF2CUr7ZBimV8Ozny5peGYPJHB+RYWYWL8yILfYa
	 mX2PzbX/kbqH2EREx1s+/jL1dICaEQLVg/urr+ek=
Date: Fri, 08 Mar 2024 20:43:35 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch removed from -mm tree
Message-Id: <20240309044335.C9CAAC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: remove the memcpy if acomp is not sleepable
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm/zswap: remove the memcpy if acomp is not sleepable
Date: Thu, 22 Feb 2024 21:11:35 +1300

Most compressors are actually CPU-based and won't sleep during compression
and decompression.  We should remove the redundant memcpy for them.

This patch checks if the algorithm is sleepable by testing the
CRYPTO_ALG_ASYNC algorithm flag.

Generally speaking, async and sleepable are semantically similar but not
equal.  But for compress drivers, they are basically equal at least due to
the below facts.

Firstly, scompress drivers - crypto/deflate.c, lz4.c, zstd.c, lzo.c etc
have no sleep.  Secondly, zRAM has been using these scompress drivers for
years in atomic contexts, and never worried those drivers going to sleep.

One exception is that an async driver can sometimes still return
synchronously per Herbert's clarification.  In this case, we are still
having a redundant memcpy.  But we can't know if one particular acomp
request will sleep or not unless crypto can expose more details for each
specific request from offload drivers.

Link: https://lkml.kernel.org/r/20240222081135.173040-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable
+++ a/mm/zswap.c
@@ -162,6 +162,7 @@ struct crypto_acomp_ctx {
 	struct crypto_wait wait;
 	u8 *buffer;
 	struct mutex mutex;
+	bool is_sleepable;
 };
 
 /*
@@ -951,6 +952,7 @@ static int zswap_cpu_comp_prepare(unsign
 		goto acomp_fail;
 	}
 	acomp_ctx->acomp = acomp;
+	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 
 	req = acomp_request_alloc(acomp_ctx->acomp);
 	if (!req) {
@@ -1078,7 +1080,7 @@ static void zswap_decompress(struct zswa
 	mutex_lock(&acomp_ctx->mutex);
 
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(zpool)) {
+	if (acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) {
 		memcpy(acomp_ctx->buffer, src, entry->length);
 		src = acomp_ctx->buffer;
 		zpool_unmap_handle(zpool, entry->handle);
@@ -1092,7 +1094,7 @@ static void zswap_decompress(struct zswa
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 	mutex_unlock(&acomp_ctx->mutex);
 
-	if (zpool_can_sleep_mapped(zpool))
+	if (!acomp_ctx->is_sleepable || zpool_can_sleep_mapped(zpool))
 		zpool_unmap_handle(zpool, entry->handle);
 }
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch

