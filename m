Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E981A4E9C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311919; cv=none; b=TX9p/OsuL66vkTURq6LP3pm8wq5gISwBOh0vd+CEtp5QmCaApNiQSwG8kiOIz96SkXxpcuPtLthFu1XuohsW7FvdtbXbhkN60CdWv87kmFUxtYjV6PAMYe9BrZBNBl2uNw1xvlKyYpodvDUGxxOfLbzTgxoIoeUgbZq1CWWD+Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311919; c=relaxed/simple;
	bh=aPH+/YQdbKZkAgQbEI83ex5zBQ057T/zy3g5LrzjoxY=;
	h=Date:To:From:Subject:Message-Id; b=ASvh3SNIajOJqTCsHRjv8NWUC61c1GCuWBSRC+duV3IPvMzY1PF71YL46zIv+C2T7CqD5p3L3H/3WHPCuKx4np3q3lJU3B0ORR/8OeZygafnwLHyqWsAaAhSkuhLfm02Su4TwmUussF3hPXVqvlzujrOWH9kyHu8Dh0b4pumJK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NSpfu4Os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NSpfu4Os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC15BC4CEC2;
	Mon,  2 Sep 2024 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311918;
	bh=aPH+/YQdbKZkAgQbEI83ex5zBQ057T/zy3g5LrzjoxY=;
	h=Date:To:From:Subject:From;
	b=NSpfu4OsE/zVY0kD5hvJZjgAXaM+e5vJP13GVCUDH5cz1Qf+uF6bCL+GlczADyVhG
	 uuKtcVd51rbnhWwjhYG2xja8QolJlo+lqxhlxeTwKDNoli8CQND8vysOLmkEfUoPsq
	 cyjldLfOkcB/QzPy2AyFkbsjShLF6q9dd/DMnz/M=
Date: Mon, 02 Sep 2024 14:18:38 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-recalculate-zstd-compression-params-once.patch added to mm-unstable branch
Message-Id: <20240902211838.CC15BC4CEC2@smtp.kernel.org>
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
Date: Mon, 2 Sep 2024 19:56:02 +0900

zstd compression params depends on level, but are constant for a given
instance of zstd compression backend.  Calculate once (during ctx
creation).

Link: https://lkml.kernel.org/r/20240902105656.1383858-15-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
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
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
zram-support-priority-parameter-in-recompression.patch

