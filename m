Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8728D148823
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417115; cv=none; b=j8I5prttXCn9PaPrSqyU0muUbwGeLhENU1gy0xpYiR+9WUP7wElkDrprOK1h6n3byTgXItZpaXBs00wmCzzBmQM0pLzEG+nYDRtTLdzVjQNTzwChPToc0Jam++iZ9sluEhvwfRXgoQSWZgvKGbdbvivMd+5yAk2XiYEgOHJMb/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417115; c=relaxed/simple;
	bh=RV+vRSDcYpkfHB5/zSL/dVQTrxqiU7U1aEfsMrRsM1M=;
	h=Date:To:From:Subject:Message-Id; b=oYBgjOy42rn65VIUYcHbs62hZ8Cvxf21rsSHBSca/5EoQWUlYSYuiLiq3mIon9RqAuDYD4+/CmoWe+ebM9/kMx5d/e3zziZ5qbeNWR+KJ7doK1XuMY7vi44Nd/GsJKM1606NKqRGFj2aW9Bk7hInU/UaN2nnIJyLU/1ZSfy7Dgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dmldxE9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dmldxE9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EC9C2BBFC;
	Wed, 22 May 2024 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417115;
	bh=RV+vRSDcYpkfHB5/zSL/dVQTrxqiU7U1aEfsMrRsM1M=;
	h=Date:To:From:Subject:From;
	b=dmldxE9IVQlhVl3p5XeOPBmOWviED/vLu604ry0by8b5lkbp5p+S3x8TAwOFGwY+U
	 zLbS/tNmXsSFWYfMhiC61/5A92Y31CFV8oET5G0OrgxmQV9eSMZTEMq5zutIXkMQjX
	 oVE/SfC+8lztpCyMIE0zqI+BJGx4EJEG2YzpZoyU=
Date: Wed, 22 May 2024 15:31:54 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-pass-estimated-src-size-hint-to-zstd.patch added to mm-unstable branch
Message-Id: <20240522223154.E3EC9C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: pass estimated src size hint to zstd
has been added to the -mm mm-unstable branch.  Its filename is
     zram-pass-estimated-src-size-hint-to-zstd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-pass-estimated-src-size-hint-to-zstd.patch

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
Subject: zram: pass estimated src size hint to zstd
Date: Wed, 15 May 2024 16:12:43 +0900

zram works with PAGE_SIZE buffers, so we always know exact size of the
source buffer and hence can pass estimated_src_size to zstd_get_params().

This hint on x86_64, for example, reduces the size of the work memory
buffer from 1303520 bytes down to 90080 bytes.  Given that compression
streams are per-CPU that's quite some memory saving.

Link: https://lkml.kernel.org/r/20240515071645.1788128-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_zstd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/backend_zstd.c~zram-pass-estimated-src-size-hint-to-zstd
+++ a/drivers/block/zram/backend_zstd.c
@@ -35,7 +35,7 @@ static void *zstd_create(void)
 		return NULL;
 
 	ctx->level = zstd_default_clevel();
-	params = zstd_get_params(ctx->level, 0);
+	params = zstd_get_params(ctx->level, PAGE_SIZE);
 	sz = zstd_cctx_workspace_bound(&params.cParams);
 	ctx->cctx_mem = vzalloc(sz);
 	if (!ctx->cctx_mem)
@@ -65,7 +65,7 @@ static int zstd_compress(void *ctx, cons
 			 unsigned char *dst, size_t *dst_len)
 {
 	struct zstd_ctx *zctx = ctx;
-	const zstd_parameters params = zstd_get_params(zctx->level, 0);
+	const zstd_parameters params = zstd_get_params(zctx->level, PAGE_SIZE);
 	size_t ret;
 
 	ret = zstd_compress_cctx(zctx->cctx, dst, *dst_len,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-move-from-crypto-api-to-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_config-structure.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-support-compression-level-comp-config.patch
zram-add-support-for-dict-comp-config.patch
lib-zstd-export-api-needed-for-dictionary-support.patch
zram-add-dictionary-support-to-zstd-backend.patch
zram-add-config-init-release-backend-callbacks.patch
zram-share-dictionaries-between-per-cpu-contexts.patch
zram-add-dictionary-support-to-lz4.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
zram-add-dictionary-support-to-lz4hc.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

