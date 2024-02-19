Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62A5467B
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 22:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708380152; cv=none; b=p1wOJqruDEQPP+TC43CmzLv5t8q+4XSv5GGSXa3E7fQS2toO7Uj2CuU9lBKXAbIHHiVJi+o3NZRoNPYVSB0/JwrtGP9C0m1CMSX+R44puEnZICwyHnZ9bH1IWMAVwxKNEfX5fUSUTyZsyjnLXvBvrp7RgJhzR4aPcYZMmXKe/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708380152; c=relaxed/simple;
	bh=2y9rw8ZqR8sJLo8gQIOoINu7Z8BUO3CDJjusbwp8DXQ=;
	h=Date:To:From:Subject:Message-Id; b=PruGo2QADCxLaOrDNE3KJmYFSrZ+A473kh3UF4GkfCzwi/vy1sbm8WT/tl2m78QcuoG3QVdhT/67YjveWbMOTR/pNurdSlVxCpBpcq3e1WJxiNBgr5aSk6iwD3nUtS2DWR/ORaKX4oKLJ4qzq2s8cYlh3xQpStYZsBcWfw+meLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v3irUnxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v3irUnxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7E1C433C7;
	Mon, 19 Feb 2024 22:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708380152;
	bh=2y9rw8ZqR8sJLo8gQIOoINu7Z8BUO3CDJjusbwp8DXQ=;
	h=Date:To:From:Subject:From;
	b=v3irUnxTIGH5hpNc6u6vWHGQp8q+kSbjmoIcIXQCXIFyj+wDx3ISi783GRycFIV0w
	 JPjc7H9cDP+BEWbigbhkvSE3i3jbYIIaztRwxTDhShL64k5waqzyTgOGfIVMvVMauX
	 FTVyOsZAP8LmhZNmszB0MJ36IqHgINrH8BgFnw8M=
Date: Mon, 19 Feb 2024 14:02:31 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch removed from -mm tree
Message-Id: <20240219220232.3D7E1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crypto: scompress: remove memcpy if sg_nents is 1
has been removed from the -mm tree.  Its filename was
     crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: crypto: scompress: remove memcpy if sg_nents is 1
Date: Sat, 17 Feb 2024 17:51:02 +1300

while sg_nents is 1 which is always true for the current kernel as the
only user - zswap is the case, we should remove two big memcpy.

Link: https://lkml.kernel.org/r/20240217045102.55339-4-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/scompress.c |   36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

--- a/crypto/scompress.c~crypto-scompress-remove-memcpy-if-sg_nents-is-1
+++ a/crypto/scompress.c
@@ -117,6 +117,7 @@ static int scomp_acomp_comp_decomp(struc
 	struct crypto_scomp *scomp = *tfm_ctx;
 	void **ctx = acomp_request_ctx(req);
 	struct scomp_scratch *scratch;
+	void *src, *dst;
 	unsigned int dlen;
 	int ret;
 
@@ -134,13 +135,25 @@ static int scomp_acomp_comp_decomp(struc
 	scratch = raw_cpu_ptr(&scomp_scratch);
 	spin_lock(&scratch->lock);
 
-	scatterwalk_map_and_copy(scratch->src, req->src, 0, req->slen, 0);
+	if (sg_nents(req->src) == 1) {
+		src = kmap_local_page(sg_page(req->src)) + req->src->offset;
+	} else {
+		scatterwalk_map_and_copy(scratch->src, req->src, 0,
+					 req->slen, 0);
+		src = scratch->src;
+	}
+
+	if (req->dst && sg_nents(req->dst) == 1)
+		dst = kmap_local_page(sg_page(req->dst)) + req->dst->offset;
+	else
+		dst = scratch->dst;
+
 	if (dir)
-		ret = crypto_scomp_compress(scomp, scratch->src, req->slen,
-					    scratch->dst, &req->dlen, *ctx);
+		ret = crypto_scomp_compress(scomp, src, req->slen,
+					    dst, &req->dlen, *ctx);
 	else
-		ret = crypto_scomp_decompress(scomp, scratch->src, req->slen,
-					      scratch->dst, &req->dlen, *ctx);
+		ret = crypto_scomp_decompress(scomp, src, req->slen,
+					      dst, &req->dlen, *ctx);
 	if (!ret) {
 		if (!req->dst) {
 			req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
@@ -152,10 +165,19 @@ static int scomp_acomp_comp_decomp(struc
 			ret = -ENOSPC;
 			goto out;
 		}
-		scatterwalk_map_and_copy(scratch->dst, req->dst, 0, req->dlen,
-					 1);
+		if (dst == scratch->dst) {
+			scatterwalk_map_and_copy(scratch->dst, req->dst, 0,
+						 req->dlen, 1);
+		} else {
+			flush_dcache_page(sg_page(req->dst));
+		}
 	}
 out:
+	if (src != scratch->src)
+		kunmap_local(src);
+	if (dst != scratch->dst)
+		kunmap_local(dst);
+
 	spin_unlock(&scratch->lock);
 	return ret;
 }
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

zram-do-not-allocate-physically-contiguous-strm-buffers.patch

