Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE07185946
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311901; cv=none; b=UQPbTbuN246BIJ1ipnzj1o0TxxNHAOcKZkWdrhOKl0+JkFsZs4S2FGPCaNxjB/eZBW1iwbAYk1lQcTSPRphDQUd+GBx3cWc8ZxAj2odo4ie5uxmHyJiL6tDpy2NR2ObIBnBbNK7NzgSsAL2cuZAQ13eJrZZygKl/kDCPm+XMXFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311901; c=relaxed/simple;
	bh=YyFbQBElL30Cte1eNCM8+nuUIZAWxUephZjI3aeHW5o=;
	h=Date:To:From:Subject:Message-Id; b=m7ey2WiozPuS11qV6DMXhEHqq1K3JCEC9y0vkURMwH7CgJkgCrJ4Foswj6qNeenXxUxbPfh2CA6SPvCUv5mFR4JDsbdrfa3Fc50OkbQQAXwFPHsqXQa+mvUI4IbZqzU5Hilb+XKwTuNhihQJbdoZyZTRsXFD8mk7C+HthjkCtIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iiwHqfe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iiwHqfe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40608C4CEC2;
	Mon,  2 Sep 2024 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311901;
	bh=YyFbQBElL30Cte1eNCM8+nuUIZAWxUephZjI3aeHW5o=;
	h=Date:To:From:Subject:From;
	b=iiwHqfe5ClKJ52Bu8r4yVUEm69tqeG2zNP/KthX/W+J+0doXcmZejbYeZ1hcD5sxr
	 uOHRPjPnYkGPYCrte7MxNcgusDHKY1ZVSLSrulGn3iJwvMIoHhFNS5xheVKdrK09ZV
	 31+DZ6x8dNRI96Qv5Yq6pn7iCuvzz11h6gZCNDa0=
Date: Mon, 02 Sep 2024 14:18:20 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-pass-estimated-src-size-hint-to-zstd.patch added to mm-unstable branch
Message-Id: <20240902211821.40608C4CEC2@smtp.kernel.org>
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
Date: Mon, 2 Sep 2024 19:55:57 +0900

zram works with PAGE_SIZE buffers, so we always know exact size of the
source buffer and hence can pass estimated_src_size to zstd_get_params().

This hint on x86_64, for example, reduces the size of the work memory
buffer from 1303520 bytes down to 90080 bytes.  Given that compression
streams are per-CPU that's quite some memory saving.

Link: https://lkml.kernel.org/r/20240902105656.1383858-10-senozhatsky@chromium.org
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

