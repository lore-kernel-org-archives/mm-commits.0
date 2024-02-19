Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FD954BC5
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 22:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708380151; cv=none; b=a7atvKrRnMKlHuQbTVQ620/ehIyuGOQ+rAjwh1IILewPVo9X/T03WbyxDZeXGotNaLwM9ZEPLAbxxosMuR7Qr7o94CM6tuQgnka4W+GB4VARE71eTFZQr/jFd/bo32rD7j6AXg4qy/QnLw700efWDEh4wIdpTYpnYU5Tv/7GJkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708380151; c=relaxed/simple;
	bh=q5t0xGPU52Gq0aEJnh1MjJr+rgFHDenfM8kdjkpPtN4=;
	h=Date:To:From:Subject:Message-Id; b=LZDUSGT9fIRfWliXD4u0i1Bf6jJ2qr6WAK/p9tx5/C7jJmo3YHn1DiNqxW92nzfEsoPUHFzo4QkafJ10zxkJMafL4hpAOu0wUMWUQZ7WK2B9IfyPh4w5xFwCbW53sh92YE4gP2iI+7ZZrSy06AScqZ0Lsl/n/Mx4bwhpCqq9L+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4vsbycM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4vsbycM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10228C43390;
	Mon, 19 Feb 2024 22:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708380151;
	bh=q5t0xGPU52Gq0aEJnh1MjJr+rgFHDenfM8kdjkpPtN4=;
	h=Date:To:From:Subject:From;
	b=C4vsbycMhksMpzT/zUdjRFoM31SzjfiX/iMrt57eap96KCFWhS7NO3d57wtrADhVx
	 JeTUU1dGJ36B/p1qv9Njh2lRWstm+Pta0eq3Zx04mJTPvn4W3bGsz54nrlfj5EC6Wq
	 PL6vUW5V7BMDMCRbDjVzFE2k6W9tEBeI7al2mb2c=
Date: Mon, 19 Feb 2024 14:02:30 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch removed from -mm tree
Message-Id: <20240219220231.10228C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: remove the memcpy if acomp is not sleepable
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm/zswap: remove the memcpy if acomp is not sleepable
Date: Sat, 17 Feb 2024 17:51:01 +1300

Most compressors are actually CPU-based and won't sleep during compression
and decompression.  We should remove the redundant memcpy for them.

Link: https://lkml.kernel.org/r/20240217045102.55339-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -973,6 +974,7 @@ static int zswap_cpu_comp_prepare(unsign
 		goto acomp_fail;
 	}
 	acomp_ctx->acomp = acomp;
+	acomp_ctx->is_sleepable = acomp_is_sleepable(acomp);
 
 	req = acomp_request_alloc(acomp_ctx->acomp);
 	if (!req) {
@@ -1101,7 +1103,7 @@ static void zswap_decompress(struct zswa
 	mutex_lock(&acomp_ctx->mutex);
 
 	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	if (!zpool_can_sleep_mapped(zpool)) {
+	if (acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) {
 		memcpy(acomp_ctx->buffer, src, entry->length);
 		src = acomp_ctx->buffer;
 		zpool_unmap_handle(zpool, entry->handle);
@@ -1115,7 +1117,7 @@ static void zswap_decompress(struct zswa
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 	mutex_unlock(&acomp_ctx->mutex);
 
-	if (zpool_can_sleep_mapped(zpool))
+	if (!acomp_ctx->is_sleepable || zpool_can_sleep_mapped(zpool))
 		zpool_unmap_handle(zpool, entry->handle);
 }
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

zram-do-not-allocate-physically-contiguous-strm-buffers.patch
crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

