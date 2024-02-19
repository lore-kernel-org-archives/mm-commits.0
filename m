Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6896D50A98
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 23:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708386716; cv=none; b=c3EaGHtsqPEcdM9KWrLD/5zrL8Gs3RVH1HeP+UKdu+x5v6mz1+3/v/m/N+j1TmfNxz2gBok8ZLvc8LaJrmjuZHZt8XL7JWEPsXihMXI6hKsEF5hzCE1SzyRidqERH3HEsH5DVEWsLV+21AxkOUmcx+vz2hdg0PuDByP0wrhzmw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708386716; c=relaxed/simple;
	bh=wl+wmvfZ1ZYmtyTz3BOC2CGX45X6X6QBEacFJ0l5rdk=;
	h=Date:To:From:Subject:Message-Id; b=NVpMB4iY3JjDpVGpjju9aiNm8SeeuJ6NR619+OpT0fQ0Gpi5GX2lYbBkNLaFwmyy/cGG8s0Hh9hqKp5rlZIoIU+vrfHHSNpzLk9cTwZ2c4x0Bn56/kvoIsqmqfZT56r8OeIPc42j4PugM9fKMA8BY4Ep7kMLcRgnyBE86yjCd8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n5B1pTH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n5B1pTH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8756C433F1;
	Mon, 19 Feb 2024 23:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708386715;
	bh=wl+wmvfZ1ZYmtyTz3BOC2CGX45X6X6QBEacFJ0l5rdk=;
	h=Date:To:From:Subject:From;
	b=n5B1pTH0dJIYWgCQKR51ux8Zc5e87hxCbB3w6UY4yRQozBCxPhObP3xiEkbqzA36y
	 a7MUtU+3M/IIPKF9mQUJ+rIKinkEOFOALFg+fnImO+N5Q9Fzyi7Ekmc8s4CiuCuzYg
	 R42KqktDruenWPK4ZOagUkX+RaCLEzrJ22uuYFa4=
Date: Mon, 19 Feb 2024 15:51:55 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc.patch added to mm-unstable branch
Message-Id: <20240219235155.D8756C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: increase reject_compress_poor but not reject_compress_fail if compression returns ENOSPC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc.patch

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
Subject: mm: zswap: increase reject_compress_poor but not reject_compress_fail if compression returns ENOSPC
Date: Tue, 20 Feb 2024 10:19:35 +1300

We used to rely on the returned -ENOSPC of zpool_malloc() to increase
reject_compress_poor.  But the code wouldn't get to there after commit
744e1885922a ("crypto: scomp - fix req->dst buffer overflow") as the new
code will goto out immediately after the special compression case happens.
So there might be no longer a chance to execute zpool_malloc now.  We are
incorrectly increasing zswap_reject_compress_fail instead.  Thus, we need
to fix the counters handling right after compressions return ENOSPC.  This
patch also centralizes the counters handling for all of compress_poor,
compress_fail and alloc_fail.

Link: https://lkml.kernel.org/r/20240219211935.72394-1-21cnbao@gmail.com
Fixes: 744e1885922a ("crypto: scomp - fix req->dst buffer overflow")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/zswap.c~mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc
+++ a/mm/zswap.c
@@ -1021,12 +1021,12 @@ static bool zswap_compress(struct folio
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
+	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
 	unsigned long handle;
 	struct zpool *zpool;
 	char *buf;
 	gfp_t gfp;
-	int ret;
 	u8 *dst;
 
 	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
@@ -1057,26 +1057,18 @@ static bool zswap_compress(struct folio
 	 * but in different threads running on different cpu, we have different
 	 * acomp instance, so multiple threads can do (de)compression in parallel.
 	 */
-	ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
+	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
-	if (ret) {
-		zswap_reject_compress_fail++;
+	if (comp_ret)
 		goto unlock;
-	}
 
 	zpool = zswap_find_zpool(entry);
 	gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
 	if (zpool_malloc_support_movable(zpool))
 		gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
-	ret = zpool_malloc(zpool, dlen, gfp, &handle);
-	if (ret == -ENOSPC) {
-		zswap_reject_compress_poor++;
-		goto unlock;
-	}
-	if (ret) {
-		zswap_reject_alloc_fail++;
+	alloc_ret = zpool_malloc(zpool, dlen, gfp, &handle);
+	if (alloc_ret)
 		goto unlock;
-	}
 
 	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
 	memcpy(buf, dst, dlen);
@@ -1086,8 +1078,15 @@ static bool zswap_compress(struct folio
 	entry->length = dlen;
 
 unlock:
+	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
+		zswap_reject_compress_poor++;
+	else if (comp_ret)
+		zswap_reject_compress_fail++;
+	else if (alloc_ret)
+		zswap_reject_alloc_fail++;
+
 	mutex_unlock(&acomp_ctx->mutex);
-	return ret == 0;
+	return comp_ret == 0 && alloc_ret == 0;
 }
 
 static void zswap_decompress(struct zswap_entry *entry, struct page *page)
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

zram-do-not-allocate-physically-contiguous-strm-buffers.patch
mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc.patch

