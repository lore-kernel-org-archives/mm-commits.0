Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D5310A34
	for <mm-commits@vger.kernel.org>; Sat,  9 Mar 2024 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709959130; cv=none; b=XIGu+gMspMIFMs4s1GxTCfIYNgj6RLwVd85rHY5GiNcwQwu3n4XT3zxLYmzTWInematYInleOgqGELtdlVZR53RzaH1/piliccf6kftSCQeWjDgOg7KQWw6ghYfxAGhCcPmkHOYIKd1WLJo/kRLEy6FgMjU3AbcrdRbF01XM0Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709959130; c=relaxed/simple;
	bh=2FN3VRj/O2qJW01n+MA08fE9SUkPhGeWx9porj64/Vc=;
	h=Date:To:From:Subject:Message-Id; b=BAsf3TqBGIBA2B0pavPoSw6wg6t5WoZRLuyrw+ItOFILGuIXd2REs90pA49s5aG3Hf+IOHxHJ+aSM+ngi4dNNMANhrSOOLRASioQfIVBqFpZ0I/i81inWcYYLgyq0kA5ypBXq0suwIJFg4t5KYZk8+xjRigdoEtUQAU/3p3yYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0j9HvyGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0j9HvyGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89F8C433C7;
	Sat,  9 Mar 2024 04:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709959129;
	bh=2FN3VRj/O2qJW01n+MA08fE9SUkPhGeWx9porj64/Vc=;
	h=Date:To:From:Subject:From;
	b=0j9HvyGG786IWszMjkkx+Z/9aB9Cp/o1nJRPhurl7N/LvUCt/jYZK8VFeF6RH2Kw0
	 8bB1XOVAImC99MEpI2wUe91Auayep8bcQbcWARFc+ypgUOxnE8Sapi3T9VXKaMgWSa
	 N1L27pw8MJkQ4XwLLSjiLj5bBD8OLHjWdVFUgPyQ=
Date: Fri, 08 Mar 2024 20:38:49 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch added to mm-unstable branch
Message-Id: <20240309043849.B89F8C433C7@smtp.kernel.org>
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
mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch

