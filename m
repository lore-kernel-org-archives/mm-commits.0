Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF9613D
	for <mm-commits@vger.kernel.org>; Wed, 24 Jul 2024 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849209; cv=none; b=MV8xY4tZebwV0Cqr01JTnbIrXKLedgZRtJOA53Qecq65+qfwcZyni1PMYEHNoDDZjIGCwkmDePBl8h9mvysCltAi2b6hvQ80AWrMQMs9+0q2kRRmea8EwNRt69UEsz4pGwSa4rulz1+CkY9eyISxilMWi2Ch1MsO/50wSbD7JGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849209; c=relaxed/simple;
	bh=WMJ/CeQjuV8fMnB3Twyo3OWDoIMYeOrbp2wWvCMj7Hw=;
	h=Date:To:From:Subject:Message-Id; b=RnqZF0UCp8brXx+fDHq3zwic6SMaAUrplh41TXzmf9BRrourUWEhP77F9ymhxi2okHo4v0gYnde9np64JaVtd3spqML7BBgZUFyS3+wQNF3oXra/kHk3/f+d2ZeiyC6+sjvRN+917zdAKEzqH5rowCs6+guj0DhrrQrhcG//+8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d7/o0sXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d7/o0sXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2616DC32781;
	Wed, 24 Jul 2024 19:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721849209;
	bh=WMJ/CeQjuV8fMnB3Twyo3OWDoIMYeOrbp2wWvCMj7Hw=;
	h=Date:To:From:Subject:From;
	b=d7/o0sXTKDLIEPrghEgp+e7DsTRUzZBkWoHVALQNb2nKJekkwV9VRI1aSLjzfuAiq
	 fPbrazu0wYB6v7TuYiGoDyy3TJnLN0/U0OO8zNDMU8Wobj7XNWjvSfIMrkBOZpGbUZ
	 odTP0vJXZzD9L4Up6Pe+d0781vD4ixcD6e27V6c0=
Date: Wed, 24 Jul 2024 12:26:48 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,nphamcs@gmail.com,ngupta@vflare.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-recalculate-zstd-compression-params-once.patch added to mm-unstable branch
Message-Id: <20240724192649.2616DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: recalculate zstd compression params once
has been added to the -mm mm-unstable branch.  Its filename is
     zram-recalculate-zstd-compression-params-once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-recalculate-zstd-compression-params-once.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: recalculate zstd compression params once
Date: Fri, 12 Jul 2024 14:18:25 +0900

zstd compression params depends on level, but are constant
for a given instance of zstd compression backend.  Calculate
once (during ctx creation).

Link: https://lkml.kernel.org/r/20240712051850.484318-15-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-recalculate-zstd-compression-params-once
+++ a/drivers/block/zram/backend_zstd.c
@@ -10,6 +10,7 @@
 struct zstd_ctx {
 	zstd_cctx *cctx;
 	zstd_dctx *dctx;
+	zstd_parameters cprm;
 	void *cctx_mem;
 	void *dctx_mem;
 	s32 level;
@@ -40,6 +41,7 @@ static void *zstd_create(struct zcomp_pa
 		ctx->level = zstd_default_clevel();
 
 	prm = zstd_get_params(ctx->level, PAGE_SIZE);
+	ctx->cprm = zstd_get_params(ctx->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&prm.cParams);
 	ctx->cctx_mem = vzalloc(sz);
 	if (!ctx->cctx_mem)
@@ -69,11 +71,10 @@ static int zstd_compress(void *ctx, cons
 			 unsigned char *dst, size_t *dst_len)
 {
 	struct zstd_ctx *zctx = ctx;
-	const zstd_parameters prm = zstd_get_params(zctx->level, PAGE_SIZE);
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
-				 src, src_len, &prm);
+				 src, src_len, &zctx->cprm);
 	if (zstd_is_error(ret))
 		return -EINVAL;
 	*dst_len = ret;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

