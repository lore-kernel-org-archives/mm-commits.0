Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4FEAD3
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 23:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708297484; cv=none; b=B0dpuSksog4GZytr6pNacce7LvdHmsU0uPFL1QYYou3z+/Xt/ZMuUwrAwxsKYFXEYywm1jCeugCxyxxzR5SITjVa0yoq1Vmw5ShmoiLrlasqlBf9ZafiVR39a4Yu06l2c4JtFFfmRinDFmGDvTw2E0gs4UFRnr7moo6GZ8yMJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708297484; c=relaxed/simple;
	bh=/2f3An1+mRCHKzpwIs95J1V0leGVjjPgHXahjmSWO4Q=;
	h=Date:To:From:Subject:Message-Id; b=IYJFwiPVwnWUgPvj4U3kUwJFheCFNkfTL7KcC4XDyhYFiuhH4L9iozGpkHlf2RwEVLAmkxIIZWE3w6JcEOcX+RDKo49sT6JT+qjaOZs9c/XcJB55xHegzGoeh7K5ftzUgVziIwLukb+WTX3Vd6MkzUfbTV0C13ic3U3XBp+QWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vkWKvvpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vkWKvvpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD257C433C7;
	Sun, 18 Feb 2024 23:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708297483;
	bh=/2f3An1+mRCHKzpwIs95J1V0leGVjjPgHXahjmSWO4Q=;
	h=Date:To:From:Subject:From;
	b=vkWKvvpfk+zOzu1RVZcPKwksPjsn8Bz6m2Xz8j7bVG4uCyWMEAgIYWOyNQkh8ewhW
	 ImpfpxvbNXN/BzUqy/oZ7cpzMLN2dxlcYJ4dlDaOPzm17zWneDVjdZAs9a2qkpwAap
	 QJH8TeisMX3NuttAIRPvgLQWT1NzX7KEkig4iAJ4=
Date: Sun, 18 Feb 2024 15:04:43 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch added to mm-unstable branch
Message-Id: <20240218230443.BD257C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: remove the memcpy if acomp is not sleepable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch

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
crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch
crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

