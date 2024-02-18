Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D01EEAD3
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 23:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708297486; cv=none; b=Bl7dCsFcKMbdrIRW1MBJW7nqeIBHfPoFqklhyjvdAobcqVccclJOuKTePrYRtSlHiaxMA18mz5Ck2fB6rxocx8Q1hdNKi8xtP2N+vZgTcy7RhmyBG/7v2zrUkDEzicXTDeb0pB7EKNbuEklL9JjBO0baVS+bOpAmDSnXMq1/JHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708297486; c=relaxed/simple;
	bh=ZcQ1cO+Dd1htncmF6gYOmZYce0qnHrl0/Twmvh5LMTU=;
	h=Date:To:From:Subject:Message-Id; b=EApLunsXTc3Gi7O0kfTcV3ygF5lGIKzKFszesgtW5h29d+ZIyaOq7lljGen+1fbq9A+y9QZCyaoJdSSeFATOQmMFFNtt6gvMJ7o+cBZ2pUcugl5DGel2fwiBoNNat5hs+I9uqPN/081M1s6MA0hN6azdpDYxtCWIStfBymVqBeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nlE7SrKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nlE7SrKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1233C433F1;
	Sun, 18 Feb 2024 23:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708297485;
	bh=ZcQ1cO+Dd1htncmF6gYOmZYce0qnHrl0/Twmvh5LMTU=;
	h=Date:To:From:Subject:From;
	b=nlE7SrKWvum0EZHzv1jjZbn+TXfm2A2aNdWpddSUsL3X+s+WZXgB2K05bDl+7WVE8
	 SzPuRaHWxtIIi8ZVyNfB5VbOHT89MwXf41Djbp+mvYbYYb5srCes5zwnn7mqVvWUIG
	 CutQvHRAxBMbgdUqnBu9o91v+urK/MrN2BcKVGIg=
Date: Sun, 18 Feb 2024 15:04:45 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch added to mm-unstable branch
Message-Id: <20240218230445.B1233C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crypto: scompress: remove memcpy if sg_nents is 1
has been added to the -mm mm-unstable branch.  Its filename is
     crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

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
crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch
crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

